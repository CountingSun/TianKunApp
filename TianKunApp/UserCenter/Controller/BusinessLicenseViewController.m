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

@interface BusinessLicenseViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *upImage;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic ,strong) NSData *imageData;

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
        
//        [[WQUploadSingleImage manager] showUpImagePickerWithVC:self allowsEditing:NO selectSucceedBlock:^(UIImage *image, NSData *imageData, NSString *filePath) {
//
//            _showImageView.image = image;
//            _imageData =UIImageJPEGRepresentation(image, 0.5);
//
//
//        }];
////
        [self showUpImagePicker];
        
    }];
    
    
}
- (void)upLoadImageWithImageData:(NSData *)imageData{
    self.view.userInteractionEnabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    
    [[[NetWorkEngine alloc]init] upLoadmageData:imageData imageName:@"pictureFile" Url:BaseUrl(@"create.license") dict:@{@"user_id":[UserInfoEngine getUserInfo].userID} succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1 ) {
            [self showSuccessWithStatus:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            
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
    if (_imageData) {
        [self upLoadImageWithImageData:_imageData];
    }else{
        [self showErrorWithStatus:@"请选择图片"];
    }


}
-(void)showUpImagePicker{
    
    
    QMUIAlertController *alertController = [[QMUIAlertController alloc]initWithTitle:@"提示" message:@"选择图片" preferredStyle:QMUIAlertControllerStyleActionSheet];
    
    QMUIAlertAction *cameraAction = [QMUIAlertAction actionWithTitle:@"相机" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        }
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    QMUIAlertAction *phothAction = [QMUIAlertAction actionWithTitle:@"本地" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
        }
        [self presentViewController:picker animated:YES completion:nil];

    }];
    
    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction * action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:phothAction];
    [alertController addAction:cancelAction];
    
    [alertController showWithAnimated:YES];
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (mediaType){
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if(image){
            _imageData = UIImageJPEGRepresentation(image, 0.5);
            _showImageView.image = image;

        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
