//
//  WebLinkViewController.h
//  CubeSugarEnglishStudent
//
//  Created by seekmac002 on 2017/7/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WQBaseViewController.h"
#import <WebKit/WebKit.h>

typedef void(^goBackBlock)(void);
@interface WebLinkViewController : WQBaseViewController
@property (nonatomic, copy) NSString    *urlString;             // url地址
@property (nonatomic, copy) NSString    *navTitle;              // 标题栏
@property (nonatomic, strong) WKWebView         *webView;               //wkwebview

@property (nonatomic,copy)goBackBlock goBackBlock;

-(instancetype)initWithTitle:(NSString *)title urlString:(NSString *)urlString;

-(instancetype)initWithTitle:(NSString *)title urlString:(NSString *)urlString goBackBlock:(goBackBlock)goBackBlock;

@end
