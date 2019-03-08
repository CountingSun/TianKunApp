//
//  AppDelegate.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
//融云
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RCIM.h>
#import "RongCloudConfigure.h"

static NSString *appKey = @"972597a347f2efcb79c9cd9c";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 网络状态 
 */
@property (nonatomic,assign) NetworkReachabilityStatus netWorkStates;
+(instancetype)sharedAppDelegate;



/**
 获取window根目录
 */
-(void)setRootController;
@property (nonatomic,assign) BOOL allowRotation;

@property (nonatomic, copy) void(^aliPayFinishBlock)(NSDictionary *resultDic);
@property (nonatomic, copy) void(^wexinPayFinishBlock)(NSInteger errorCode,NSString *message);

@end

