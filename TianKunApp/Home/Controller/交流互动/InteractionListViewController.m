//
//  InteractionListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "InteractionListViewController.h"
#import "InteractionListTableViewCell.h"
#import "InteractionDetailViewController.h"
#import "InteractionInfo.h"

@interface InteractionListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic, copy) NSString *classID;
@end

@implementation InteractionListViewController
- (instancetype)initWithClassID:(NSString *)classID{
    if (self = [super init]) {
        _classID= classID;
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:0];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"InteractionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InteractionListTableViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self showLoadingView];
    [self getData];

}
- (void)getData{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    [self.netWorkEngine postWithDict:@{@"lb":_classID,@"startnum":@(_pageIndex),@"endnum":@(_pageSize)} url:BaseUrl(@"/Forums/selectForumlimitbyid.action") succed:^(id responseObject) {
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
                
                [self showErrorWithStatus:NET_WAIT_NO_DATA];
                
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
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [_tableView headerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView endRefresh];
                
            });
            
        }];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InteractionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InteractionListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InteractionListTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;

    }
    InteractionInfo *info = _arrData[indexPath.row];
    
    cell.titleLabel.text = info.title;
    cell.contentLabel.text = info.content;
    cell.timeLabel.text = [NSString timeReturnDateString:info.create_date formatter:@"MM-dd"];
    cell.lookLabel.text = [NSString stringWithFormat:@"%@",@(info.hits_show)];
    cell.commentLabel.text = [NSString stringWithFormat:@"%@",@(info.hfnum)];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InteractionInfo *info = _arrData[indexPath.row];

    InteractionDetailViewController *vc = [[InteractionDetailViewController alloc]initWithInteractionID:info.interactionID];
    [self.navigationController pushViewController:vc animated:YES];
    
    
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

@end
