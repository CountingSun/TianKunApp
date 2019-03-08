//
//  CitiesDataTool.m
//  ChooseLocation
//
//  Created by Sekorm on 16/10/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "CitiesDataTool.h"
#import "AddressInfo.h"

@interface CitiesDataTool ()
@property (nonatomic,strong) NSMutableArray * arrProvince;
@property (nonatomic,strong) NSMutableArray * arrCity;
@property (nonatomic,strong) NSMutableArray * arrCounties;

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@end

@implementation CitiesDataTool

//查询出所有的省
- (void)getAllProvinceWithBlock:(getAddressBlock)getAddressBlock{
    [self.netWorkEngine postWithUrl:BaseUrl(@"home/getprivince.action") succed:^(id responseObject) {
        if(!_arrProvince){
            _arrProvince = [NSMutableArray array];
        }
        [_arrProvince removeAllObjects];

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"provinceList"];
            for (NSDictionary *dict in arrData) {
                
                AddressInfo *info = [[AddressInfo alloc]init];
                info.addressID = [dict objectForKey:@"provinceid"];
                info.addressName = [dict objectForKey:@"province"];
                
                [_arrProvince addObject:info];
            }
            
            
        }else{
        }
        getAddressBlock(code,_arrProvince);
        
    } errorBlock:^(NSError *error) {
        getAddressBlock(0,_arrProvince);

    }];
    
    

}
//查询出省下所有的市
- (void)getCityWithProvinceID:(NSString *)provinceID getAddressBlock:(getAddressBlock)getAddressBlock{
    [self .netWorkEngine postWithDict:@{@"provinceid":provinceID} url:BaseUrl(@"home/getcity.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(!_arrCity){
            _arrCity = [NSMutableArray array];
        }
        [_arrCity removeAllObjects];

        if (code == 1) {
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"cityList"];
            for (NSDictionary *dict in arrData) {
                
                AddressInfo *filterInfo = [[AddressInfo alloc]init];
                filterInfo.addressID = [dict objectForKey:@"cityid"];
                filterInfo.addressName = [dict objectForKey:@"city"];
                
                [_arrCity addObject:filterInfo];
            }
            
        }else{
        }
        getAddressBlock(code,_arrCity);

        
    } errorBlock:^(NSError *error) {
        getAddressBlock(0,_arrCity);

    }];

}
//查询出市下所有的县
- (void)getCountiesWithCityID:(NSString *)cityID getAddressBlock:(getAddressBlock)getAddressBlock{
    
    [self .netWorkEngine getWithUrl:[NSString stringWithFormat:@"%@?cityid=%@",BaseUrl(@"find.by.areaList"),cityID] succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(!_arrCounties){
            _arrCounties = [NSMutableArray array];
        }
        [_arrCounties removeAllObjects];
        
         if (code == 1) {
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            for (NSDictionary *dict in arrData) {
                
                AddressInfo *filterInfo = [[AddressInfo alloc]init];
                filterInfo.addressID = [dict objectForKey:@"areaid"];
                filterInfo.addressName = [dict objectForKey:@"area"];
                
                [_arrCounties addObject:filterInfo];
            }
            
        }else{
        }
        getAddressBlock(code,_arrCounties);

    } errorBlock:^(NSError *error) {
        getAddressBlock(0,_arrCounties);

    }];
    


}

- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
}

@end
