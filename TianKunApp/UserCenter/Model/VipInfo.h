//
//  VipInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/17.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipInfo : NSObject

/**
 开通会员金额
 */
@property (nonatomic ,assign) double total_amount;

/**
 用户会员到期时间  毫秒值
 */
@property (nonatomic, copy) NSString *vip_endtime;

/**
 户vip状态（0不是vip，1是vip），
 */
@property (nonatomic ,assign) NSInteger vip_status;

/**
 比如会员12个月
 */
@property (nonatomic, copy) NSString *vip_date;

/**
  vip类型
 */
@property (nonatomic, copy) NSString *vip_type;

@end
