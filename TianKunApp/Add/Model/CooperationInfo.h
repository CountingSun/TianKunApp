//
//  CooperationInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CooperationInfo : NSObject

/**
 发布单位
 */
@property (nonatomic, assign) NSInteger cooperationID;

/**
 发布单位
 */
@property (nonatomic, copy) NSString *initiator;

/**
 合作请求作用地区,根据省市区,拿到区域编号list
 */
@property (nonatomic, copy) NSString *action_scope;

/**
 联系人
 */
@property (nonatomic, copy) NSString *linkman;

/**
 联系人电话
 */
@property (nonatomic, copy) NSString *phone;

/**
 发布者商家地址(详细)
 */
@property (nonatomic, copy) NSString *address;

/**
 用户填写的商家地址  和上面的字段一起组成 address
 */
@property (nonatomic, copy) NSString *addressDetail;

@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

/**
 服务详情(具体请求合作内容说明)
 */
@property (nonatomic, copy) NSString *content;

/**
 当前登录人是否收藏,0:未收藏  不是0就是收藏了
 */
@property (nonatomic, assign) NSInteger isCollect;
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic, assign) NSInteger hits_show;
@property (nonatomic, assign) NSInteger hits_record;
@property (nonatomic, assign) NSInteger delete_flag;

@property (nonatomic ,strong) NSMutableArray *arrAddressName;


@property (nonatomic, copy) NSString *action_scope_name;
@property (nonatomic, copy) NSString *cities_id;
@property (nonatomic, copy) NSString *cities_name;
@property (nonatomic, copy) NSString *provinces_id;
@property (nonatomic, copy) NSString *provinces_name;

@end
