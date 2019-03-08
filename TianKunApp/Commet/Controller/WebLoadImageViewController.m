//
//  WebLoadImageViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/15.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WebLoadImageViewController.h"
#import <WebKit/WebKit.h>

@interface WebLoadImageViewController ()
@property (nonatomic, strong) WKWebView         *webView;               //wkwebview
@property (nonatomic ,strong) NSArray *arrImageName;
@property (nonatomic, copy) NSString *viewTitle;
@end

@implementation WebLoadImageViewController
- (instancetype)initWithTitle:(NSString *)title arrImageName:(NSArray<NSString *> *)arrImageName{
    if(self = [super init]){
        _arrImageName = arrImageName;
        _viewTitle = title;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:_viewTitle];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    self.webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) configuration:wkWebConfig];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:[self createHtmlStrWithImageUrlArr:_arrImageName] baseURL:[NSURL URLWithString:@""]];
    

}
- (NSString *)createHtmlStrWithImageUrlArr:(NSArray *)imageUrlArr{
    NSString *baseStr = @"";
    baseStr = @"<!DOCTYPE html>\
               <html lang=\"en\">\
               <head>\
               <meta charset=\"utf-8\">\
               <meta name='viewport' content='width=device-width,height:auto, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>\
               </head>\
               <body style='margin:0;padding:0'>";
    for(NSString *str in imageUrlArr){
        baseStr = [baseStr  stringByAppendingString:[NSString stringWithFormat:@"<img src=\"%@\"  width=\"100%%\" height=auto\" />",[self htmlForPNGImage:str]]];
    }
    baseStr = [baseStr stringByAppendingString:@"</body></html>"];
    return baseStr;
}
- (NSString *)htmlForPNGImage:(NSString *)imageName

{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *imageSource = [NSString stringWithFormat:@"data:image/png;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    
    return imageSource;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
