//
//  TallyBookInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "TallyBookInfo.h"

@implementation TallyBookInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"bookID":@"id"
             };
}
@end
