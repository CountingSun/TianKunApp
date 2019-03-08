//
//  MessageDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MessageDetailViewController.h"
#import <WebKit/WebKit.h>
#import "TKMessageInfo.h"
#import "IconBadgeManager.h"

@interface MessageDetailViewController ()<WKNavigationDelegate>
@property (nonatomic ,assign) NSInteger messageID;

@property (nonatomic ,assign) NSInteger isRead;
@property (nonatomic, strong) WKWebView         *webView;               //wkwebview

@property (nonatomic ,strong) TKMessageInfo *messageInfo;
@property (nonatomic, copy) NSString *htmlStr;

@end

@implementation MessageDetailViewController
- (instancetype)initWithMessageID:(NSInteger)messageID isRead:(NSInteger)isRead{
    if (self = [super init]) {
        _messageID = messageID;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"详情"];
    [self setupView];
    [self showLoadingView];
    
    [self getData];
    
}
- (void)setupView{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:wkUserScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = userContentController;
    
    
    self.webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) configuration:wkWebConfig];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    self.webView.navigationDelegate=self;
    [self.view addSubview:self.webView];

}
- (void)getData{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([UserInfoEngine getUserInfo].userID) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userId"];
    }
    [dict setObject:@(_messageID) forKey:@"id"];
    [dict setObject:@(_isRead) forKey:@"isRead"];
    
    [[[NetWorkEngine alloc] init] postWithDict:dict url:BaseUrl(@"find.recommendMessage.and.change.status") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _messageInfo = [TKMessageInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            _htmlStr = [self createHtmlStrWithTitle:_messageInfo.title docStr:_messageInfo.content];
            _htmlStr = [self autoWebAutoImageSize:_htmlStr];
            
            [self.webView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:@""]];
            if ([IconBadgeManager isContainsSystemMessageID:[NSString stringWithFormat:@"%@",@(_messageID)]]) {
                [IconBadgeManager deleteSystemMessageWithMessageID:[NSString stringWithFormat:@"%@",@(_messageID)]];
                
            }else{
                [IconBadgeManager deleteRecomendMessageWithMessageID:[NSString stringWithFormat:@"%@",@(_messageID)]];
            }

            if (_readBlock) {
                _readBlock();
            }


        }else{
            [self hideLoadingView];
            
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
#pragma mark --- webkit delegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self hideLoadingView];
    [self showGetDataNullWithReloadBlock:^{
        [self showLoadingView];
        [self.webView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:@""]];

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
        [self.webView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:@""]];

    }];
    
}
- (NSString *)createHtmlStrWithTitle:(NSString *)title docStr:(NSString *)docStr{
    NSString *baseStr = @"";
    baseStr = [NSString stringWithFormat:@"<!DOCTYPE html>\
               <html lang=\"en\">\
               <head>\
               <meta charset=\"utf-8\">\
               <meta name='viewport' content='width=device-width,height:auto, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>\
               </head>\
               <body style='margin:0;padding:0'>\
               <div style=\"margin:0px auto;padding:10px\">\
               <h3 style=\"text-align: center;\">\
               %@\
               </h3>\
               </div>\
               <div style='margin:0;padding:10px'>%@</div>\
               </body>\
               </html>",title,docStr];
    baseStr = [baseStr stringByReplacingOccurrencesOfString:@"" withString:@""];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
