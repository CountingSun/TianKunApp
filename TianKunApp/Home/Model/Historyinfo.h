//
//  Historyinfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Historyinfo : NSObject

@property (nonatomic, copy) NSString *data_title;
@property (nonatomic ,assign) NSInteger data_type;
@property (nonatomic ,assign) NSInteger data_id;
@property (nonatomic, copy) NSString *data_sketch;
@property (nonatomic, copy) NSString *data_picture_url;
@property (nonatomic, copy) NSString *create_date;

@property (nonatomic ,assign) BOOL isSelect;

@end
