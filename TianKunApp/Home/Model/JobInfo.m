//
//  JobInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/30.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "JobInfo.h"

@implementation JobInfo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"job_id":@"id",
             @"firstTypeName":@"first_typename",
             @"secondTypeName":@"second_typename"

             };
}
@end
