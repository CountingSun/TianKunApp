//
//  SetInfoWebViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/7.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface SetInfoWebViewController : WQBaseViewController
@property (nonatomic ,strong) NSURL *url;
@property (nonatomic ,strong) NSString *viewTitle;

- (instancetype)initWithUrl:(NSURL *)url title:(NSString *)title;

@end
