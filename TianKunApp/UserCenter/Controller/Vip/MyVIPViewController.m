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
#import "MyVipCertificateCollectionViewCell.h"
#import "CertificateInfo.h"
#import "MyVipCertificateTableViewCell.h"
#import "MyVipCertificateListViewController.h"
#import "RongCloudConfigure.h"
//融云
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RCIM.h>
#import "IconBadgeManager.h"

@interface MyVIPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
///立即开通按钮
@property (weak, nonatomic) IBOutlet QMUIButton *dredgeButton;
@property (nonatomic ,assign) BOOL isVIP;
@property (nonatomic ,strong) VipInfo *vipInfo;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UIView *collectionHeadView;
@property (nonatomic ,strong) CertificateInfo *personCertificateInfo;
@property (nonatomic ,strong) CertificateInfo *companyCertificateInfo;
@property (nonatomic ,strong) UIView *footView;

@property (weak, nonatomic) IBOutlet UILabel *alearnLabel;
@property (weak, nonatomic) IBOutlet UIButton *renewalButton;

@end

@implementation MyVIPViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.titleView.tintColor = [UIColor whiteColor];

    [self getIsVip];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.titleView.tintColor = [UIColor blackColor];

    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的会员";
    _renewalButton.hidden = YES;
    [IconBadgeManager deleteVIPMessage];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _nameLabel.text = [UserInfoEngine getUserInfo].nickname;
    [self setupCollectonView];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"返回_白色" highImage:@"返回_白色"];

    [self showLoadingView];
    [self getIsVip];


}
- (void)getIsVip{
//    [self showWithStatus:NET_WAIT_TOST];
    
    [[[NetWorkEngine alloc]init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"payment/userdetail.action") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];
        if (code == 1) {
            
            _vipInfo = [[VipInfo alloc]init];
            
            _vipInfo.vip_endtime = [[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"vip_endtime"];
            _vipInfo.vip_status = [[[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"vip_status"] integerValue];

            if (_vipInfo.vip_status == 1) {
                _timeLabel.text = [NSString stringWithFormat:@"至%@",[NSString timeReturnDateString:_vipInfo.vip_endtime formatter:@"yyyy/MM/dd"]];
                self.tableView.tableFooterView = [UIView new];
                [self getCerficateWithType:1];
                [self getCerficateWithType:2];


            }else{
                _arrMenu = [UserCenterViewModel arrVipMenu];
                _timeLabel.text = @"";
                self.tableView.tableFooterView = self.footView;

                
            }
            NSInteger btn_status = [[[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"btn_status"] integerValue];
            if (btn_status == 1) {
                _renewalButton.hidden = NO;

            }else{
                _renewalButton.hidden = YES;
            }
            [self setupUI];
            
            [self.tableView reloadData];

            
            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getIsVip];

            }];
            self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"返回" highImage:@"返回"];

        }
    } errorBlock:^(NSError *error) {
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getIsVip];
        }];
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"返回" highImage:@"返回"];

        
    }];
    
}
- (void)getCerficateWithType:(NSInteger)type{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    //data_type 1:个人证书; 2:企业证书
    [dict setObject:@(type) forKey:@"data_type"];
    [dict setObject:@(1) forKey:@"pageNo"];
    [dict setObject:@(1) forKey:@"pageSize"];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];

    [[[NetWorkEngine alloc]init] postWithDict:dict url:BaseUrl(@"find.vipUpDataList.by.vip.userid") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            if (arr.count) {
                for (NSDictionary *dict in arr) {
                    if (type == 1) {
                        _personCertificateInfo = [CertificateInfo mj_objectWithKeyValues:dict];
                        
                    }else{
                        _companyCertificateInfo = [CertificateInfo mj_objectWithKeyValues:dict];

                    }
                }
            }
            [self.tableView reloadData];
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
    _backImageView.layer.masksToBounds = YES;
    CGFloat h = NavBarHeight;
    if (_vipInfo.vip_status == 1) {
        [_dredgeButton setTitle:@"上传资料" forState:0];
        [_dredgeButton setImagePosition:QMUIButtonImagePositionLeft];
        [_dredgeButton setImage:[UIImage imageNamed:@"上传"] forState:0];
        [_dredgeButton setSpacingBetweenImageAndTitle:5];
        _alearnLabel.text = @"我的证书";
    }else{
        [_dredgeButton setTitle:@"立即开通" forState:0];
        [_dredgeButton setImage:[UIImage imageNamed:@""] forState:0];
        _alearnLabel.text = @"VIP特权";

    }
    
    _tableView.frame = CGRectMake(0, -h, SCREEN_WIDTH, SCREEN_HEIGHT+h);
    
}
- (void)setupCollectonView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _collectionHeadView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyVipCertificateTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyVipCertificateTableViewCell"];

    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
    _tableView.backgroundColor = COLOR_VIEW_BACK;


}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_vipInfo.vip_status == 1) {
        NSInteger i = 0;
        
        if (_personCertificateInfo) {
            i++;
        }
        if (_companyCertificateInfo) {
            i++;
        }
        return i;
    }else{
        return 1;
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_vipInfo.vip_status == 1) {
        return 1;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_vipInfo.vip_status == 1) {
        
        return UITableViewAutomaticDimension;
    }else{
        return CGFLOAT_MIN;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_vipInfo.vip_status == 1) {
        MyVipCertificateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyVipCertificateTableViewCell" forIndexPath:indexPath];
        cell.block = ^{
            if (indexPath.section == 0) {
                if (_personCertificateInfo) {
                    MyVipCertificateListViewController *vc = [[MyVipCertificateListViewController alloc] initWithType:1];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];

                }else{
                    MyVipCertificateListViewController *vc = [[MyVipCertificateListViewController alloc] initWithType:2];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];

                }
                
            }else{
                MyVipCertificateListViewController *vc = [[MyVipCertificateListViewController alloc] initWithType:2];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

            }
        };
        
        if (indexPath.section == 0) {
            if (_personCertificateInfo) {
                cell.typeNameLabel.text = @"个人证书";
                
                cell.companyNameLabel.text = @"企业名称：";
                cell.companyDetailLabel.text = _personCertificateInfo.company_name;
                
                cell.certificateTypeNameLabel.text = @"类型专业：";
                NSString *type = _personCertificateInfo.certificate_type_names.count?_personCertificateInfo.certificate_type_names[0]:@"";
                
                cell.certificateTypeDetailLabel.text = [NSString stringWithFormat:@"%@-%@",_personCertificateInfo.certificate_name,type];
                
                cell.timeLabel.text = @"证书姓名：";
                cell.timeDetailLabel.text = _personCertificateInfo.name;
                
            }else{
                cell.typeNameLabel.text = @"企业证书";
                
                cell.companyNameLabel.text = @"企业名称：";
                cell.companyDetailLabel.text = _companyCertificateInfo.company_name;
                
                cell.certificateTypeNameLabel.text = @"证书类型：";
                cell.certificateTypeDetailLabel.text = _companyCertificateInfo.certificate_name;
                
                cell.timeLabel.text = @"发证日期：";
                cell.timeDetailLabel.text = [NSString timeReturnDateString:_companyCertificateInfo.opening_date formatter:@"yyyy-MM-dd"];

            }


        }else{
            cell.typeNameLabel.text = @"企业证书";
            
            cell.companyNameLabel.text = @"企业名称：";
            cell.companyDetailLabel.text = _companyCertificateInfo.company_name;
            
            cell.certificateTypeNameLabel.text = @"证书类型：";
            cell.certificateTypeDetailLabel.text = _companyCertificateInfo.certificate_name;
            
            cell.timeLabel.text = @"发证日期：";
            cell.timeDetailLabel.text = [NSString timeReturnDateString:_companyCertificateInfo.opening_date formatter:@"yyyy-MM-dd"];

        }
        return cell;
    }else{
        return [UITableViewCell new];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (IBAction)dredgeButtonClick:(id)sender {
    if (_vipInfo.vip_status == 1) {
        [self.navigationController pushViewController:[VIPUploadInfoViewController new] animated:YES];
    }else{
        [self.navigationController pushViewController:[DredgeViewController new] animated:YES];
        
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_personCertificateInfo) {
            MyVipCertificateListViewController *vc = [[MyVipCertificateListViewController alloc] initWithType:1];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            MyVipCertificateListViewController *vc = [[MyVipCertificateListViewController alloc] initWithType:2];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else{
        MyVipCertificateListViewController *vc = [[MyVipCertificateListViewController alloc] initWithType:2];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}
- (UIView *)footView{
    if (!_footView) {
        CGFloat itemW = SCREEN_WIDTH/4;
        
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4*3+10)];
        _footView.backgroundColor = [UIColor whiteColor];
        for (NSInteger i = 0; i<_arrMenu.count; i++) {
            MenuInfo *info = _arrMenu[i];
            
            NSInteger x = i%4;
            NSInteger y = i/4;
            
            UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(x*itemW, y*itemW, itemW, itemW)];
            [_footView addSubview:baseView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemW/3, itemW/3, itemW/3, itemW/3)];
            [imageView setImage:[UIImage imageNamed:info.menuIcon]];
            [baseView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), itemW, itemW/3)];
            label.textColor = COLOR_TEXT_BLACK;
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = info.menuName;
            
            [baseView addSubview:label];
            
            
            
        }
    }
    return _footView;
}
- (IBAction)renewalButtonClick:(id)sender {
    [self.navigationController pushViewController:[DredgeViewController new] animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
