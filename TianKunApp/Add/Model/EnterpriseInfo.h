//
//  EnterpriseInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterpriseInfo : NSObject

/**
 企业名称
 */
@property (nonatomic, copy) NSString *enterprise_name;

/**
 企业类别id
 */
@property (nonatomic, copy) NSString *categoryid;

/**
 企业类别
 */
@property (nonatomic, copy) NSString *category;

/**
 phone
 */
@property (nonatomic, copy) NSString *phone;

/**
 企业图片地址 （服务器地址+企业图片地址如：192.168.1.1/image/enterprice/）

 */
@property (nonatomic, copy) NSString *picture_url;

/**
 企业地址
 */
@property (nonatomic, copy) NSString *address;

/**
 联系人
 */
@property (nonatomic, copy) NSString *contacts;


@end
