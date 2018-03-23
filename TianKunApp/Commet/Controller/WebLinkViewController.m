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

@interface WebLinkViewController ()<WKNavigationDelegate>
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
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"返回" highImage:@"返回"];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
                                             

    self.webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) configuration:configuration];
   self.webView.scrollView.showsHorizontalScrollIndicator=NO;
   self.webView.scrollView.showsVerticalScrollIndicator=NO;
   self.webView.navigationDelegate=self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
//    [self.webView addObserver:self
//                 forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
//                    options:0
//                    context:nil];

   [self.view addSubview:self.webView];
//    if ([self.navigationItem.title isEqualToString:LocaStr(@"私人订制")]||[self.title isEqualToString:LocaStr(@"方糖老师")]) {
//        self.webView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-40);
//    }
//    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];


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
/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    self.progressView.hidden = NO;
    [self showWithStatus:@""];

}

/*! @abstract Invoked when a server redirect is received for the main
 frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{

}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self dismiss];

}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{

}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self dismiss];

    
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self dismiss];

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
