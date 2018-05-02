//
//  HomePublicInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomePublicInfo.h"

@implementation HomePublicInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"publicID":@"id"
             };
}

@end
