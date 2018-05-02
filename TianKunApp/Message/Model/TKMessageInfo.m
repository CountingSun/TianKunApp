//
//  TKMessageInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "TKMessageInfo.h"

@implementation TKMessageInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"message_id":@"id"
             };
}
@end
