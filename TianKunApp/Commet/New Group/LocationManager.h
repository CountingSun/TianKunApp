//
//  LocationManager.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AddressInfo;


//存储经度的key
#define LNG_kEY @"LNG_kEY"

//存储维度的key
#define LAT_KEY @"LAT_KEY"

//存储城市名的key
#define CITY_KEY @"CITY_KEY"

//存储城市编号的key
#define CITY_CODE_KEY @"CITY_CODE_KEY"
//用户确定存储的key
#define USER_ASSIGN_KEY @"USER_ASSIGN_KEY"

typedef NS_ENUM(NSUInteger,LocationType) {
    LocationTypeLng,
    LocationTypeLat,
    LocationTypeCity,
    LocationTypeCityCode

};

/**
 定位到的经纬度

 @param latitude 纬度
 @param longitude 经度
 */
typedef void(^GetCoordinateFinsisBlock)(double latitude,double longitude);

/**
 地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)

 @param country 国家
 @param locality 城市
 @param subLocality 社区
 @param thoroughfare 街道
 @param name 具体地址
 */
typedef void(^GetCityInfoFinsisBlock)(NSString *country,NSString *locality,NSString *subLocality,NSString *thoroughfare,NSString *name);

/**
 定位失败回调

 @param error 错误信息 
 */
typedef void(^GetLocationErrorBlock)(NSError *error);

@interface LocationManager : NSObject

@property (nonatomic, copy) GetCoordinateFinsisBlock coordinateFinsisBlock;
@property (nonatomic, copy) GetCityInfoFinsisBlock cityInfoFinsisBlock;
@property (nonatomic, copy) GetLocationErrorBlock locationErrorBlock;


+(instancetype)manager;


/**
 刷新定位到的信息  保存在本地
 */
- (void)reloadLocation;

- (void)requestWithReturnBlock:(GetCoordinateFinsisBlock)coordinateFinsisBlock cityInfoFinsisBlock:(GetCityInfoFinsisBlock)cityInfoFinsisBlock locationErrorBlock:(GetLocationErrorBlock)locationErrorBlock;


-(void)saveAddressWithAddressInfo:(AddressInfo *)addressInfo;

-(NSString *)getLoactionInfoWithType:(LocationType)type;




@end
