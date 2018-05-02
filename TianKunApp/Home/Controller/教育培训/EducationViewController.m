//
//  EducationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationViewController.h"
#import "EducationTableViewCell.h"
#import "HomeClassCollectionViewCell.h"
#import "MenuInfo.h"
#import "HomeViewModel.h"

#import "EducationDetailViewController.h"
#import "EducationMeansViewController.h"
#import "CollectionViewHorizontalLayout.h"
#import "DocumentInfo.h"
#import "EductationNetworkEngine.h"
#import "PlayViewController.h"

@interface EducationViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic ,strong) CollectionViewHorizontalLayout *flowLayout;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) EductationNetworkEngine *eductationNetworkEngine;

@end

@implementation EducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"教育信息"];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;

    [_pageControl setValue:[self createImageWithColor:COLOR_THEME] forKeyPath:@"_currentPageImage"];
    [_pageControl setValue:[self createImageWithColor:UIColorSeparator] forKeyPath:@"_pageImage"];
    _pageControl.userInteractionEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"EducationTableViewCell" bundle:nil] forCellReuseIdentifier:@"EducationTableViewCell"];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.canLoadMore = NO;

    [self setCollectionView];
    [self showLoadingView];
    [self getClass];
    [self getRecommend];
    

}
- (void)getClass{
 
    [self.netWorkEngine postWithUrl:BaseUrl(@"find.education.type.ancestor") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrMenu) {
                _arrMenu = [NSMutableArray array];
            }
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            
            for (NSDictionary *dict in arr) {
                MenuInfo *info = [[MenuInfo alloc]init];
                info.menuID = [[dict objectForKey:@"id"] integerValue];
                info.menuName = [dict objectForKey:@"type_name"];
                info.menuIcon = [dict objectForKey:@"picture_url"];
                [_arrMenu addObject:info];

            }
            [self.collectionView reloadData];
            if (_arrMenu.count) {
                [_pageControl setNumberOfPages: (_arrMenu.count - 1)/3+1];
            }
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getClass];
            }];
            
        }
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getClass];

        }];
        
    }];
    
}
- (void)getRecommend{
    if (!_eductationNetworkEngine) {
        _eductationNetworkEngine = [[EductationNetworkEngine alloc]init];
    }
    [_eductationNetworkEngine postWithPageIndex:_pageIndex pageSize:_pageSize dataType2:-1 calssType:-1 returnBlock:^(NSInteger code,NSString *msg, NSMutableArray *arrData) {
        if (code == 1) {
            if(!_arrData){
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
            }
            [_arrData addObjectsFromArray:arrData];
            [self.tableView reloadData];
            
            if (arrData<_pageSize) {
                self.tableView.canLoadMore = NO;
            }else{
                self.tableView.canLoadMore = YES;
            }
        }else if(code == -1){
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            [self showErrorWithStatus:msg];
        }

    }];
    
    
}
#pragma mark collectionview

- (void)setCollectionView{
    _collectionView.collectionViewLayout = self.flowLayout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    _collectionView.indexDisplayMode = UIScrollViewIndexDisplayModeAutomatic;
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeClassCollectionViewCell"];
    _pageControl.hidden = YES;
    
    [self.collectionView reloadData];
    

    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrMenu.count;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeClassCollectionViewCell" forIndexPath:indexPath];
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];
    cell.label.text = menuInfo.menuName;
    [cell.imageView sd_imageDef11WithUrlStr:BaseUrl(menuInfo.menuIcon)];
    return cell;
    
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[CollectionViewHorizontalLayout alloc]init];
        _flowLayout.itemCountPerRow = 3;
        _flowLayout.rowCount = 1;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
//        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3, 100);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
    }
    return _flowLayout;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/3, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];

    EducationMeansViewController *vc = [[EducationMeansViewController alloc]initWithClassID:menuInfo.menuID viewTitle:menuInfo.menuName];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _collectionView) {

        CGFloat floatIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
        
        if (floatIndex == roundf(floatIndex)) {
            [_pageControl setCurrentPage:floatIndex];

        }else{
            [_pageControl setCurrentPage:floatIndex +1];
        }


    }
}
#pragma mark - tableview
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 140;
        _tableView.separatorStyle = 0;
        
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        
        __weak typeof(self) weakSelf = self;

        [_tableView headerWithRefreshingBlock:^{
            
            weakSelf.pageIndex = 1;
            [weakSelf getRecommend];
            
        }];
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex ++;
            [weakSelf getRecommend];

        }];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrData.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EducationTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EducationTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = 0;

    }
    
    DocumentInfo *info = _arrData[indexPath.section];
    NSString *url = [info.video_image_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    [cell.titleImageView sd_imageDef11WithUrlStr:url];
    cell.titleLabel.text = info.data_title;
    cell.detailLabel.text = info.synopsis;
    if (info.is_charge) {
        cell.isFreeLabel.text = @"收费";
    }else{
        cell.isFreeLabel.text = @"免费";

    }
    cell.numLabel.text = [NSString stringWithFormat:@"浏览%@次",@(info.hits_show)];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentInfo *info = _arrData[indexPath.section];
    if (info.type == 1) {
        EducationDetailViewController *vc = [[EducationDetailViewController alloc]initWithDocumentID:info.data_id];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PlayViewController *vc = [[PlayViewController alloc]initWithDocumentID:info.data_id];
        [self.navigationController pushViewController:vc animated:YES];

    }


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
- (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,10.0f,2.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    return theImage;
    
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
