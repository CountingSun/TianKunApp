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

@interface JobViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet QMUIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet QMUIButton *thirdButton;
@property (nonatomic ,strong) FilterView *filterView;
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *positionID;

/**
 0升序 1降序
 */
@property (nonatomic, assign) NSInteger hot;


@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"招聘"];
    _hot = 1;
    _cityID = @"";
    _positionID = @"";
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    
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
                [_arrData addObject:jobInfo];
                
            }
            [self.tableView reloadData];
            
        }else{
            if (!_arrData.count) {
                [self showGetDataNullWithReloadBlock:^{
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

        [_tableView endRefresh];
        if (_arrData.count) {
            
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            [self showGetDataFailViewWithReloadBlock:^{
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
    if (self.filterView.state == 1) {
        [self.filterView hiddenFilterView];
        self.filterView.state = 4;
        return;
    }
    if ([self.filterView isShow]) {
        [self.filterView reloadWithKey:@""];
    }else{
        [self.filterView showFilterView];
        
    }
    self.filterView.state = 1;
    
}
- (IBAction)secondButtonClick:(id)sender {
    if (self.filterView.state == 2) {
        [self.filterView hiddenFilterView];
        self.filterView.state = 4;
        return;
    }

    if ([self.filterView isShow]) {
        [self.filterView reloadWithKey:@""];
    }else{
        [self.filterView showFilterView];
        
    }
    self.filterView.state = 2;

}
- (IBAction)thirdButtonClick:(id)sender {
//    if (_currectType == 3) {
//        [self.filterView hiddenFilterView];
//        _currectType = 4;
//        return;
//    }
//
//    if ([self.filterView isShow]) {
//        [self.filterView reloadWithKey:@""];
//    }else{
//        [self.filterView showFilterView];
//
//    }
//    _currectType = 3;
    self.filterView.state = 4;

    [self.filterView hiddenFilterView];

}

#pragma mark- lazy init
- (FilterView *)filterView{
    if (!_filterView) {
        _filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0)];
        [self.view addSubview:_filterView];
        _filterView.hidden = YES;
    }
    return _filterView;
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [_tableView headerWithRefreshingBlock:^{
            _pageIndex = 1;
            
            [self getJob];
            
        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex --;
            
            [self getJob];

        }];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(45);
        }];
        
        
        
        
    }
    return _tableView;
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
