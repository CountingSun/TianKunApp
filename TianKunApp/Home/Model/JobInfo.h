//
//  JobInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/30.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobInfo : NSObject

/**
 招聘信息id 
 */
@property (nonatomic, copy) NSString *job_id;
/**
 职位名称 
 */
@property (nonatomic, copy) NSString *name;
/**
 职位类型编号 如:建筑设计的编号:100100' 
 */
@property (nonatomic, copy) NSString *position2_number;
/**
 市编码 
 */
@property (nonatomic, copy) NSString *job_site;
/**
 职位描述 
 */
@property (nonatomic, copy) NSString *work_describe;
/**
 联系人
 */
@property (nonatomic, copy) NSString *inquisitorial;

/**
 职位询问联系电话 
 */
@property (nonatomic, copy) NSString *inquiry_phone;

/**
 职位联系邮箱 
 */
@property (nonatomic, copy) NSString *inquiry_email ;

/**
 创建时间 
 */
@property (nonatomic, copy) NSString *create_date;

/**
 更新时间

 */
@property (nonatomic, copy) NSString *update_date;

/**
 图片地址

 */
@property (nonatomic, copy) NSString *imageurl;

/**
 公司地址
 */
@property (nonatomic, copy) NSString *address;

/**
 职位类别二级目录名字

 */
@property (nonatomic, copy) NSString *secondTypeName;
@property (nonatomic, copy) NSString *second_typeid;

/**
 职位类别一级目录名字

 */
@property (nonatomic, copy) NSString *firstTypeName;
@property (nonatomic, copy) NSString *first_typeid;

/**
 此招聘信息对应的企业的招聘信息的总条数
 */
@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *enterprisename;

@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, copy) NSString *province_name;
@property (nonatomic, copy) NSString *provinceid;

@property (nonatomic, copy) NSString *enterpriseid;
@property (nonatomic, copy) NSString *refreshtime;

@end
