//
//  JobIntensionInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/8.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobIntensionInfo : NSObject

@property (nonatomic ,assign) NSInteger work_status;



@property (nonatomic ,assign) NSInteger jobIntensionID;

/**
 职位类型id
 */
@property (nonatomic ,assign) NSInteger position_type_id;

/**
 职位类型name
 */
@property (nonatomic, copy) NSString *position_type_name;

/**
 工作地点
 */
@property (nonatomic, copy) NSString *workplace;


/**
 工作地点,利用省市区定位到区编号
 */
@property (nonatomic, assign) NSInteger workplace_number;


/**
 2兼职;3全职;
 */
@property (nonatomic ,assign) NSInteger work_type;


/**
 期望月薪
 */
@property (nonatomic ,copy) NSString * want_salary;


/**
 是否隐藏期望月薪,0隐藏,1显示
 */
@property (nonatomic ,assign) NSInteger salary_show;


/**
 期望工作领域name.
 */
@property (nonatomic ,copy) NSString * position_territory_name;


/**
 期望工作领域id.
 */
@property (nonatomic, assign) NSInteger position_territory_ids;

/**
 月薪最小
 */
@property (nonatomic ,assign) NSInteger want_salary_start;

/**
 月薪最大
 */
@property (nonatomic ,assign) NSInteger want_salary_end;



@end
