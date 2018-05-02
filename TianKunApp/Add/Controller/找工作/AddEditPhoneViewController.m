//
//  AddEditPhoneViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/16.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddEditPhoneViewController.h"

@interface AddEditPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger countTime;

@end

@implementation AddEditPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([[GCDTimer sharedInstance] existTimer:@"code"]) {
        [[GCDTimer sharedInstance] cancelTimerWithName:@"code"];
    }
}

- (void)setupUI{
    _countTime = GET_CODE_TIME;

    _sureButton.layer.cornerRadius = _sureButton.qmui_height/2;
    _sureButton.layer.masksToBounds = YES;
    [_sureButton setBackgroundColor:COLOR_THEME];
    _phoneTextField.keyboardType =  UIKeyboardTypePhonePad;
    
    _codeTextField.keyboardType =  UIKeyboardTypeNumberPad;

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
    [self.netWorkEngine postWithDict:@{@"iphone":_phoneTextField.text,@"state":@"4"} url:BaseUrl(@"lg/getcode.action") succed:^(id responseObject) {
        
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
            [_codeButton setTitle:[NSString stringWithFormat:@"%@秒后从发",@(_countTime)] forState:0];
            
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
    
    NSString *urlStr = BaseUrl(@"lg/verification.code.validation?");
   urlStr =  [urlStr stringByAppendingString:[NSString stringWithFormat:@"iphone=%@&yzm=%@",_phoneTextField.text,_codeTextField.text]];
    
    
    [self.netWorkEngine getWithUrl:urlStr succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            
            [self showSuccessWithStatus:@"手机号检校成功"];
            if (_succeedBlock) {
                _succeedBlock(_phoneTextField.text);
            }
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
