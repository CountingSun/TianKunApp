//
//  ChangePasswordViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UIView+AddTapGestureRecognizer.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *oldTextField;
@property (weak, nonatomic) IBOutlet UILabel *oldLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet QMUITextField *lastTextField;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldTfViewHeight;
@property (nonatomic ,assign) NSInteger isSetPwd;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"修改密码"];
    [_sureButton setBackgroundColor:COLOR_TEXT_ORANGE];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 20;
    __weak typeof(self) weakSelf = self;
    [self.view addTapGestureRecognizerWithActionBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    
    if ([UserInfoEngine getIsHadPwd]) {
        _isSetPwd = NO;
    }else{
        
        _isSetPwd = YES;
        _oldLabelHeight.constant = 0;
        _oldTfViewHeight.constant = 0;
        _oldLabel.hidden = YES;
        _oldTextField.hidden = YES;
        
        
    }

}
- (IBAction)sureButtonClickEvent:(id)sender {
    if (_isSetPwd) {
        if (!_lastTextField.text.length) {
            [self showErrorWithStatus:@"请输入密码"];
            return;
        }

    }else{
        if (!_oldTextField.text.length) {
            [self showErrorWithStatus:@"请输入旧密码"];
            return;
        }
        if (_oldTextField.text.length<6) {
            [self showErrorWithStatus:@"密码长度需不少于6位"];
            return;
            
        }
        if (!_lastTextField.text.length) {
            [self showErrorWithStatus:@"请输入新密码"];
            return;
        }

    }

    if (_lastTextField.text.length<6) {
        [self showErrorWithStatus:@"密码长度需不少于6位"];
        return;
        
        
    }
    if (_lastTextField.text.length>18) {
        [self showErrorWithStatus:@"密码长度需不大于于18位"];
        return;
        
    }
    if ([_lastTextField.text includeChinese]) {
        [self showErrorWithStatus:@"密码不能包含汉字"];
        return;
        
    }
    if (_isSetPwd) {
        
    }else{
        if ([_oldTextField.text isEqualToString:_lastTextField.text]) {
            [self showErrorWithStatus:@"新密码不能入旧密码相同"];
            return;
            
        }

    }
    self.view.userInteractionEnabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    NSString *urlString = @"";
    if (_isSetPwd) {
        urlString = BaseUrl(@"lg/setotherpwd.action");
    }else{
        urlString = BaseUrl(@"lg/edit_password.action");
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (_isSetPwd) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
        [dict setObject:[_oldTextField.text qmui_md5] forKey:@"pwd"];

    }else{
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
        [dict setObject:[UserInfoEngine getUserInfo].nickname forKey:@"username"];
        [dict setObject:_oldTextField.text forKey:@"oldPassword"];
        [dict setObject:_lastTextField.text forKey:@"password"];

    }
    [[[NetWorkEngine alloc]init] postWithDict:dict url:urlString succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"修改成功"];
            UserInfo *userInfo = [UserInfoEngine getUserInfo];
            [UserInfoEngine setIsHadPwd:@"1"];
            [UserInfoEngine setUserInfo:userInfo];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            self.view.userInteractionEnabled = YES;

        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;

    }];
    
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
