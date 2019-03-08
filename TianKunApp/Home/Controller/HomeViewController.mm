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
#import "AddressInfo.h"


#import "FindJodDetailViewController.h"
#import "JobDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "InteractionDetailViewController.h"

#import "LocationManager.h"
#import "JumpToAssignVC.h"
#import "HomeSelectAddressViewController.h"
#import "WebLoadImageViewController.h"
#import "FileNoticceListViewController.h"
#import "IndustryInformationListViewController.h"
#import "FileNoticceInfo.h"
#import "ArticleDetailViewController.h"

#import "HomeListNoImageTableViewCell.h"
#import "InteractionListViewController.h"
#import "SalaryCalculationViewController.h"
#import "HomeContioueEducationTableViewCell.h"
#import "SetInfoWebViewController.h"
#import "InvitationlistViewController.h"
#import "PointShopViewController.h"

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
@property (weak, nonatomic) IBOutlet QMUIButton *reloadButton;
@property (nonatomic ,strong) QMUIButton *addressButton;



@property (strong, nonatomic) IBOutlet UIView *changeView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressUpdate) name:LOCATION_UPDATE_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:LOGIN_SUCCEED_NOTICE object:nil];

    [self setUpNav];
    [self setupUI];
    [self setUpSearchBarController];
    [self getEnterpriseList];
    [self getBanner];
    [self getScorllAdvertising];
    
    [self getRecommend];
    _tableView.canLoadMore= NO;

    
    

}
#pragma mark - 位置信息更新通知

/**
 在定位到的位子发生变化时 且用户确定更新位置时调用
 */
- (void)addressUpdate{
    _pageIndex = 1;
    
    [self.tableView beginRefreshing];
    
    [_addressButton setTitle:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCity] forState:0];

}
- (void)userLogin{
 
    _pageIndex = 1;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeListNoImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeListNoImageTableViewCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"HomeContioueEducationTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeContioueEducationTableViewCell"];

    
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, NavigationContentStaticTop, SCREEN_WIDTH, SCREEN_HEIGHT-56-NavigationContentStaticTop) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headView;


        _tableView.backgroundColor = COLOR_VIEW_BACK;
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            weakSelf.pageIndex = 1;

            [weakSelf getEnterpriseList];
            [weakSelf getBanner];
            [weakSelf getScorllAdvertising];
            [weakSelf getRecommend];


        }];
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex++;
            [weakSelf getRecommend];
            
        }];

        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(_barView.mas_bottom);
        }];
        
        
        
        
    }
    return _tableView;
}

- (void)setUpNav {
    
    _barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationContentStaticTop)];
    _barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_barView];
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    // 文字居左
//    [searchBar changeLeftPlaceholder:@"请输入想要搜索的内容"];
    searchBar.placeholder = @"请输入想要搜索的内容";
    
    // 设置文本框背景
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:(UIControlStateNormal)];
    // 设置文本框圆角
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.layer.cornerRadius = 15;
    searchField.layer.masksToBounds = YES;
    // 设置文本框默认字体颜色
    [searchField setValue:COLOR_TEXT_LIGHT forKeyPath:@"_placeholderLabel.textColor"];
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
    
    QMUIButton *addressBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.imagePosition = QMUIButtonImagePositionRight;
    addressBtn.spacingBetweenImageAndTitle = 5;
    [addressBtn setTitle:@"郑州市" forState:UIControlStateNormal];
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addressBtn setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
    [addressBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(addressBtnClickEnent) forControlEvents:UIControlEventTouchUpInside];
    
    [_barView addSubview:addressBtn];
    _addressButton = addressBtn;
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_barView).offset(10);
        make.centerY.equalTo(searchBar);
        make.height.offset(30);
    }];
   NSString *city =  [[LocationManager manager] getLoactionInfoWithType:LocationTypeCity];
    [addressBtn setTitle:city forState:UIControlStateNormal];
    QMUIButton *messageBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setTitle:@"签到" forState:UIControlStateNormal];
    messageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [messageBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtnClickEcent) forControlEvents:UIControlEventTouchUpInside];
    
    [_barView addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_barView).offset(-10);
        make.centerY.equalTo(searchBar);
        make.height.offset(30);
        make.width.offset(40);

    }];
//        messageBtn.hidden = YES;

    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_barView).offset(-5);
        make.left.equalTo(addressBtn.mas_right).offset(10);
        make.height.mas_offset(30);
        make.right.equalTo(messageBtn.mas_left).offset(-10);

    }];
    

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
                menuInfo.menuIcon = [dict objectForKey:@"image_url"];
                menuInfo.menuLink = [dict objectForKey:@"link_url"];
                [_arrBanner addObject:menuInfo];
                [_arrBannerUrl addObject:menuInfo.menuIcon];
                
            }
//            if (!IS_OPEN_VIP) {
//                [_arrBanner removeLastObject];
//                [_arrBannerUrl removeLastObject];
//
//            }

            _headView.imageURLStringsGroup = _arrBannerUrl;
            
            NSMutableArray *arrEasy = [[responseObject objectForKey:@"value"] objectForKey:@"bianmin"];

            for (NSDictionary *dict in arrEasy) {
                MenuInfo *menuInfo = [[MenuInfo alloc]init];
                menuInfo.menuIcon = [dict objectForKey:@"image_url"];
                menuInfo.menuLink = [dict objectForKey:@"link_url"];
                menuInfo.menuName = [dict objectForKey:@"imagedescribe"];
                
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
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];

    [dict setObject:@(_pageIndex) forKey:@"pageNo"];
    [dict setObject:@(_pageSize) forKey:@"pageSize"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"find.watchRecordList.by") succed:^(id responseObject) {
        [self.tableView endRefresh];
        [self pauseAnimation];
        
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

            }else{
                _pageIndex--;
            }
            if (arr.count<_pageSize) {
                _tableView.canLoadMore= NO;
            }else{
                _tableView.canLoadMore= YES;
            }
            [self.tableView reloadData];

        }else{
            _pageIndex--;
            
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self pauseAnimation];

        [self.tableView endRefresh];
        _pageIndex--;
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
}
- (void)getScorllAdvertising{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"IndustryInformationController/selectzdIndustryInformation.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrScrollAd) {
                _arrScrollAd = [NSMutableArray array];
                _arrScrollAdTitle = [NSMutableArray array];
            }
            [_arrScrollAd removeAllObjects];
            _arrScrollAdTitle = [NSMutableArray array];
            NSArray *arr = [responseObject objectForKey:@"value"];
            for (NSDictionary *dict in arr) {
                FileNoticceInfo *info = [FileNoticceInfo mj_objectWithKeyValues:dict];
                [_arrScrollAd addObject:info];
                [_arrScrollAdTitle addObject:info.article_title];

            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            
        }
    } errorBlock:^(NSError *error) {
        
    }];
    
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 40;
    }
    return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }

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
    return self.arrData.count;
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

                FileNoticceInfo *info = _arrScrollAd[index];

                ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] initWithArticleID:[info.article_id integerValue] fromType:3];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

            };
            cell.clickMainImageBlock = ^{
//                IndustryInformationListViewController *vc = [[IndustryInformationListViewController alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
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
            Historyinfo *info =_arrData[indexPath.row];
            
            if (info.data_picture_url.length) {
                HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListTableViewCell" forIndexPath:indexPath];

                [cell.titleImageView sd_imageDef11WithUrlStr:info.data_picture_url];
                cell.titleLabel.text = info.data_title;
                cell.detailLabel.text = info.data_sketch;
                
                return cell;

            }else{
                HomeListNoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListNoImageTableViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = info.data_title;
                cell.detailLabel.text = info.data_sketch;
                return cell;

            }

    }
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"HomeContinueEducation" ofType:@"html"];
            NSURL*Url = [NSURL fileURLWithPath:path];
            
            SetInfoWebViewController *viewController = [[SetInfoWebViewController alloc]initWithUrl:Url title:@"继续教育"];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];

        }
    }
    if (indexPath.section == 3) {
        Historyinfo *info =_arrData[indexPath.row];
        [JumpToAssignVC jumpToAssignVCWithDataID:[NSString stringWithFormat:@"%@",@(info.data_id)] dataType:info.data_type documentType:info.data_type_two];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            return SCREEN_WIDTH/749*180;
            return 80;
        }else{
            return 82;

        }
    }
    if (indexPath.section ==2) {
        return 120;
        
    }

    if (indexPath.section == 3) {
            return 100;
        
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        [_reloadButton setTitleColor:COLOR_TEXT_LIGHT forState:0];
        [_reloadButton setSpacingBetweenImageAndTitle:5];
        [_reloadButton setImagePosition:QMUIButtonImagePositionLeft];
        [_reloadButton setImage:[UIImage imageNamed:@"刷新"] forState:0];
        [_reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return _changeView;
        
    }
    return [UIView new];
}
#pragma mark - UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    QMUITextField *searchBar = [QMUITextField new];
    searchBar.placeholder = @"请输入搜索内容";
    searchBar.textColor = COLOR_TEXT_LIGHT;
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
#pragma mark - SearchBar Delegate &&nav event
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    SearchViewController *vc = [SearchViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
    
    return NO;
}
- (void)addressBtnClickEnent{
    
    HomeSelectAddressViewController *vc = [[HomeSelectAddressViewController alloc] init];
    vc.selectAddressSuccedBlock = ^(AddressInfo *addressInfo) {
        [_addressButton setTitle:addressInfo.cityName forState:0];
    };
    QMUINavigationController *nav = [[QMUINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)messageBtnClickEcent{
    if ([UserInfoEngine isLogin]) {
        PointShopViewController *vc = [[PointShopViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];

    }
    

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
//    NSString *imageName;
//    NSString *title;
//
//    if(index == 0 ){
//        title = @"建筑一秘使用指南";
//        imageName = @"new_user_lead";
//    }else{
//        title = @"VIP特权介绍";
//        imageName = @"vip_introct";
//
//    }
//    WebLoadImageViewController *vc = [[WebLoadImageViewController alloc] initWithTitle:title arrImageName:@[imageName]];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

//MARK: ################## 功能模块点击回调 ##################


- (void)didSelectCellWithMenuInfo:(MenuInfo *)menuInfo{
//    JumpToAssignVC jumpToAssignVCWithDataId
//    if ([UserInfoEngine isLogin]) {
//    }
    switch (menuInfo.menuID) {
        case 0:
        {
//            WebLinkViewController *webLinkViewController = [[WebLinkViewController alloc]initWithTitle:@"建设企业" urlString:@"http://jzsc.mohurd.gov.cn/dataservice/query/comp/list"];
//            webLinkViewController.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:webLinkViewController animated:YES];
            

//            ConstructionViewController *vc = [[ConstructionViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        IndustryInformationListViewController *vc = [[IndustryInformationListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 1:{
//            WebLinkViewController *webLinkViewController = [[WebLinkViewController alloc]initWithTitle:@"从业人员" urlString:@"http://jzsc.mohurd.gov.cn/dataservice/query/staff/list"];
//            webLinkViewController.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:webLinkViewController animated:YES];

//            HomePeopleViewController *vc = [[HomePeopleViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
                SalaryCalculationViewController *vc = [[SalaryCalculationViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];


        }
            break;
        case 2:{
            FileNoticceListViewController *vc = [[FileNoticceListViewController alloc]init];
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
//            InvitationViewController *vc = [[InvitationViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.viewTitle = @"招标信息";
//            [self.navigationController pushViewController:vc animated:YES];


            InvitationlistViewController *vc = [[InvitationlistViewController alloc]initWithClassTypeInfo:nil type:1];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 5:{
            InvitationlistViewController *vc = [[InvitationlistViewController alloc]initWithClassTypeInfo:nil type:2];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

//            InvitationViewController *vc = [[InvitationViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.viewTitle = @"中标信息";
//
//            [self.navigationController pushViewController:vc animated:YES];
            
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
//            InteractionViewController *vc = [[InteractionViewController alloc]init];
            
            InteractionListViewController *vc = [[InteractionListViewController alloc]initWithClassID:@""];

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
    [self rotationAnimation];
    _pageIndex = 1;
    [self getRecommend];
}
- (void)pauseAnimation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        _reloadButton.imageView.layer.timeOffset = 0;
        //3.将动画的运行速度设置为0， 默认的运行速度是1.0
        _reloadButton.imageView.layer.speed = 0;

    });
}
- (void)rotationAnimation {
    //1.创建动画对象
    
    //默认是按Z轴旋转
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //2.设置动画属性
    
    [basic setToValue:@(2*M_PI)];  //2*M_PI 旋转一周
    
    [basic setDuration:0.5f];
    
    
    
    //动画完成后，是否从CALayer上移除动画对象
    
    //    [basic setRemovedOnCompletion:YES];
    
    
    
    //设置重复次数，HUGE_VALF是一个非常大的浮点数
    
    [basic setRepeatCount:HUGE_VALF];
    //动画根据锚点旋转的
    //修改锚点
//    [_reloadButton.imageView.layer setAnchorPoint:CGPointMake(0, 0)];
    
    //3.添加动画
    _reloadButton.imageView.layer.speed = 1;

    [_reloadButton.imageView.layer addAnimation:basic forKey:@"rotationAnimation"];
    
    
    
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
