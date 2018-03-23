//
//  WQAlertController.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/22.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQAlertController.h"

@implementation WQAlertController

+(void)showAlertControllerWithTitle:(NSString *)title
                            message:(NSString *)message
                    sureButtonTitle:(NSString *)sureButtonTitle
                        cancelTitle:(NSString *)cancelTitle
                          sureBlock:(sureBlock)sureBlock
                        cancelBlock:(cancelBlock)cancelBlock{
    
    
    QMUIAlertController *alertController = [[QMUIAlertController alloc]initWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
    
    QMUIAlertAction *setAction = [QMUIAlertAction actionWithTitle:sureButtonTitle style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        sureBlock(action);
    }];
    
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:cancelTitle style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction * action) {
        cancelBlock(action);

    }];
    
    [alertController addAction:setAction];
    [alertController addAction:cancelAction];
    
    
    [alertController showWithAnimated:YES];
    

    
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
