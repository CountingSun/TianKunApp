//
//  ProjectInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectInfo : NSObject

/**
 项目名称',

 */
@property (nonatomic, copy) NSString *project_name;
/**
 项目编码
 */
@property (nonatomic, copy) NSString *project_number;
/**
 '项目归属地：',

 */
@property (nonatomic, copy) NSString *project_address;
/**
 '项目类别',

 */
@property (nonatomic, copy) NSString *project_type_id;

/**
 "类型名称",

 */
@property (nonatomic, copy) NSString *type_name;
/**
 建设单位

 */
@property (nonatomic, copy) NSString *development_organization;
/**
 公司项目还是员（1，公司2人
 */
@property (nonatomic, copy) NSString *company_or_person;




















@end
