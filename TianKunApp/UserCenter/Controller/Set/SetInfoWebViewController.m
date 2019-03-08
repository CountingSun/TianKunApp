//
//  SetInfoWebViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/7.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SetInfoWebViewController.h"
#import <WebKit/WebKit.h>

@interface SetInfoWebViewController ()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation SetInfoWebViewController
- (instancetype)initWithUrl:(NSURL *)url title:(NSString *)title{
    if (self = [super init]) {
        _url = url;
        _viewTitle = title;
        
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:_viewTitle];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.navigationDelegate = self;
        
        [self.view addSubview:_webView];
        
        
    }
    return _webView;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
