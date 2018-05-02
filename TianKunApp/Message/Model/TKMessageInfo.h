//
//  TKMessageInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKMessageInfo : NSObject

/**
 消息ID
 */
@property (nonatomic ,assign) NSInteger message_id;

/**
 图片url
 */
@property (nonatomic, copy) NSString *picture_url;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 系统消息内容

 */
@property (nonatomic, copy) NSString *content;

/**
 create_date
 */
@property (nonatomic, copy) NSString *create_date;

/**
 //查看资料的类型: 1岗位信息,2简历信息,3文件通知,4公示公告,5招投标信息,6教育培训,7互动交流,8企业信息(APP发布),9企业信息(WEB发布)',

 */
@property (nonatomic ,assign) NSInteger data_type;

/**
 // 资料id

 */
@property (nonatomic ,assign) NSInteger data_id;

/**
 // 是否已经读过:1已读; 0未读; 暂时不存数据库. 只用于查询结果中,来表示当前用户是否已读此信息;

 */
@property (nonatomic ,assign) NSInteger is_read;



@end
