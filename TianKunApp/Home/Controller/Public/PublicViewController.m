//
//  PublicViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PublicViewController.h"
#import "HomeListTableViewCell.h"
#import "ArticleDetailViewController.h"
#import "HomePublicInfo.h"
#import "TInvitationlistableViewCell.h"
#import "FileSearchViewController.h"

@interface PublicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"公告公示"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchEvent)];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    [self.tableView registerNib:[UINib nibWithNibName:@"TInvitationlistableViewCell" bundle:nil] forCellReuseIdentifier:@"TInvitationlistableViewCell"];
    [self showLoadingView];
    [self getData];
}
- (void)searchEvent{
    FileSearchViewController *vc = [[FileSearchViewController alloc] initWithFromType:FileSearchTypePublic];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];

    [dict setObject:@(_pageIndex) forKey:@"startnum"];
    [dict setObject:@(_pageSize) forKey:@"endnum"];

    [_netWorkEngine postWithDict:dict url:BaseUrl(@"Announcement/findAnnouncementlimitbyid.action") succed:^(id responseObject) {
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
                    HomePublicInfo *homePublicInfo = [HomePublicInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:homePublicInfo];
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
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
    
    HomePublicInfo *info = _arrData[indexPath.row];
    cell.titleLabel.text = info.announcement_title;
    cell.timeLabel.text = [NSString timeReturnDate:[NSNumber numberWithInteger:[info.create_date integerValue]]];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePublicInfo *info = _arrData[indexPath.row];

    ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]initWithArticleID:[info.publicID integerValue] fromType:2];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
