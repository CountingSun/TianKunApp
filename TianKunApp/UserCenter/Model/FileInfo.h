//
//  FileInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/17.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfo : NSObject

/**
 证书存储地址
 */
@property (nonatomic, copy) NSString *certificate_url;

/**
 上传时间
 */
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic ,assign) NSInteger fileID;

/**
 /资料类型1个人证书; 2企业证书; 3资质资料;
 */
@property (nonatomic ,assign) NSInteger data_type;

@end
