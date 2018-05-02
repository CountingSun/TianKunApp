//
//  PlayViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PlayViewController.h"
#import "SBPlayer.h"
#import "AppDelegate.h"
#import "MyVIPViewController.h"
#import "DocumentInfo.h"
#import "PlayViewShareCollectionViewCell.h"
#import "PlayViewAuthorCollectionViewCell.h"
#import "PlayViewIntroctCollectionViewCell.h"
#import "EducationVidoCollectionViewCell.h"
#import "VipTimeCollectionReusableView.h"
#import "EductationNetworkEngine.h"

@interface PlayViewController ()<SBPlayerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) SBPlayer *player;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic ,assign) NSInteger documentID;
@property (nonatomic ,strong) DocumentInfo *documentInfo;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,assign) BOOL isShowAll;
@property (nonatomic ,strong) EductationNetworkEngine *eductationNetworkEngine;

@end


@implementation PlayViewController
- (instancetype)initWithDocumentID:(NSInteger)documentID{
    if (self = [super init]) {
        _documentID = documentID;
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate sharedAppDelegate].allowRotation = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppDelegate sharedAppDelegate].allowRotation = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingView];


    [self getData];
}
- (void)getData{
    if (!_eductationNetworkEngine) {
        _eductationNetworkEngine = [[EductationNetworkEngine alloc]init];
    }
    [_eductationNetworkEngine getEductationInfoWithDocumentID:_documentID returnBlock:^(NSInteger code, NSString *msg, DocumentInfo *documentInfo) {
        [self hideLoadingView];
        if (code == 1) {
            _documentInfo = documentInfo;
            if (_documentInfo.date_details_url.length) {
                [self setVieo];
            }
            [self getRecommend];

            [self.collectionView reloadData];
        }else if(code == -1){
            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];

        }else{
            [self showGetDataErrorWithMessage:msg reloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];
        }
    }];
    
    
}
- (void)getRecommend{
    if (!_eductationNetworkEngine) {
        _eductationNetworkEngine = [[EductationNetworkEngine alloc]init];
    }
    [_eductationNetworkEngine postWithPageIndex:_pageIndex pageSize:_pageSize dataType2:_documentInfo.data_type2 calssType:_documentInfo.type returnBlock:^(NSInteger code,NSString *msg, NSMutableArray *arrData) {
        if (code == 1) {
            if(!_arrData){
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
            }
            [_arrData addObjectsFromArray:arrData];
            [self.collectionView reloadData];
            
        }else if(code == -1){
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            [self showErrorWithStatus:msg];
        }
        
    }];
    
    
}

- (void)clickBakcButton{
    if (_player.isFullScreen) {
        [_player outFullScreen];
    }else{
        [self.player stop];

        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (void)buyVipButtonClick:(QMUIButton *)button{
    if ([self.player isFullScreen]) {
        [self.player outFullScreen];
    }
    MyVIPViewController *myVIPViewController = [[MyVIPViewController alloc]init];
    [self.navigationController pushViewController:myVIPViewController animated:YES];
    
}
- (void)setVieo{
    [self.player setTitle:_documentInfo.data_title];
    self.player.tryWatchTime = _documentInfo.try_and_see_time;
    NSString * imageUrlStr = [_documentInfo.video_image_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];

    [self.player.playerStateView showBaceViewWithImageUrlStr:imageUrlStr];
    
    
}
- (SBPlayer *)player{
    if (!_player) {
        //纯代码请用此种方法
        _player = [[SBPlayer alloc]init];
        _player.delegate = self;
        //设置标题
        //设置播放器背景颜色
        _player.backgroundColor = [UIColor blackColor];
        //设置播放器填充模式 默认SBLayerVideoGravityResizeAspectFill，可以不添加此语句
        _player.mode = SBLayerVideoGravityResizeAspect;
        //添加播放器到视图
        [self.view addSubview:_player];
        _player.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9);
        //    [self.player play];

    }
    return _player;
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.player.mas_bottom);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"PlayViewShareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlayViewShareCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"PlayViewAuthorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlayViewAuthorCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"PlayViewIntroctCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlayViewIntroctCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"EducationVidoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EducationVidoCollectionViewCell"];
       
        
        [_collectionView registerNib:[UINib nibWithNibName:@"VipTimeCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VipTimeCollectionReusableView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];

        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];


        _collectionView.backgroundColor = COLOR_VIEW_BACK;
    }
    return _collectionView;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (section == 3) {
        return _arrData.count;
        
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [PlayViewShareCollectionViewCell getCellHeightWithDocumentInfo:_documentInfo];
        
        
    }else if (indexPath.section == 1){
        return [PlayViewAuthorCollectionViewCell getCellHeightWithDocumentInfo:_documentInfo isShowAll:_isShowAll];
        
    }else if (indexPath.section == 2){
        return [PlayViewIntroctCollectionViewCell getCellHeightWithDetailString:_documentInfo.synopsis];
    }else{
        return CGSizeMake(SCREEN_WIDTH/2-1, SCREEN_WIDTH/2-1);
        
    }
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else if (section == 3){
        return 10;
    }
    return CGFLOAT_MIN;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
    return CGSizeMake(SCREEN_WIDTH, CGFLOAT_MIN);

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 10);
    }else if (section == 2){
        return CGSizeMake(SCREEN_WIDTH, 10);
    }else{
        return CGSizeMake(SCREEN_WIDTH, CGFLOAT_MIN);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        PlayViewShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayViewShareCollectionViewCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = _documentInfo.data_title;
        cell.timeLabel.text = [NSString timeReturnDateString:_documentInfo.create_date formatter:@"MM月dd日"];
        cell.publicLabel.text = [NSString stringWithFormat:@"发布者：%@",_documentInfo.previous_format];
        if (_documentInfo.collectID) {
            cell.collectButton.selected = YES;
            
        }else{
            cell.collectButton.selected = NO;
        }
        [cell.collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }else if (indexPath.section == 1){
        PlayViewAuthorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayViewAuthorCollectionViewCell" forIndexPath:indexPath];
        cell.isShowAll = _isShowAll;
        cell.documentInfo = _documentInfo;
        cell.reloadCellBlock = ^{
            _isShowAll = YES;
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            
        };
        
        
        
        return cell;

    }else if (indexPath.section == 2){
        PlayViewIntroctCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayViewIntroctCollectionViewCell" forIndexPath:indexPath];
        cell.detailString = _documentInfo.synopsis;
        
        return cell;

    }else{
        EducationVidoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EducationVidoCollectionViewCell" forIndexPath:indexPath];
        DocumentInfo *info = _arrData[indexPath.row];
        info.video_image_url = [info.video_image_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        
        [cell.vidoImageView sd_imageDef21WithUrlStr:info.video_image_url];
        cell.nameLabel.text = info.data_title;
        cell.detailLabel.text = info.synopsis;
        
        if (info.is_charge) {
            cell.freeType.text = [NSString stringWithFormat:@"%@",@(info.money)];
        }else{
            cell.freeType.text = @"免费";
        }
        
        return cell;

    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 3) {
            VipTimeCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VipTimeCollectionReusableView" forIndexPath:indexPath];
            headerView.timeLabel.text = @"热门推荐";
            headerView.backgroundColor = [UIColor whiteColor];
            return headerView;

        }
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
        view.backgroundColor = COLOR_VIEW_BACK;
        
        return view;

    }else{
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
        view.backgroundColor = COLOR_VIEW_BACK;
        
        return view;
    }
}

- (void)collectButtonClick:(QMUIButton *)button{
    if (![UserInfoEngine isLogin]) {
        return;
    }
    button.enabled = NO;
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:@(_documentInfo.data_id) forKey:@"learning_notice_id"];
    if (button.selected) {
        [dict setObject:@(2) forKey:@"type"];
        [dict setObject:@(_documentInfo.collectID) forKey:@"id"];
        
    }else{
        [dict setObject:@(1) forKey:@"type"];
    }
    
    
    [self showWithStatus:NET_WAIT_TOST];
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"Learning/insertforumcollectible.action") succed:^(id responseObject) {
        button.enabled = YES;
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            button.selected = ! button.selected;
            
            if (button.selected) {
                [self showSuccessWithStatus:@"收藏成功"];
                _documentInfo.collectID = [[responseObject objectForKey:@"value"] integerValue];

            }else{
                [self showSuccessWithStatus:@"取消收藏成功"];
                
            }
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
        
    } errorBlock:^(NSError *error) {
        button.enabled = YES;
        
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
/**
 购买视频
 
 @param button <#button description#>
 */
- (void)buyButtonClick:(QMUIButton *)button{
    
}

 -(void)clickStateViewPlayButton{
     NSString *urlstr = _documentInfo.date_details_url;
     urlstr = [urlstr stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
     NSURL*url=[NSURL URLWithString:urlstr];
     [self.player assetWithURL:url];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
