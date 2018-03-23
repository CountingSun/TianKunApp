//
//  HomeViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<QMUISearchControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIView *barView;
@property (nonatomic ,strong) QMUISearchController *searchBarController;
@property (weak, nonatomic) IBOutlet WQTableView *tableView;

@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setUpNav];
    [self setUpSearchBarController];

}
- (void)setupUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}
- (void)setUpNav {
    
    _barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationContentStaticTop)];
    _barView.backgroundColor = UIColorClear;
    [self.view addSubview:_barView];
    
    QMUITextField *searchBar = [[QMUITextField alloc]init];
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.borderWidth = 0.5;
    searchBar.layer.borderColor = UIColorWhite.CGColor;
    searchBar.placeholderColor = UIColorWhite;
    searchBar.textColor = UIColorWhite;
    searchBar.tintColor = UIColorWhite;
    searchBar.placeholder = @"请输入想要搜索的内容";
    searchBar.textInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    searchBar.backgroundColor = UIColorClear;
    searchBar.font = [UIFont systemFontOfSize:14];
    [_barView addSubview:searchBar];
    CGFloat width = 240 * SCREENSCAL;
    if (IS_58INCH_SCREEN) {
        width = 240;
    }
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_barView);
        make.bottom.equalTo(_barView).offset(-5);
        make.width.mas_offset(width);
        make.height.mas_offset(30);
    }];
    UIImageView *searchBarRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
    searchBarRight.contentMode = UIViewContentModeCenter;
    [searchBarRight sizeToFit];
    [searchBar addSubview:searchBarRight];
    [searchBarRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchBar).offset(-10);
        make.centerY.equalTo(searchBar);
        make.size.mas_offset(CGSizeMake(18, 18));
    }];
    
    QMUIButton *addressBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.imagePosition = QMUIButtonImagePositionRight;
    addressBtn.spacingBetweenImageAndTitle = 5;
    [addressBtn setTitle:@"郑州" forState:UIControlStateNormal];
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addressBtn setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
    [addressBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
    [_barView addSubview:addressBtn];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_barView).offset(10);
        make.centerY.equalTo(searchBar);
    }];
    
    QMUIButton *messageBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    [_barView addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_barView).offset(-10);
        make.centerY.equalTo(searchBar);
    }];
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

#pragma mark - UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 50) {
        CGFloat alpha = MIN(1, 1 - ((50 + 64 - offsetY) / 64));
        _barView.backgroundColor = COLOR_THEME;
    } else {
        _barView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    QMUITextField *searchBar = [QMUITextField new];
    searchBar.placeholder = @"请输入搜索内容";
    searchBar.textColor = UIColorWhite;
    searchBar.font = [UIFont systemFontOfSize:20];
    searchBar.placeholderColor = searchBar.textColor;
    [searchBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"搜索背景"]]];
    [searchBar sizeToFit];
    self.navigationItem.titleView = searchBar;
}

- (void)setUpSearchBarController {
    _searchBarController = [[QMUISearchController alloc] initWithContentsViewController:self];
    _searchBarController.searchResultsDelegate = self;
    //    [self.titleView addSubview:_searchBarController.searchBar];
}
#pragma mark - QMUISearchControllerDelegate

/**
 *  搜索框文字发生变化时的回调，请自行调用 `[tableView reloadData]` 来更新界面。
 *  @warning 搜索框文字为空（例如第一次点击搜索框进入搜索状态时，或者文字全被删掉了，或者点击搜索框的×）也会走进来，此时参数searchString为@""，这是为了和系统的UISearchController保持一致
 */
- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString{
    [searchController.tableView reloadData];

}
- (void)willPresentSearchController:(QMUISearchController *)searchController {
    [QMUIHelper renderStatusBarStyleDark];
}

- (void)willDismissSearchController:(QMUISearchController *)searchController {
    BOOL oldStatusbarLight = NO;
    if ([self respondsToSelector:@selector(shouldSetStatusBarStyleLight)]) {
        oldStatusbarLight = [self shouldSetStatusBarStyleLight];
    }
    if (oldStatusbarLight) {
        [QMUIHelper renderStatusBarStyleLight];
    } else {
        [QMUIHelper renderStatusBarStyleDark];
    }
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
