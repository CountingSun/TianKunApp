//
//  CompanyInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CompanyClassInfo;

@interface CompanyInfo : NSObject

/**
 公司id 
 */
@property (nonatomic ,assign) NSInteger companyID;
/**
 统一社会信用代码
 */
@property (nonatomic, copy) NSString *companySocialNum;
/**
 企业名字 
 */
@property (nonatomic, copy) NSString *companyName;

/**
 企业法定代表人 
 */
@property (nonatomic, copy) NSString *companyLegalRepresentative;
/**
 企业登记注册类型
 */
@property (nonatomic, copy) NSString *companyType;


/**
 企业经营地址
 */
@property (nonatomic, copy) NSString *companyAddress;
 /**
  企业资质类型
  */

@property (nonatomic, copy) NSString *companyCertification;


/**
 工程项目
 */
@property (nonatomic, copy) NSString *companyProject;


/**
 特殊行为记录:  当查询表信息时,也查询特殊行为记录表赛选条件:个人or公司=个人 记录隶属id=当前表id.然后根据行为类型拆分(不良行为, 良好行为)(后端处理) 
 */
@property (nonatomic, copy) NSString *companyRecord;


/**
 变更记录 
 */
@property (nonatomic, copy) NSString *companyChangeRecord;


/**
 创建时间 
 */
@property (nonatomic, copy) NSString *companyCreateDate;


/**
 更新时间 
 */
@property (nonatomic, copy) NSString *companyUpDate;
/**
 企业描述 
 */
@property (nonatomic, copy) NSString *companyIntroduce;

/**
 公司类型信息 
 */
@property (nonatomic ,strong) CompanyClassInfo *companyClassInfo;


/**
 公司联系人
 */
@property (nonatomic, copy) NSString *contacts;

/**
 手机号
 */
@property (nonatomic, copy) NSString *phone;

 /**
  企业图片地址
  */

@property (nonatomic ,strong) NSString *picture_url;
/**
 企业注册地址
 */

@property (nonatomic ,strong) NSString *registered_address;



@end
