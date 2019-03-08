//
//  FileSearchViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FileSearchViewController.h"
#import "TInvitationlistableViewCell.h"

#import "UITableView+EmpayData.h"
#import "MenuInfo.h"
#import "InvitationDetailViewController.h"
#import "ArticleDetailViewController.h"

@interface FileSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) WQTableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic ,assign) FileSearchType searchType;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *searchKey;

@end

@implementation FileSearchViewController
- (instancetype)initWithFromType:(FileSearchType)fileSearchType{
    if (self = [super init]) {
        _searchType = fileSearchType;
        
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchBar.hidden = NO;

    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除Nav搜索框
    self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    self.tableView.canLoadMore = NO;
    //Nav搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(35, 0, SCREEN_WIDTH - 100, 44))];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = @"请输入关键词搜索";
    self.searchBar.tintColor = COLOR_THEME;
    [self.searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.searchBar];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];

    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//    
//        make.left.right.top.bottom.equalTo(self);
//        
//    }];
    
}
- (void)searchEvent{
    
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc] init];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];
    [dict setObject:@(_pageIndex) forKey:@"startnum"];
    [dict setObject:@(_pageSize) forKey:@"endnum"];
    [dict setObject:_searchKey forKey:@"title"];

    NSString *urlStr = @"";
    switch (_searchType) {
        case FileSearchTypeNotice:
        {
            urlStr = BaseUrl(@"ArticleNotices/selectarticlenoticebyliketitle.action");
        }
            break;
        case FileSearchTypePublic:
        {
            urlStr = BaseUrl(@"Announcement/selectannouncementbyliketitle.action");
        }
            break;
        case FileSearchTypeInvitation:
        {
            urlStr = BaseUrl(@"TenderNotice/selecttendernoticebyliketitle.action");
            [dict setObject:@(1) forKey:@"notice_type"];

        }
            break;
        case FileSearchTypeWin:
        {
            urlStr = BaseUrl(@"TenderNotice/selecttendernoticebyliketitle.action");
            [dict setObject:@(2) forKey:@"notice_type"];

        }
            break;

        case FileSearchTypeIndustry:
        {
            urlStr = BaseUrl(@"IndustryInformationController/selectarticlenoticebyliketitle.action");
        }
            break;

            
        default:
            break;
    }
    [_netWorkEngine postWithDict:dict url:urlStr succed:^(id responseObject) {
        [_tableView endRefresh];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self dismiss];
            
            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
            }
            NSMutableArray *arrResule = [responseObject objectForKey:@"value"];
            if (arrResule.count) {
                [self.searchBar endEditing:YES];

                for (NSDictionary *dict in arrResule) {
                    switch (_searchType) {
                        case FileSearchTypeNotice:
                        {
                            MenuInfo *menInfo = [[MenuInfo alloc] init];
                            menInfo.menuID = [[dict objectForKey:@"id"] integerValue];
                            menInfo.menuName = [dict objectForKey:@"article_title"];
                            menInfo.menuDetail = [dict objectForKey:@"create_date"];
                            [_arrData addObject:menInfo];
                        }
                            break;
                        case FileSearchTypePublic:
                        {
                            MenuInfo *menInfo = [[MenuInfo alloc] init];
                            menInfo.menuID = [[dict objectForKey:@"id"] integerValue];
                            menInfo.menuName = [dict objectForKey:@"announcement_title"];
                            menInfo.menuDetail = [dict objectForKey:@"create_date"];
                            [_arrData addObject:menInfo];
                        }
                            break;
                        case FileSearchTypeInvitation:
                        {
                            MenuInfo *menInfo = [[MenuInfo alloc] init];
                            menInfo.menuID = [[dict objectForKey:@"id"] integerValue];
                            menInfo.menuName = [dict objectForKey:@"tender_title"];
                            menInfo.menuDetail = [dict objectForKey:@"create_date"];
                            [_arrData addObject:menInfo];
                            
                        }
                            break;
                        case FileSearchTypeWin:
                        {
                            MenuInfo *menInfo = [[MenuInfo alloc] init];
                            menInfo.menuID = [[dict objectForKey:@"id"] integerValue];
                            menInfo.menuName = [dict objectForKey:@"tender_title"];
                            menInfo.menuDetail = [dict objectForKey:@"create_date"];
                            [_arrData addObject:menInfo];
                            
                        }
                            break;
                            
                        case FileSearchTypeIndustry:
                        {
                            MenuInfo *menInfo = [[MenuInfo alloc] init];
                            menInfo.menuID = [[dict objectForKey:@"id"] integerValue];
                            menInfo.menuName = [dict objectForKey:@"article_title"];
                            menInfo.menuDetail = [dict objectForKey:@"create_date"];
                            [_arrData addObject:menInfo];
                        }
                            break;
                            
                            
                        default:
                            break;
                    }
                    
                    
                }

            }else{
                [self showErrorWithStatus:@"暂无数据"];
            }
            [self.tableView reloadData];
            
            if (arrResule.count == _pageSize) {
                self.tableView.canLoadMore = YES;
            }else{
                self.tableView.canLoadMore = NO;

            }
        }else{
            self.tableView.canLoadMore = YES;

            if (_arrData.count) {
                [self showErrorWithStatus:NET_ERROR_TOST];
            }else{
                [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                    [self searchEvent];
                }];
                
            }

        }
    } errorBlock:^(NSError *error) {
        [_tableView endRefresh];
        [self dismiss];

        if (_arrData.count) {
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            [self showGetDataFailViewWithReloadBlock:^{
                [self searchEvent];
            }];
            
        }
    }];
    
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (!_searchBar.text.length) {
        [self showErrorWithStatus:@"请输入搜索内容"];
        return;
    }
    _pageIndex = 1;
    
    _searchKey = _searchBar.text;
    [self showWithStatus:@""];

    [self searchEvent];
    
    
}
- (WQTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WQTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 65;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        _tableView.separatorColor  = RGB(220, 220, 220,1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            weakSelf.pageIndex=1;
            [weakSelf searchEvent];
        }];
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex++;
            [weakSelf searchEvent];

        }];

        
        
    }
    return  _tableView;
}
#pragma mark - Table view Datasource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.arrData.count];
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuInfo *menuInfo = self.arrData[indexPath.row];
    
    TInvitationlistableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TInvitationlistableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TInvitationlistableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;
        
    }
    
    cell.titleLabel.attributedText = [self showKeyWordWithInwardString:menuInfo.menuName];

    cell.timeLabel.text = [NSString timeReturnDate:[NSNumber numberWithInteger:[menuInfo.menuDetail integerValue]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    headerView.backgroundColor = RGB(220, 220, 220,1);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuInfo *info  = self.arrData[indexPath.row];
    switch (_searchType) {
        case FileSearchTypeNotice:
        {
            ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]initWithArticleID:info.menuID fromType:1];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case FileSearchTypePublic:
        {
            ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]initWithArticleID:info.menuID fromType:2];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case FileSearchTypeInvitation:
        {
            InvitationDetailViewController *vc = [[InvitationDetailViewController alloc] initWithInvitationID:info.menuID fromType:1];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case FileSearchTypeWin:
        {
            InvitationDetailViewController *vc = [[InvitationDetailViewController alloc] initWithInvitationID:info.menuID fromType:2];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
        case FileSearchTypeIndustry:
        {
            ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]initWithArticleID:info.menuID fromType:3];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
            
        default:
            break;
    }

}
- (NSMutableAttributedString *)showKeyWordWithInwardString:(NSString *)inwardString{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:inwardString];
    
    if ([inwardString containsString:_searchKey]) {
        NSRange range = NSMakeRange([[attributedString string] rangeOfString:_searchKey].location, _searchKey.length);
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_THEME range:range];
        
    }
    return attributedString;
    
}

#pragma mark - 取消回去上级页面
- (void)rightBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
