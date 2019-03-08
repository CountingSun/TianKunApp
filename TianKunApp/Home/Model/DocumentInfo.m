//
//  DocumentInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/16.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "DocumentInfo.h"

@implementation DocumentInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"data_id":@"id"
             };
}
-(NSString *)previous_format{
    if (!_previous_format.length) {
        return @"";
    }
    return _previous_format;
}
@end
