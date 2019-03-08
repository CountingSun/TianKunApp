//
//  UserGoodsAddressInfo.h
//  TianKunApp
//
//  Created by 天堃 on 2018/6/14.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGoodsAddressInfo : NSObject
@property (nonatomic ,assign) NSInteger addressID;

@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *addres;

@end
