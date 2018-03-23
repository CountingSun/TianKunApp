//
//  MapViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "MapFootView.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic ,strong) BMKMapView* mapView;
@property (nonatomic ,strong) BMKLocationService *locationService;
@property (nonatomic ,strong) BMKPointAnnotation* annotation;
@property (nonatomic ,strong) BMKGeoCodeSearch *geoCodeSearch;
@end

@implementation MapViewController
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geoCodeSearch.delegate = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"发布定位"];
    
    MapFootView *mapFootView = [[[NSBundle mainBundle] loadNibNamed:@"MapFootView" owner:nil options:nil] firstObject];
    [self.view addSubview:mapFootView];
    [mapFootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:mapFootView];
    
    
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [_mapView setZoomLevel:19];
    self.view = _mapView;
    [self starLocation];
    _annotation = [[BMKPointAnnotation alloc]init];
    //初始化检索对象
    _geoCodeSearch =[[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;


}

- (void)starLocation{
    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    //启动LocationService
    [_locationService startUserLocationService];

}
- (void)starGeoCodeSearchWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D{
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coordinate2D;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
//        在此处理正常结果
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLLocationCoordinate2D locationCoordinate2D = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    
    [_mapView setCenterCoordinate:locationCoordinate2D animated:YES];
    
    _annotation.coordinate = locationCoordinate2D;
    _annotation.title = @"当前位置";
    [_mapView addAnnotation:_annotation];
    
    [self starGeoCodeSearchWithCLLocationCoordinate2D:locationCoordinate2D];

    
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    [self showErrorWithStatus:[NSString stringWithFormat:@"定位失败\n%@",error]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
