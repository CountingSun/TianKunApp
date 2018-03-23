//
//  HMUploadSingleImage.m
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/8/4.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WQUploadSingleImage.h"

@interface WQUploadSingleImage ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) CGFloat compression;

@end
@implementation WQUploadSingleImage

static WQUploadSingleImage *_uploadSingleImage;
+(instancetype)manager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uploadSingleImage = [[WQUploadSingleImage alloc]init];
    });
    return _uploadSingleImage;
}

-(void)showUpImagePickerWithVC:(UIViewController *)vc compression:(CGFloat)compression selectSucceedBlock:(SelectSucceedBlock)selectSucceedBlock{

    _selectSucceedBlock = selectSucceedBlock;
    _compression = compression;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        }
        [vc presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *actionLocation = [UIAlertAction actionWithTitle:@"本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
        }
        [vc presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [vc dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertController addAction:actionPhoto];
    [alertController addAction:actionLocation];
    [alertController addAction:actionCancel];
    [vc presentViewController:alertController animated:YES completion:^{
        
    }];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerEditedImage];
    if (mediaType){
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image)
        {
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        if(image){
             NSData *imageData = UIImageJPEGRepresentation(image, _compression);
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"image"];
            [imageData writeToFile:fullPath atomically:NO];
         
            if (_selectSucceedBlock) {
                _selectSucceedBlock(image,fullPath);
                
            }
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
