//
//  VIPUploadInfoViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "VIPUploadInfoViewController.h"
#import "PYPhotosView.h"


@interface VIPUploadInfoViewController ()<PYPhotosViewDelegate,QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate>
@property (strong, nonatomic) PYPhotosView *photosView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSMutableArray *selectImages;

@end

@implementation VIPUploadInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"上传资料"];
    _photosView = [PYPhotosView photosView];
    _photosView.photosState = PYPhotosViewStateWillCompose;
    _photosView.layoutType = PYPhotosViewLayoutTypeFlow;
    _photosView.photosMaxCol = 4;
    _photosView.delegate = self;
    _photosView.photoWidth = (SCREEN_WIDTH-45)/4.0;
    _photosView.photoHeight = (SCREEN_WIDTH-45)/4.0;
    [self.view addSubview:_photosView];
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(10);
        make.left.right.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view);
    }];
    
    
}
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images {
    QMUIAlbumViewController *VC = [[QMUIAlbumViewController alloc]init];
    QMUINavigationController *nav = [[QMUINavigationController alloc]initWithRootViewController:VC];
    VC.albumViewControllerDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}
- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.maximumSelectImageCount = 9;
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    if (_selectImages) {
        imagePickerViewController.selectedImageAssetArray = _selectImages;
    }
    return imagePickerViewController;
}
- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    
    CGFloat height = [_photosView sizeWithPhotoCount:imagesAssetArray.count photosState:PYPhotosViewStateWillCompose].height;
    [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height)).priority(900);
    }];
    NSMutableArray *imageUrls = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    __block NSMutableString *string = [NSMutableString string];
    [imagesAssetArray enumerateObjectsUsingBlock:^(QMUIAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = obj.previewImage;
        [imageArray addObject:image];
//        [QMUITips showLoading:@"图片上传中" inView:[self parentController].view];
        [self showWithStatus:@"图片上传中"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showSuccessWithStatus:@"上传成功"];
        });
        
//        UploadImageRequest *request = [UploadImageRequest new];
//        request.Base64Image = [UIImageJPEGRepresentation(image, 0.3) base64EncodedString];
//        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//            if ([request.responseJSONObject[@"errorcode"] integerValue] == 0) {
//                [QMUITips hideAllToastInView:[self parentController].view animated:YES];
//                [imageUrls addObject:request.responseJSONObject[@"resultdata"]];
//                if (idx == imagesAssetArray.count - 1) {
//                    [self appendImageUrlsWith:imageUrls WithCount:imagesAssetArray.count];
//                    //                    [string appendString:request.responseJSONObject[@"resultdata"]];
//                }
//                //                else{
//                //                    [string appendString:[NSString stringWithFormat:@"%@,",request.responseJSONObject[@"resultdata"]]];
//                //                }
//                //                _imageUrl = string;
//                [QMUITips showWithText:@"上传成功" inView:[self parentController].view hideAfterDelay:1.0];
//            }else{
//                [QMUITips hideAllToastInView:[self parentController].view animated:YES];
//                [QMUITips showError:request.responseJSONObject[@"Msg"] inView:[self parentController].view hideAfterDelay:1.0];
//            }
//        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//            [QMUITips hideAllToastInView:[self parentController].view animated:YES];
//        }];
    }];
    _selectImages = imagesAssetArray;
    _photosView.images = imageArray;
}
- (void)appendImageUrlsWith:(NSMutableArray *)imageUrls WithCount:(NSInteger)count {
    __block NSMutableString *string = [NSMutableString string];
    [imageUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == count - 1) {
            [string appendString:obj];
        }else{
            [string appendString:[NSString stringWithFormat:@"%@,",obj]];
        }
    }];
//    _imageUrl = string;
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
