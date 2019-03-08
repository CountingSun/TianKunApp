//
//  AddHistoryRecordNetwork.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddHistoryRecordNetwork : NSObject
//  private Short data_type;//资料(信息)类型: 1岗位信息,2简历信息,3文件通知,4公示公告,5招投标信息,6教育培训,7互动交流,8企业信息(APP发布),9企业信息(WEB发布) 11 商务合作

- (void)addHistoryRecodeWithDataID:(NSInteger)dataID dataType:(NSInteger)dataType  dataTypeTwo:(NSInteger)dataTypeTwo data_title:(NSString *)data_title data_sketch:(NSString *)data_sketch dataPictureUrl:(NSString *)dataPictureUrl;

@end
