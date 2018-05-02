//
//  UsercollectionInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsercollectionInfo : NSObject

/**
 收藏标题
 */
@property (nonatomic, copy) NSString *collectTitle;
/**
 收藏ID
 */
@property (nonatomic, assign) NSInteger collectID;

@property (nonatomic, copy) NSString *collectImage;

/**
 数据ID
 */
@property (nonatomic, assign) NSInteger collectDataID;

/**
 音视频  文本用到
 */
@property (nonatomic, assign) NSInteger collectType;

/**
 辑删除状态：0删除，1显示
 */
@property (nonatomic, assign) NSInteger collectIsEffective;

/**
 阅读量
 */
@property (nonatomic, assign) NSInteger collectReadNum;

/**
 时间
 */
@property (nonatomic, copy) NSString *collectTime;


@end
