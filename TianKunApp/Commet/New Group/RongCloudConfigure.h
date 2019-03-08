//
//  RongCloudConfigure.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>
//融云
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RCIM.h>

@interface RongCloudConfigure : NSObject 
+ (void)registerRongCloud;

/**
 连接融云


 @param resultBlock errMessage 为@""时 登录成功
 */
+ (void)loginRongCloudWithresultBlock:(void(^)(NSString *errMessage))resultBlock;
+ (void)logout;

@end
