//
//  HomeSearchDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/14.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeSearchDetailViewController.h"
#import "Historyinfo.h"
#import "HomeSearchDetailTableViewCell.h"
#import "JumpToAssignVC.h"

@interface HomeSearchDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *keyWord;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation HomeSearchDetailViewController
- (instancetype)initWithKeyWor:(NSString *)keyWord{
    if (self = [super init]) {
        _keyWord = keyWord;
    }
    return self;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Nav搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(35, 0, SCREEN_WIDTH - 100, 44))];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = @"请输入关键词搜索";
    self.searchBar.text = _keyWord;

    self.searchBar.tintColor = COLOR_THEME;
    [self.searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除Nav搜索框
    [self.searchBar removeFromSuperview];
}

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
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];
    
    [dict setObject:@(_pageIndex) forKey:@"startnum"];
    [dict setObject:@(_pageSize) forKey:@"endnum"];
    [dict setObject:_keyWord forKey:@"keyword"];

    [_netWorkEngine postWithDict:dict url:BaseUrl(@"home.search.all.by.keyword") succed:^(id responseObject) {
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
                    Historyinfo *info = [[Historyinfo alloc] init];
                    info.data_id = [[dict objectForKey:@"data_id"] integerValue];
                    info.data_title = [dict objectForKey:@"data_keyword"];
                    info.data_type = [[dict objectForKey:@"data_type"] integerValue];

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
                _tableView.canLoadMore = NO;

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
    HomeSearchDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSearchDetailTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeSearchDetailTableViewCell" owner:nil options:nil] firstObject];
    }
    Historyinfo *info =_arrData[indexPath.row];
    cell.titleLabel.attributedText = [self showKeyWordWithInwardString:info.data_title];
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Historyinfo *info =_arrData[indexPath.row];
    [JumpToAssignVC jumpToAssignVCWithDataID:[NSString stringWithFormat:@"%@",@(info.data_id)] dataType:info.data_type documentType:info.data_type_two];
}

- (NSMutableAttributedString *)showKeyWordWithInwardString:(NSString *)inwardString{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:inwardString];

    if ([inwardString containsString:_keyWord]) {
        NSRange range = NSMakeRange([[attributedString string] rangeOfString:_keyWord].location, _keyWord.length);
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_THEME range:range];

    }
    return attributedString;
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];

    return NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
