//
//  AppDelegate.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 网络状态 暂未用到
 */
@property (nonatomic,assign) NetworkReachabilityStatus netWorkStates;
+(instancetype)sharedAppDelegate;



/**
 获取window根目录

 @return <#return value description#>
 */
-(void)setRootController;

@end

