//
//  FindJobViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindJobViewController.h"
#import "FilterView.h"
#import "UIView+Extension.h"
#import "FindJobTableViewCell.h"
#import "FindJodDetailViewController.h"
#import "ResumeInfo.h"
#import "FilterInfo.h"


@interface FindJobViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet QMUIButton *firstButton;
@property (weak, nonatomic) IBOutlet QMUIButton *secondButton;
@property (weak, nonatomic) IBOutlet QMUIButton *thirdButton;
@property (nonatomic ,strong) FilterView *filterView;
@property (nonatomic ,strong) FilterView *addressFilterView;
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) NSMutableArray *arrProvice;
@property (nonatomic ,strong) NSMutableArray *arrCity;
@property (strong, nonatomic) IBOutlet UIView *fileterPropertyView;

/**
 职位类别id

 */
@property (nonatomic, copy) NSString *jobTypeID;
/**
 工作性质id 2兼职;3全职
 */

@property (nonatomic, copy) NSString *jobPropertyID;
/**
 工作地点id
 */

@property (nonatomic, copy) NSString *jobAddressID;

@property (nonatomic ,strong) NSMutableArray *arrTypeOne;
@property (nonatomic ,strong) NSMutableArray *arrTypeTwo;

@end

@implementation FindJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self showLoadingView];
    [self getData];
    
}
- (void)setupView{
    [self.titleView setTitle:@"求职"];

    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    _jobPropertyID = @"";
    _jobTypeID = @"";
    _jobAddressID = @"";
    _fileterPropertyView.backgroundColor = UIColorMask;
    [_firstButton setImage:[UIImage imageNamed:@"jian_tou下"] forState:UIControlStateNormal];
    [_firstButton setImage:[UIImage imageNamed:@"jian_tou"] forState:UIControlStateSelected];
    [_firstButton setImagePosition:QMUIButtonImagePositionRight];
    [_firstButton setSpacingBetweenImageAndTitle:5];

    [_secondButton setImage:[UIImage imageNamed:@"jian_tou下"] forState:UIControlStateNormal];
    [_secondButton setImage:[UIImage imageNamed:@"jian_tou"] forState:UIControlStateSelected];
    [_secondButton setImagePosition:QMUIButtonImagePositionRight];
    [_secondButton setSpacingBetweenImageAndTitle:5];

    [_thirdButton setImage:[UIImage imageNamed:@"jian_tou下"] forState:UIControlStateNormal];
    [_thirdButton setImage:[UIImage imageNamed:@"jian_tou"] forState:UIControlStateSelected];
    [_thirdButton setImagePosition:QMUIButtonImagePositionRight];
    [_thirdButton setSpacingBetweenImageAndTitle:5];

    [self.tableView registerNib:[UINib nibWithNibName:@"FindJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindJobTableViewCell"];
    
    [self.view addSubview:_fileterPropertyView];
    _fileterPropertyView.hidden = YES;
    [_fileterPropertyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_firstButton.mas_bottom);
        make.height.offset(SCREEN_HEIGHT-64-40);
    }];

}
- (void)getData{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSMutableDictionary *partDict = [NSMutableDictionary dictionary];
    [partDict setObject:@(_pageIndex) forKey:@"pageNo"];
    [partDict setObject:@(_pageSize) forKey:@"pageSize"];

    if (_jobTypeID.length) {
        [partDict setObject:_jobTypeID forKey:@"position_type_id"];
    }
    if (_jobPropertyID.length) {
        [partDict setObject:_jobPropertyID forKey:@"work_type"];

    }
    if (_jobAddressID.length) {
        [partDict setObject:_jobAddressID forKey:@"workplace_number"];

    }

    [self.netWorkEngine postWithDict:partDict url:BaseUrl(@"find.pushResume.list.by.pushResume") succed:^(id responseObject) {
        [self hideLoadingView];
        [_tableView endRefresh];
        [self hideSelfEmptyView];
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            if (arr.count) {
                if (!_arrData) {
                    _arrData = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    ResumeInfo *jobInfo = [ResumeInfo mj_objectWithKeyValues:dict];
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
                        [self getData];
                    }];
                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
            }

        }else{
            if (!_arrData.count) {
                [self showGetDataFailEmptyViewInView:self.tableView message:[responseObject objectForKey:@"msg"] reloadBlock:^{
                    [self showLoadingView];
                    [self getData];
                }];
            }else{
                _pageIndex--;
                
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
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
                [self getData];
            }];
            
        }
        
    }];

}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 165;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            weakSelf.pageIndex = 1;
            [weakSelf getData];
            
        }];
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex++;
            [weakSelf getData];
        }];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(45);
        }];
        
        
        
        
    }
    return _tableView;
}
#pragma makr- tableview  d d
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindJobTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FindJobTableViewCell" owner:nil options:nil] firstObject];
        cell.contentView.backgroundColor = COLOR_VIEW_BACK;
    }
    ResumeInfo *info = _arrData[indexPath.row];
    [cell.headImageView sd_imageWithUrlStr:info.portrait placeholderImage:@"头像"];
    cell.nameLabel.text = info.name;
    cell.jobTypeLabel.text = info.position_type_id_string;
    NSString *sexString ;
    if (info.sex == 1) {
        sexString = @"男";
    }else{
        sexString = @"女";
    }
    cell.infoLabel.text = [NSString stringWithFormat:@"%@元 - %@元  %@ %@ %@",@(info.want_salary_start),@(info.want_salary_end),sexString,info.workplace_number_string,info.work_type_string];
    cell.contentLabel.text = info.self_evaluate;
//    [NSString updateTimeForTimeString:info.]
    if (info.create_date.length) {
        cell.timeLabel.text = [NSString stringWithFormat:@"发布时间：%@",[NSString updateTimeForTimeString:info.create_date]];
    }
    cell.numLabel.text = [NSString stringWithFormat:@"%@人浏览·%@人收藏",@(info.hits_record),@(info.collect_count)];
    cell.selectionStyle = 0;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResumeInfo *info = _arrData[indexPath.row];

    FindJodDetailViewController *vc = [[FindJodDetailViewController alloc]initWithResumeID:info.resume_id];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma makr - button click
- (IBAction)firstButtonClick:(id)sender {
    _secondButton.selected = NO;
    _thirdButton.selected = NO;

    [self.addressFilterView hiddenFilterView];
    [self hiddenFilterPropertyView];
    
    
    if ([self.filterView isShow]) {
        [self.filterView hiddenFilterView];
        _firstButton.selected = NO;

        
    }else{
        [self.filterView showFilterView];
        _firstButton.selected = YES;

    }
    
}
- (IBAction)secondButtonClick:(id)sender {
    _firstButton.selected = NO;
    _thirdButton.selected = NO;

    [self.addressFilterView hiddenFilterView];
    [self.filterView hiddenFilterView];
    if (_fileterPropertyView.hidden) {
        [self showFilterPropertyView];
        _secondButton.selected = NO;

    }else{
        [self hiddenFilterPropertyView];
        _secondButton.selected = YES;

    }

}
- (IBAction)thirdButtonClick:(id)sender {
    _firstButton.selected = NO;
    _secondButton.selected = NO;

    [self.filterView hiddenFilterView];
    [self hiddenFilterPropertyView];

    if ([self.addressFilterView isShow]) {
        [self.addressFilterView hiddenFilterView];
        _thirdButton.selected = NO;
        
        
    }else{
        [self.addressFilterView showFilterView];
        _thirdButton.selected = YES;

    }
    

}
- (IBAction)allTimeButtonClick:(id)sender {
    [self hiddenFilterPropertyView];
    
    _secondButton.selected = NO;
    
    _jobPropertyID = @"3";
    [_tableView beginRefreshing];
    _pageIndex = 1;
    [_secondButton setTitle:@"全职" forState:0];
    
    [self getData];
    
}
- (IBAction)partTimeButtonClick:(id)sender {
    _secondButton.selected = NO;

    [self hiddenFilterPropertyView];
    _jobPropertyID = @"2";
    [_tableView beginRefreshing];
    _pageIndex = 1;
    [_secondButton setTitle:@"兼职" forState:0];
    [self getData];

}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
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
            _pageIndex = 1;
            [weakSelf.firstButton setTitle:filterInfo.propertyName forState:0];
            weakSelf.firstButton.selected = NO;
            
            _jobTypeID = filterInfo.propertyID;
            [weakSelf.tableView beginRefreshing];
            [weakSelf getData];
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
            [weakSelf.thirdButton setTitle:filterInfo.propertyName forState:0];
            weakSelf.thirdButton.selected = NO;
            _jobAddressID = filterInfo.propertyID;
            [weakSelf.tableView beginRefreshing];
            [weakSelf getData];

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
- (void)showFilterPropertyView{
    _fileterPropertyView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _fileterPropertyView.qmui_height = SCREEN_HEIGHT-64-40;

    } completion:^(BOOL finished) {
        
    }];

}
- (void)hiddenFilterPropertyView{
    [UIView animateWithDuration:0.3 animations:^{
        _fileterPropertyView.qmui_height = 0;
        
    } completion:^(BOOL finished) {
        _fileterPropertyView.hidden = YES;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
