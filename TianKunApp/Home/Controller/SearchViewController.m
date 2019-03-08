//
//  SearchViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionCell.h"
#import "SearchTableViewCell.h"
#import "UITableView+EmpayData.h"
#import "UICollectionView+EmpayData.h"
#import "SDAutoLayout.h"
#import "NSString+WQString.h"
#import "HomeSearchDetailViewController.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate> {
    NSString *filePath;
}
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *botLeftLab;
@property (nonatomic, strong) UIButton *botRightBtn;

@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, strong) NSMutableArray *liShiArray;//数据源
@property (nonatomic, strong) NSMutableArray *reSouArray;//数据源


@end

@implementation SearchViewController{
    
    NSString *_hotEmtyStr;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///获取文件路径
    NSString *doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    filePath = [doucumentPath stringByAppendingPathComponent:@"QXStoresearch"];
    [self getHistoryList];
    //Nav搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(35, 0, SCREEN_WIDTH - 100, 44))];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = @"请输入关键词搜索";
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
    self.view.backgroundColor = COLOR_VIEW_BACK;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];

    _liShiArray = [[NSMutableArray alloc] initWithCapacity:0];//历史记录数据源
    _reSouArray = [[NSMutableArray alloc] initWithCapacity:0];//热搜数据源
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    //初始化视图
    [self initView];
    
    
    
    self.curPage = 1;//默认当前热搜列表为第一页
    //请求热搜数据列表
//    [self showLoadding:@"" time:1];
//    [self requestListDataArrray];
}

#pragma mark - 请求搜索信息
- (void)requestSearchInfo:(NSString *)searchKeyWord {
    
    HomeSearchDetailViewController *vc = [[HomeSearchDetailViewController alloc] initWithKeyWor:searchKeyWord];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 清除历史记录
- (void)botRightBtnClick {
    
    [self.liShiArray removeAllObjects];
    BOOL result = [NSKeyedArchiver archiveRootObject:self.liShiArray toFile:filePath];
    if (result) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"保存失败");
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - 初始化视图
- (void)initView {
    
    [self.view addSubview:self.botLeftLab];
    [self.view addSubview:self.botRightBtn];
    [self.view addSubview:self.tableView];
    
    self.botLeftLab.sd_layout.topSpaceToView(self.view,15).leftSpaceToView(self.view,15).widthIs(60).heightIs(14);
    self.botRightBtn.sd_layout.topSpaceToView(self.view,15).rightSpaceToView(self.view,15).widthIs(30).heightIs(14);
    self.tableView.sd_layout.topSpaceToView(self.botLeftLab,15).widthIs(SCREEN_WIDTH).bottomSpaceToView(self.view,0);
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length) {
        if ([self.liShiArray containsObject:searchBar.text]) {
            [self.liShiArray removeObject:searchBar.text];
        }
//        [self.liShiArray addObject:searchBar.text];
        [self.liShiArray insertObject:searchBar.text atIndex:0 ];
        [NSKeyedArchiver archiveRootObject:self.liShiArray toFile:filePath];
        [self getHistoryList];
        [searchBar resignFirstResponder];
    }
    [self requestSearchInfo:searchBar.text];

}

#pragma mark - Table view Datasource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitMsg:@"您还没有进行任何搜索记录哦!" ifNecessaryForRowCount:self.liShiArray.count];
    return self.liShiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = self.liShiArray[indexPath.row];
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchTableViewCell class]) forIndexPath:indexPath];
    cell.titleLab.text = str;
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
    NSString *str = self.liShiArray[indexPath.row];
    [self requestSearchInfo:str];
}

- (UILabel *)botLeftLab {
    if (!_botLeftLab) {
        _botLeftLab = [UILabel new];
        _botLeftLab.text = @"历史记录";
        _botLeftLab.textColor = RGB(140, 140, 140,1);
        _botLeftLab.font = [UIFont boldSystemFontOfSize:14];
    }
    return  _botLeftLab;
}
- (UIButton *)botRightBtn {
    if (!_botRightBtn) {
        _botRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_botRightBtn setTitle:@"清除" forState:UIControlStateNormal];
        _botRightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_botRightBtn setTitleColor:RGB(140, 140, 140,1) forState:UIControlStateNormal];
        _botRightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_botRightBtn addTarget:self action:@selector(botRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _botRightBtn;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        _tableView.separatorColor  = RGB(220, 220, 220,1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SearchTableViewCell class])];
    }
    return  _tableView;
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
    // Dispose of any resources that can be recreated.
}

///获取历史数据
- (void)getHistoryList {
    [self.liShiArray removeAllObjects];
    NSArray *unarchiverArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (unarchiverArr != nil) {
        [self.liShiArray addObjectsFromArray:unarchiverArr];
        [self.tableView reloadData];
    } else {
        NSLog(@"没有数");
    }
}



@end

