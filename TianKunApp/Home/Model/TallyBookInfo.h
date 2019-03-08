//
//  TallyBookInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TallyBookInfo : NSObject

@property (nonatomic ,assign) NSInteger bookID;

/**
 备注
 */
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic ,assign) CGFloat number;
@property (nonatomic ,assign) CGFloat price;

/**
 类型（1工时，2面积，3重量）
 */
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic ,strong) NSDate *nowDate;

@end
