//
//  RongCloudConfigure.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RongCloudConfigure.h"
#import "AppDelegate.h"

@implementation RongCloudConfigure
+ (void)registerRongCloud{
    [[RCIMClient sharedRCIMClient] initWithAppKey:@"pwe86ga5pvv16"];

}

+ (void)loginRongCloudWithresultBlock:(void(^)(NSString *errMessage))resultBlock{
    if ([UserInfoEngine getUserInfo].userID) {

    [[RCIM sharedRCIM] connectWithToken:[UserInfoEngine getUserInfo].token     success:^(NSString *userId) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:[UserInfoEngine getUserInfo].nickname portrait:[UserInfoEngine getUserInfo].headimg];
        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
        [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
        if (resultBlock) {
            resultBlock(@"");
        }
    } error:^(RCConnectErrorCode status) {
        if (resultBlock) {
            resultBlock([NSString stringWithFormat:@"登陆的错误码为:%ld", (long)status]);
        }

        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        if (resultBlock) {
            resultBlock(@"token错误");
        }
    }];
    }else{
        if (resultBlock) {
            resultBlock(@"");
        }

    }
}
+ (void)logout{
    [[RCIMClient sharedRCIMClient] logout];
}

@end
