//
//  FindBackPasswordViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/18.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindBackPasswordViewController.h"

@interface FindBackPasswordViewController ()
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger countTime;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation FindBackPasswordViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([[GCDTimer sharedInstance] existTimer:@"code"]) {
        [[GCDTimer sharedInstance] cancelTimerWithName:@"code"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"忘记密码"];
    [self setupUI];
}
- (void)setupUI{
    _countTime = GET_CODE_TIME;
    
    _sureButton.layer.cornerRadius = _sureButton.qmui_height/2;
    _sureButton.layer.masksToBounds = YES;
    [_sureButton setBackgroundColor:COLOR_THEME];
    _phoneTextField.keyboardType =  UIKeyboardTypePhonePad;
    
    _codeTextField.keyboardType =  UIKeyboardTypeNumberPad;
    
    _pwdTextField.keyboardType =  UIKeyboardTypeDefault;
    [_actionButton setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
    [_actionButton setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateSelected];
    _actionButton.selected = YES;
    
    _pwdTextField.secureTextEntry = YES;
}
- (IBAction)getCodeButtonClick:(UIButton *)sender {
    if (!_phoneTextField.text.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
        
    }
    
    if (![_phoneTextField.text isMobileNum]) {
        [self showErrorWithStatus:@"手机号码格式不正确"];
        return;
    }
    [self showWithStatus:NET_WAIT_TOST];
    _codeButton.enabled = NO;
    [self.netWorkEngine postWithDict:@{@"iphone":_phoneTextField.text,@"state":@"1"} url:BaseUrl(@"lg/getcode.action") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"获取验证码成功"];
            [self setCodeButton];
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (void)setCodeButton{
    _codeButton.enabled = NO;
    
    [[GCDTimer sharedInstance] scheduledDispatchTimerWithName:@"code" timeInterval:1 queue:dispatch_queue_create(0, 0) repeats:YES actionOption:AbandonPreviousAction action:^{
        _countTime--;
        NSLog(@"%@",@(_countTime));
        dispatch_async(dispatch_get_main_queue(), ^{
            [_codeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",@(_countTime)] forState:0];
            
        });
        
        
        if (_countTime == 0) {
            if ([[GCDTimer sharedInstance] existTimer:@"code"]) {
                [[GCDTimer sharedInstance] cancelTimerWithName:@"code"];
                _countTime = GET_CODE_TIME;
                
                _codeButton.enabled = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_codeButton setTitle:@"获取动态码" forState:0];
                    
                });
                
            }else{
                
            }
            
            
        }
    }];
    
}
- (IBAction)sureButtonClick:(id)sender {
    if (!_phoneTextField.text.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
        
    }
    
    if (![_phoneTextField.text isMobileNum]) {
        [self showErrorWithStatus:@"手机号码格式不正确"];
        return;
    }
    if (!_codeTextField.text.length) {
        [self showErrorWithStatus:@"请输入验证码"];
        return;
        
    }
    if (!_pwdTextField.text.length) {
        [self showErrorWithStatus:@"请输入新密码"];
        return;
        
    }
    if (_pwdTextField.text.length<6) {
        [self showErrorWithStatus:@"密码长度需不少于6位"];
        return;
        
        
    }
    if (_pwdTextField.text.length>18) {
        [self showErrorWithStatus:@"密码长度需不大于于18位"];
        return;
        
    }
    if ([_pwdTextField.text includeChinese]) {
        [self showErrorWithStatus:@"密码不能包含汉字"];
        return;
        
    }
    

    [self showWithStatus:NET_WAIT_TOST];
    
    [self.netWorkEngine postWithDict:@{@"iphone":_phoneTextField.text,@"pwd":[_pwdTextField.text qmui_md5],@"yzm":_codeTextField.text} url:BaseUrl(@"lg/editpwd.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];

        if (code == 1) {
            
            [self showSuccessWithStatus:@"修改密码成功"];
            self.view.userInteractionEnabled = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
    
    
    
    
}
- (IBAction)actionButtonClick:(UIButton *)sender {
    sender.selected =! sender.selected;
    _pwdTextField.secureTextEntry = sender.selected;

}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
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
