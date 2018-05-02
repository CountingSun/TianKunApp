//
//  MyVIPViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyVIPViewController.h"
#import "VipItemCollectionViewCell.h"
#import "MenuInfo.h"
#import "UserCenterViewModel.h"
#import "UIBarButtonItem+Extension.h"
#import "DredgeViewController.h"
#import "VIPUploadInfoViewController.h"
#import "VipInfo.h"

@interface MyVIPViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
///发布按钮
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
///立即开通按钮
@property (weak, nonatomic) IBOutlet UIButton *dredgeButton;
@property (nonatomic ,assign) BOOL isVIP;
@property (nonatomic ,strong) VipInfo *vipInfo;

@end

@implementation MyVIPViewController
- (void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self getIsVip];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrMenu = [UserCenterViewModel arrVipMenu];
    self.title = @"我的会员";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    

    [self setupUI];
    [self getIsVip];
    _nameLabel.text = [UserInfoEngine getUserInfo].nickname;
    
    [self setupCollectonView];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"返回_白色" highImage:@"返回_白色"];

}
- (void)getIsVip{
//    [self showWithStatus:NET_WAIT_TOST];
    
    [[[NetWorkEngine alloc]init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"payment/userdetail.action") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            
            _vipInfo = [[VipInfo alloc]init];
            
            _vipInfo.vip_endtime = [[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"vip_endtime"];
            _vipInfo.vip_status = [[[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"vip_status"] integerValue];

            if (_vipInfo.vip_status) {
                _timeLabel.text = [NSString stringWithFormat:@"至%@",[NSString timeReturnDateString:_vipInfo.vip_endtime formatter:@"yyyy/MM/dd"]];

            }else{
                _timeLabel.text = @"";

            }
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}

- (void)setupUI{
    
    _freeLabel.textColor = COLOR_THEME;
    _freeLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:16];
    _dredgeButton.layer.masksToBounds = YES;
    _dredgeButton.layer.cornerRadius = _dredgeButton.qmui_height/2;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.qmui_width/2;
    [_headImageView sd_imageWithUrlStr:[UserInfoEngine getUserInfo].headimg placeholderImage:@"头像"];
    
}
- (void)setupCollectonView{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.userInteractionEnabled = NO;
    _collectionView.collectionViewLayout = self.flowLayout;
    [_collectionView registerNib:[UINib nibWithNibName:@"VipItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VipItemCollectionViewCell"];

}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrMenu.count;
    
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VipItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VipItemCollectionViewCell" forIndexPath:indexPath];
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];
    [cell.button setImage:[UIImage imageNamed:menuInfo.menuIcon] forState:0];
    [cell.button setTitle:menuInfo.menuName forState:0];
    return cell;
    
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/4 ,80);
        
    }
    return _flowLayout;
}
- (IBAction)dredgeButtonClick:(id)sender {
    [self.navigationController pushViewController:[DredgeViewController new] animated:YES];
}
- (IBAction)publicButtonClick:(id)sender {
    [self.navigationController pushViewController:[VIPUploadInfoViewController new] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
