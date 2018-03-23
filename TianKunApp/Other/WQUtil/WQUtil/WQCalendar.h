//
//  WQCalendar.h
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2018/1/24.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQCalendar : NSObject
+(NSInteger)getDayWithDate:(NSDate *)date;

/**
 // 星期几（注意，周日是“1”，周一是“2”。。。。）

 @param date <#date description#>
 @return <#return value description#>
 */
+(NSInteger)getWeekdayWithDate:(NSDate *)date;



@end
