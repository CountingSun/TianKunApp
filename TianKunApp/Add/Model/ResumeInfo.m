//
//  ResumeInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/5.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ResumeInfo.h"

@implementation ResumeInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"resume_id":@"id"
             };
}
- (NSString *)name{
    if (!_name.length) {
        return @"";
    }
    return _name;
}
@end
