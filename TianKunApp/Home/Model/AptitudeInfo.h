//
//  AptitudeInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AptitudeInfo : NSObject

/**
类别名称
 */
@property (nonatomic, copy) NSString *lbname;

/**
 证书编号

 */
@property (nonatomic, copy) NSString *zsbh;
/**
 /发证时间

 */
@property (nonatomic, copy) NSString *fzdate;
/**
 测试类型",//证书名称

 */
@property (nonatomic, copy) NSString *name;
/**
 证书截止日期

 */
@property (nonatomic, copy) NSString *jzdate;
/**
 发证机关

 */
@property (nonatomic, copy) NSString *jg;


@end
