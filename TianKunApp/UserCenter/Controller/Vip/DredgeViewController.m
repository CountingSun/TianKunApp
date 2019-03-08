//
//  DredgeViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "DredgeViewController.h"
#import "NSString+WQString.h"
#import "DredgeTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "VipInfo.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "IconBadgeManager.h"

@interface DredgeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *hierLabel;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (nonatomic, copy) NSString *orderStr;
@property (nonatomic ,strong) VipInfo *vipInfo;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (nonatomic ,strong) NSMutableDictionary *dict;

/**
 1 支付宝
 2 微信
 */
@property (nonatomic ,assign) NSInteger payType;
;

@end

@implementation DredgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"充值VIP"];
    _payType = 1;
    [self getIsVip];
    [self setupUI];

    [AppDelegate sharedAppDelegate].aliPayFinishBlock = ^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        
        NSString * memo = resultDic[@"memo"];
        
        NSLog(@"===memo:%@", memo);
        
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            
            
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:PAY_SUCCEED_NOTICE object:nil userInfo:@{@"key":@"支付宝支付开通vip"}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];

            [self showSuccessWithStatus:@"支付成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });

            
            
        }else{
            
            [self showErrorWithStatus:memo];
            
        }

    };
    
    
}
- (void)getOrder{
    [self showWithStatus:@"正在生成订单信息，请稍候"];
    [[[NetWorkEngine alloc]init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname,@"total_amount":@(_vipInfo.total_amount),@"body":@"购买会员",@"subject":@"VIP会员"} url:BaseUrl(@"payment/initalipayclient.action") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        
        if (code == 1) {
            [self dismiss];
            _orderStr = [[responseObject objectForKey:@"value"] objectForKey:@"orderinfo"];
            [self aliPay];

        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
}
- (void)getWxOrder{
    [self showWithStatus:@"正在生成订单信息，请稍候"];
    [[[NetWorkEngine alloc]init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"wx/wxpay.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self dismiss];

            _dict = [[responseObject objectForKey:@"value"] objectForKey:@"ordermessage"];
            [self wxPay];
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
    
}
- (void)getIsVip{
        [self showWithStatus:NET_WAIT_TOST];
    
    [[[NetWorkEngine alloc]init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"payment/userdetail.action") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self dismiss];
            
            _vipInfo = [VipInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            
            _vipInfo.vip_endtime = [[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"vip_endtime"];
            _vipInfo.vip_status = [[[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"] objectForKey:@"vip_status"] integerValue];
            [self setView];
            NSSet *set;
            
            if (_vipInfo.vip_status == 1) {
                set = [NSSet setWithObjects:@"VIP", nil];
            }else{
                set = [NSSet setWithObjects:@"ID", nil];
            }
            [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                
            } seq:1];
            [JPUSHService setAlias:[UserInfoEngine getUserInfo].userID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:1];
            

            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (void)setView{
    if (_vipInfo.vip_status) {
        _timeLabel.text = [NSString stringWithFormat:@"(有效期至%@)",[NSString timeReturnDateString:_vipInfo.vip_endtime formatter:@"yyyy-MM-dd"]];
        
    }else{
        _timeLabel.text = @"";
        
    }
    _hierLabel.text = _vipInfo.vip_type;
    
    _monthLabel.text = _vipInfo.vip_date;
    
    _moneyLabel.text = [NSString stringWithFormat:@"%@",@(_vipInfo.total_amount)];

}
- (void)setupUI{
    _vipLabel.textColor = COLOR_THEME;
    
    
    _tableView.tableHeaderView = self.headView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _footView;
    [_tableView registerNib:[UINib nibWithNibName:@"DredgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"DredgeTableViewCell"];
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

    _nameLabel.text = [UserInfoEngine getUserInfo].nickname;

    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.qmui_width/2;
    [_headImageView sd_imageWithUrlStr:[UserInfoEngine getUserInfo].headimg placeholderImage:@"头像"];

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DredgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DredgeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"pay_支付宝"];
        cell.label.text = @"支付宝";
        cell.iamgeView.image = [UIImage imageNamed:@"选中"];


    }else{
        cell.iconImageView.image = [UIImage imageNamed:@"pay_微信"];
        cell.label.text = @"微信";
        
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DredgeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.iamgeView.image = [UIImage imageNamed:@"选中"];
    if (indexPath.row == 0) {
        _payType = 1;
    }else{
        _payType = 2;
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    DredgeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.iamgeView.image = [UIImage imageNamed:@"未选中"];

}
- (IBAction)buttonClick:(id)sender {
    if (_payType == 1) {
        [self getOrder];
    }else{
        [self getWxOrder];
    }

    
}
// NOTE: 调用支付结果开始支付

- (void)aliPay{
    NSString *appScheme = ALIPAY_SCHEMES;
    
    
    // NOTE: 调用支付结果开始支付
    
    [[AlipaySDK defaultService] payOrder:_orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSLog(@"reslut = %@",resultDic);
        
        NSString * memo = resultDic[@"memo"];
        
        NSLog(@"===memo:%@", memo);
        
        if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {
            
            
            
            [self showSuccessWithStatus:@"支付成功"];
            self.view.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];

            });
            
//            [self getIsVip];

            
        }else{
            
            [self showErrorWithStatus:memo];
            
        }
        
        
        
    }];
    

}
- (void)wxPay{
    if (![WXApi isWXAppInstalled]){
        [self showErrorWithStatus:@"请先安装微信"];
        
        self.view.userInteractionEnabled = YES;
        
    }else if(![WXApi isWXAppSupportApi]){
        [self showErrorWithStatus:@"请更新微信版本"];
        self.view.userInteractionEnabled = YES;
        
    }else{
        //调起微信支付
        NSMutableString *stamp  = [_dict objectForKey:@"timestamp"];

        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [_dict objectForKey:@"partnerid"];
        req.prepayId            = [_dict objectForKey:@"prepayid"];
        req.nonceStr           = [_dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package = [_dict objectForKey:@"package"];
        req.sign                = [_dict objectForKey:@"sign"];
        [WXApi sendReq:req];


        [AppDelegate sharedAppDelegate].wexinPayFinishBlock  = ^(NSInteger errorCode,NSString *message) {
            
            switch (errorCode) {
                case 0:
                {
                    [self showSuccessWithStatus:@"支付结果：成功！"];
                    
                    //创建一个消息对象
                    NSNotification * notice = [NSNotification notificationWithName:PAY_SUCCEED_NOTICE object:nil userInfo:@{@"key":@"微信支付开通vip"}];
                    //发送消息
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];

                    });


                }
                    break;
                case -1:
                {
                    [self showErrorWithStatus:@"支付结果：失败！"];

                }
                    break;
                case -2:{
                    [self showErrorWithStatus:@"用户已经退出支付！"];
                }
                    break;
                    
                default:{
                    [self showErrorWithStatus:message];

                }
                    break;
            }
        };
        

    }


}
- (void)setMessageID:(NSInteger)messageID{
    if ([IconBadgeManager isContainsSystemMessageID:[NSString stringWithFormat:@"%@",@(messageID)]]) {
        [IconBadgeManager deleteSystemMessageWithMessageID:[NSString stringWithFormat:@"%@",@(messageID)]];
        
    }else{
        [IconBadgeManager deleteRecomendMessageWithMessageID:[NSString stringWithFormat:@"%@",@(messageID)]];
    }
    if (_succeedBlock) {
        _succeedBlock();
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
