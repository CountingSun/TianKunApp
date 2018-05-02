//
//  ChangeInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeInfo : NSObject


/**
 公司or人员（1，公司。2，人员）',

 */
@property (nonatomic, copy) NSString *company_or_person;
/**
 记录隶属ID（公司OR人员）',
 */
@property (nonatomic, copy) NSString *company_or_person_id;
/**
'企业变更序号
 */
@property (nonatomic, copy) NSString *company_change_number;
/**
'变更类别（公司为null，人员跟执业注册信息类别）
 */
@property (nonatomic, copy) NSString *change_flag;
/**
变更内容
 */
@property (nonatomic, copy) NSString *change_contents;
/**
 '变更注册日期',

 */
@property (nonatomic, copy) NSString *change_date;

@end
