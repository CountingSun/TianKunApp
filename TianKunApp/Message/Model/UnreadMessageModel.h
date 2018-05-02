//
//  UnreadMessageModel.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnreadMessageModel : NSObject

/**
 今日推荐消息未读个数
 */
@property (nonatomic ,assign) NSInteger recommendation_message;

/**
 系统消息未读数
 */
@property (nonatomic ,assign) NSInteger system_message;

/**
 企业证书通知未读数
 */
@property (nonatomic ,assign) NSInteger enterprise_certificate_message;

/**
 个人证书通知未读数
 */
@property (nonatomic ,assign) NSInteger personal_certificate_message;

/**
 专家消息通知未读数
 */
@property (nonatomic ,assign) NSInteger datum_certificate_message;

@end
