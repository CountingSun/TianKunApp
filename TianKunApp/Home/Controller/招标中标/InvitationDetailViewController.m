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

@interface InvitationDetailViewController ()<WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic ,assign) NSInteger invitationID;
@property (nonatomic ,strong) TenderBidInfo *tenderBidInfo;
@property (nonatomic, strong) UIProgressView *progressView;//设置加载进度条
@property (nonatomic, strong) WKWebView         *webView;               //wkwebview

@property (nonatomic, copy) NSString *htmlStr;
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,assign) NSInteger fromType;

@property (nonatomic, copy) NSString *imagePath;
@end

@implementation InvitationDetailViewController
-(instancetype)initWithInvitationID:(NSInteger)invitationID fromType:(NSInteger)fromType{
    if (self = [super init]) {
        _invitationID = invitationID;
        _fromType = fromType;
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

    [self.bgView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"返回" highImage:@"返回"];
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
    
    ;
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    wkWebConfig.userContentController = wkUController;
    
    _imagePath = [[NSBundle mainBundle] pathForResource:@"web_fail_image@2x" ofType:@"png"];

    self.webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT) configuration:wkWebConfig];
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    self.webView.scrollView.showsVerticalScrollIndicator=NO;
    self.webView.navigationDelegate=self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    [self bgView];
    
    
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

    
    [[[NetWorkEngine alloc]init] postWithDict:@{@"id":@(_invitationID)} url:urlStr succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _tenderBidInfo = [TenderBidInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            _htmlStr = [self createHtmlStrWithTitle:_tenderBidInfo.tender_title imageUrl:_tenderBidInfo.tender_pictures docStr:_tenderBidInfo.notice_content];
            _htmlStr = [self autoWebAutoImageSize:_htmlStr];
            
            self.title = _tenderBidInfo.tender_ym_title;
            
            [self.webView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:@""]];
            
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
               <body>\
               <img src=\"%@\"  width=\"100%%\"  onerror=\"web_fail_image@2x.png\" />\
               <div style=\"width:80%%;margin:0px auto;\">\
               <h3>\
               %@\
               </h3>\
               </div>\
               <div>%@</div>\
               </body>\
               </html>",imageUrl,title,docStr];
    
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
    for (int i = 0; i < len; ++ i) {
        html = [html stringByReplacingOccurrencesOfString:mutArray[i] withString: @"style=\"width:100%; height:auto;\""];
    }
    
    return html;
}
//懒加载实现背景View
- (UIView*)bgView {
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height + 20)];
        [self.navigationController.view insertSubview:_bgView belowSubview:self.navigationController.navigationBar];
        
    }
    return _bgView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat alpha = scrollView.contentOffset.y/64;
    if (alpha > 1) {
        alpha = 1;
    }
        [self bgView].backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
