//
//  AssociationAccountViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AssociationAccountViewController.h"
#import "MessageSetVoiceTableViewCell.h"
#import "ThirdAccountModel.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <AlibabaAuthSDK/ALBBSDK.h>

@interface AssociationAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) UISwitch *qqSwitch;
@property (nonatomic ,strong) UISwitch *wxSwitch;
@property (nonatomic ,strong) UISwitch *tbSwitch;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;

@end

@implementation AssociationAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self showLoadingView];
    [self getData];
    
}

- (void)setupUI{
    [self.titleView setTitle:@"账户关联设置"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MessageSetVoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageSetVoiceTableViewCell"];
    _tableView.tableFooterView = [UIView new];
    
    [self.tableView reloadData];
    
    
}
- (void)getData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"lg/bindinglist.action") succed:^(id responseObject) {
        [self hideLoadingView];

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrData) {
                _arrData  = [NSMutableArray array];
                
            }
            NSArray *arr = [responseObject objectForKey:@"value"];
            for (NSDictionary *dic in arr) {
                ThirdAccountModel *info = [ThirdAccountModel mj_objectWithKeyValues:dic];
                [_arrData addObject:info];
                
            }
            [self.tableView reloadData];

            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getData];
                
            }];
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];

        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getData];
            
        }];
        
        
    }];
    

    
}
- (void)bindThirdAccoundWithType:(NSInteger)type uid:(NSString *)uid othername:(NSString *)othername status:(NSInteger)status{
    self.view.userInteractionEnabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (uid.length) {
        [dict setObject:uid forKey:@"uid"];
        
    }
    if (othername.length) {
        [dict setObject:othername forKey:@"othername"];

    }
    [dict setObject:@(type) forKey:@"type"];
    [dict setObject:@(status) forKey:@"status"];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"lg/binding.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        self.view.userInteractionEnabled = YES;

        if (code == 1) {
            if (status == 1) {
                [self showSuccessWithStatus:@"解绑成功"];
            }else{
                [self showSuccessWithStatus:@"绑定成功"];

            }
        }else{
            [QMUITips showError:[responseObject objectForKey:@"msg"] inView:self.view hideAfterDelay:3];
            [self dismiss];
            if (type == 0) {
                [_qqSwitch setOn:!_qqSwitch.isOn];
                
            }else if (type == 1){
                [_wxSwitch setOn:!_wxSwitch.isOn];
                
            }else{
                [_tbSwitch setOn:!_tbSwitch.isOn];
                
            }

        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;
        if (type == 0) {
            [_qqSwitch setOn:!_qqSwitch.isOn];
            
        }else if (type == 1){
            [_wxSwitch setOn:!_wxSwitch.isOn];

        }else{
            [_tbSwitch setOn:!_tbSwitch.isOn];

        }

    }];
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        MessageSetVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageSetVoiceTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.mainLabel.text = @"微信";
            _wxSwitch =  cell.selectSwicch;
            [_wxSwitch addTarget:self action:@selector(wxSwitchClickEvent) forControlEvents:UIControlEventValueChanged];
            
        }else if(indexPath.row == 1){
            cell.mainLabel.text = @"腾讯QQ";
            _qqSwitch =  cell.selectSwicch;
            [_qqSwitch addTarget:self action:@selector(qqSwitchClickEvent) forControlEvents:UIControlEventValueChanged];

        }else{
            cell.mainLabel.text = @"淘宝";
            _tbSwitch =  cell.selectSwicch;
            [_tbSwitch addTarget:self action:@selector(tbSwitchClickEvent) forControlEvents:UIControlEventValueChanged];

        }
    if (_arrData.count) {
        [_arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ThirdAccountModel *info = obj;
            if (info.type == 0) {
                [_qqSwitch setOn:YES];
            }
            if (info.type == 1) {
                [_wxSwitch setOn:YES];
            }
            if (info.type == 2) {
                [_tbSwitch setOn:YES];
                
            }
        }];
        
    }

        return cell;
    
    
}
- (void)wxSwitchClickEvent{
    
    if (!_wxSwitch.isOn) {
        [self bindThirdAccoundWithType:1 uid:nil othername:nil status:1];
    }else{
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat
                                       onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                           
                                           //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                           //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                           associateHandler (user.uid, user, user);
                                           [ShareSDK  cancelAuthorize:SSDKPlatformTypeWechat];

                                           [self bindThirdAccoundWithType:1 uid:user.uid othername:user.nickname status:0];
                                           
                                       }
                                    onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                        if (state == SSDKResponseStateSuccess)
                                        {
                                            
                                        }
                                        else if(state == SSDKResponseStateCancel){
                                            [self showErrorWithStatus:@"取消拉取授权"];
                                            self.view.userInteractionEnabled = YES;
                                            
                                        }
                                        
                                        else
                                        {
                                            self.view.userInteractionEnabled = YES;
                                            
                                            [self showErrorWithStatus:[NSString stringWithFormat:@"%@",error]] ;
                                        }
                                        
                                    }];
        
    }
    
}
- (void)qqSwitchClickEvent{
    if (!_qqSwitch.isOn) {
        [self bindThirdAccoundWithType:0 uid:nil othername:nil status:1];
        
    }else{
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ
                                       onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                           
                                           //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                           //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                           associateHandler (user.uid, user, user);
                                           [ShareSDK  cancelAuthorize:SSDKPlatformTypeQQ];
                                           
                                           [self bindThirdAccoundWithType:0 uid:user.uid othername:user.nickname status:0];
                                           
                                       }
                                    onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                        if (state == SSDKResponseStateSuccess)
                                        {
                                            
                                        }
                                        else if(state == SSDKResponseStateCancel){
                                            [self showErrorWithStatus:@"取消拉取授权"];
                                            self.view.userInteractionEnabled = YES;
                                            
                                        }
                                        
                                        else
                                        {
                                            self.view.userInteractionEnabled = YES;
                                            
                                            [self showErrorWithStatus:[NSString stringWithFormat:@"%@",error]] ;
                                        }
                                        
                                    }];

    }

}

- (void)tbSwitchClickEvent{
    if (!_tbSwitch.isOn) {
        [self bindThirdAccoundWithType:2 uid:nil othername:nil status:1];
        
    }else{
        ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
        [albbSDK setAppkey:@"24876724"];
        [albbSDK setAuthOption:NormalAuth];
        [albbSDK auth:self successCallback:^(ALBBSession *session){
            
            ALBBUser *user = [session getUser];
            WQLog(@"session == %@, user.nick == %@,user.avatarUrl == %@,user.openId == %@,user.openSid == %@,user.topAccessToken == %@",session,user.nick,user.avatarUrl,user.openId,user.openSid,user.topAccessToken);
            [self bindThirdAccoundWithType:2 uid:user.openId othername:user.nick status:0];
            ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
            [albbSDK logout];

        } failureCallback:^(ALBBSession *session,NSError *error){
            self.view.userInteractionEnabled = YES;
            [self showErrorWithStatus:@"拉取授权失败，请通过其他方式登录"];
            NSLog(@"session == %@,error == %@",session,error);
        }];

    }

}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc] init];
    }
    return _netWorkEngine;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
