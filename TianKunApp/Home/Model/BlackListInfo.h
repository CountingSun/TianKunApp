//
//  BlackListInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlackListInfo : NSObject

/**
 个人or公司:(1个人行为,2公司行为)',

 */
@property (nonatomic, copy) NSString *person_or_company;

/**
 '黑名单记录主体',

 */
@property (nonatomic, copy) NSString *blacklist_body;
/**
 '记录原由',

 */
@property (nonatomic, copy) NSString *cause;
/**
 '认定部门',

 */
@property (nonatomic, copy) NSString *from_department;
/**
 决定日期
 */
@property (nonatomic, copy) NSString *start_time;
/**
 有效期截止
 */
@property (nonatomic, copy) NSString *end_time;
/**
 记录隶属id: (个人记录个人id,公司记录的则是公司id)',

 */
@property (nonatomic, copy) NSString *person_or_company_id;






















@end
