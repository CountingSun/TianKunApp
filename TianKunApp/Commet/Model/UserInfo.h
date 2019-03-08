//
//  UserInfo.h
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/7/18.
//  Copyright © 2017年 seek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/**
 用户id
 */
@property (nonatomic, copy) NSString *userID;
/**
 1有密码 0 无密码
 */
@property (nonatomic, strong) NSString *hadPwd;

/**
 认证，微信认证（1）,芝麻实名认证（2）,银行卡实名认证（3）,    营销执照认证（4） 存储数组[1,2,4] 
 */
@property (nonatomic, copy) NSString *authentication;
@property (nonatomic, copy) NSString *company_name;

@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *job_seeker_or_advertises_for;

/**
 qq号码或微信的uuid
 */
@property (nonatomic, copy) NSString *lgtype;
/**
  融云token
 */

@property (nonatomic, copy) NSString *token;
/**
 token
 */

@property (nonatomic, copy) NSString *login_token;
/**
 用户名称 
 */

@property (nonatomic, copy) NSString *nickname;
/**
 真实姓名
 */

@property (nonatomic, copy) NSString *name;

/**
 电话

 */
@property (nonatomic, copy) NSString *phone;
/**
 性别 
 */
@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *vid_status;
/**
 营业执照认证流程状态,1:待审核 2:审核中 3审核通过; 4:审核未通过

 */

@property (nonatomic, assign) NSInteger stastu;
/**
 学历
 */
@property (nonatomic, copy) NSString *degree;
/**
 生日
 */
@property (nonatomic, copy) NSString *birthday;


/**
 是否是vip用户 0不是,1是

 */
@property (nonatomic, assign) NSInteger vip_status;


/**
 营业执照图片地址

 */
@property (nonatomic, copy) NSString *picture_url;


/**
 营业执照认证流程状态,（””:未认证，1:待审核 2:审核中 3审核通过; 4:审核未通过）
 */
@property (nonatomic ,assign)  NSInteger status;


/**
 vip 客服的targetID
 */
@property (nonatomic, copy) NSString *vip_webid;
/**
 vip 客服名字
 */
@property (nonatomic, copy) NSString *webname;
 /**
  0：使用此第三方帐号第一次登录 1：使用此第三方帐号一次以上登录
  */

@property (nonatomic ,assign) NSInteger bol;

@end
