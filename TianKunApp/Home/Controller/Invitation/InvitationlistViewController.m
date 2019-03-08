//
//  InvitationlistViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "InvitationlistViewController.h"
#import "TInvitationlistableViewCell.h"
#import "WebLinkViewController.h"
#import "ClassTypeInfo.h"
#import "TenderBidInfo.h"
#import "InvitationDetailViewController.h"
#import "FileSearchViewController.h"

@interface InvitationlistViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) ClassTypeInfo *classTypeInfo;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,assign) NSInteger type;
@end

@implementation InvitationlistViewController
- (instancetype)initWithClassTypeInfo:(ClassTypeInfo *)classTypeInfo type:(NSInteger)type{
    if(self = [super init]){
//        _classTypeInfo = classTypeInfo;
        _type = type;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageSize = DEFAULT_PAGE_SIZE;
    if (_type == 1) {
        [self.titleView setTitle:@"招标"];
    }else{
        [self.titleView setTitle:@"中标"];

    }
    _pageIndex = 1;
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:0];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"TInvitationlistableViewCell" bundle:nil] forCellReuseIdentifier:@"TInvitationlistableViewCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchEvent)];

    [self showLoadingView];
    [self getData];

}
- (void)searchEvent{
    if (_type == 1) {
        FileSearchViewController *vc = [[FileSearchViewController alloc] initWithFromType:FileSearchTypeInvitation];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        FileSearchViewController *vc = [[FileSearchViewController alloc] initWithFromType:FileSearchTypeWin];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
    
}


- (void)getData{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSString *urlStr = @"";
    if (_type == 1) {
        urlStr =   @"TenderNotice/findtendernoticelist.action";
    }else{
        urlStr =   @"TenderNotice/findtendernoticelistin.action";
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];

    [dict setObject:@"" forKey:@"lb"];
    [dict setObject:@(_pageIndex) forKey:@"startnum"];
    [dict setObject:@(_pageSize) forKey:@"endnum"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(urlStr) succed:^(id responseObject) {
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
                    TenderBidInfo *info = [TenderBidInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:info];
                    //
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
        _tableView.rowHeight = 65;
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
    TInvitationlistableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TInvitationlistableViewCell" forIndexPath:indexPath];
    TenderBidInfo *info = _arrData[indexPath.row];
    
    cell.titleLabel.text = info.tender_title;
    cell.timeLabel.text = [NSString timeReturnDate:[NSNumber numberWithInteger:[info.create_date integerValue]]];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title;
    if (_type == 1) {
        title = @"招标详情";
    }else{
        title = @"中标详情";
    }
    TenderBidInfo *info = _arrData[indexPath.row];

//    WebLinkViewController *vc = [[WebLinkViewController alloc]initWithTitle:title urlString:info.notice_content_url];
//
//    [self.navigationController pushViewController:vc animated:YES];
    InvitationDetailViewController *vc = [[InvitationDetailViewController alloc]initWithInvitationID:[info.tender_id integerValue] fromType:_type];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
