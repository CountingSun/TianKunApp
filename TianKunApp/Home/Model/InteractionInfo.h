//
//  InteractionInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InteractionInfo : NSObject

/**
 <#Description#>
 */
@property (nonatomic, copy) NSString *interactionID;
/**
 创建人(用户)id',

 */
@property (nonatomic, copy) NSString *user_id;
/**
 主题
 */
@property (nonatomic, copy) NSString *title;
/**
 内容',
 */
@property (nonatomic, copy) NSString *content;
/**
 文章类别',

 */
@property (nonatomic, copy) NSString *category;
/**
 点击量（显示）',

 */
@property (nonatomic, assign) NSInteger hits_show;
/**
 点击量（实际）
 */
@property (nonatomic, copy) NSString *hits_record;
/**
 收藏量 --
 */
@property (nonatomic, assign) NSInteger collect_count;


/**
 发布时间
 */
@property (nonatomic, copy) NSString *create_date;
/**
 更新时间
 */
@property (nonatomic, copy) NSString *update_date;

/**
 评论数量
 */
@property (nonatomic, assign) NSInteger hfnum;

/**
 收藏ID
 */
@property (nonatomic ,assign) NSInteger shoucangid;

@end
