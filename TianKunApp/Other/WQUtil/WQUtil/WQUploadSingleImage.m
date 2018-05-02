//
//  HMUploadSingleImage.m
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/8/4.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WQUploadSingleImage.h"
#import "WQAlertController.h"

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
    
    
    QMUIAlertController *alertController = [[QMUIAlertController alloc]initWithTitle:@"提示" message:@"选择图片" preferredStyle:QMUIAlertControllerStyleActionSheet];
    
    QMUIAlertAction *cameraAction = [QMUIAlertAction actionWithTitle:@"相机" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        }
        [vc presentViewController:picker animated:YES completion:nil];

    }];
    QMUIAlertAction *phothAction = [QMUIAlertAction actionWithTitle:@"本地" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
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

    
    QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction * action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:phothAction];
    [alertController addAction:cancelAction];
    
    [alertController showWithAnimated:YES];

    

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
