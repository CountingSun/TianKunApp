//
//  VIPUploadInfoViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "VIPUploadInfoViewController.h"
#import "SVProgressHUD.h"
#import "FileInfo.h"
#import "VipFileUpLoadCollectionViewCell.h"
#import "VipTimeCollectionReusableView.h"
#import "QDMultipleImagePickerPreviewViewController.h"

#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048
static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeAll;

@interface VipViewModel ()
@property (nonatomic, copy) NSString *time;
@property (nonatomic ,strong) NSMutableArray *arrInfo;
@end

@implementation VipViewModel
@end

@interface VIPUploadInfoViewController ()<QDMultipleImagePickerPreviewViewControllerDelegate,QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSMutableArray *selectImages;
@property (nonatomic, strong) NSMutableArray *arrImageFilePath;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,strong) NSMutableDictionary *resultDict;
@property (nonatomic ,strong) QMUIImagePickerViewController *imagePickerViewController;

@end

@implementation VIPUploadInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"上传资料"];
    _resultDict = [NSMutableDictionary dictionary];
    _pageIndex = 1;
    _pageSize = 30;
    
    [self setupCollectionView];
    
    [self showLoadingView];

    [self getData];
}
#pragma mark- net work
- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }

    [[[NetWorkEngine alloc]init] postWithDict:@{@"user_id":[UserInfoEngine getUserInfo].userID,@"status":@"0",@"pageSize":@(_pageSize),@"pageNo":@(_pageIndex)} url:BaseUrl(@"find.vipUpDataList.by.vipUpData") succed:^(id responseObject) {
        [self hideLoadingView];
        [self endRefesh];
        

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            if (arr.count) {
                [_arrData removeAllObjects];
                if (_pageIndex == 1) {
                    [_resultDict removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    FileInfo *info = [FileInfo mj_objectWithKeyValues:dict];
                    [self dealDataWithFileInfo:info];
                }
                [self dealDict];

                if (arr.count<_pageSize) {
                    self.collectionView.footer.hidden = YES;
                }else{
                    self.collectionView.footer.hidden = NO;
                }
            }else{
                if (!_arrData.count) {
                    
                    
                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
            }
            
        }else{
            if (!_arrData.count) {
                
                
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
                [self getData];
            }];
            
        }
        
    }];
    
}

- (void)upLoadImage{
    
    [self showWithStatus:@"图片上传中"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [[[NetWorkEngine alloc] init] uploadImagesWithArrImageData:_arrImageFilePath url:BaseUrl(@"web/CompanyController/create.vipMaterial") dict:@{@"user_id":[UserInfoEngine getUserInfo].userID} name:@"pictureFile" fileName:@"" succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"上传成功"];
            [_selectImages removeAllObjects];
            [_arrImageFilePath removeAllObjects];
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
        _pageIndex = 1;
        [self getData];
        
    } progressBlock:^(CGFloat progress) {
        
        [SVProgressHUD showProgress:progress];
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
    
}

#pragma mark- view

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-20-15)/4, (SCREEN_WIDTH-20-15)/4);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 当前组如果还在可视范围时让头部视图停留
        if (@available(iOS 9.0, *)) {
            self.flowLayout.sectionHeadersPinToVisibleBounds = YES;
        } else {
            // Fallback on earlier versions
        }
        self.flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);

    }
    return _flowLayout;
}

- (void)setupCollectionView{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = self.flowLayout;
    [_collectionView registerNib:[UINib nibWithNibName:@"VipFileUpLoadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VipFileUpLoadCollectionViewCell"];

    [_collectionView registerNib:[UINib nibWithNibName:@"VipTimeCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VipTimeCollectionReusableView"];
    __weak typeof(self) weakSelf = self;
    
    _collectionView .header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf getData];

    }];
    _collectionView .footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf getData];
        
    }];

}
#pragma mark- collectionView delegate data&source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    VipViewModel *model = _arrData[section];
    
    return model.arrInfo.count;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _arrData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VipViewModel *model = _arrData[indexPath.section];

    VipFileUpLoadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VipFileUpLoadCollectionViewCell" forIndexPath:indexPath];
    FileInfo *info = model.arrInfo[indexPath.row];
    [cell.imageView sd_imageDef11WithUrlStr:info.certificate_url];
    
    
    return cell;

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        VipViewModel *model = _arrData[indexPath.section];
        
        VipTimeCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VipTimeCollectionReusableView" forIndexPath:indexPath];
        headerView.timeLabel.text = model.time;
        
        return headerView;

    }else{
        return nil;
    }
}

#pragma mark- QMUIImagePicker
- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = MaxSelectedImageCount;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    return imagePickerViewController;
}
- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];

    if (!_arrImageFilePath) {
        _arrImageFilePath = [NSMutableArray array];

    }
    [imagesAssetArray enumerateObjectsUsingBlock:^(QMUIAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = obj.previewImage;
        NSData *data =  UIImageJPEGRepresentation(image, 0.5);
        [_arrImageFilePath addObject:data];
        
    }];

    _selectImages = imagesAssetArray;
    [self upLoadImage];
    
}
#pragma mark - <QDMultipleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QDMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    
    if (!_arrImageFilePath) {
        _arrImageFilePath = [NSMutableArray array];
        
    }
    [imagesAssetArray enumerateObjectsUsingBlock:^(QMUIAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = obj.previewImage;
        NSData *data =  UIImageJPEGRepresentation(image, 0.5);
        [_arrImageFilePath addObject:data];
        
    }];
    
    _selectImages = imagesAssetArray;
    [self upLoadImage];
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController{
    QDMultipleImagePickerPreviewViewController *imagePickerPreviewViewController = [[QDMultipleImagePickerPreviewViewController alloc] init];
    imagePickerPreviewViewController.delegate = self;
    imagePickerPreviewViewController.maximumSelectImageCount = MaxSelectedImageCount;
    imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
    imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
    return imagePickerPreviewViewController;

}


#pragma mark - upLoadButtonClick

- (IBAction)upLoadButtonClick:(id)sender {

    QMUIAlbumViewController *VC = [[QMUIAlbumViewController alloc]init];
    QMUINavigationController *nav = [[QMUINavigationController alloc]initWithRootViewController:VC];
    VC.albumViewControllerDelegate = self;
    nav.navigationBar.tintColor = COLOR_TEXT_GENGRAL;

    [self presentViewController:nav animated:YES completion:nil];
}
- (void)authorizationPresentAlbumViewControllerWithTitle:(NSString *)title {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewControllerWithTitle:title];
            });
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:title];
    }
}
- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeAll;
    albumViewController.title = title;
    albumViewController.view.tag = MultipleImagePickingTag;
    
    QMUINavigationController *navigationController = [[QMUINavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}


- (void)dealDataWithFileInfo:(FileInfo *)fileInfo{
    
    NSString *key = [NSString timeReturnDateString:fileInfo.create_date formatter:@"yyyy-MM-dd"];
    if ([_resultDict objectForKey:key]) {
        NSMutableArray *arr = [_resultDict objectForKey:key];
        [arr addObject:fileInfo];
        [_resultDict setObject:arr forKeyedSubscript:key];
        
    }else{
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:fileInfo];
        [_resultDict setObject:arr forKeyedSubscript:key];
        
    }
    
    
}
- (void)dealDict{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
    }
    
    [_resultDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        VipViewModel *vipViewModel = [[VipViewModel alloc]init];
        vipViewModel.time = key;
        vipViewModel.arrInfo = obj;
        [_arrData addObject:vipViewModel];
        
    }];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    [_arrData sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    
    [self.collectionView reloadData];
    
    
    
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
    // Dispose of any resources that can be recreated.
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
