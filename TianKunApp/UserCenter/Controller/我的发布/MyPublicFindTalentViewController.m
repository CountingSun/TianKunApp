//
//  MyPublicFindTalentViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublicFindTalentViewController.h"
#import "MyPublicJobTableViewCell.h"
#import "JobInfo.h"
#import "JobDetailViewController.h"

@interface MyPublicFindTalentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation MyPublicFindTalentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    [self showLoadingView];
    [self getData];

}
- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    [_netWorkEngine postWithDict:@{@"pageNum":@(_pageIndex),@"pageSize":@(_pageSize),@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"my/enterpriseIsReleasejob.action") succed:^(id responseObject) {
        [self hideLoadingView];
        [self.tableView endRefresh];
        
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
                    JobInfo *info = [[JobInfo alloc] init];
                    info.job_id = [dict objectForKey:@"jobid"];
                    info.name = [dict objectForKey:@"jobname"];
                    info.enterprisename = [dict objectForKey:@"enterprisename"];
                    info.work_describe = [dict objectForKey:@"description"];

                    [_arrData addObject:info];
                }
                [self.tableView reloadData];
                if(arr.count<_pageSize){
                    _tableView.canLoadMore = NO;
                }else{
                    _tableView.canLoadMore = YES;
                }
                
            }else{
                if (!_arrData.count) {
                    [self showGetDataNullWithReloadBlock:^{
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
                [self showGetDataNullWithReloadBlock:^{
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
        [_tableView endRefresh];
        if (_arrData.count) {
            _pageIndex = 1;
            
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            _pageIndex = 1;
            [self showGetDataFailViewWithReloadBlock:^{
                [self hideEmptyView];
                [self showLoadingView];
                [self getData];
            }];
            
        }
        
    }];
    
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        __weak typeof(self) weakSelf = self;
        [_tableView headerWithRefreshingBlock:^{
            _pageIndex = 1;
            [weakSelf getData];
        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex ++;
            [weakSelf getData];
            
        }];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPublicJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPublicJobTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyPublicJobTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;
        
    }
    JobInfo *info = _arrData[indexPath.row];
    
    cell.titleLabel.text = info.enterprisename;
    cell.nameLabel.text = info.name;
    cell.detailLabel.text= info.work_describe;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobInfo *info = _arrData[indexPath.row];
//
    JobDetailViewController *vc = [[JobDetailViewController alloc] initWithJobID:info.job_id];
    [self.navigationController pushViewController:vc animated:YES];
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
