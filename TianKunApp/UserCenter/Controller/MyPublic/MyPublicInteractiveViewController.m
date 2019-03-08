//
//  MyPublicInteractiveViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublicInteractiveViewController.h"
#import "InteractionInfo.h"
#import "MyPublicInteractionListTableViewCell.h"
#import "InteractionDetailViewController.h"
#import "AddEnterpriseCcommunicationViewController.h"

@interface MyPublicInteractiveViewController ()<UITableViewDataSource,UITableViewDelegate,MyPublicInteractionListTableViewCellDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation MyPublicInteractiveViewController

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
    [_netWorkEngine postWithDict:@{@"startnum":@(_pageIndex),@"endnum":@(_pageSize),@"userid":[UserInfoEngine getUserInfo].userID} url:BaseUrl(@"Forums/selectforumsfabubyuseridandlimit.action") succed:^(id responseObject) {
        [self hideLoadingView];
        [self.tableView endRefresh];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrData) {
                    _arrData = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    InteractionInfo *info = [InteractionInfo mj_objectWithKeyValues:dict];
                    
//
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
    MyPublicInteractionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPublicInteractionListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyPublicInteractionListTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;
        
    }
    InteractionInfo *info = _arrData[indexPath.row];
    cell.interactionInfo = info;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InteractionInfo *info = _arrData[indexPath.row];
//    //
    InteractionDetailViewController *vc = [[InteractionDetailViewController alloc] initWithInteractionID:info.interactionID];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)deleteInteractionWithInteractionInfo:(InteractionInfo *)interactionInfo indexPath:(NSIndexPath *)indexPath{
    
    [WQAlertController showAlertControllerWithTitle:@"提示" message:@"您确定要删除当前互动交流吗？" sureButtonTitle:@"确定" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
        if (!_netWorkEngine) {
            _netWorkEngine = [[NetWorkEngine alloc]init];
        }
        [self showWithStatus:NET_WAIT_TOST];
        if (!_netWorkEngine) {
            _netWorkEngine = [[NetWorkEngine alloc]init];
        }
        self.view.userInteractionEnabled = NO;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:interactionInfo.interactionID forKey:@"id"];
        
        [_netWorkEngine postWithDict:dict url:BaseUrl(@"Forums/deleteforumandcollandrepbyid.action") succed:^(id responseObject) {
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
- (void)gotoPublic{
    AddEnterpriseCcommunicationViewController *vc = [[AddEnterpriseCcommunicationViewController alloc] init];
//    vc.succeedBlock = ^(CooperationInfo *cooperationInfo) {
//        _pageIndex = 1;
//        [self hideEmptyView];
//        [self.tableView beginRefreshing];
//
//
//    };

    vc.succeedBlock = ^{
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
