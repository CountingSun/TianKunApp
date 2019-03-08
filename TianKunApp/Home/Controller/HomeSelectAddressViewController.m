//
//  HomeSelectAddressViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeSelectAddressViewController.h"
#import "FilterInfo.h"
#import "FilterView.h"
#import "AddressInfo.h"
#import "LocationManager.h"
#import "FilterTableView.h"

@interface HomeSelectAddressViewController ()
@property (nonatomic ,strong) NSMutableArray *arrProvice;
@property (nonatomic ,strong) NSMutableArray *arrCity;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) QMUIButton *saveButton;
@property (nonatomic ,strong) FilterTableView *cityTableView;
@property (nonatomic ,strong) FilterTableView *provinceTableView;

@end

@implementation HomeSelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cityTableView];
    [self provinceTableView];

    [self showLoadingView];
    [self getProvice];
    [self.titleView setTitle:@"选择位置"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];

    
    
}
- (void)rightBarButtonItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- lazy init
- (FilterTableView *)provinceTableView{
    if (!_provinceTableView) {
        _provinceTableView = [[FilterTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
        
        
        [self.view addSubview:_provinceTableView];
        [_provinceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.view);
            make.width.offset(SCREEN_WIDTH/2);
            
        }];
        
        __weak typeof(self) weakSelf = self;
        
        _provinceTableView.selectTableViewBlock = ^(FilterInfo *filterInfo) {
            [weakSelf getCityArrWithProiviceID:filterInfo.propertyID];

        };
        
    }
    return _provinceTableView;
}
- (FilterTableView *)cityTableView{
    if (!_cityTableView) {
        _cityTableView = [[FilterTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
        
        [self.view addSubview:_cityTableView];
        [_cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.view);
            make.width.offset(SCREEN_WIDTH/2);
            
        }];
        
        
        
        __weak typeof(self) weakSelf = self;
        
        _cityTableView.selectTableViewBlock = ^(FilterInfo *filterInfo) {
            
            AddressInfo *addressInfo = [[AddressInfo alloc] init];
            addressInfo.cityID = filterInfo.propertyID;
            addressInfo.cityName = filterInfo.propertyName;
            [[LocationManager manager] saveAddressWithAddressInfo:addressInfo];
            if (weakSelf.selectAddressSuccedBlock) {
                weakSelf.selectAddressSuccedBlock(addressInfo);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _cityTableView;
    
}

- (void)getProvice{
    
    [self.netWorkEngine postWithUrl:BaseUrl(@"home/getprivince.action") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if(!_arrProvice){
                _arrProvice = [NSMutableArray array];
            }
            [_arrProvice removeAllObjects];
            
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"provinceList"];
            for (NSDictionary *dict in arrData) {
                
                FilterInfo *filterInfo = [[FilterInfo alloc]init];
                filterInfo.propertyID = [dict objectForKey:@"provinceid"];
                filterInfo.propertyName = [dict objectForKey:@"province"];
                
                [_arrProvice addObject:filterInfo];
            }
            FilterInfo *filterInfo= _arrProvice[0];
            
            [self getCityArrWithProiviceID:filterInfo.propertyID];
            self.provinceTableView.arrData = _arrProvice;
            [self.provinceTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            
        }else{
            [self hideLoadingView];
            [self showGetDataFailViewWithReloadBlock:^{
                [self getProvice];
            }];
            
        }
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self getProvice];
        }];
        
    }];
    
    
    
}
- (void)getCityArrWithProiviceID:(NSString *)proiviceID{
    
    [self .netWorkEngine postWithDict:@{@"provinceid":proiviceID} url:BaseUrl(@"home/getcity.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];
        if(!_arrCity){
            _arrCity = [NSMutableArray array];
        }
        [_arrCity removeAllObjects];
        
        if (code == 1) {
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"cityList"];
            for (NSDictionary *dict in arrData) {
                
                FilterInfo *filterInfo = [[FilterInfo alloc]init];
                filterInfo.propertyID = [dict objectForKey:@"cityid"];
                filterInfo.propertyName = [dict objectForKey:@"city"];
                
                [_arrCity addObject:filterInfo];
            }
            self.cityTableView.arrData = _arrCity;
            
            
        }else{
            
            [self hideLoadingView];
            [self showGetDataFailViewWithReloadBlock:^{
                [self getProvice];
            }];
            
        }
        
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self getProvice];
        }];
        
    }];
    
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
