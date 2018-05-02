//
//  UserInfoEngine.m
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/7/18.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "UserInfoEngine.h"
#import "WQPigeonhole.h"
#import "UserInfo.h"
#import "LoginViewController.h"

@implementation UserInfoEngine

+(void)setUserInfo:(UserInfo *)userInfo{

    [WQPigeonhole encodeObject:userInfo];
    
}
+(UserInfo *)getUserInfo{

    return (UserInfo *)[WQPigeonhole decodeObject];
    
}
+(BOOL)isLogin{

    if ([UserInfoEngine getUserInfo].userID) {
        return YES;
    }else{
        UIViewController *showVC = [self topViewController];
        QMUINavigationController *nav = [[QMUINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        nav.navigationBar.tintColor = COLOR_TEXT_GENGRAL;

        [showVC presentViewController:nav animated:YES completion:^{
            
        }];
        
        
        return NO;
    }
}
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
