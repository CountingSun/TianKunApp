//
//  UserInfoEngine.h
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/7/18.
//  Copyright © 2017年 seek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@interface UserInfoEngine : NSObject

/**
 存储用户信息
 */
+(void)setUserInfo:(UserInfo *)userInfo;

/**
 获取用户信息
 */
+(UserInfo *)getUserInfo;

/**
 用户是否登录

 @return bool
 */
+(BOOL)isLogin;

/**
 退出登录
 */
+(void)loginOut;

+(BOOL)getIsHadPwd;
+(void)setIsHadPwd:(NSString *)str;

@end
