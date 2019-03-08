//
//  ISVipManager.h
//  TianKunApp
//
//  Created by 天堃 on 2018/7/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISVipManager : NSObject

+ (void)getIsOpenVip:(void(^)(NSString *isOpen))succeedBlock;


+ (BOOL)isOpenVip;
+ (void)setIsOpenVip:(NSString *)isVIP;

@end
