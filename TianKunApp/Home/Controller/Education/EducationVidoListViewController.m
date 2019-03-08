//
//  EducationVidoListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationVidoListViewController.h"
#import "EducationVidoCollectionViewCell.h"
#import "PlayViewController.h"
#import "DocumentPropertyInfo.h"
#import "DocumentInfo.h"


@interface EducationVidoListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)  UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;


/**
 参数字典
 */
@property (nonatomic ,strong) NSMutableDictionary *dict;


@end

@implementation EducationVidoListViewController
- (instancetype)initWithClassID:(NSInteger)classID{
    if (self = [super init]) {
        [self.dict setObject:@(classID) forKey:@"k"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    _pageSize = 16;
    [self showLoadingView];


}
- (void)reloadWithDocumentPropertyInfo:(DocumentPropertyInfo *)documentPropertyInfo{
    
    [self.dict removeAllObjects];
    _pageIndex = 1;
    [self.dict setObject:@(DEFAULT_PAGE_SIZE) forKey:@"num"];
    [self.dict setObject:@(_pageIndex) forKey:@"stratnum"];
    [self.dict setObject:@(documentPropertyInfo.classType) forKey:@"k"];
    [self.dict setObject:@(documentPropertyInfo.documentClass) forKey:@"l"];
    [self.dict setObject:@(documentPropertyInfo.isFree) forKey:@"m"];
    [self.dict setObject:@(documentPropertyInfo.documentType) forKey:@"z"];

    [self.collectionView.header beginRefreshing];
    self.collectionView.footer.hidden = YES;

//    [self getDocumentListWithDict:self.dict];

}
- (void)getDocumentListWithDict:(NSMutableDictionary *)dict{
    if (_pageIndex <1) {
        _pageIndex = 1;
    }
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"Learning/selectlearninglistbytj.action") succed:^(id responseObject) {
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        [self hideLoadingView];
        [self hideEmptyView];

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1) {
            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
                
            }
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            for (NSDictionary *dict in arr) {
                DocumentInfo *info = [DocumentInfo mj_objectWithKeyValues:dict];
                [_arrData addObject:info];
            }
            [self.collectionView reloadData];
            if (!_arrData.count) {
                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    
                    [self getDocumentListWithDict:self.dict];
                }];
                
            }
            if (arr.count<_pageSize) {
                self.collectionView.footer.hidden = YES;
            }else{
                self.collectionView.footer.hidden = NO;
            }

            
        }else{
            _pageIndex--;
            if (_arrData.count) {
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
            }else{
                [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                    [self showLoadingView];

                    [self getDocumentListWithDict:self.dict];
                }];
                
            }

        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        [self hideEmptyView];

        _pageIndex--;
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            
            [self getDocumentListWithDict:self.dict];
        }];
        

    }];
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/2-1, SCREEN_WIDTH/2-1);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        __weak typeof(self)  weakSelf = self;
        _collectionView.header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageIndex = 1;
            [weakSelf.dict setObject:@(weakSelf.pageIndex) forKey:@"stratnum"];
            [weakSelf getDocumentListWithDict:weakSelf.dict];
            
        }];
        _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageIndex ++;
            [weakSelf.dict setObject:@(weakSelf.pageIndex) forKey:@"stratnum"];
            [weakSelf getDocumentListWithDict:weakSelf.dict];
        }];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"EducationVidoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EducationVidoCollectionViewCell"];
        
    }
    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _arrData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EducationVidoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EducationVidoCollectionViewCell" forIndexPath:indexPath];
    DocumentInfo *info = _arrData[indexPath.row];
    info.video_image_url = [info.video_image_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];

    [cell.vidoImageView sd_imageDef21WithUrlStr:info.video_image_url];
    cell.nameLabel.text = info.data_title;
    cell.detailLabel.text = info.data_title1;
    
    if (info.is_charge) {
        cell.freeType.text = [NSString stringWithFormat:@"%@",@(info.money)];
    }else{
            cell.freeType.text = @"免费";
    }
    if (![ISVipManager isOpenVip]) {
        cell.freeType.hidden = YES;
    }

    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DocumentInfo *info = _arrData[indexPath.row];

    PlayViewController *vc = [[PlayViewController alloc]initWithDocumentID:info.data_id];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
}
- (NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

@end
