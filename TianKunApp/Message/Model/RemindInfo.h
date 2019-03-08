//
//  RemindInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/9.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindInfo : NSObject
@property (nonatomic, copy) NSString *certificate_url;
@property (nonatomic, copy) NSString *opening_date;
@property (nonatomic, copy) NSString *remind_date;

@property (nonatomic, copy) NSString *certificate_name;
@property (nonatomic, copy) NSString *name;
//消息内容
@property (nonatomic, copy) NSString *remind;
//消息标题
@property (nonatomic, copy) NSString *certificate_type_name;


@end
