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
#import "RongCloudConfigure.h"
#import "JPUSHService.h"
#import <ShareSDK/ShareSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import "IconBadgeManager.h"

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
/**
 退出登录
 */
+(void)loginOut{
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:2];
    NSSet *set = [NSSet setWithObjects:@"VIP",@"ID", nil];
    [JPUSHService deleteTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        
    } seq:2];
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
        [ShareSDK  cancelAuthorize:SSDKPlatformTypeWechat];
    }
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeQQ]) {
        [ShareSDK  cancelAuthorize:SSDKPlatformTypeQQ];
    }
    ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
    [albbSDK logout];

    [UserInfoEngine setUserInfo:nil];
    [RongCloudConfigure logout];
    [IconBadgeManager deleteAllSystemMessage];
    [IconBadgeManager deleteAllRecomendMessage];
    [IconBadgeManager deleteVIPMessage];
    

}
+(BOOL)getIsHadPwd{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsHadPwd"];

    if ([str isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
    
}
+(void)setIsHadPwd:(NSString *)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"IsHadPwd"];
    
}

@end
