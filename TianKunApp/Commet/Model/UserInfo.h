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
 状态1 登陆
 */
@property (nonatomic,assign) NSInteger login;

/**
 教师id
 */
@property (nonatomic,assign) NSString *id;

/**
 用户id
 */
@property (nonatomic,assign) NSString *user_id;

/**
 用户名
 */
@property (nonatomic,copy) NSString *username;

/**
 用户头像图片地址
 */
@property (nonatomic,copy) NSString *avatar;

/**
 登陆网易云所需返回token
 */
@property (nonatomic,copy) NSString *token;

/**
 session id
 */
@property (nonatomic,copy) NSString *session;
/**
 登录手机号，同时也是云信ID 登录成功时保存
 */
@property (nonatomic,copy) NSString *userTel;

/**
 热线电话
 */
@property (nonatomic,copy) NSString *hotline;
/**
 余额
 */
@property (nonatomic,assign) NSString *money;
/**
 余额
 */
@property (nonatomic,assign) NSString *order_paid_no;
/**
 余额
 */
@property (nonatomic,assign) NSString *order_refund_no;
/**
 余额
 */
@property (nonatomic,assign) NSString *order_unpaid_no;
/**
 退款数
 */
@property (nonatomic,assign) NSString *order_unrate_no;
/**
 小红🌺数量
 */
@property (nonatomic,assign) NSString *flower;

@end
