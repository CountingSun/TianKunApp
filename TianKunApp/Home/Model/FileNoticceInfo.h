//
//  FileNoticceInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileNoticceInfo : NSObject
/**
 '文章ID
 
 */
@property (nonatomic, copy) NSString *article_id;

/**
 '文章类别（1土木工程/2工程施工/3市政工程/4水里工程等等数据库还是类中）',

 */
@property (nonatomic, copy) NSString *article_type;

/**
 '添加时间',

 */
@property (nonatomic, copy) NSString *add_date;

/**
 '区域'
 
 */
@property (nonatomic, copy) NSString *page_area;
/**
 页面标题',

 
 */
@property (nonatomic, copy) NSString *page_title;
/**
 文章标签',

 */
@property (nonatomic, copy) NSString *article_label;
/**
 '文章描述',

 */
@property (nonatomic, copy) NSString *article_describe;
/**
 文章标题',

 */
@property (nonatomic, copy) NSString *article_title;
/**
图片
 */
@property (nonatomic, copy) NSString *article_pictures;
/**
文章内容
 */
@property (nonatomic, copy) NSString *article_details;
/**
点击量
 */
@property (nonatomic, copy) NSString *hits_show;
@property (nonatomic ,strong) NSString *create_date;

@end
