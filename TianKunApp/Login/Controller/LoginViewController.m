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

    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             WQLog(@"uid=%@",user.uid);
             WQLog(@"%@",user.credential);
             WQLog(@"token=%@",user.credential.token);
             WQLog(@"nickname=%@",user.nickname);
             [self thirdPartyLoginWithUID:user.uid name:user.nickname];
             
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

    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self thirdPartyLoginWithUID:user.uid name:user.nickname];

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
- (IBAction)weiBoButtonClickEvent:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
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
}


- (void)userLogin{
    [self showWithStatus:NET_WAIT_TOST];
    
    [self.netWorkEngine postWithDict:@{@"iphone":_nameStr,@"pwd":[_passwordStr qmui_md5]} url:BaseUrl(@"lg/login.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self.view endEditing:YES];
            [self showSuccessWithStatus:@"登录成功"];
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            [UserInfoEngine setUserInfo:userInfo];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEED_NOTICE object:nil];
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
        
    }];
    
}
- (void)thirdPartyLoginWithUID:(NSString *)uid name:(NSString *)name{
    [self showWithStatus:NET_WAIT_TOST];
    [self.netWorkEngine postWithDict:@{@"uid":uid,@"name":name} url:BaseUrl(@"lg/otherlogin.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self.view endEditing:YES];
            [self showSuccessWithStatus:@"登录成功"];
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            [UserInfoEngine setUserInfo:userInfo];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEED_NOTICE object:nil];
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
        
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
