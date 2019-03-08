//
//  JobViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "JobViewController.h"
#import "FilterView.h"
#import "UIView+Extension.h"
#import "JobViewTableViewCell.h"
#import "JobDetailViewController.h"
#import "JobInfo.h"
#import "FilterInfo.h"

@interface JobViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet QMUIButton *firstButton;
@property (weak, nonatomic) IBOutlet QMUIButton *secondButton;
@property (weak, nonatomic) IBOutlet QMUIButton *thirdButton;
@property (nonatomic ,strong) FilterView *filterView;
@property (nonatomic ,strong) FilterView *addressFilterView;

@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NSMutableArray *arrTypeOne;
@property (nonatomic ,strong) NSMutableArray *arrTypeTwo;

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *positionID;
/**
 0升序 1降序
 */
@property (nonatomic, assign) NSInteger hot;

@property (nonatomic ,strong) NSMutableArray *arrProvice;
@property (nonatomic ,strong) NSMutableArray *arrCity;

@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"找人才"];
    _hot = 1;
    _cityID = @"";
    _positionID = @"";
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    [_firstButton setImage:[UIImage imageNamed:@"jian_tou下"] forState:UIControlStateNormal];
    [_firstButton setImage:[UIImage imageNamed:@"jian_tou"] forState:UIControlStateSelected];
    [_secondButton setImage:[UIImage imageNamed:@"jian_tou下"] forState:UIControlStateNormal];
    [_secondButton setImage:[UIImage imageNamed:@"jian_tou"] forState:UIControlStateSelected];
    [_firstButton setImagePosition:QMUIButtonImagePositionRight];
    [_firstButton setSpacingBetweenImageAndTitle:5];
    [_secondButton setSpacingBetweenImageAndTitle:5];
    [_secondButton setImagePosition:QMUIButtonImagePositionRight];

    [self.tableView registerNib:[UINib nibWithNibName:@"JobViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobViewTableViewCell"];
    
    [self showLoadingView];
    [self getJob];
    

}
- (void)getJob{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSDictionary *partDict =@{
                              @"cityid":_cityID,
                              @"position_id":_positionID,
                              @"hot":@(_hot),
                              @"startPage":@(_pageIndex),
                              @"endPage":@(_pageSize),
                              };
    [self.netWorkEngine postWithDict:partDict url:BaseUrl(@"home/getjoblist.action") succed:^(id responseObject) {
        [self hideLoadingView];
        [_tableView endRefresh];
        [self hideSelfEmptyView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"joblist"];
            if (arr.count) {
                if (!_arrData) {
                    _arrData = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    JobInfo *jobInfo = [JobInfo mj_objectWithKeyValues:dict];
                    jobInfo.firstTypeName = [dict objectForKey:@"firstTypeName"];
                    jobInfo.secondTypeName = [dict objectForKey:@"secondTypeName"];

                    [_arrData addObject:jobInfo];
                    
                }
                [self.tableView reloadData];
                if (_pageSize>arr.count) {
                    self.tableView.canLoadMore = NO;
                }else{
                    self.tableView.canLoadMore = YES;
                }
            }else{
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                    [self.tableView reloadData];
                }
                if (!_arrData.count) {
                    [self showGetDataNullEmptyViewInView:self.tableView reloadBlock:^{
                        [self showLoadingView];
                        [self getJob];
                    }];
                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
            }

        }else{
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
                [self.tableView reloadData];
            }
            if (!_arrData.count) {
                [self showGetDataNullEmptyViewInView:self.tableView reloadBlock:^{
                    [self showLoadingView];
                    [self getJob];
                }];
            }else{
                _pageIndex--;
                
                [self showErrorWithStatus:NET_WAIT_NO_DATA];
                
            }
        }


    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        _pageIndex --;
        [self hideSelfEmptyView];

        [_tableView endRefresh];
        
        if (_arrData.count) {
            
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            [self showGetDataFailEmptyViewInView:self.tableView reloadBlock:^{
                [self showLoadingView];
                [self getJob];
            }];
            
        }

    }];
    
}
#pragma makr- tableview  d d
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobViewTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JobViewTableViewCell" owner:nil options:nil] firstObject];
    }
    
    JobInfo *jobInfo = _arrData[indexPath.row];
    
    cell.jobInfo = jobInfo;
    cell.selectionStyle = 0;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobInfo *jobInfo = _arrData[indexPath.row];
    JobDetailViewController *vc = [[JobDetailViewController alloc]initWithJobID:jobInfo.job_id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma makr- button click
- (IBAction)firstButtonClick:(id)sender {
    [self.addressFilterView hiddenFilterView];
    _secondButton.selected = NO;

    if ([self.filterView isShow]) {
        [self.filterView hiddenFilterView];
        _firstButton.selected = NO;

        
    }else{
        [self.filterView showFilterView];
        _firstButton.selected = YES;
    }

}
- (IBAction)secondButtonClick:(id)sender {
    [self.filterView hiddenFilterView];
    _firstButton.selected = NO;

    if ([self.addressFilterView isShow]) {
        [self.addressFilterView hiddenFilterView];
        _secondButton.selected = NO;
    }else{
        [self.addressFilterView showFilterView];
        _secondButton.selected = YES;

    }
}
- (IBAction)thirdButtonClick:(id)sender {

    _secondButton.selected = NO;
    _firstButton.selected = NO;
    if (_thirdButton.selected) {
        _hot = 1;
    }else{
        _hot = 0;
    }
    [self.tableView beginRefreshing];

    [self getJob];
    _thirdButton.selected =!_thirdButton.selected;
    
    
    [self.filterView hiddenFilterView];
    [self.addressFilterView hiddenFilterView];

}

#pragma mark- lazy init
- (FilterView *)filterView{
    if (!_filterView) {
        _filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0)];
        [self.view addSubview:_filterView];
        [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstButton.mas_bottom);
            make.bottom.equalTo(self.view);
            make.left.right.equalTo(self.view);
            
        }];

        __weak typeof(self) weakSelf = self;
        _filterView.hidden = YES;
        _filterView.firseSelectBlock = ^(FilterInfo *filterInfo) {
            [weakSelf getJobTypeWithID:filterInfo.propertyID];
        };
        _filterView.secondSelectBlock = ^(FilterInfo *filterInfo) {
            weakSelf.pageIndex = 1;
            [weakSelf.firstButton setTitle:filterInfo.propertyName forState:0];
            
            weakSelf.positionID = filterInfo.propertyID;
            [weakSelf.tableView beginRefreshing];
            [weakSelf getJob];
        };
        [self getJobTypeWithID:@"15"];
    }
    return _filterView;
}
- (FilterView *)addressFilterView{
    if (!_addressFilterView) {
        _addressFilterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0)];
        [self.view addSubview:_addressFilterView];
        __weak typeof(self) weakSelf = self;
        _addressFilterView.hidden = YES;

        _addressFilterView.firseSelectBlock = ^(FilterInfo *filterInfo) {
                [weakSelf getCityArrWithProiviceID:filterInfo.propertyID];
        };
        _addressFilterView.secondSelectBlock = ^(FilterInfo *filterInfo) {
            _pageIndex = 1;
            _cityID = filterInfo.propertyID;
            [weakSelf.secondButton setTitle:filterInfo.propertyName forState:0];

            [weakSelf.tableView beginRefreshing];
            [weakSelf getJob];

        };
        [_addressFilterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstButton.mas_bottom);
            make.bottom.equalTo(self.view);
            make.left.right.equalTo(self.view);
            
        }];
        
        [self getProvice];

    }
    return _addressFilterView;

}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            weakSelf.pageIndex = 1;
            
            [weakSelf getJob];
            
        }];
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex ++;
            
            [weakSelf getJob];

        }];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(45);
        }];
        
        
        
        
    }
    return _tableView;
}
- (void)getProvice{
    [self showWithStatus:NET_WAIT_TOST];
    
    [self.netWorkEngine postWithUrl:BaseUrl(@"home/getprivince.action") succed:^(id responseObject) {

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self dismiss];

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
            self.addressFilterView.arrData1 = _arrProvice;
            [self.addressFilterView.firsetTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }

    } errorBlock:^(NSError *error) {

        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
    
    
}
- (void)getCityArrWithProiviceID:(NSString *)proiviceID{
    [self showWithStatus:NET_WAIT_TOST];

    [self .netWorkEngine postWithDict:@{@"provinceid":proiviceID} url:BaseUrl(@"home/getcity.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];
        if(!_arrCity){
            _arrCity = [NSMutableArray array];
        }
        [_arrCity removeAllObjects];
        [self dismiss];

        if (code == 1) {
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"cityList"];
            for (NSDictionary *dict in arrData) {
                
                FilterInfo *filterInfo = [[FilterInfo alloc]init];
                filterInfo.propertyID = [dict objectForKey:@"cityid"];
                filterInfo.propertyName = [dict objectForKey:@"city"];
                
                [_arrCity addObject:filterInfo];
            }
            self.addressFilterView.arrData2 = _arrCity;
            
            
        }else{
            
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];

    }];
    
}
- (void)getJobTypeWithID:(NSString *)typeID{
    
    [self showWithStatus:NET_WAIT_TOST];

    [[[NetWorkEngine alloc]init] postWithDict:@{@"edificeid":typeID} url:BaseUrl(@"home/getcategory.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if ([typeID isEqualToString:@"15"]) {
            if (!_arrTypeOne) {
                _arrTypeOne = [NSMutableArray array];
            }
            [_arrTypeOne removeAllObjects];
            
            
        }else{
            if (!_arrTypeTwo) {
                _arrTypeTwo = [NSMutableArray array];
            }
            [_arrTypeTwo removeAllObjects];
            
        }
        
        if (code == 1) {
            [self dismiss];

            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"zwlx"];
            for (NSDictionary *dict in arrData) {
                FilterInfo *filterInfo = [[FilterInfo alloc]init];
                filterInfo.propertyID = [[dict objectForKey:@"id"] stringValue];
                filterInfo.propertyName = [dict objectForKey:@"type_name"];
                if ([typeID isEqualToString:@"15"]) {
                    [_arrTypeOne addObject:filterInfo];
                    
                    
                }else{
                    [_arrTypeTwo addObject:filterInfo];
                    
                }
                
                
            }
            if ([typeID isEqualToString:@"15"]) {
                FilterInfo *filterInfo = _arrTypeOne[0];
                [self getJobTypeWithID:filterInfo.propertyID];
                self.filterView.arrData1 = _arrTypeOne;
                [self.filterView.firsetTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

            }else{
                
                self.filterView.arrData2 = _arrTypeTwo;
                
            }
        }else{
            if (![typeID isEqualToString:@"15"]) {
                [_arrTypeTwo removeAllObjects];
                self.filterView.arrData2 = _arrTypeTwo;

            }
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
    
        [self showErrorWithStatus:NET_ERROR_TOST];
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
