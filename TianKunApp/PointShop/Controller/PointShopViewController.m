//
//  PointShopViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PointShopViewController.h"
#import "SDCycleScrollView.h"
#import "PointShopGoodsCollectionViewCell.h"
#import "MenuInfo.h"
#import "GoodsInfo.h"
#import "MyPointViewController.h"
#import "PointGoodsDetailViewController.h"
#import "MyExchangeRecordViewController.h"
#import "SignInView.h"
#import "PointGoodsDetailViewController.h"

@interface PointShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic ,strong) UIView *headView;
@property (nonatomic ,strong) SDCycleScrollView *bannerView;

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) NSMutableArray *arrBanner;
@property (nonatomic ,strong) NSMutableArray *arrBannerUrl;
@property (nonatomic ,strong) SignInView *signInView;
@property (nonatomic ,assign) NSInteger point;
@property (nonatomic ,strong) QMUIButton *myPointButton;


@end

@implementation PointShopViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getBanner];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"积分商城"];
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    [self headView];
    [self showLoadingView];
    [self getBanner];
    [self getGoods];
    [self signInNet];
    
    
    
    
    
    
    
}
- (void)getBanner{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TkSpCommodityAPPController/selectsplbpicture.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrBanner) {
                _arrBanner = [NSMutableArray array];
            }
            [_arrBanner removeAllObjects];
            if (!_arrBannerUrl) {
                _arrBannerUrl = [NSMutableArray array];
            }
            [_arrBannerUrl removeAllObjects];
            
            
            NSMutableArray *arrBanner = [[responseObject objectForKey:@"value"] objectForKey:@"lists"];
            for (NSDictionary *dict in arrBanner) {
                MenuInfo *menuInfo = [[MenuInfo alloc]init];
                menuInfo.menuIcon = [dict objectForKey:@"picture"];
                menuInfo.menuID = [[dict objectForKey:@"id"] integerValue];

                [_arrBanner addObject:menuInfo];
                [_arrBannerUrl addObject:menuInfo.menuIcon];
                
            }
            _point = [[[responseObject objectForKey:@"value"] objectForKey:@"total"] integerValue];
            _bannerView.imageURLStringsGroup = _arrBannerUrl;
            
            [self setPointButtonTitle:_point];
            

            
            
        }else{
            
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
}
- (void)setPointButtonTitle:(NSInteger)point{
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"积分" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@(point)] attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] init];
    [string3 appendAttributedString:string1];
    [string3 appendAttributedString:string2];
    
    [_myPointButton setAttributedTitle:string3 forState:0];

}
- (void)signInNet{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TkSpCommodityAPPController/insertsignin.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSInteger point = [[responseObject objectForKey:@"value"] integerValue];
            self.signInView.point = [NSString stringWithFormat:@"+%@",@(point)];
            
        }else{
//            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
     } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    

}
- (void)getGoods{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_pageIndex) forKey:@"page"];
    [dict setObject:@(_pageSize) forKey:@"count"];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TkSpCommodityAPPController/selectspcommodity.action") succed:^(id responseObject) {
        [self hideLoadingView];
        [self endRefesh];

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
                    GoodsInfo *goodsInfo = [GoodsInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:goodsInfo];
                }
                [self.collectionView reloadData];
                
            }else{
                if (!_arrData.count) {
                    [self showGetDataNullWithReloadBlock:^{
                        [self showLoadingView];
                        [self getGoods];
                    }];
                    
                    
                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
            }
            if(arr.count<_pageSize){
                _collectionView.header.hidden = YES;
            }else{
                _collectionView.header.hidden = NO;
            }
            
        }else{
            if (!_arrData.count) {
                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    [self getGoods];
                }];
                
                
            }else{
                _pageIndex--;
                
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
            }
            
        }
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self endRefesh];
        if (_arrData.count) {
            _pageIndex = 1;
            
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            _pageIndex = 1;
            [self showGetDataFailViewWithReloadBlock:^{
                [self hideEmptyView];
                [self showLoadingView];
                [self getGoods];
            }];
        }
    }];
}
- (SignInView *)signInView{
    if (!_signInView) {
        _signInView = [[SignInView alloc] initNib];
        _signInView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        __weak typeof(self) weakSelf = self;
        
        _signInView.finishBlock = ^{
            [weakSelf getBanner];
            
        };
        
        [[UIApplication sharedApplication].keyWindow addSubview:_signInView];
        
    }
    return _signInView;
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2+70);
        layout.itemSize =CGSizeMake(SCREEN_WIDTH/2-.5f, SCREEN_WIDTH/2/3*2+80);


        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        
        [_collectionView registerNib:[UINib nibWithNibName:@"PointShopGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PointShopGoodsCollectionViewCell"];

        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
        __weak typeof(self) weakSelf = self;

        _collectionView .header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageIndex = 1;
            [weakSelf getGoods];
            
        }];
        _collectionView .footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageIndex ++;
            [weakSelf getGoods];
            
        }];

        
        
        _collectionView.backgroundColor = COLOR_VIEW_BACK;
    }
    return _collectionView;
    
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2+80+30)];
        
        WQLabel *appleLabel = [[WQLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20) font:[UIFont systemFontOfSize:12] text:@"*商品和活动皆与设备制造商Apple Inc.无关" textColor:COLOR_TEXT_LIGHT textAlignment:NSTextAlignmentCenter numberOfLine:1];
        appleLabel.backgroundColor = COLOR_VIEW_BACK;
        
        [_headView addSubview:appleLabel];
        [appleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_headView);
            make.height.offset(30);
        }];
        
        
        _headView.backgroundColor = [UIColor whiteColor];
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, CGRectGetMaxY(appleLabel.frame), SCREEN_WIDTH, SCREEN_WIDTH/2) delegate:self placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_21]];
        [_headView addSubview:_bannerView];
        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(appleLabel.mas_bottom);
            make.left.right.equalTo(_headView);
            make.height.offset(SCREEN_WIDTH/2);
            
        }];
        
        QMUIButton *myPointButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_headView addSubview:myPointButton];
        [myPointButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headView);
            make.top.equalTo(_bannerView.mas_bottom);
            make.width.offset(SCREEN_WIDTH/2-1);
            make.height.offset(50);
            
        }];
        [myPointButton setTitle:@"积分" forState:0];
        [myPointButton addTarget:self action:@selector(myPointButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _myPointButton = myPointButton;
        [myPointButton setImagePosition:QMUIButtonImagePositionLeft];
        [myPointButton setImage:[UIImage imageNamed:@"point_diamond"]  forState:0];
        [myPointButton setSpacingBetweenImageAndTitle:5];
        
        
        UIView *spView = [[UIView alloc]init];
        spView.backgroundColor = COLOR_VIEW_SEGMENTATION;
        [_headView addSubview:spView];
        [spView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(myPointButton);
            make.top.equalTo(_bannerView.mas_bottom).offset(10);
            make.height.offset(30);
            make.width.offset(1);
        }];
        QMUIButton *recordButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_headView addSubview:recordButton];
        [recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headView);
            make.top.equalTo(_bannerView.mas_bottom);
            make.width.offset(SCREEN_WIDTH/2-1);
            make.height.offset(50);
            
        }];
        [recordButton setTitle:@"兑换记录" forState:0];
        WQLabel *label = [[WQLabel alloc] initWithFrame:CGRectZero font:[UIFont systemFontOfSize:14] text:@"【大家都在兑】" textColor:COLOR_TEXT_BLACK textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [recordButton addTarget:self action:@selector(recordButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [recordButton setImagePosition:QMUIButtonImagePositionLeft];
        [recordButton setImage:[UIImage imageNamed:@"记录"]  forState:0];
        [recordButton setSpacingBetweenImageAndTitle:5];

        [_headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headView).offset(10);
            make.right.equalTo(_headView).offset(-10);
            make.height.offset(20);
            make.top.equalTo(myPointButton.mas_bottom);
        }];
        
        
        
    }
    return _headView;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView* view = [_collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
        [view addSubview:self.headView];
        return view;
    }
    return nil;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrData.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PointShopGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PointShopGoodsCollectionViewCell" forIndexPath:indexPath];
    
    GoodsInfo *info = _arrData[indexPath.row];
    cell.goodsInfo = info;
    

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsInfo *info = _arrData[indexPath.row];
    PointGoodsDetailViewController *vc = [[PointGoodsDetailViewController alloc] initWithGoodsID:info.goodsID];
    vc.buySucceedBlock = ^{
        info.number --;
        if (info.number<0) {
            info.number = 0;
            
        }
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
    };
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}
- (void)myPointButtonClick{
    MyPointViewController *vc = [[MyPointViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)recordButtonClick{
    
    MyExchangeRecordViewController *vc = [[MyExchangeRecordViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
- (NetWorkEngine *)netWorkEngine{
    
    
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
        
    }
    return _netWorkEngine;
}
- (void)endRefesh{
    
    if ([_collectionView.header isRefreshing]) {
        [_collectionView.header endRefreshing];
        
    }
    if ([_collectionView.footer isRefreshing]) {
        [_collectionView.footer endRefreshing];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    MenuInfo *info = _arrBanner[index];
    PointGoodsDetailViewController *vc = [[PointGoodsDetailViewController alloc] initWithGoodsID:info.menuID];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
