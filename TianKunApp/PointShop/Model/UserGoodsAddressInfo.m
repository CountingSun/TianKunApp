//
//  UserGoodsAddressInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/14.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UserGoodsAddressInfo.h"

@implementation UserGoodsAddressInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"addressID":@"id"
             };
}
@end
