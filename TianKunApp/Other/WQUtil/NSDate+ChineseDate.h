//
//  NSDate+ChineseDate.h
//  WeddingApp
//
//  Created by seekmac002 on 2017/11/10.
//  Copyright © 2017年 seek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ChineseDate)

/**
 获取当前是星期几

 @return string
 */
- (NSString *)getWeek;


/**
 获取当前农历日期

 @returnstring
 */
- (NSString *)getChineseCalendar;

@end
