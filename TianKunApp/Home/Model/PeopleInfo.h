//
//  PeopleInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleInfo : NSObject

/**
 id
 */
@property (nonatomic, copy) NSString *people_id;
/**
 姓名
 */

@property (nonatomic, copy) NSString *name;
/**
 性别：1男，2女

 */

@property (nonatomic, copy) NSString *sex;
/**
 证件类型
 */

@property (nonatomic, copy) NSString *certificate_type;
/**
 证件号码
 */

@property (nonatomic, copy) NSString *certificate_number;
/**
 执业注册信息id
 */

@property (nonatomic, copy) NSString *practicing_information_id;

/**
 隶属公司id
 */

@property (nonatomic, copy) NSString *company_id;

/**
 注册类型：',（新增注册类型名称）
 */
@property (nonatomic, copy) NSString *category_id;
@end
