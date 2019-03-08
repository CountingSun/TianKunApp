//
//  AddressInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject
@property (nonatomic, copy) NSString *addressName;
@property (nonatomic ,copy) NSString *addressID;
@property (nonatomic ,assign) BOOL isSelect;


@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *provinceID;
@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *countiesID;
@property (nonatomic, copy) NSString *countiesName;

@end
