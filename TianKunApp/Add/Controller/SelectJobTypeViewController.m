//
//  SelectJobTypeViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/30.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SelectJobTypeViewController.h"
#import "FilterTableView.h"
#import "FilterInfo.h"
#import "ClassTypeInfo.h"

@interface SelectJobTypeViewController ()
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) NSMutableArray *arrProvice;
@property (nonatomic ,strong) NSMutableArray *arrCity;
@property (nonatomic ,strong) FilterTableView *cityTableView;
@property (nonatomic ,strong) FilterTableView *provinceTableView;
@property (nonatomic ,strong) FilterInfo *provinceInfo;
@property (nonatomic ,strong) ClassTypeInfo *classTypeInfo;

@end

@implementation SelectJobTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"工作类型"];
    [self cityTableView];
    [self provinceTableView];
    [self showLoadingView];
    [self getJobTypeWithID:@"15"];
}

- (void)getJobTypeWithID:(NSString *)typeID{
    
    
    [[[NetWorkEngine alloc]init] postWithDict:@{@"edificeid":typeID} url:BaseUrl(@"home/getcategory.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if ([typeID isEqualToString:@"15"]) {
            if (!_arrProvice) {
                _arrProvice = [NSMutableArray array];
            }
            [_arrProvice removeAllObjects];
            

        }else{
            if (!_arrCity) {
                _arrCity = [NSMutableArray array];
            }
            [_arrCity removeAllObjects];

        }

        if (code == 1) {
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"zwlx"];
            for (NSDictionary *dict in arrData) {
                FilterInfo *filterInfo = [[FilterInfo alloc]init];
                filterInfo.propertyID = [[dict objectForKey:@"id"] stringValue];
                filterInfo.propertyName = [dict objectForKey:@"type_name"];
                if ([typeID isEqualToString:@"15"]) {
                    [_arrProvice addObject:filterInfo];
                    
                    
                }else{
                    [_arrCity addObject:filterInfo];

                }
                
                
            }
            if ([typeID isEqualToString:@"15"]) {
                FilterInfo *filterInfo = _arrProvice[0];
                [self getJobTypeWithID:filterInfo.propertyID];
                _provinceTableView.arrData = _arrProvice;
            }else{
                
                _cityTableView.arrData = _arrCity;
                
            }
        }else{
            [self hideLoadingView];
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            if ([typeID isEqualToString:@"15"]) {
                [self showGetDataFailViewWithReloadBlock:^{
                    [self showLoadingView];
                    [self getJobTypeWithID:@"15"];
                }];
                
            }else{
                [_arrCity removeAllObjects];
                _cityTableView.arrData = _arrCity;
                
            }

        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView ];
            if (_classTypeInfo) {
                [self getJobTypeWithID:_classTypeInfo.typeID];
                
            }else{
                [self getJobTypeWithID:@"15"];
                
            }
            
        }];
        
    }];
    
}

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
            [weakSelf getJobTypeWithID:filterInfo.propertyID];
            _provinceInfo = filterInfo;
            
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
            
            if (weakSelf.selectJobSucceedBlock) {
                weakSelf.selectJobSucceedBlock(weakSelf.provinceInfo,filterInfo);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _cityTableView;
    
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
