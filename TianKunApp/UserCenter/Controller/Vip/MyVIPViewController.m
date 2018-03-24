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

@end

@implementation MyVIPViewController
- (void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrMenu = [UserCenterViewModel arrVipMenu];
    [self.titleView setTitle:@"我的会员"];
    self.title = @"我的会员";
    [self setupUI];
    
    [self setupCollectonView];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"返回_白色" highImage:@"返回_白色"];

}
- (void)setupUI{
    
    _freeLabel.textColor = COLOR_THEME;
    _freeLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:16];
    _dredgeButton.layer.masksToBounds = YES;
    _dredgeButton.layer.cornerRadius = _dredgeButton.qmui_height/2;

    
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
