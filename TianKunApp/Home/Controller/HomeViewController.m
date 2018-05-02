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
#import "FindJobViewController.h"

#import "ConstructionViewController.h"
#import "HomePeopleViewController.h"
#import "CompanyInfo.h"
#import "CompanyDetailViewController.h"
#import "ImageInfo.h"
#import "WebLinkViewController.h"
#import "Historyinfo.h"


#import "FindJodDetailViewController.h"
#import "JobDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "InteractionDetailViewController.h"


@interface HomeViewController ()<QMUISearchControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SDCycleScrollViewDelegate,HomeClassTableViewCellDelegate>

@property (nonatomic ,strong) UIView *barView;
@property (nonatomic ,strong) QMUISearchController *searchBarController;
@property (nonatomic ,strong)  WQTableView *tableView;
@property (nonatomic ,strong) SDCycleScrollView *headView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;


/**
 6个 公司的数组
 */
@property (nonatomic ,strong) NSMutableArray *arrCompany;

/**
 轮播图
 */
@property (nonatomic ,strong) NSMutableArray *arrBanner;
@property (nonatomic ,strong) NSMutableArray *arrBannerUrl;

/**
 便民服务
 */
@property (nonatomic ,strong) NSMutableArray *arrEasy;

/**
 轮播广告
 */
@property (nonatomic ,strong) NSMutableArray *arrScrollAd;
@property (nonatomic ,strong) NSMutableArray *arrScrollAdTitle;

@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) QMUIButton *reloadButton;




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
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    [self setupUI];
    [self setUpNav];
    [self setUpSearchBarController];
    [self getEnterpriseList];
    [self getBanner];
    [self getScorllAdvertising];
    
    [self getRecommend];
    
    
    

}
#pragma mark - ui

- (void)setupUI{
        [self.tableView registerNib:[UINib nibWithNibName:@"HomeClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeClassTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeInfoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeBrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeBrandTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EasyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EasyTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeGuessTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeGuessTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeListTableViewCell"];
    
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-56) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headView;
        _tableView.estimatedRowHeight = 160;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 10;
        
        _tableView.estimatedSectionFooterHeight = 10;
        

        _tableView.backgroundColor = COLOR_VIEW_BACK;
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            [weakSelf getEnterpriseList];
            [weakSelf getBanner];
            [weakSelf getScorllAdvertising];


        }];
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex++;
            [weakSelf getRecommend];
            
        }];

        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
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
//    UIImage *iconImage = [UIImage imageNamed:@"home_search"];
//    [searchBar setImage:iconImage forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [searchBar sizeToFit];

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
//    UIImageView *searchBarRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
//    searchBarRight.contentMode = UIViewContentModeCenter;
//    [searchBarRight sizeToFit];
//    [searchBar addSubview:searchBarRight];
//    [searchBarRight mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(searchBar).offset(-10);
//        make.centerY.equalTo(searchBar);
//        make.size.mas_offset(CGSizeMake(18, 18));
//    }];
    
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
    
//    QMUIButton *messageBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    [messageBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
//    [_barView addSubview:messageBtn];
//    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_barView).offset(-10);
//        make.centerY.equalTo(searchBar);
//    }];
}
- (SDCycleScrollView *)headView{
    if (!_headView) {
        _headView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2) delegate:self placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_21]];
    }
    return _headView;
}

#pragma mark- net

- (void)getEnterpriseList{
    [self.netWorkEngine postWithDict:@{@"amount":@"6"} url:BaseUrl(@"find.recommendExt.by.enterpriseList") succed:^(id responseObject) {
        [_tableView endRefresh];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrCompany) {
                _arrCompany = [NSMutableArray arrayWithCapacity:6];
                
            }
            [_arrCompany removeAllObjects];
            
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            for (NSDictionary *dicr in arr) {
                CompanyInfo *companyInfo = [CompanyInfo mj_objectWithKeyValues:dicr];

                [_arrCompany addObject:companyInfo];
                if (_arrCompany.count>6) {
                    [_arrCompany removeLastObject];
                }

            }

            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [_tableView endRefresh];

        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (void)getBanner{
    [self.netWorkEngine postWithUrl:BaseUrl(@"ShouYeAndBianMingFuWu/selectslideshoworbianminbytypeapp.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrBanner) {
                _arrBanner = [NSMutableArray array];
            }
            [_arrBanner removeAllObjects];
            if (!_arrEasy) {
                _arrEasy = [NSMutableArray array];
            }
            [_arrEasy removeAllObjects];
            if (!_arrBannerUrl) {
                _arrBannerUrl = [NSMutableArray array];
            }
            [_arrBannerUrl removeAllObjects];

            
            NSMutableArray *arrBanner = [[responseObject objectForKey:@"value"] objectForKey:@"shouye"];
            for (NSDictionary *dict in arrBanner) {
                MenuInfo *menuInfo = [[MenuInfo alloc]init];
                menuInfo.menuIcon = [NSString stringWithFormat:@"%@%@",BaseUrl(@"image/slideshow/"),[dict objectForKey:@"image_url"]];
                menuInfo.menuLink = [dict objectForKey:@"link_url"];
                [_arrBanner addObject:menuInfo];
                [_arrBannerUrl addObject:menuInfo.menuIcon];
                
            }
            _headView.imageURLStringsGroup = _arrBannerUrl;
            NSMutableArray *arrEasy = [[responseObject objectForKey:@"value"] objectForKey:@"bianmin"];

            for (NSDictionary *dict in arrEasy) {
                MenuInfo *menuInfo = [[MenuInfo alloc]init];
                menuInfo.menuIcon = [NSString stringWithFormat:@"%@%@",BaseUrl(@"image/slideshow/"),[dict objectForKey:@"image_url"]];
                menuInfo.menuLink = [dict objectForKey:@"link_url"];
                menuInfo.menuName = [dict objectForKey:@"imagename"];
                
                [_arrEasy addObject:menuInfo];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                
            }

            
        }else{
            
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
}
- (void)getRecommend{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([UserInfoEngine getUserInfo].userID) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userId"];
    }
    [dict setObject:@(_pageIndex) forKey:@"pageNo"];
    [dict setObject:@(_pageSize) forKey:@"pageSize"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"find.watchRecordList.by") succed:^(id responseObject) {
        [self.tableView endRefresh];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
            }
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            if (arr.count) {
                for (NSDictionary *dict in arr) {
                    Historyinfo *info = [Historyinfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:info];
                }
                [self.tableView reloadData];

            }else{
                _pageIndex--;
            }
        }else{
            _pageIndex--;
            
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self.tableView endRefresh];
        _pageIndex--;
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
}
- (void)getScorllAdvertising{
    [self.netWorkEngine postWithUrl:BaseUrl(@"ArticleNotices/recommendExt.by.flag") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrScrollAd) {
                _arrScrollAd = [NSMutableArray array];
                _arrScrollAdTitle = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrScrollAd removeAllObjects];
                _arrScrollAdTitle = [NSMutableArray array];

            }
            NSArray *arr = [responseObject objectForKey:@"value"];
            for (NSDictionary *dict in arr) {
                Historyinfo *info = [Historyinfo mj_objectWithKeyValues:dict];
                [_arrScrollAd addObject:info];
                [_arrScrollAdTitle addObject:info.data_title];

            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            
        }
    } errorBlock:^(NSError *error) {
        
    }];
    
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
            cell.arrData = _arrScrollAdTitle;
            cell.clickWithIndexBlock = ^(NSInteger index) {
                Historyinfo *info = _arrScrollAd[index];
                NSLog(@"%@",@(info.data_id));
                [self jumpTodetailWithHistoryinfo:info];

            };
            
            return cell;

        }else{
            HomeBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeBrandTableViewCell" forIndexPath:indexPath];
            cell.arrData = self.arrCompany;
            cell.collectionViewDidSelectItemBlock = ^(CompanyInfo *companyInfo, NSIndexPath *indexPath) {
                CompanyDetailViewController *vc = [[CompanyDetailViewController alloc]initWithCompanyID:companyInfo.companyID type:2];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            };
            
            return cell;

        }
        

    }
    
    if (indexPath.section == 2) {
        EasyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EasyTableViewCell" forIndexPath:indexPath];
        cell.arrMenu = _arrEasy;
        cell.selectSucceed = ^(MenuInfo *menuInfo) {
            WebLinkViewController *webLinkViewController = [[WebLinkViewController alloc]initWithTitle:menuInfo.menuName urlString:menuInfo.menuLink];
            webLinkViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webLinkViewController animated:YES];

        };
        

        return cell;

    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            HomeGuessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeGuessTableViewCell" forIndexPath:indexPath];

           _reloadButton =  cell.reloadButton;
            [_reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            
            return cell;
        }else{
            Historyinfo *info =_arrData[indexPath.row-1];
            
            HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListTableViewCell" forIndexPath:indexPath];
            [cell.titleImageView sd_imageDef11WithUrlStr:@""];
            cell.titleLabel.text = info.data_title;
            cell.detailLabel.text = info.data_sketch;
            
            return cell;

        }
    }
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        if (indexPath.row >0) {
            Historyinfo *info =_arrData[indexPath.row-1];
            [self jumpTodetailWithHistoryinfo:info];
            
        }
    }
}
//MARK: 根据ID 类型 跳转到相应详情
- (void)jumpTodetailWithHistoryinfo:(Historyinfo *)info{
    //  private Short data_type;//资料(信息)类型: 1岗位信息,2简历信息,3文件通知,4公示公告,5招投标信息,6教育培训,7互动交流,8企业信息(APP发布),9企业信息(WEB发布)
    switch (info.data_type) {
        case 1:
        {
            JobDetailViewController *viewController = [[JobDetailViewController alloc] initWithJobID:[NSString stringWithFormat:@"%@",@(info.data_id)]];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:{
            
            FindJodDetailViewController *viewController = [[FindJodDetailViewController alloc] initWithResumeID:[NSString stringWithFormat:@"%@",@(info.data_id)]];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 3:{
            
            ArticleDetailViewController *viewController = [[ArticleDetailViewController alloc] initWithArticleID:info.data_id fromType:1];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4:{
            
            ArticleDetailViewController *viewController = [[ArticleDetailViewController alloc] initWithArticleID:info.data_id fromType:0];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 7:{
            
            InteractionDetailViewController *viewController = [[InteractionDetailViewController alloc] initWithInteractionID:[NSString stringWithFormat:@"%@",@(info.data_id)]];
            
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
            
        default:
            break;
    }

}
#pragma mark - UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 50) {
        CGFloat alpha = MIN(1, 1 - ((50 + 64 - offsetY) / 64));
        _barView.backgroundColor = UIColorMakeWithRGBA(75, 150, 247, alpha);
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
    MenuInfo *menuInfo = _arrBanner[index];
    WebLinkViewController *webLinkViewController = [[WebLinkViewController alloc]initWithTitle:menuInfo.menuName urlString:menuInfo.menuLink];
    webLinkViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webLinkViewController animated:YES];

}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

//MARK: ################## 功能模块点击回调 ##################


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
            HomePeopleViewController *vc = [[HomePeopleViewController alloc]init];
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
            FindJobViewController *vc = [[FindJobViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            
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
- (void)reloadButtonClick{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    
    [_reloadButton.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    _pageIndex = 1;
    [self getRecommend];
}
- (NetWorkEngine *)netWorkEngine{
    
    
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
        
    }
    return _netWorkEngine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
