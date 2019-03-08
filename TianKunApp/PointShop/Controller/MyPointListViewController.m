//
//  MyPointListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPointListViewController.h"
#import "MyPointListTableViewCell.h"
#import "UserPointInfo.h"

@interface MyPointListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *viewTitle;

@end

@implementation MyPointListViewController
- (instancetype)initWithViewTitle:(NSString *)viewTitle{
    if (self = [super init]) {
        _viewTitle = viewTitle;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBaseData];
    
    [self showLoadingView];
    [self getData];
    
}
- (void)setBaseData{
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;

    [self.tableView registerNib:[UINib nibWithNibName:@"MyPointListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyPointListTableViewCell"];

}
- (void)getData{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [dict setObject:@(_pageIndex) forKey:@"page"];
    [dict setObject:@(_pageSize) forKey:@"count"];
    
    if ([_viewTitle isEqualToString:@"全部记录"]) {
        [dict setObject:@(0) forKey:@"type"];

    }else if ([_viewTitle isEqualToString:@"收入记录"]){
        [dict setObject:@(1) forKey:@"type"];

    }else{
        [dict setObject:@(2) forKey:@"type"];

    }
    
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TkSpCommodityAPPController/selectsptkspintegrationbyuserid.action") succed:^(id responseObject) {
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
                    UserPointInfo *info = [UserPointInfo mj_objectWithKeyValues:dict];
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
            {
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
        _tableView.rowHeight = 45;
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
    MyPointListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyPointListTableViewCell" forIndexPath:indexPath];
    UserPointInfo *info = _arrData[indexPath.row];
    cell.titleLabel.text = info.type_name;
    cell.timeLabel.text = [NSString timeReturnDateString:info.create_date formatter:@"yyyy-MM-dd"];
    
    if (info.revenue_or_expenses == 1) {
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%@",@(info.number)];

    }else{
        cell.moneyLabel.text = [NSString stringWithFormat:@"-%@",@(info.number)];

    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (NetWorkEngine *)netWorkEngine{
    if(!_netWorkEngine){
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
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
