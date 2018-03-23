//
//  HomeViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "UISearchBar+PlaceHolder.h"
#import "SDCycleScrollView.h"
#import "HomeClassTableViewCell.h"
#import "MenuInfo.h"
#import "HomeInfoTableViewCell.h"
#import "HomeBrandTableViewCell.h"
#import "EasyTableViewCell.h"
#import "HomeViewModel.h"
#import "HomeGuessTableViewCell.h"
#import "HomeListTableViewCell.h"
#import "FileNoticceViewController.h"
#import "PublicViewController.h"
#import "InvitationViewController.h"
#import "JobViewController.h"
#import "InteractionViewController.h"
#import "EducationViewController.h"

#import "ConstructionViewController.h"

@interface HomeViewController ()<QMUISearchControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SDCycleScrollViewDelegate,HomeClassTableViewCellDelegate>

@property (nonatomic ,strong) UIView *barView;
@property (nonatomic ,strong) QMUISearchController *searchBarController;
@property (weak, nonatomic) IBOutlet WQTableView *tableView;
@property (nonatomic ,strong) SDCycleScrollView *headView;
@property (nonatomic ,strong) NSMutableArray *arrData;


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
    _tableView.tableHeaderView = self.headView;
    _tableView.estimatedRowHeight = 80;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView registerNib:[UINib nibWithNibName:@"HomeClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeClassTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeInfoTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeBrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeBrandTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"EasyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EasyTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeGuessTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeGuessTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeListTableViewCell"];

}
- (void)setUpNav {
    
    _barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationContentStaticTop)];
    _barView.backgroundColor = UIColorClear;
    [self.view addSubview:_barView];
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    // 文字居左
    [searchBar changeLeftPlaceholder:@"请输入想要搜索的内容"];
    // 设置文本框背景
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:(UIControlStateNormal)];
    // 设置文本框圆角
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.layer.cornerRadius = 15;
    searchField.layer.masksToBounds = YES;
    // 设置文本框默认字体颜色
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    // 设置搜索图标
    UIImage *iconImage = [UIImage imageNamed:@"home_search"];
    [searchBar setImage:iconImage forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar sizeToFit];

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
- (SDCycleScrollView *)headView{
    if (!_headView) {
        _headView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2) delegate:self placeholderImage:[UIImage imageNamed:@"default_image_21@2x"]];
        [_headView setImageURLStringsGroup:@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=253568843,526167858&fm=27&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521461712420&di=46910b9e6a1a56a549e02470ac5b37e6&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201511%2F22%2F20151122131622_XYkMd.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521461712420&di=e2c5b119c9b1db78da4cf9472d36142c&imgtype=0&src=http%3A%2F%2Fimg0w.pconline.com.cn%2Fpconline%2F1606%2F15%2Fspcgroup%2Fwidth_640-qua_30%2F8023441_20140213174329_MQ2iZ.jpeg"]];
    }
    return _headView;
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 1;
    }
    return self.arrData.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomeClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeClassTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HomeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeInfoTableViewCell" forIndexPath:indexPath];
            return cell;

        }else{
            HomeBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeBrandTableViewCell" forIndexPath:indexPath];
            return cell;

        }
        

    }
    
    if (indexPath.section == 2) {
        EasyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EasyTableViewCell" forIndexPath:indexPath];
        cell.arrMenu = [HomeViewModel arrEasyMenu];
        return cell;

    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            HomeGuessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeGuessTableViewCell" forIndexPath:indexPath];

            return cell;
        }else{
            HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListTableViewCell" forIndexPath:indexPath];
            return cell;

        }
    }
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
#pragma mark - SearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    SearchViewController *vc = [SearchViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
    
    return NO;
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
#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
#pragma makr - top view
- (void)didSelectCellWithMenuInfo:(MenuInfo *)menuInfo{
    
//    if ([UserInfoEngine isLogin]) {
//    }
    switch (menuInfo.menuID) {
        case 0:
        {
            ConstructionViewController *vc = [[ConstructionViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 1:{
            ConstructionViewController *vc = [[ConstructionViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 2:{
            FileNoticceViewController *vc = [[FileNoticceViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 3:{
            PublicViewController *vc = [[PublicViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

            
        }
            break;
        case 4:{
            
            InvitationViewController *vc = [[InvitationViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.viewTitle = @"招标信息";
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 5:{
            
            InvitationViewController *vc = [[InvitationViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.viewTitle = @"中标信息";

            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 6:{
            
            JobViewController *vc = [[JobViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.viewTitle = @"企业招聘";
            
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 7:{
            JobViewController *vc = [[JobViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.viewTitle = @"人才求职";
            
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 8:{
            InteractionViewController *vc = [[InteractionViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:{
            
            EducationViewController *vc = [[EducationViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        default:
            break;
    }
}
- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];

    }
    return _arrData;
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
