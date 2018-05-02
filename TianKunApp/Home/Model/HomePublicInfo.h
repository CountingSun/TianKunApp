//
//  HomePublicInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePublicInfo : NSObject
/**
 公示公告ID
 */
@property (nonatomic, copy) NSString *publicID;

/**
 页面标题',

 */
@property (nonatomic, copy) NSString *page_title;
/**
 文章标签
 */
@property (nonatomic, copy) NSString *announcement_label;
/**
 文章描述
 */
@property (nonatomic, copy) NSString *announcement_describe;
/**
 文章标题
 */
@property (nonatomic, copy) NSString *announcement_title;
/**
 文章内容
 */
@property (nonatomic, copy) NSString *announcement_details;
/**
 点击量
 */
@property (nonatomic, copy) NSString *hits_show;
/**
 <#Description#>
 */
@property (nonatomic, copy) NSString *hits_record;
/**
 文章状态:1暂存,2发表
 */
@property (nonatomic, copy) NSString *announcement_status;
/**
 '添加时间',

 */
@property (nonatomic, copy) NSString *add_date;

/**
 图片
 */
@property (nonatomic, copy) NSString *announcement_pictures;
@property (nonatomic, copy) NSString *create_date;

/**
 收藏id
 */
@property (nonatomic, assign) NSInteger yonghushoucangid;

/**
 转发量
 */
@property (nonatomic, assign) NSInteger zfnum;

/**
 收藏数
 */
@property (nonatomic, assign) NSInteger sznum;
@property (nonatomic, copy) NSString  *announcement_details_url;

/**
 类别ID  获取推荐时用到
 */
@property (nonatomic ,assign) NSInteger article_type;

@end
