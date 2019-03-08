//
//  CertificateInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CertificateInfo : NSObject
@property (nonatomic ,assign) NSInteger data_id;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic ,assign) NSInteger service_id;

@property (nonatomic, copy) NSString *service_name;
@property (nonatomic ,assign) NSInteger data_type;
@property (nonatomic ,assign) NSInteger certificate_id;
@property (nonatomic, copy) NSString *certificate_name;
@property (nonatomic, copy) NSString *certificate_type_name;
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic ,strong) NSMutableArray *certificate_type_names;

/**
 发证时期
 */
@property (nonatomic, copy) NSString *opening_date;
/**
 到期时间
 */
@property (nonatomic, copy) NSString *remind_date;

/**
 到期提醒
 */
@property (nonatomic, copy) NSString *remind;

/**
 /证书所有人名字  个人证书姓名
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *certificate_url;


@end
