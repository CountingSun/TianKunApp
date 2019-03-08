//
//  MyExchangeRecordViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/13.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyExchangeRecordViewController.h"
#import "MyExchangeListTableViewCell.h"
#import "GoodsInfo.h"
#import "PointGoodsDetailViewController.h"

@interface MyExchangeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation MyExchangeRecordViewController

- (void)viewDidLoad {
    [self.titleView setTitle:@"兑换记录"];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyExchangeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyExchangeListTableViewCell"];
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    
    [dict setObject:@(_pageIndex) forKey:@"page"];
    [dict setObject:@(_pageSize) forKey:@"count"];
    
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"TkSpCommodityAPPController/selectspdhbyuserid.action") succed:^(id responseObject) {
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
                    GoodsInfo *info = [GoodsInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:info];
                }
                [self.tableView reloadData];
                
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
        _tableView.rowHeight = 100;
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
    MyExchangeListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyExchangeListTableViewCell" forIndexPath:indexPath];
    
    GoodsInfo *info = _arrData[indexPath.row];
    
    cell.titleLabel.text = info.name;
    [cell.goodsImageView sd_imageDef11WithUrlStr:info.picture];
    cell.numberLabel.text = @"数量X1";
    cell.pointLabel.text = [NSString stringWithFormat:@"%@",@(info.integral)];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsInfo *info = _arrData[indexPath.row];
    PointGoodsDetailViewController *vc = [[PointGoodsDetailViewController alloc] initWithGoodsID:info.goodsID];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
