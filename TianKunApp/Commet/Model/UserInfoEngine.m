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

@implementation UserInfoEngine

+(void)setUserInfo:(UserInfo *)userInfo{

    [WQPigeonhole encodeObject:userInfo];
    
}
+(UserInfo *)getUserInfo{

    return (UserInfo *)[WQPigeonhole decodeObject];
    
}
+(BOOL)isLogin{

    if ([UserInfoEngine getUserInfo].user_id) {
        return YES;
    }
    return NO;
    
}
@end
