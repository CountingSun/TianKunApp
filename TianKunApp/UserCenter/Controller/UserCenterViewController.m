//
//  UserCenterViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterViewModel.h"
#import "MenuInfo.h"
#import "SetViewController.h"
#import "HistoryViewController.h"
#import "CollectionViewController.h"
#import "DetailRecordViewController.h"
#import "MyVIPViewController.h"
#import "MyPublickViewController.h"
#import "UserInfoViewController.h"
#import "UIView+AddTapGestureRecognizer.h"
#import "BuyRecoredViewController.h"

@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *vipButton;
@property (weak, nonatomic) IBOutlet QMUIButton *recordButton;
@property (weak, nonatomic) IBOutlet QMUIButton *pointButton;
@property (weak, nonatomic) IBOutlet QMUIButton *publicButton;
@property (weak, nonatomic) IBOutlet UIImageView *headBGimageView;

@property (weak, nonatomic) IBOutlet UIImageView *vipStateImageView;
@property (nonatomic ,strong) UserInfo *userInfo;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@end

@implementation UserCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self getUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getUserInfo];
    
}

- (void)getUserInfo{
    [[[NetWorkEngine alloc]init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"my/userdetail.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1 ){
            _userInfo = [UserInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"]];
            
            [UserInfoEngine setUserInfo:_userInfo];
            
            [_headImageView sd_imageWithUrlStr:[UserInfoEngine getUserInfo].headimg placeholderImage:@"头像"];
            _nameLabel.text = _userInfo.nickname;
            if (_userInfo.vip_status) {
                [_vipStateImageView setImage:[UIImage imageNamed:@"VIP_open"]];
            }else{
                [_vipStateImageView setImage:[UIImage imageNamed:@"VIP_close"]];
            }
        }else{
            
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}


- (void)setupUI{
    
    
    _arrMenu = [UserCenterViewModel arrMenu];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headView;
    _tableView.rowHeight = 45;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }

    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.qmui_width/2;
    [self.tableView reloadData];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView addTapGestureRecognizerWithActionBlock:^{
        UserInfoViewController *infoViewController = [[UserInfoViewController alloc]init];
        infoViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoViewController animated:YES];
    }];
    
    [_vipButton setImagePosition:QMUIButtonImagePositionTop];
    [_vipButton setSpacingBetweenImageAndTitle:5];
    
    [_recordButton setImagePosition:QMUIButtonImagePositionTop];
    [_recordButton setSpacingBetweenImageAndTitle:5];
    
    [_pointButton setImagePosition:QMUIButtonImagePositionTop];
    [_pointButton setSpacingBetweenImageAndTitle:5];
    
    [_publicButton setImagePosition:QMUIButtonImagePositionTop];
    [_publicButton setSpacingBetweenImageAndTitle:5];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = _arrMenu[indexPath.row];
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = 0;
        
        
        
    }
    cell.imageView.image = [UIImage imageNamed:menuInfo.menuIcon];
    cell.textLabel.text = menuInfo.menuName;

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = _arrMenu[indexPath.row];

    switch (menuInfo.menuID) {
        case 0:
            {
                
                CollectionViewController *viewController = [[CollectionViewController alloc]init];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];

            }
            break;
        case 1:{
            
            
            HistoryViewController *viewController = [[HistoryViewController alloc]init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];

        }
            break;
        case 2:{
            SetViewController *viewController = [[SetViewController alloc]init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
            break;
        case 3:{
            BuyRecoredViewController *viewController = [[BuyRecoredViewController alloc]init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];

            
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)vipButtobClick:(id)sender {
    MyVIPViewController *viewController = [[MyVIPViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];

}
- (IBAction)recordButtobClick:(id)sender {
    DetailRecordViewController *viewController = [[DetailRecordViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];

}
- (IBAction)pointButtonClick:(id)sender {
    
}
- (IBAction)publishButtonClick:(id)sender {
    
    
    MyPublickViewController *viewController = [[MyPublickViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    
    NSLog(@"Y:%@",@(y));
    if (y<0) {
//        [_headBGimageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_vipButton.mas_top);
//            make.centerX.equalTo(_headView);
//            make.height.offset(206-y);
//            make.width.offset(SCREEN_WIDTH);
//        }];
//        
//        [_headView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(206-y);
//            make.width.offset(SCREEN_WIDTH);
//        }];
        
    }else{
        
    }
    
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
