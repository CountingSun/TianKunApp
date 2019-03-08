//
//  ExpertMessageViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ExpertMessageViewController.h"
#import "ExpertTableViewCell.h"
#import "ExpertMessageInfo.h"
#import "RemindInfo.h"

@interface ExpertMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation ExpertMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"专家消息"];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;

    [self showLoadingView];
    [self getReaindList];
    
    
}
- (void)getReaindList{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:@(_pageIndex) forKey:@"pageNo"];
    [dict setObject:@(_pageSize) forKey:@"pageSize"];
    [dict setObject:@(3) forKey:@"date_type"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"find.vipUpDataList.by.vipUpData") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self hideLoadingView];
            [self.tableView endRefresh];
            
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
                        ExpertMessageInfo *info = [[ExpertMessageInfo alloc] init];
                        info.messageTime = [[dict objectForKey:@"create_date"] stringValue];
                        info.messageTitle = [dict objectForKey:@"certificate_type_name"];
                        info.messageDetail = [dict objectForKey:@"remind"];

                        
                        [_arrData addObject:info];
                        
                    }
                    [self.tableView reloadData];
                    if(arr.count<_pageSize){
                        _tableView.canLoadMore = NO;
                    }else{
                        _tableView.canLoadMore = YES;
                    }
                    
                }else{
                    if (_arrData.count) {
                        _pageIndex--;
                        [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    }else{
                        [self showGetDataNullWithReloadBlock:^{
                            [self showLoadingView];
                            [self getReaindList];
                            
                        }];
                    }
                }
                
            }else{
                if (_arrData.count) {
                    _pageIndex--;
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                }else{
                    [self showGetDataNullWithReloadBlock:^{
                        [self showLoadingView];
                        [self getReaindList];
                        
                    }];
                }
            }
            
            
            
        }else{
            if (_arrData.count) {
                _pageIndex--;
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            }else{
                [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                    [self showLoadingView];
                    [self getReaindList];
                }];
            }
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [_tableView endRefresh];
        
        if (_arrData.count) {
            _pageIndex = 1;
            [self showErrorWithStatus:NET_ERROR_TOST];

        }else{
            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getReaindList];
                
            }];
            
            
        }
        
    }];
    
}

- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = COLOR_VIEW_BACK;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            _pageIndex = 1;
            [weakSelf getReaindList];
        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex ++;
            [weakSelf getReaindList];
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpertMessageInfo *info  = self.arrData[indexPath.row];

    return [ExpertTableViewCell getCellHeightWithExpertMessageInfo:info];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ExpertTableViewCell";
    
    ExpertTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ExpertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ExpertMessageInfo *info = self.arrData[indexPath.row];
    cell.messageInfo = info;
    cell.cellIndexPath = indexPath;
    cell.selectionStyle = 0;
    cell.clickLookAllButtonBlock = ^(NSIndexPath *cellIndexPath) {
        [_tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc] init];
    }
    return _netWorkEngine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
