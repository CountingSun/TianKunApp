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
#import <AipOcrSdk/AipOcrSdk.h>
#import "XLPhotoBrowser.h"

@interface BusinessLicenseViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *upImage;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic ,strong) NSData *imageData;
@property (nonatomic, copy) NSString *imageUrl;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextFiedl;

@property (nonatomic ,copy) NSString *companyNameString;
@property (nonatomic ,copy) NSString *licenseImage;
@property (nonatomic ,assign) NSInteger status;
@property (nonatomic ,strong) UserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UIImageView *demoImage;



@end

@implementation BusinessLicenseViewController
- (instancetype)initWithImageUrl:(NSString *)imageUrl succeedBlock:(succeedBlock)succeedBlock{
    if (self = [super init]) {
        _imageUrl = imageUrl;
        _succeedBlock = succeedBlock;
        
    }
    return self;
}
- (instancetype)initWithUserInfo:(UserInfo *)userInfo succeedBlock:(succeedBlock)succeedBlock{
    if (self = [super init]) {
        _userInfo   = userInfo;
        _succeedBlock = succeedBlock;
        
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"上传营业执照"];
    _status = 0;
    [[AipOcrService shardService] authWithAK:AipOcrServiceAK andSK:AipOcrServiceSK];

    _demoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookBigImage)];
    [_demoImage addGestureRecognizer:tap];
    

    [self showLoadingView];
    [self getData];

    
    
}
- (void)getData{
    [[[NetWorkEngine alloc] init] postWithDict:@{@"userId":[UserInfoEngine getUserInfo].userID,} url:BaseUrl(@"find.license.bu.user.id") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSLog(@"responseObject:%@",responseObject);
        if(code == 1 ){
            _licenseImage = [[responseObject objectForKey:@"value"] objectForKey:@"picture_url"];
            _status = [[[responseObject objectForKey:@"value"] objectForKey:@"status"] integerValue];
            _companyNameString = [[responseObject objectForKey:@"value"] objectForKey:@"company_name"];
            _companyNameTextFiedl.text = _companyNameString;
            [_demoImage sd_imageWithUrlStr:_licenseImage placeholderImage:@"def_ business_license"];
            if (_status == 1||_status == 2||_status == 3) {
                _companyNameTextFiedl.enabled = NO;
                _upImage.userInteractionEnabled = NO;
                [_sureButton setBackgroundColor:[UIColor grayColor]];
                _sureButton.enabled = NO;
            }else{
                _companyNameTextFiedl.enabled = YES;
                _upImage.userInteractionEnabled = YES;
                _sureButton.enabled = YES;
                [self setupUI];
                

            }
            

        }

        else{
            [self setupUI];

        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataErrorWithMessage:NET_ERROR_TOST reloadBlock:^{
            [self showLoadingView];
            [self getData];
        }];

    }];

}
- (void)lookBigImage{
    [XLPhotoBrowser showPhotoBrowserWithImages:@[_demoImage.image] currentImageIndex:0];

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
    [_showImageView sd_imageWithUrlStr:_imageUrl placeholderImage:@"def_ business_license"];
    
    [_upImage addTapGestureRecognizerWithActionBlock:^{
        
        [self showUpImagePicker];
        
    }];
    
    
}

- (void)upLoadImageWithImageData:(NSData *)imageData{
    self.view.userInteractionEnabled = NO;
    [self showWithStatus:@"正在上传营业执照，请稍候..."];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setValue:_companyNameString forKey:@"company_name"];

    
    [[[NetWorkEngine alloc]init] upLoadmageData:imageData imageName:@"pictureFile" Url:BaseUrl(@"create.license") dict:dict succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1 ) {
            [self showSuccessWithStatus:@"上传营业执照成功"];
            if (_succeedBlock) {
                _succeedBlock(@"");
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];

            });
            
            
        }else{
            self.view.userInteractionEnabled = YES;
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;

    }];
    
}
- (IBAction)sureButtonClick:(id)sender {
    if (!_companyNameTextFiedl.text.length) {
        [self showErrorWithStatus:@"请输入企业名"];
        return;
    }
    if (_imageData) {
        [self upLoadImageWithImageData:_imageData];
    }else{
        [self showErrorWithStatus:@"请选择图片"];
    }


}
-(void)showUpImagePicker{
    
    if (!_companyNameTextFiedl.text.length) {
        [self showErrorWithStatus:@"请输入企业名称"];
        return;
        
    }
    __weak typeof(self) weakSelf = self;

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [[weakSelf topViewController] dismissViewControllerAnimated:YES completion:nil];

        [self showWithStatus:@"正在识别，请稍候"];

        [[AipOcrService shardService] detectBusinessLicenseFromImage:image withOptions:nil successHandler:^(id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
                if(result[@"words_result"]){
                    if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                        [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                            if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                                
                                if ([key isEqualToString:@"单位名称"]) {
                                    _companyNameString = [obj objectForKey:@"words"];
                                    
                                }
                            }else{
                            }
                            
                        }];
                    }else{
                    }
                    
                }
                
                
                if (_companyNameString.length <=1) {
                [WQAlertController showAlertControllerWithTitle:@"提示" message:@"未能检测到您的企业名称,请确定证书照片是否清晰正确" sureButtonTitle:@"我知道了" cancelTitle:nil sureBlock:^(QMUIAlertAction *action) {
                        
                    } cancelBlock:^(QMUIAlertAction *action) {
                        
                    }];
                }else{
                    if ([_companyNameString isEqualToString:_companyNameTextFiedl.text]) {
                        [self showSuccessWithStatus:@"可用的营业执照"];
                        _imageData = UIImageJPEGRepresentation(image, 1);
                        _demoImage.image = image;
                        
                        
                    }else{
                        [WQAlertController showAlertControllerWithTitle:@"提示" message:@"输入的企业名称与证书企业名称不一致" sureButtonTitle:@"我知道了" cancelTitle:nil sureBlock:^(QMUIAlertAction *action) {
                            
                        } cancelBlock:^(QMUIAlertAction *action) {
                            
                        }];
                    }
                }


            });
        } failHandler:^(NSError *err) {
            NSLog(@"%@", err);
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [WQAlertController showAlertControllerWithTitle:@"提示" message:msg sureButtonTitle:@"确定" cancelTitle:nil sureBlock:^(QMUIAlertAction *action) {
                    
                } cancelBlock:^(QMUIAlertAction *action) {
                    
                }];

            }];
        }];
        
    }];
    [self presentViewController:vc animated:YES completion:nil];

    
    
}
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
