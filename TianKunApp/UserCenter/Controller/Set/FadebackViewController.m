//
//  FadebackViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FadebackViewController.h"
#import "UIView+AddTapGestureRecognizer.h"

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
    
    __weak typeof(self) weakSelf = self;
    [self.view addTapGestureRecognizerWithActionBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    

}
- (IBAction)commitButtonClickEvent:(id)sender {
    [self showSuccessWithStatus:@"提交成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        
    });
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
