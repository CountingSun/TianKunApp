//
//  TKMessageListInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKMessageListInfo : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString *listTitle;

/**
 图标
 */
@property (nonatomic, copy) NSString *listImage;

/**
 详情
 */
@property (nonatomic, copy) NSString *listDetail;

/**
 未读消息个数
 */
@property (nonatomic ,assign) NSInteger listUnReadNum;

/**
 id
 */
@property (nonatomic ,assign) NSInteger listID;


- (instancetype)initWithListTitle:(NSString *)listTitle
                       listDetail:(NSString *)listDetail
                        listImage:(NSString *)listImage
                    listUnReadNum:(NSInteger)listUnReadNum
                           listID:(NSInteger)listID;

@end
