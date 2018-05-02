//
//  SpecialBehaviorInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialBehaviorInfo : NSObject

/**
 行为类型: (良好行为,不良行为)
 */
@property (nonatomic, copy) NSString *behavior_type;
/**
 诚信记录编号',
 */
@property (nonatomic, copy) NSString *record_number;
/**
 '诚信记录主体',
 */
@property (nonatomic, copy) NSString *record_body;
/**
决定内容 */
@property (nonatomic, copy) NSString *record_details;
/**
实施部门(文号):'
 */
@property (nonatomic, copy) NSString *department_number;
/**
发布有效期'
 */
@property (nonatomic, copy) NSString *expiration_date;

@end
