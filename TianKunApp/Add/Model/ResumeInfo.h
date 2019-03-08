//
//  ResumeInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/5.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResumeInfo : NSObject




/**
 姓名
 */
@property (nonatomic, copy) NSString * name;


/**
 是否隐藏名(显示姓氏)
 */
@property (nonatomic, copy) NSString * conceal_name;


/**
 //简历名字
 */
@property (nonatomic, copy) NSString * resume_name;
/**
 //简历id
 */
@property (nonatomic, copy) NSString * resume_id;


/**
 //简历头像
 */
@property (nonatomic, copy) NSString * portrait;


/**
 //工作意向id
 */
@property (nonatomic, copy) NSString * job_intension_id ;


/**
 //学历
 */
@property (nonatomic, copy) NSString * degree  ;

/**
 //学历ID
 */
@property (nonatomic, copy) NSString * degreeID  ;

/**
 //性别:1男,2女
 */
@property (nonatomic, assign) NSInteger sex;


/**
 //血型
 */
@property (nonatomic, copy) NSString * blood_type;


/**
 //身高cm
 */
@property (nonatomic, copy) NSString * stature;


/**
 //生日
 */
@property (nonatomic, copy) NSString *birthday;


/**
 //电子邮箱
 */
@property (nonatomic, copy) NSString *email;


/**
 //手机号码
 */
@property (nonatomic, copy) NSString *phone;


/**
 //居住详细地址
 */
@property (nonatomic, copy) NSString *address;


/**
 //政治面貌
 */
@property (nonatomic, copy) NSString *politics_status;


/**
 //婚姻状况
 */
@property (nonatomic, copy) NSString *marriage_status;


/**
 //证件类型
 */
@property (nonatomic, copy) NSString *certificate_type;


/**
 //证件号码
 */
@property (nonatomic, copy) NSString *certificate_id;

//参加工作年/月
@property (nonatomic, copy) NSString *work_date;
//工作经验
@property (nonatomic, assign) NSInteger worked;



/**
 //自我评价
 */
@property (nonatomic, copy) NSString *self_evaluate;




//现有职称
@property (nonatomic, copy) NSString *appellation;

//户籍所在地
@property (nonatomic, copy) NSString *place_of_domicile;

//最高教育经历表id
@property (nonatomic, copy) NSString *education_status_id;

//求职优势
@property (nonatomic, copy) NSString * my_advantage;

//点击量（实际）
@property (nonatomic, assign) NSInteger hits_record;

/**
 收藏量
 */
@property (nonatomic, assign) NSInteger collect_count;


/**
 期望月薪
 */
@property (nonatomic, copy) NSString * want_salary;

/**
 期望职位名字
 */
@property (nonatomic, copy) NSString * position_type_id_string;

/**
 工作地点,利用省市区定位到区编号  --
 */
@property (nonatomic, copy) NSString * workplace_number_string;

/**
 工作类型(兼职/全职/实习/不限)  计算得出
 */
@property (nonatomic, copy) NSString * work_type_string;

/**
 求职状态1随时到岗,2有换工作意向,3无换工作意向; j
 */
@property (nonatomic, copy) NSString * work_status;

/**
 求职状态1随时到岗,2有换工作意向,3无换工作意向;
 */
@property (nonatomic, copy) NSString * work_status_string;


/**
 期望薪资 大
 */
@property (nonatomic ,assign) NSInteger want_salary_end;

/**
 期望薪资 小
 */
@property (nonatomic ,assign) NSInteger want_salary_start;

/**
 发布时间
 */
@property (nonatomic, copy) NSString *create_date;


/**
 是否收藏
 */
@property (nonatomic ,assign) NSInteger isCollect;

@property (nonatomic, copy) NSString *update_date;

@end
