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
#import "LocationManager.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic ,strong) BMKMapView* mapView;
@property (nonatomic ,strong) BMKLocationService *locationService;
@property (nonatomic ,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic ,strong) BMKAnnotationView *annotationView;
@property (nonatomic ,strong) BMKPointAnnotation* annotation;
@property (nonatomic ,strong) MapFootView *mapFootView;

@property (nonatomic ,strong) QMUIButton *nowLocationButton;
@property (nonatomic ,strong) BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;

@end

@implementation MapViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geoCodeSearch.delegate = self;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geoCodeSearch.delegate = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"位置"];
    [self setupMap];
    
    [self setupView];
    
}
- (void)setupMap{
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [_mapView setZoomLevel:19];
    self.view = _mapView;
    //初始化检索对象
    _geoCodeSearch =[[BMKGeoCodeSearch alloc]init];

    if (_centerCoordinate.latitude) {
        [_mapView setCenterCoordinate:_centerCoordinate animated:YES];

    }else{
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            
            //定位功能可用
            [self starLocation];

            
        }else {
            BMKGeoCodeSearchOption *searchOption = [[BMKGeoCodeSearchOption alloc] init];
            searchOption.city = [[LocationManager manager] getLoactionInfoWithType:LocationTypeCity];
            searchOption.address = [[LocationManager manager] getLoactionInfoWithType:LocationTypeCity];

           BOOL flag =  [_geoCodeSearch geoCode:searchOption];
            if(flag)
            {
                NSLog(@"geo检索发送成功");
            }
            else
            {
                NSLog(@"geo检索发送失败");
            }
//            CLLocationCoordinate2D locationCoordinate2Dd = CLLocationCoordinate2DMake(34.760000,113.650000);
//
//            [_mapView setCenterCoordinate:locationCoordinate2Dd animated:NO];

//            QMUIAlertController *alertController = [[QMUIAlertController alloc]initWithTitle:@"提示" message:@"定位失败，已默认定位到郑州，请手动选择地址。" preferredStyle:QMUIAlertControllerStyleAlert];
//
//
//            QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction * action) {
//                //        [self.navigationController popViewControllerAnimated:YES];
//            }];
//
//            [alertController addAction:cancelAction];
//            [alertController showWithAnimated:YES];

        }

    }

}
- (void)setupView{
    UIImageView *locationImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectLocation"]];
    
    [self.view addSubview:locationImageView];
    
    locationImageView.frame = CGRectMake(0, 0, 20, 20);
    locationImageView.center = self.view.center;
    _mapFootView = [[[NSBundle mainBundle] loadNibNamed:@"MapFootView" owner:nil options:nil] firstObject];
    [self.view addSubview:_mapFootView];
    [_mapFootView.changeButton addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_mapFootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(180);
    }];
    
    if (_addressText.length) {
        _mapFootView.detailLabel.text = _addressText;
    }
    if (_addressDetail.length) {
        _mapFootView.textField.text = _addressDetail;
    }
    
    _nowLocationButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_nowLocationButton];
    [_nowLocationButton setImage:[UIImage imageNamed:@"get_user_location"] forState:0];
    [_nowLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        
        make.width.height.offset(20);
    }];
    [_nowLocationButton addTarget:self action:@selector(starLocation) forControlEvents:UIControlEventTouchUpInside];
    

}
- (void)changeButtonClick{
    if (!_mapFootView.detailLabel.text.length) {
        [self showErrorWithStatus:@"请选择地址"];
        return;
    }
    if (!_mapFootView.textField.text.length) {
        [self showErrorWithStatus:@"请填写详细地址"];
        return;

    }
    if (_selectSucceedBlock) {
        _selectSucceedBlock(_mapView.centerCoordinate,_mapFootView.detailLabel.text,_mapFootView.textField.text);
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
- (void)starLocation{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
    }
    //启动LocationService
    [_locationService startUserLocationService];

}
- (void)starGeoCodeSearchWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D{
    
    if (!_reverseGeoCodeSearchOption) {
        _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    _reverseGeoCodeSearchOption.reverseGeoPoint = coordinate2D;
    BOOL flag = [_geoCodeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
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
        _mapFootView.detailLabel.text = result.address;
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //        在此处理正常结果
        _mapFootView.detailLabel.text = result.address;
        [_mapView setCenterCoordinate:result.location animated:NO];
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
    
    [self starGeoCodeSearchWithCLLocationCoordinate2D:locationCoordinate2D];

    [_mapView setCenterCoordinate:locationCoordinate2D animated:YES];
    [_locationService stopUserLocationService];
}
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{

}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"当前中心点坐标 lat %f,long %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    
    CLLocationCoordinate2D locationCoordinate2D = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);

    [self starGeoCodeSearchWithCLLocationCoordinate2D:locationCoordinate2D];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    QMUIAlertController *alertController = [[QMUIAlertController alloc]initWithTitle:@"提示" message:@"定位失败,请手动选择地址" preferredStyle:QMUIAlertControllerStyleAlert];
    
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction * action) {
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertController addAction:cancelAction];
    [alertController showWithAnimated:YES];
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
