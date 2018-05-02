//
//  HomePeopleViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomePeopleViewController.h"
#import "HomePeopleInfoViewController.h"
#import "UITableView+EmpayData.h"
#import "ConstructionSearchViewController.h"
#import "PeopleInfo.h"
#import "HomePeopleSearchViewController.h"

@interface HomePeopleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) UIView *searchView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *firstTypeStr;
@property (nonatomic, copy) NSString *secondTypeStr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *numStr;

@end

@implementation HomePeopleViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.searchView) {
        [self.navigationController.navigationBar addSubview:self.searchView];
        
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingView];
    _firstTypeStr = @"";
    _secondTypeStr = @"";
    _numStr = @"";
    _nameStr = @"";

    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    [self setupTitleView];
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
    [dict setObject:@(_pageIndex) forKey:@"startnum"];
    [dict setObject:@(_pageSize) forKey:@"num"];
    [dict setObject:_nameStr forKey:@"name"];
    [dict setObject:@"" forKey:@"id"];
    [dict setObject:_numStr forKey:@"number "];
    [dict setObject:_firstTypeStr forKey:@"type1"];
    [dict setObject:_secondTypeStr forKey:@"type2"];

    [_netWorkEngine postWithDict:dict url:BaseUrl(@"PesonListXinXi/selectAppPesonsList.action") succed:^(id responseObject) {
        [self hideLoadingView];
        [_tableView endRefresh];
        
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
                    PeopleInfo *peopleInfo = [PeopleInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:peopleInfo];
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
        _tableView.rowHeight = 45;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        __weak typeof(self) weakSelf = self;

        [_tableView headerWithRefreshingBlock:^{
            weakSelf.pageIndex = 1;
            [weakSelf getData];
        }];
        [self.view addSubview:_tableView];
        
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex++;
            [weakSelf getData];
            
        }];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (void)setupTitleView{
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-70, 44)];
    [self.navigationController.navigationBar addSubview:titleView];
    
    QMUIButton *button = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"搜索"] title:@"请输入想要搜索的内容"];
    [button setImagePosition:QMUIButtonImagePositionLeft];
    [button setSpacingBetweenImageAndTitle:5];
    [titleView addSubview:button];
    [button setBackgroundColor:COLOR_VIEW_BACK];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:COLOR_TEXT_GENGRAL forState:0];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(searchBarSearchButton) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView).offset(-10);
        make.top.equalTo(titleView).offset(7);
        make.left.equalTo(titleView).offset(30);
        make.bottom.equalTo(titleView).offset(-7);
        
    }];
    _searchView = titleView;
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = 0;
    }
    PeopleInfo *info = _arrData[indexPath.row];
    cell.textLabel.text = info.name;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopleInfo *info = _arrData[indexPath.row];

    HomePeopleInfoViewController *vc = [[HomePeopleInfoViewController alloc]initWithPeopleInfo:info];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchBarSearchButton{
    
    HomePeopleSearchViewController *vc= [[HomePeopleSearchViewController alloc]init];
    vc.sureButtonClickBlock = ^(NSString *nameStr, NSString *numStr, NSString *firsetStr, NSString *secondStr) {
        _nameStr = nameStr;
        _numStr = numStr;
        _firstTypeStr = firsetStr;
        _secondTypeStr = secondStr;
        _pageIndex = 1;
        [self showLoadingView];
        
        [_arrData removeAllObjects];
        [self getData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
