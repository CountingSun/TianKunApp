//
//  FadebackViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FadebackViewController.h"
#import "UIView+AddTapGestureRecognizer.h"
#import "NSString+WQString.h"

@interface FadebackViewController ()
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation FadebackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"反馈问题"];
    [_commitButton setBackgroundColor:COLOR_TEXT_ORANGE];
    _commitButton.layer.masksToBounds = YES;
    _commitButton.layer.cornerRadius = 20;
    _textField.keyboardType = UIKeyboardTypePhonePad;
    
    __weak typeof(self) weakSelf = self;
    [self.view addTapGestureRecognizerWithActionBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    

}
- (IBAction)commitButtonClickEvent:(id)sender {
    
    if (!_textView.text.length) {
        [self showErrorWithStatus:@"请输入反馈内容"];
        return;
    }
    if (_textField.text.length&&![_textField.text isMobileNum]) {
        [self showErrorWithStatus:@"手机号码格式不正确"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([UserInfoEngine getUserInfo].userID) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"useris"];
    }
    if (_textField.text.length) {
        [dict setObject:_textField.text forKey:@"phone"];

    }
    [dict setObject:_textView.text forKey:@"counts"];
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    [[[NetWorkEngine alloc] init] postWithDict:dict url:BaseUrl(@"HelpFeedbackController/insertHelpFeedbackbyhelp.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1){
            [self showSuccessWithStatus:@"提交成功"];
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
