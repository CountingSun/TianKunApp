//
//  EditPhoneViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EditPhoneViewController.h"
@interface EditPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *codeTexeField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (nonatomic ,assign) NSInteger countTime;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger type;
@property (weak, nonatomic) IBOutlet UIButton *commitBUtton;
@property (nonatomic ,strong) UIButton *editButton;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic ,assign) BOOL isThird;
@end

@implementation EditPhoneViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)initWithType:(NSInteger)type userTel:(NSString *)userTel{
    if (self = [super init]) {
        _type = type;
        _userTel = userTel;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _countTime = GET_CODE_TIME;
    _identifier = [NSString stringWithFormat:@"changePhone%@",@(_type)];
}
- (void)setupUI{
    
    
    if (_type == 1) {
        [self.titleView setTitle:@"修改手机号"];
        _commitBUtton.hidden = YES;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [button setTitle:@"下一步" forState:UIControlStateSelected];
        [button setTintColor:COLOR_TEXT_BLACK];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:COLOR_TEXT_BLACK forState:0];
        [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        _editButton = button;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        _phoneTextfield.text = _userTel;
        _phoneTextfield.placeholder = @"请输入旧手机号";
    }else{
        
        
        if ([_userTel isEqualToString:@"第三方"]) {
            _isThird = YES;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:self action:@selector(doNothing)];
            
        }
        
        [self.titleView setTitle:@"绑定手机号"];
        _phoneTextfield.placeholder = @"请输入手机号";
    }
    _phoneTextfield.keyboardType = UIKeyboardTypePhonePad;
    _codeTexeField.keyboardType = UIKeyboardTypeNumberPad;
}
- (void)doNothing{
    
}
-(void)rightBarButtonItemClick{
    [WQAlertController showAlertControllerWithTitle:@"提示" message:@"如想绑定手机号，请到“个人中心”->“个人信息”->“手机号”处绑定手机号" sureButtonTitle:@"确定" cancelTitle:@"" sureBlock:^(QMUIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];

    } cancelBlock:^(QMUIAlertAction *action) {
        
    }];
    
    
}
- (void)userGetVefCode{
    
    _codeButton.enabled = NO;
    if (!_phoneTextfield.text.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
    }
    [self showWithStatus:NET_WAIT_TOST];
    [self.netWorkEngine postWithDict:@{@"iphone":_phoneTextfield.text,@"state":@"3"} url:BaseUrl(@"lg/getcode.action") succed:^(id responseObject) {
        
        _codeButton.enabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 1) {
            [self setCodeButton];
            [self showSuccessWithStatus:@"获取验证码成功"];
        }else{
            NSString *msg = [responseObject objectForKey:@"msg"];
            [self showErrorWithStatus:msg];
            
        }
        
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        _codeButton.enabled = YES;
    }];
    
}
- (void)nextStep{
    if (!_phoneTextfield.text.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
        
    }
    if (![_phoneTextfield.text isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确的手机号"];
        return;

    }
    if (!_codeTexeField.text.length) {
        [self showErrorWithStatus:@"请输入验证码"];
        return;

    }
    _editButton.enabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    [ self.netWorkEngine postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"iphone":_phoneTextfield.text,@"yzm":_codeTexeField.text} url:BaseUrl(@"my/editIphoneFirst.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        _editButton.enabled = YES;
        if (code == 1) {
            [self dismiss];
            EditPhoneViewController *vc = [[EditPhoneViewController alloc]initWithType:2 userTel:_phoneTextfield.text];
            vc.succeedBlock = ^{
                if (_succeedBlock) {
                    _succeedBlock();
                }
            };
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {
        _editButton.enabled = YES;

        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
    
}
- (void)setCodeButton{
    _codeButton.enabled = NO;
    
    [[GCDTimer sharedInstance] scheduledDispatchTimerWithName:_identifier timeInterval:1 queue:dispatch_queue_create(0, 0) repeats:YES actionOption:AbandonPreviousAction action:^{
        _countTime--;
        NSLog(@"%@",@(_countTime));
        dispatch_async(dispatch_get_main_queue(), ^{
            [_codeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",@(_countTime)] forState:0];
            
        });
        
        
        if (_countTime == 0) {
            if ([[GCDTimer sharedInstance] existTimer:_identifier]) {
                [[GCDTimer sharedInstance] cancelTimerWithName:_identifier];
                _countTime = GET_CODE_TIME;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _codeButton.enabled = YES;

                    [_codeButton setTitle:@"获取动态码" forState:0];
                    
                });
                
            }else{
                
            }
            
            
        }
    }];
    
}
- (IBAction)commitButtonClick:(id)sender {
    if (_type == 2) {
        [self bingingTel];

    }else{
        [self editUserTel];

    }
    
    
}
- (void)editUserTel{
    if (!_phoneTextfield.text.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
        
    }
    if (![_phoneTextfield.text isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确的手机号"];
        return;
        
    }
    if (!_codeTexeField.text.length) {
        [self showErrorWithStatus:@"请输入验证码"];
        return;
        
    }
    self.view.userInteractionEnabled = NO;

    _editButton.enabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [dict setObject:_phoneTextfield.text forKey:@"iphone"];
    [dict setObject:_codeTexeField.text forKey:@"yzm"];
    if (_userTel.length) {
        [dict setObject:_userTel forKey:@"oldiphone"];

    }

    [ self.netWorkEngine postWithDict:dict url:BaseUrl(@"my/saveiphone.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        _editButton.enabled = YES;
        self.view.userInteractionEnabled = YES;
        if (code == 1) {
            
            UserInfo *userInfo = [UserInfoEngine getUserInfo];
            userInfo.phone = _phoneTextfield.text;
            [UserInfoEngine setUserInfo:userInfo];
            
            if (_isThird) {
                [self showSuccessWithStatus:@"绑定成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
                

            }else{
                [self showSuccessWithStatus:@"修改成功"];
                self.view.userInteractionEnabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([NSStringFromClass([vc class]) isEqualToString:@"UserInfoViewController"]) {
                            if (_succeedBlock) {
                                _succeedBlock();
                            }
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                });

            }
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            self.view.userInteractionEnabled = YES;

        }
    } errorBlock:^(NSError *error) {
        _editButton.enabled = YES;
        self.view.userInteractionEnabled = YES;

        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    

}
- (void)bingingTel{
    if (!_phoneTextfield.text.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
        
    }
    if (![_phoneTextfield.text isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确的手机号"];
        return;
        
    }

    if (!_codeTexeField.text.length) {
        [self showErrorWithStatus:@"请输入验证码"];
        return;
        
    }
    _editButton.enabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    [ self.netWorkEngine postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"iphone":_phoneTextfield.text,@"yzm":_codeTexeField.text} url:BaseUrl(@"my/other_iphone.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        _editButton.enabled = YES;
        self.view.userInteractionEnabled = YES;

        if (code == 1) {
            
            UserInfo *userInfo = [UserInfoEngine getUserInfo];
            userInfo.phone = _phoneTextfield.text;
            
            [UserInfoEngine setUserInfo:userInfo];
            
            [self showSuccessWithStatus:@"绑定成功"];
            if ([_userTel isEqualToString:@"第三方"]) {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                
            }else{
                self.view.userInteractionEnabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([NSStringFromClass([vc class]) isEqualToString:@"UserInfoViewController"]) {
                            if (_succeedBlock) {
                                _succeedBlock();
                            }
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                });

            }

        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            self.view.userInteractionEnabled = YES;

        }
    } errorBlock:^(NSError *error) {
        _editButton.enabled = YES;
        self.view.userInteractionEnabled = YES;

        [self showErrorWithStatus:NET_ERROR_TOST];
    }];

}
- (IBAction)coldbuttonClick:(id)sender {
    [self userGetVefCode];
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

@end
