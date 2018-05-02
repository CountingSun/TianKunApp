//
//  DocumentInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/16.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentInfo : NSObject

@property (nonatomic ,assign) NSInteger data_id;

/**
 '文件类型:1文本(直接存储),  2音频(url), 3视频(url);',

 */
@property (nonatomic ,assign) NSInteger type;

/**
 '资料类别: \r\n 一级(政策解读,一级造师,二级造师...)',

 */
@property (nonatomic ,assign) NSInteger data_type1;

/**
 资料标题
 */
@property (nonatomic, copy) NSString *data_title;

/**
 资料类别 二级,属于资料标签用于课程二级分类
 */
@property (nonatomic ,assign) NSInteger data_type2;

/**
 '视频的展示图片,',
 */
@property (nonatomic, copy) NSString *video_image_url;

/**
 资料详情(如果是文本直接显示,如果是音频或者是视频就显示url)',

 */
@property (nonatomic, copy) NSString *date_details;


/**
 如果收费,收费到少钱',

 */
@property (nonatomic, assign) double money;

/**
 是否收费
 */
@property (nonatomic ,assign) NSInteger is_charge;



/**
 内容简介',

 */
@property (nonatomic, copy) NSString *synopsis;

/**
 作者
 */
@property (nonatomic, copy) NSString *author;

/**
 作者简介

 */
@property (nonatomic, copy) NSString *author_introduce;

/**
 作者头像地址

 */
@property (nonatomic, copy) NSString *author_picture_url;

/**
 '发布者',

 */
@property (nonatomic, copy) NSString *previous_format;

/**
 创建时间',

 */
@property (nonatomic, copy) NSString *create_date;

/**
 点击量（显示）',

 */
@property (nonatomic ,assign) NSInteger hits_show;

/**
 视频URL
 */
@property (nonatomic, copy) NSString *date_details_url;

/**
 试看时间
 */
@property (nonatomic, assign) NSInteger try_and_see_time;


/**
 收藏ID
 */
@property (nonatomic ,assign) NSInteger collectID;

/**
 是否能看
 */
@property (nonatomic ,assign) NSInteger canSee;

@end
