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
    [aCoder encodeObject:_hadPwd forKey:@"_hadPwd"];
    [aCoder encodeObject:_userID forKey:@"_userID"];
    [aCoder encodeObject:_login_token forKey:@"_login_token"];
    [aCoder encodeObject:_token forKey:@"_token"];

    [aCoder encodeObject:_phone forKey:@"_phone"];
    [aCoder encodeObject:_nickname forKey:@"_nickname"];
    [aCoder encodeObject:_headimg forKey:@"_headimg"];
    [aCoder encodeObject:_vid_status forKey:@"_vid_status"];
    [aCoder encodeObject:_vip_webid forKey:@"_vip_webid"];
    [aCoder encodeObject:_webname forKey:@"_webname"];
    


}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _hadPwd = [aDecoder decodeObjectForKey:@"_hadPwd"];
        _userID = [aDecoder decodeObjectForKey:@"_userID"];
        _login_token = [aDecoder decodeObjectForKey:@"_login_token"];
        _token = [aDecoder decodeObjectForKey:@"_token"];
        _phone = [aDecoder decodeObjectForKey:@"_phone"];
        _nickname = [aDecoder decodeObjectForKey:@"_nickname"];
        _headimg = [aDecoder decodeObjectForKey:@"_headimg"];
        _vid_status = [aDecoder decodeObjectForKey:@"_vid_status"];
        _vip_webid = [aDecoder decodeObjectForKey:@"_vip_webid"];
        _webname = [aDecoder decodeObjectForKey:@"_webname"];

        
    }
    return self;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userID":@"id",
             @"hadPwd":@"isPassword"

             };
}
@end
