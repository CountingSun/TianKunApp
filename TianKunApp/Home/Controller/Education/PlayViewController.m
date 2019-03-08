//
//  PlayViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PlayViewController.h"
#import "AppDelegate.h"
#import "MyVIPViewController.h"
#import "DocumentInfo.h"
#import "PlayViewShareCollectionViewCell.h"
#import "PlayViewAuthorCollectionViewCell.h"
#import "PlayViewIntroctCollectionViewCell.h"
#import "EducationVidoCollectionViewCell.h"
#import "VipTimeCollectionReusableView.h"
#import "EductationNetworkEngine.h"
#import "SingleBuyDocumentView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"
#import "TKAudioContrilView.h"


@interface PlayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZFPlayerDelegate,TKAudioContrilViewDelegate>

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic ,assign) NSInteger documentID;
@property (nonatomic ,strong) DocumentInfo *documentInfo;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,assign) BOOL isShowAll;
@property (nonatomic ,strong) EductationNetworkEngine *eductationNetworkEngine;
@property (nonatomic ,strong) SingleBuyDocumentView *singleBuyDocumentView;
@property (nonatomic ,assign) BOOL allowRotation;
@property (nonatomic ,strong) UIView *playerFatherView;



/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic ,assign) NSInteger navCount;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (strong, nonatomic) ZFPlayerView *playerView;

@property (nonatomic ,assign) BOOL isFirst;

/**
 购买完成自动播放
 */
@property (nonatomic ,assign) BOOL autoPlay;
@property (nonatomic ,strong) TKAudioContrilView *audioContrilView;
@end


@implementation PlayViewController
- (instancetype)initWithDocumentID:(NSInteger)documentID{
    if (self = [super init]) {
        _documentID = documentID;
        
    }
    return self;
}
// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // 开始接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self resignFirstResponder];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    // 接触远程控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    

}
// 重写父类成为响应者方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//重写父类方法，接受外部事件的处理
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"remote");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) { // 得到事件类型
                
            case UIEventSubtypeRemoteControlTogglePlayPause: // 暂停 ios6
                [self.playerView pause]; // 调用你所在项目的暂停按钮的响应方法 下面的也是如此
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:  // 上一首
                [self.playerView seekWithTime:-15];
//                [self lastMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack: // 下一首
                [self.playerView seekWithTime:15];

//                [self nextMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlPlay: //播放
            {
                [self.playerView play];

            }
                break;
                
            case UIEventSubtypeRemoteControlPause: // 暂停 ios7
                [self.playerView pause];
                break;
                
            default:
                break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = YES;
    [self setupView];
    self.view.backgroundColor = [UIColor blackColor];
    ZFPlayerShared.isLandscape = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucceed) name:LOGIN_SUCCEED_NOTICE object:nil];
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    [self getData];
}
- (void)userLoginSucceed{
//    [self showLoadingView];
    [self showWithStatus:NET_WAIT_TOST];
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
            if (_documentInfo.type == 2) {
                self.view.backgroundColor = RGB(101, 139, 228, 1);

            }else{
                self.view.backgroundColor = [UIColor blackColor];
                
            }
            self.playerModel.title            = @"";
            self.playerModel.videoURL         = [NSURL URLWithString:_documentInfo.date_details_url];
            NSLog(@"%@",_documentInfo.date_details_url);
            // 设置网络封面图
            self.playerModel.placeholderImageURLString = [_documentInfo.video_image_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            // 从xx秒开始播放视频
            self.playerModel.seekTime         = 0;
            if (_isFirst) {
                
            }else{
                [_audioContrilView resetView];
                [self.playerView resetToPlayNewVideo:self.playerModel];
                _audioContrilView.documentInfo = _documentInfo;

            }

            if (_documentInfo.canSee == 1) {
                self.playerView.trySeeTime = 0;
            }else{
                self.playerView.trySeeTime = _documentInfo.try_and_see_time;
            }
            if (_autoPlay) {
                [self.playerView play];
            }

            if(_reloadBlock){
                _reloadBlock();
            }

            [self.collectionView reloadData];
        }else if(code == -1){

            [self showErrorWithStatus:NET_ERROR_TOST];

        }else{

            [self showErrorWithStatus:msg];
            
        }
        [self getRecommend];
        

    }];
    
    
}
- (void)getRecommend{
    if (!_eductationNetworkEngine) {
        _eductationNetworkEngine = [[EductationNetworkEngine alloc]init];
    }
    [_eductationNetworkEngine postWithPageIndex:_pageIndex pageSize:_pageSize dataType2:_documentInfo.data_type2 calssType:_documentInfo.type docID:_documentID returnBlock:^(NSInteger code,NSString *msg, NSMutableArray *arrData) {
        if (code == 1) {
            [self dismiss];
            if(!_arrData){
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
            }
            [_arrData addObjectsFromArray:arrData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];

            });
            
            
        }else if(code == -1){
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            [self showErrorWithStatus:msg];
        }
        
    }];
    
    
}

- (void)setupView{
    
     self.playerFatherView = [[UIView alloc] init];
    self.playerFatherView.backgroundColor = [UIColor blackColor];
     [self.view addSubview:self.playerFatherView];
     [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
         if (IS_IPHONE_X) {
             make.top.mas_equalTo(44);

         }else{
             make.top.mas_equalTo(20);

         }
     make.leading.trailing.mas_equalTo(0);
     // 这里宽高比16：9,可自定义宽高比
     make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
     }];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.playerFatherView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerFatherView).offset(5);
        make.top.equalTo(self.playerFatherView).offset(-2);
        make.width.height.offset(50);
    }];
    [backButton setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];

    [self collectionView];

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
            make.top.equalTo(self.playerFatherView.mas_bottom);
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
        return [PlayViewIntroctCollectionViewCell getCellHeightWithDetailString:_documentInfo.data_title1];
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
        cell.documentInfo = _documentInfo;

        [cell.collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }else if (indexPath.section == 1){
        PlayViewAuthorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayViewAuthorCollectionViewCell" forIndexPath:indexPath];
        cell.isShowAll = _isShowAll;
        cell.documentInfo = _documentInfo;
        
        __weak typeof(self) weakSelf = self;
        
        cell.reloadCellBlock = ^{
            weakSelf.isShowAll = YES;
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            
        };
        
        
        
        return cell;

    }else if (indexPath.section == 2){
        PlayViewIntroctCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayViewIntroctCollectionViewCell" forIndexPath:indexPath];
        cell.detailString = _documentInfo.data_title1;
        
        return cell;

    }else{
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
    
        _playerView.playerTryWatchFinishView.hidden = YES;
        [self showWithStatus:@"正在切换，请稍候"];
        DocumentInfo *info = _arrData[indexPath.row];
        _documentID = info.data_id;
        _isFirst = NO;
        [self getData];
        

        

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

- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}



- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        
        if (_documentInfo.type == 2) {
            _audioContrilView = [[TKAudioContrilView alloc] init];
            _audioContrilView.documentInfo = _documentInfo;
            _audioContrilView.audioContrilDelegate = self;
            
            [_playerView playerControlView:_audioContrilView playerModel:self.playerModel];

        }else{
            [_playerView playerControlView:nil playerModel:self.playerModel];

        }
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = NO;
        
        // 打开预览图
        _playerView.hasPreviewView = YES;
        
        
    }
    return _playerView;
}

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"";
        _playerModel.videoURL         = [NSURL URLWithString:_documentInfo.date_details_url];
        _playerModel.placeholderImage = [UIImage imageNamed:DEFAULT_IMAGE_21];
        _playerModel.placeholderImageURLString = [_documentInfo.video_image_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] ;
        _playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)trySeeViewReplyButtonClick{
    
}
- (void)trySeeViewVipButtonClic{
    if ([UserInfoEngine isLogin]) {
        MyVIPViewController *myVIPViewController = [[MyVIPViewController alloc]init];
        [self.navigationController pushViewController:myVIPViewController animated:YES];
    }

}
- (void)trySeeViewBuyButtonClick{
    if ([UserInfoEngine isLogin]) {
        if (!_singleBuyDocumentView) {
            _singleBuyDocumentView = [[SingleBuyDocumentView alloc]initWithNib];
            _singleBuyDocumentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            __weak typeof(self) weakSelf = self;
            _singleBuyDocumentView.pauSucceedBlock = ^{
                [weakSelf showLoadingView];
                [weakSelf getData];
                _autoPlay = YES;
            };
        }
        _singleBuyDocumentView.documentID = _documentInfo.data_id;
        [_singleBuyDocumentView showSingleBuyDocumentView];
    }

}

- (void)clickBackTimeButtonEvent{
    [self.playerView seekWithTime:-15];
    
}
- (void)clickForwardTimeButtonEvent{
    [self.playerView seekWithTime:15];

}


- (void)clickBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
