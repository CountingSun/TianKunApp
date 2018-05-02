//
//  RecommendVidoInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/9.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendVidoInfo : NSObject


/**
 资料标题
 */
@property (nonatomic, copy) NSString *data_title;

/**
 点击量
 */
@property (nonatomic ,assign) NSInteger hits_show;

@property (nonatomic, copy) NSString *recommend_id;


/**
 是否收费,0否,1是
 */
@property (nonatomic ,assign) NSInteger is_charge;
@property (nonatomic ,assign) NSInteger shoucangrenid;

/**
 内容简介
 */
@property (nonatomic, copy) NSString *synopsis;

/**
 视频的展示图片
 */
@property (nonatomic, copy) NSString *video_image_url;

@end
