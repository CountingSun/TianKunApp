//
//  GoodsInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/6/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfo : NSObject


@property (nonatomic ,assign) NSInteger goodsID;
/**
 '商品名称'
 */
@property (nonatomic, copy) NSString *name;

/**
 库存量'
 */
@property (nonatomic ,assign) NSInteger number;

/**
 原价（钱）'
 */
@property (nonatomic ,assign) double money;

/**
 缩略图'
 */
@property (nonatomic, copy) NSString *picture;

/**
 商品简介
 */
@property (nonatomic, copy) NSString *synopsis;

/**
 商品简介生成的HTML
 */
@property (nonatomic, copy) NSString *synopsis_url;

/**
 积分'
 */
@property (nonatomic ,assign) NSInteger integral;

/**
 创建时间
 */
@property (nonatomic, copy) NSString *create_date;



@end
