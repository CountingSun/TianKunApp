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
#import "FindTalentsViewController.h"

@interface MyPublicFindTalentViewController ()<UITableViewDataSource,UITableViewDelegate,MyPublicJobTableViewCellDelegate>
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
    self.tableView.canLoadMore = NO;

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
                    JobInfo *info = [JobInfo mj_objectWithKeyValues:dict];
                    info.job_id = [dict objectForKey:@"jobid"];
                    info.name = [dict objectForKey:@"jobname"];
                    info.enterprisename = [dict objectForKey:@"enterprisename"];
                    info.work_describe = [dict objectForKey:@"description"];

                    [_arrData addObject:info];
                }
                [self.tableView reloadData];
                
            }else{
                if (!_arrData.count) {
                    [self showEmptyViewWithImage:[UIImage imageNamed:@"net_fail"] text:@"暂无数据" detailText:@"" buttonTitle:@"去发布" buttonAction:@selector(gotoPublic)];

                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
            }
            if(arr.count<_pageSize){
                _tableView.canLoadMore = NO;
            }else{
                _tableView.canLoadMore = YES;
            }

        }else{
            if (!_arrData.count) {
                [self showEmptyViewWithImage:[UIImage imageNamed:@"net_fail"] text:@"暂无数据" detailText:@"" buttonTitle:@"去发布" buttonAction:@selector(gotoPublic)];

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
        _tableView.rowHeight = 160;
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
    cell.indexPath = indexPath;
    cell.jobInfo = info;
    cell.delegate = self;
    if (indexPath.row == 2) {
        cell.refreshTimeLabel.text = [NSString stringWithFormat:@"置顶时间：%@",[NSString timeReturnDateString:info.refreshtime formatter:@"yyyy年MM月dd日 HH:mm:ss"]];

    }else{
        cell.refreshTimeLabel.text = @"置顶可以让更多人看见";
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobInfo *info = _arrData[indexPath.row];
//
    JobDetailViewController *vc = [[JobDetailViewController alloc] initWithJobID:info.job_id];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)clickEditButtonWithIndexPath:(NSIndexPath *)indexPath jobInfo:(JobInfo *)jobInfo{
    FindTalentsViewController *vc = [[FindTalentsViewController alloc] initWithJobInfo:jobInfo succeedBlock:^(JobInfo *jobInfo) {
        _arrData[indexPath.section] = jobInfo;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)clickDeleteButtonWithIndexPath:(NSIndexPath *)indexPath jobInfo:(JobInfo *)jobInfo{
    
    [WQAlertController showAlertControllerWithTitle:@"提示" message:@"您确定要删除当前招聘信息吗？" sureButtonTitle:@"确定" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
        if (!_netWorkEngine) {
            _netWorkEngine = [[NetWorkEngine alloc]init];
        }
        [self showWithStatus:NET_WAIT_TOST];
        self.view.userInteractionEnabled = NO;
        
        [_netWorkEngine postWithDict:@{@"jobid":jobInfo.job_id} url:BaseUrl(@"my/delete_job.action") succed:^(id responseObject) {
            self.view.userInteractionEnabled = YES;
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1) {
                [self showSuccessWithStatus:@"删除成功"];
                [self.arrData removeObjectAtIndex:indexPath.row];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [self.tableView reloadData];
                if (!_arrData.count) {
                    _pageIndex = 1;
                    [self.tableView beginRefreshing];
                    
                }

            }else{
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
            }
        } errorBlock:^(NSError *error) {
            self.view.userInteractionEnabled = YES;
            
            [self showErrorWithStatus:NET_ERROR_TOST];
        }];

    } cancelBlock:^(QMUIAlertAction *action) {
        
    }];
    

}
- (void)clickmakeTopButtonWithIndexPath:(NSIndexPath *)indexPath jobInfo:(JobInfo *)jobInfo{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    [self showWithStatus:NET_WAIT_TOST];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:jobInfo.job_id forKey:@"jobid"];
    
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"my/refreshjob.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"置顶成功"];
            JobInfo *info = _arrData[indexPath.row];
            NSInteger time = [[[responseObject objectForKey:@"value"] objectForKey:@"refreshtime"] integerValue];
            info.refreshtime = [NSString stringWithFormat:@"%@",@(time)];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (void)gotoPublic{
    FindTalentsViewController *vc = [[FindTalentsViewController alloc] init];
    vc.succeedBlock = ^(JobInfo *jobInfo) {
        _pageIndex = 1;
        [self hideEmptyView];
        [self.tableView beginRefreshing];

    };
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
