//
//  LocationManager.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/2.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "AddressInfo.h"



@interface LocationManager()<CLLocationManagerDelegate>
@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
@property (nonatomic,copy)    NSString *currentCity;//城市
@property (nonatomic,copy)    NSString *strLatitude;//经度
@property (nonatomic,copy)    NSString *strLongitude;//维度
@property (nonatomic,assign)  BOOL isAlearnHadShow;


@end

@implementation LocationManager

static LocationManager *_manager;

+ (instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_manager == nil) {
            _manager = [[LocationManager alloc] init];
        }
    });
    return _manager;
}
- (void)requestWithReturnBlock:(GetCoordinateFinsisBlock)coordinateFinsisBlock
           cityInfoFinsisBlock:(GetCityInfoFinsisBlock)cityInfoFinsisBlock
            locationErrorBlock:(GetLocationErrorBlock)locationErrorBlock{
    
    _coordinateFinsisBlock = coordinateFinsisBlock;
    _cityInfoFinsisBlock = cityInfoFinsisBlock;
    _locationErrorBlock = locationErrorBlock;
    
    [self locatemap];
}
- (void)reloadLocation{
    if ([CLLocationManager locationServicesEnabled]) {
    [self locatemap];
    }
}

- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            _currentCity = @"";
            [_locationManager requestWhenInUseAuthorization];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 5.0;

        }
        [_locationManager startUpdatingLocation];
    }else{
        [WQAlertController showAlertControllerWithTitle:@"提示" message:@"\"建筑一秘\"想获取你的位置信息来为你精准推荐相关内容" sureButtonTitle:@"打开定位" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
            NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication]openURL:settingURL];
        } cancelBlock:^(QMUIAlertAction *action) {
            
        }];
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain  code:-1000 userInfo:@{NSLocalizedDescriptionKey:@"未打开定位服务"}];
        
        WQLog(@"%@",error);
        if (_locationErrorBlock) {
            _locationErrorBlock(error);
            
        }

    }
}
#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (_locationErrorBlock) {
        _locationErrorBlock(error);
    }
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当前的经纬度
//    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    

    if (_coordinateFinsisBlock) {
        _coordinateFinsisBlock(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
        
    }
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 1.0){//如果调用已经一次，不再执行
        return;
    }
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            if (!_currentCity) {
                _currentCity = @"无法定位当前城市";
            }else{
                
                [self judgeIsReloadNewAddress:_currentCity updateBlock:^{
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

                    [userDefaults setObject:placeMark.locality forKey:CITY_KEY];
                    [userDefaults setObject:[NSString stringWithFormat:@"%@",@(currentLocation.coordinate.latitude)] forKey:LAT_KEY];
                    [userDefaults setObject:[NSString stringWithFormat:@"%@",@(currentLocation.coordinate.longitude)] forKey:LNG_kEY];
                    [userDefaults setObject:@"" forKey:CITY_CODE_KEY];
                    [userDefaults synchronize];

                }];
                
                
            }
            if (_cityInfoFinsisBlock) {
                _cityInfoFinsisBlock(placeMark.country,placeMark.locality,placeMark.subLocality,placeMark.thoroughfare,placeMark.name);
            }
        }else if (error == nil && placemarks.count){
            
            NSLog(@"NO location and error return");
        }else if (error){
            
            NSLog(@"loction error:%@",error);
        }
    }];
}
- (void)saveAddressWithAddressInfo:(AddressInfo *)addressInfo{
    if (addressInfo) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:addressInfo.cityName forKey:USER_ASSIGN_KEY];
        [userDefaults setObject:addressInfo.cityName forKey:CITY_KEY];
        [userDefaults setObject:addressInfo.cityID forKey:CITY_CODE_KEY];
        [userDefaults setObject:@"" forKey:LAT_KEY];
        [userDefaults setObject:@"" forKey:LNG_kEY];
        [userDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_UPDATE_KEY object:nil];

    }
}
- (NSString *)getLoactionInfoWithType:(LocationType)type{
    
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    switch (type) {
        case LocationTypeLng:{
            if ([userDefaults objectForKey:LNG_kEY]) {
                return [userDefaults objectForKey:LNG_kEY];
            }else{
                return @"";
            }
        }
            
            break;
        case LocationTypeLat:{
            if ([userDefaults objectForKey:LAT_KEY]) {
                return [userDefaults objectForKey:LAT_KEY];
            }else{
                return @"";
            }
        }

            break;
        case LocationTypeCity:{
            if ([userDefaults objectForKey:CITY_KEY]) {
                return [userDefaults objectForKey:CITY_KEY];
            }else{
                return @"郑州市";
            }
        }
            break;
        case LocationTypeCityCode:{
            if ([userDefaults objectForKey:CITY_CODE_KEY]) {
                return [userDefaults objectForKey:CITY_CODE_KEY];
            }else{
                return @"";
            }
        }
            break;

        default:{
            return @"";
        }
            break;
    }
}
+ (void)removeAllAddress{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:LNG_kEY];
    [userDefaults removeObjectForKey:LAT_KEY];
    [userDefaults removeObjectForKey:CITY_KEY];
    [userDefaults removeObjectForKey:CITY_CODE_KEY];
}
- (void)judgeIsReloadNewAddress:(NSString *)newCityName updateBlock:(dispatch_block_t)updateBlock{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   NSString *userAssginAdress =  [userDefaults objectForKey:USER_ASSIGN_KEY];
    
    if (!userAssginAdress.length) {
        [userDefaults setObject:newCityName forKey:USER_ASSIGN_KEY];

        if (updateBlock) {
            updateBlock();
        }
        return;

    }
    
    if ([userAssginAdress isEqualToString:newCityName]) {
        return;
    }

    NSString *oldAddress = [self getLoactionInfoWithType:LocationTypeCity];
    if (![newCityName isEqualToString:oldAddress]) {
        if (_isAlearnHadShow) {
            return;
        }
        _isAlearnHadShow = YES;
        [WQAlertController showAlertControllerWithTitle:@"提示" message:@"发现您当前的位置发生变化，是否更新位置信息？" sureButtonTitle:@"确定" cancelTitle:@"不再提示" sureBlock:^(QMUIAlertAction *action) {
            [userDefaults setObject:newCityName forKey:USER_ASSIGN_KEY];
            if (updateBlock) {
                updateBlock();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_UPDATE_KEY object:nil];
        
            _isAlearnHadShow = NO;

        } cancelBlock:^(QMUIAlertAction *action) {
            [userDefaults setObject:newCityName forKey:USER_ASSIGN_KEY];
            _isAlearnHadShow = NO;

        }];
    }
    
}

@end
