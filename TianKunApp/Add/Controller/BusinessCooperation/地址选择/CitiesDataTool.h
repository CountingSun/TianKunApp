//
//  CitiesDataTool.h
//  ChooseLocation
//
//  Created by Sekorm on 16/10/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^getAddressBlock)(NSInteger code,NSMutableArray *arrData);

@interface CitiesDataTool : NSObject
//查询出所有的省
- (void)getAllProvinceWithBlock:(getAddressBlock)getAddressBlock;
//查询出省下所有的市
- (void)getCityWithProvinceID:(NSString *)provinceID getAddressBlock:(getAddressBlock)getAddressBlock;
//查询出市下所有的县
- (void)getCountiesWithCityID:(NSString *)cityID getAddressBlock:(getAddressBlock)getAddressBlock;
@end
