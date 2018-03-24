//
//  BusinessLicenseViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "BusinessLicenseViewController.h"
#import "UIView+AddTapGestureRecognizer.h"
#import "WQUploadSingleImage.h"

@interface BusinessLicenseViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *upImage;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation BusinessLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"上传营业执照"];

    [self setupUI];
    
}
- (void)setupUI{
    [_sureButton setBackgroundColor:COLOR_THEME];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius =  _sureButton.qmui_height/2;
    _upImage.userInteractionEnabled = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addTapGestureRecognizerWithActionBlock:^{
        
        [weakSelf.view endEditing:YES];
    }];

    [_upImage addTapGestureRecognizerWithActionBlock:^{
        
        [[WQUploadSingleImage manager] showUpImagePickerWithVC:self compression:0.5 selectSucceedBlock:^(UIImage *image, NSString *filePath) {
            [self showSuccessWithStatus:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
    
    
}
- (IBAction)sureButtonClick:(id)sender {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
