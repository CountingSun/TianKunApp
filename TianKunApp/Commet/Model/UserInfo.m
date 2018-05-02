//
//  UserInfo.m
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/7/18.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "UserInfo.h"


@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_userID forKey:@"_userID"];
    [aCoder encodeObject:_login_token forKey:@"_login_token"];
    [aCoder encodeObject:_phone forKey:@"_phone"];
    [aCoder encodeObject:_nickname forKey:@"_nickname"];
    [aCoder encodeObject:_headimg forKey:@"_headimg"];


}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userID = [aDecoder decodeObjectForKey:@"_userID"];
        _login_token = [aDecoder decodeObjectForKey:@"_login_token"];
        _phone = [aDecoder decodeObjectForKey:@"_phone"];
        _nickname = [aDecoder decodeObjectForKey:@"_nickname"];
        _headimg = [aDecoder decodeObjectForKey:@"_headimg"];

        
    }
    return self;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userID":@"id"
             };
}
@end
