//
//  ClassTypeInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ClassTypeInfo.h"

@implementation ClassTypeInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"typeID":@"id",
             @"typeName":@"type_name"
             };
    
}
@end
