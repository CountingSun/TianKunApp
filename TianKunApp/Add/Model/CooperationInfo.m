//
//  CooperationInfo.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CooperationInfo.h"

@implementation CooperationInfo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"cooperationID":@"id"
             };
}
- (NSMutableArray *)arrAddressName{
    if (!_arrAddressName) {
        _arrAddressName = [NSMutableArray array];
        
    }
    return _arrAddressName;
}
- (NSString *)address{
    if (!_address) {
        _address = @"";
    }
    return _address;
}
- (NSString *)addressDetail{
    if (!_addressDetail) {
        _addressDetail = @"";
    }
    return _addressDetail;
}
@end
