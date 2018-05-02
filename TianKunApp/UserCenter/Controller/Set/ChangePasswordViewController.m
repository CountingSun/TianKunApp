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
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet QMUITextField *lastTextField;

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

}
- (IBAction)sureButtonClickEvent:(id)sender {
    if (!_oldTextField.text.length) {
        [self showErrorWithStatus:@"请输入旧密码"];
        return;
    }
    if (!_lastTextField.text.length) {
        [self showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if ([_oldTextField.text isEqualToString:_lastTextField.text]) {
        [self showErrorWithStatus:@"新密码不能入旧密码相同"];
        return;

    }
    self.view.userInteractionEnabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    [[[NetWorkEngine alloc]init] postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname,@"oldPassword":_oldTextField.text,@"password":_lastTextField.text} url:BaseUrl(@"lg/edit_password.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"修改成功"];
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
