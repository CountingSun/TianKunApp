//
//  InvitationDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "InvitationDetailViewController.h"
#import "TenderBidInfo.h"
#import "UIBarButtonItem+Extension.h"
#import "NSString+WQString.h"
#import <WebKit/WebKit.h>
#import "AddHistoryRecordNetwork.h"

@interface InvitationDetailViewController ()<WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic ,assign) NSInteger invitationID;
@property (nonatomic ,strong) TenderBidInfo *tenderBidInfo;
@property (nonatomic, strong) UIProgressView *progressView;//设置加载进度条
@property (nonatomic, strong) WKWebView         *webView;               //wkwebview

@property (nonatomic, copy) NSString *htmlStr;
//@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,assign) NSInteger fromType;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic ,strong) UIButton *collectButton;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger collectID;

@end

@implementation InvitationDetailViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (!_collectID) {
        if (_deleteCollectBlock) {
            _deleteCollectBlock();
        }
    }
}
-(instancetype)initWithInvitationID:(NSInteger)invitationID fromType:(NSInteger)fromType{
    if (self = [super init]) {
        _invitationID = invitationID;
        _fromType = fromType;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:0];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];
    _collectButton.frame = CGRectMake(0, 0, 40, 40);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_collectButton];
    
    [_collectButton addTarget:self action:@selector(collectEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    _imagePath = [[NSBundle mainBundle] pathForResource:@"web_fail_image@2x" ofType:@"png"];

    self.webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) configuration:wkWebConfig];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    self.webView.navigationDelegate=self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
//    [self bgView];
    
    if (_fromType == 1) {
        self.title = @"招标详情";
    }else{
        self.title = @"中标详情";
    }
    _collectButton.enabled = NO;
    
    [self showLoadingView];

    [self getData];
    
}
- (void)getData{
    [self showLoadingView];
    NSString *urlStr = @"";
    if (_fromType == 1) {
        urlStr = BaseUrl(@"TenderNotice/findtendernoticelistxqbyid.action");
    }else{
        urlStr = BaseUrl(@"TenderNotice/findtendernoticelistxqbyidin.action");

    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([UserInfoEngine getUserInfo].userID) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];

    }
    [dict setObject:@(_invitationID) forKey:@"id"];

    
    [self.netWorkEngine postWithDict:dict url:urlStr succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _collectButton.enabled = YES;

            _tenderBidInfo = [TenderBidInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            _htmlStr = [self createHtmlStrWithTitle:_tenderBidInfo.tender_title imageUrl:_tenderBidInfo.tender_pictures docStr:_tenderBidInfo.notice_content];
            _htmlStr = [self autoWebAutoImageSize:_htmlStr];
            
            [self.webView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:@""]];
            
            [[[AddHistoryRecordNetwork alloc] init] addHistoryRecodeWithDataID:_invitationID dataType:5 dataTypeTwo:_fromType data_title:_tenderBidInfo.tender_title data_sketch:_tenderBidInfo.notice_summary dataPictureUrl:@""];
            
            _collectID = [[[responseObject objectForKey:@"value"] objectForKey:@"phone"] integerValue];
            if (_collectID) {
                _collectButton.selected = YES;
            }else{
                _collectButton.selected = NO;
                
                
            }
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getData];
                
            }];
            
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getData];
            
        }];
        
    }];
    
}
- (void)collectEvent{
    
    if (![UserInfoEngine isLogin]) {
        return;
        
    }
    [self showWithStatus:NET_WAIT_TOST];
    _collectButton.enabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (_collectButton.selected) {
        [dict setObject:@(2) forKey:@"type"];
        [dict setObject:@(_collectID) forKey:@"id"];
        [dict setObject:@(_invitationID) forKey:@"tender_notice_id"];
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];


    }else{
        [dict setObject:@(1) forKey:@"type"];
        [dict setObject:@"" forKey:@"id"];
        [dict setObject:@(_invitationID) forKey:@"tender_notice_id"];
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];

    }


    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TenderNotice/inserttendernoticecollectible.action") succed:^(id responseObject) {
        _collectButton.enabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _collectButton.selected =! _collectButton.selected;

            if (_collectButton.selected) {

                [self showSuccessWithStatus:@"收藏成功"];
                _collectID = [[responseObject objectForKey:@"value"] integerValue];
            }else{
                _collectID = 0;
                [self showSuccessWithStatus:@"取消收藏成功"];

            }
        }else{
            if (_collectButton.selected) {
                [self showErrorWithStatus:@"取消收藏失败"];
            }else{
                [self showErrorWithStatus:@"收藏失败"];
            }

        }
    } errorBlock:^(NSError *error) {
        _collectButton.enabled = YES;
        [self showErrorWithStatus:NET_ERROR_TOST];

    }];
    
    
    
}
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, WIDTH, 5);
        
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
                                                         green:240.0/255
                                                          blue:240.0/255
                                                         alpha:1.0]];
        _progressView.progressTintColor = [UIColor orangeColor];
        
        [self.view addSubview:_progressView];
        
    }
    return _progressView;
}

//点击返回按钮
- (void)comeBack
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress
                              animated:animated];
        
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }else if([keyPath isEqualToString:@"title"]){
        
        if ([self.webView.title isChinese]) {
            self.navigationItem.title = self.webView.title;
            
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        
    }
}
-(void)dealloc{
    //    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark --- webkit delegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self hideLoadingView];
    [self showGetDataNullWithReloadBlock:^{
        [self showLoadingView];
        [self.webView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:_imagePath]];

    }];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self hideLoadingView];
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];

    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self hideLoadingView];
    [self showGetDataNullWithReloadBlock:^{
        [self showLoadingView];
        [self.webView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:_imagePath]];

    }];
    
}

- (NSString *)createHtmlStrWithTitle:(NSString *)title imageUrl:(NSString *)imageUrl docStr:(NSString *)docStr{
    NSString *baseStr = @"";
    baseStr = [NSString stringWithFormat:@"<!DOCTYPE html>\
               <html lang=\"en\">\
               <head>\
               <meta charset=\"utf-8\">\
               <meta name='viewport' content='width=device-width,height:auto, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>\
               </head>\
               <body style='margin:0;padding:0'>\
               <div style=\"margin:0px auto;padding:10px\">\
               <h3>\
               %@\
               </h3>\
               </div>\
               <div style='margin:0;padding:10px'>%@</div>\
               </body>\
               </html>",title,docStr];
//    baseStr = [baseStr stringByReplacingOccurrencesOfString:@"" rwithString:@"    "];
    return baseStr;
}
- (NSString *)autoWebAutoImageSize:(NSString *)html{
    
    NSString * regExpStr = @"<img\\s+.*?\\s+(style\\s*=\\s*.+?\")";
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches=[regex matchesInString:html
                                    options:0
                                      range:NSMakeRange(0, [html length])];
    
    
    NSMutableArray * mutArray = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString* group1 = [html substringWithRange:[match rangeAtIndex:1]];
        [mutArray addObject: group1];
    }
    
    NSUInteger len = [mutArray count];
    for (int i = 1; i < len; ++ i) {
        html = [html stringByReplacingOccurrencesOfString:mutArray[i] withString: @"style=\"width:100%; height:auto;\""];
    }
    
    return html;
}
- (NSString *)htmlForPNGImage:(NSString *)imageName

{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *imageSource = [NSString stringWithFormat:@"data:image/png;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    
    return imageSource;
    
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc] init];
    }
    return _netWorkEngine;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
