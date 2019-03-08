//
//  LoginViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LoginTextTableViewCell.h"
#import "DynamicLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "FindBackPasswordViewController.h"
#import "JPUSHService.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import "RongCloudConfigure.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "EditPhoneViewController.h"

@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource,ClickSecureButtonDelegate>

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *passwordStr;
@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headView;
    _tableView.tableFooterView = self.footView;
    _tableView.rowHeight = 45;
    _tableView.backgroundColor = COLOR_VIEW_BACK;
    _headView.backgroundColor = COLOR_VIEW_BACK;
    [_dynamicButton setTitleColor:COLOR_TEXT_GENGRAL forState:0];
    [_forgetButton setTitleColor:COLOR_TEXT_GENGRAL forState:0];
    _otherLabel.textColor = COLOR_TEXT_GENGRAL;
    
    _lineView.backgroundColor = COLOR_VIEW_SEGMENTATION;
    _footView.backgroundColor = COLOR_VIEW_BACK;
    _otherLabel.backgroundColor = COLOR_VIEW_BACK;
    [_loginButton setBackgroundColor:COLOR_THEME];
    
    
    [_registerButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [_tableView registerNib:[UINib nibWithNibName:@"LoginTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"LoginTextTableViewCell"];
    
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeEditing)];
    [self.view addGestureRecognizer:tap];
    
    
}
-(void)closeEditing{
    [self.view endEditing:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LoginTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginTextTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (indexPath.row == 0) {
        cell.texeField.placeholder = @"请输入账号";
        cell.texeField.keyboardType = UIKeyboardTypePhonePad;

        cell.texeField.secureTextEntry = NO;
        cell.actionButton.hidden = YES;
        cell.textBlock = ^(NSString *text) {
            _nameStr = text;
        };
        
        
    }else{
        cell.texeField.placeholder = @"请输入密码";
        cell.texeField.secureTextEntry = YES;
        cell.actionButton.hidden = NO;
        cell.texeField.keyboardType = UIKeyboardTypeDefault;
        cell.textBlock = ^(NSString *text) {
            _passwordStr = text;
        };

    }
    return cell;
    
}
- (IBAction)closeButtonClickEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (IBAction)registerButtonClickEvent:(id)sender {
    
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
    
}
- (void)clickSecureButton:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    LoginTextTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (cell.actionButton.selected) {
        cell.texeField.secureTextEntry = NO;

    }else{
        cell.texeField.secureTextEntry = YES;

    }
    
}
#pragma mark - buttonEvent

- (IBAction)loginButtonEvent:(id)sender {
    
    if (!_nameStr.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![_nameStr isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }

    if (!_passwordStr) {
        [self showErrorWithStatus:@"请输入密码"];
        return;
    }
    [self userLogin];
}
- (IBAction)dynamicButtonClickEven:(id)sender {
    [self.navigationController pushViewController:[DynamicLoginViewController new] animated:YES];
    
}
- (IBAction)forgetButtonClickEvent:(id)sender {
    [self.navigationController pushViewController:[FindBackPasswordViewController new] animated:YES];

    
}
#pragma mark 第三方登录
- (IBAction)wxButtonClickEvent:(id)sender {
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    [ShareSDK  cancelAuthorize:SSDKPlatformTypeWechat];
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       NSLog(@"dd%@",user.rawData);
                                       NSLog(@"dd%@",user.credential);
                                       [self thirdPartyLoginWithUID:user.uid name:user.nickname type:1 headImage:user.icon];

                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    self.view.userInteractionEnabled = YES;

                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        
                                        
                                    }
                                    else if(state == SSDKResponseStateCancel){
                                        [self showErrorWithStatus:@"登录取消"];
                                        
                                    }
                                    
                                    else
                                    {
                                        
                                        [self showErrorWithStatus:[NSString stringWithFormat:@"%@",error]] ;
                                    }
                                    
                                }];
}
- (IBAction)qqButtonClickEvent:(id)sender {
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    [ShareSDK  cancelAuthorize:SSDKPlatformTypeQQ];
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       NSLog(@"dd%@",user.rawData);
                                       NSLog(@"dd%@",user.credential);
                                       [self thirdPartyLoginWithUID:user.uid name:user.nickname type:0 headImage:user.icon];
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    self.view.userInteractionEnabled = YES;

                                    if (state == SSDKResponseStateSuccess)
                                    {

                                    }
                                    else if(state == SSDKResponseStateCancel){
                                        [self showErrorWithStatus:@"登录取消"];
                                        
                                    }
                                    
                                    else
                                    {

                                        [self showErrorWithStatus:[NSString stringWithFormat:@"%@",error]] ;
                                    }
                                    
                                }];
}
- (IBAction)taobao:(id)sender {
    self.view.userInteractionEnabled = NO;
    ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
    [albbSDK setAppkey:@"24876724"];
    [albbSDK setAuthOption:NormalAuth];
    [albbSDK auth:self successCallback:^(ALBBSession *session){
        
        ALBBUser *user = [session getUser];
        WQLog(@"session == %@, user.nick == %@,user.avatarUrl == %@,user.openId == %@,user.openSid == %@,user.topAccessToken == %@",session,user.nick,user.avatarUrl,user.openId,user.openSid,user.topAccessToken);
        [self thirdPartyLoginWithUID:user.openId name:user.nick type:2 headImage:user.avatarUrl];

    } failureCallback:^(ALBBSession *session,NSError *error){
        self.view.userInteractionEnabled = YES;
        [self showErrorWithStatus:@"拉取授权失败，请通过其他方式登录"];
        NSLog(@"session == %@,error == %@",session,error);
    }];

}


- (void)userLogin{
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    [self.netWorkEngine postWithDict:@{@"iphone":_nameStr,@"pwd":[_passwordStr qmui_md5]} url:BaseUrl(@"lg/login.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1) {
            
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            [UserInfoEngine setIsHadPwd:@"1"];
            
            [UserInfoEngine setUserInfo:userInfo];
            
            if (IS_OPEN_RongCloud) {
                [RongCloudConfigure loginRongCloudWithresultBlock:^(NSString *errMessage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!errMessage.length) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEED_NOTICE object:nil];
                            if (userInfo.vip_status == 1) {
                                NSSet *set;
                                set = [NSSet setWithObjects:@"VIP", nil];
                                [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                                    WQLog(@"%@",iTags);
                                    
                                } seq:1];
                                [JPUSHService setAlias:userInfo.userID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                    WQLog(@"%@",iAlias);
                                    
                                } seq:1];
                                
                            }else{
                                NSSet *set;
                                
                                set = [NSSet setWithObjects:@"ID", nil];
                                [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                                    WQLog(@"%@",iTags);
                                    
                                } seq:1];
                                [JPUSHService setAlias:userInfo.userID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                    WQLog(@"%@",iAlias);
                                    
                                } seq:1];
                                
                            }
                            
                            [self.view endEditing:YES];
                            [self showSuccessWithStatus:@"登录成功"];
                            
                        }else{
                            self.view.userInteractionEnabled = YES;
                            [UserInfoEngine setUserInfo:nil];
                            [self showErrorWithStatus:errMessage];
                        }
                        
                    });
                    
                }];
                
                

            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
                [self showSuccessWithStatus:@"登录成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEED_NOTICE object:nil];

            }
            

        }else{
            self.view.userInteractionEnabled = YES;
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;

    }];
    
}

/**
 第三方登录

 @param uid openID
 @param name 用户名
 @param type type 0：qq登录 1：微信登录 2：淘宝登录
 */
- (void)thirdPartyLoginWithUID:(NSString *)uid name:(NSString *)name type:(NSInteger)type headImage:(NSString *)headImage{
    [self showWithStatus:NET_WAIT_TOST];
    
    self.view.userInteractionEnabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:name forKey:@"othername"];
    [dict setObject:@(type) forKey:@"type"];
    [dict setObject:headImage forKey:@"headimg"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"lg/otherlogin.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            
            
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            [UserInfoEngine setIsHadPwd:userInfo.hadPwd];

            [UserInfoEngine setUserInfo:userInfo];
            
            if (IS_OPEN_RongCloud) {
                [RongCloudConfigure loginRongCloudWithresultBlock:^(NSString *errMessage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!errMessage.length) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEED_NOTICE object:nil];
                            if (userInfo.vip_status == 1) {
                                NSSet *set;
                                set = [NSSet setWithObjects:@"VIP", nil];
                                [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                                    WQLog(@"%@",iTags);
                                    
                                } seq:1];
                                [JPUSHService setAlias:userInfo.userID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                    WQLog(@"%@",iAlias);
                                    
                                } seq:1];
                                
                            }else{
                                NSSet *set;
                                
                                set = [NSSet setWithObjects:@"ID", nil];
                                [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                                    WQLog(@"%@",iTags);
                                    
                                } seq:1];
                                [JPUSHService setAlias:userInfo.userID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                    WQLog(@"%@",iAlias);
                                    
                                } seq:1];
                                
                            }
                            
                            if (userInfo.bol) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                                [self showSuccessWithStatus:@"登录成功"];
                                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEED_NOTICE object:nil];
                                [self.view endEditing:YES];

                            }else{
                                EditPhoneViewController *vc = [[EditPhoneViewController alloc] initWithType:2 userTel:@"第三方"];
                                vc.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            }

                        }else{
                            self.view.userInteractionEnabled = YES;
                            [UserInfoEngine setUserInfo:nil];
                            [self showErrorWithStatus:errMessage];
                        }
                        
                    });
                    
                }];
                

            }else{
                if (userInfo.bol) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self showSuccessWithStatus:@"登录成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEED_NOTICE object:nil];

                }else{
                    EditPhoneViewController *vc = [[EditPhoneViewController alloc] initWithType:2 userTel:@"第三方"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }

            }

            
            
            
            
        }else{
            self.view.userInteractionEnabled = YES;
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];

        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;

    }];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
