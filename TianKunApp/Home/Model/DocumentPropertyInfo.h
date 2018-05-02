//
//  DocumentPropertyInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/9.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentPropertyInfo : NSObject

/**
 课程类型 k data_type2;//课程类别 二级,属于资料标签用于课程二级分类

 */
@property (nonatomic ,assign) NSInteger classType;

/**
 资料类别 l type;//文件类型:1文本,  2音频, 3视频;

 */
@property (nonatomic ,assign) NSInteger documentClass;

/**
 是否收费 m 是否收费0否,1是

 */
@property (nonatomic ,assign) NSInteger isFree;

/**
 资料种类 z data_type1;//资料类别:一级(政策解读,一级造师,二级造师...)
 */
@property (nonatomic ,assign) NSInteger documentType;

@end
