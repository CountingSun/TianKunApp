//
//  UserInfo.m
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/7/18.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "UserInfo.h"

static NSString *userID = @"userID";
static NSString *idString = @"id";
static NSString *username = @"username";
static NSString *token = @"token";
static NSString *session = @"session";
static NSString *tel = @"tel";
static NSString *avatar = @"avatar";

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_user_id forKey:userID];
    [aCoder encodeObject:_username forKey:username];

    [aCoder encodeObject:_id forKey:idString];
    [aCoder encodeObject:_token forKey:token];
    [aCoder encodeObject:_session forKey:session];
    [aCoder encodeObject:_userTel forKey:tel];
    [aCoder encodeObject:_avatar forKey:avatar];

}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _user_id = [aDecoder decodeObjectForKey:userID];
        _id = [aDecoder decodeObjectForKey:idString];

        _username = [aDecoder decodeObjectForKey:username];
        _token = [aDecoder decodeObjectForKey:token];
        _session = [aDecoder decodeObjectForKey:session];

        _userTel = [aDecoder decodeObjectForKey:tel];
        _avatar = [aDecoder decodeObjectForKey:avatar];

        
    }
    return self;
}

@end
