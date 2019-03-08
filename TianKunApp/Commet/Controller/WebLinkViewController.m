//
//  WebLinkViewController.m
//  CubeSugarEnglishStudent
//
//  Created by seekmac002 on 2017/7/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WebLinkViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "NSString+WQString.h"

@interface WebLinkViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) UIProgressView *progressView;//设置加载进度条

@end

@implementation WebLinkViewController

-(instancetype)initWithTitle:(NSString *)title urlString:(NSString *)urlString{

    if (self = [super init]) {
        _navTitle = title;
        _urlString = urlString;
        
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title urlString:(NSString *)urlString goBackBlock:(goBackBlock)goBackBlock{
    if (self = [super init]) {
        _navTitle = title;
        _urlString = urlString;
        _goBackBlock = goBackBlock;
        
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleView setTitle:self.navTitle];
    NSString *jScript =@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
    ;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"返回" highImage:@"返回"];

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;


    self.webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) configuration:wkWebConfig];
   self.webView.navigationDelegate=self;
    self.webView.UIDelegate = self;
    
   [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];

//    [self showLoadingView];
    

}
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, WIDTH, 5);
        
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
                                                         green:240.0/255
                                                          blue:240.0/255
                                                         alpha:1.0]];
        _progressView.progressTintColor = COLOR_THEME;
        
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

        if (_goBackBlock) {
            _goBackBlock();
            
        }
    }
}
//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]
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
    }else if([keyPath isEqualToString:@"title"]&& object == self.webView){
        
        if (!_navTitle.length) {
            self.title = self.webView.title;

        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];

    }
}
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark --- webkit delegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self hideLoadingView];
    [self showGetDataFailViewWithReloadBlock:^{
        [self showLoadingView];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
        
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
    if([error code] == NSURLErrorCancelled)  {
        return;
    }

    [self hideLoadingView];
    [self showGetDataFailViewWithReloadBlock:^{
        [self showLoadingView];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
        
    }];

}
#pragma mark - WKNavigationDelegate
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures

{
    
    
    if (!navigationAction.targetFrame.isMainFrame) {
        NSURL *url = navigationAction.request.URL;
        WebLinkViewController *webLinkViewController = [[WebLinkViewController alloc]initWithTitle:@"" urlString:[url absoluteString]];
        
        webLinkViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webLinkViewController animated:YES];

    }
    
    return nil;
    
}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
