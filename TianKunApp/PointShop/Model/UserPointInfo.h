//
//  UserPointInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/6/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPointInfo : NSObject

@property (nonatomic, copy) NSString *type_name;
@property (nonatomic ,assign) NSInteger number;
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic ,assign) NSInteger revenue_or_expenses;

@end
