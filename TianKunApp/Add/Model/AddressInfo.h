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

@end
