//
//  AFAppDotNetAPIClient.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/1.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

@implementation AFAppDotNetAPIClient
static AFHTTPSessionManager *_manager;

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_manager == nil) {
            _manager = [AFHTTPSessionManager manager];
        }
    });
    return [[self alloc]init];
}
@end
