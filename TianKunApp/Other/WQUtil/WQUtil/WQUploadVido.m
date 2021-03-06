//
//  HMUploadVido.m
//  CubeSugarEnglishTeacher
//
//  Created by seekmac002 on 2017/8/10.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WQUploadVido.h"
#import <AVFoundation/AVFoundation.h>

@implementation ResultVidoInfo
@end

@interface WQUploadVido ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong) UIViewController *vc;


@end

@implementation WQUploadVido
static WQUploadVido *_uploadVido;
+(instancetype)shared{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uploadVido = [[WQUploadVido alloc]init];
    });
    return _uploadVido;
}

-(void)showUpVidoPickerWithVC:(UIViewController *)vc selectSucceedBlock:(SelectVideoSucceedBlock)selectSucceedBlock{
    _vc = vc;
    _selectSucceedBlock = selectSucceedBlock;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择视频" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self startvideo];
        
    }];
    UIAlertAction *actionLocation = [UIAlertAction actionWithTitle:@"本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self choosevideo];
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

//选择本地视频
- (void)choosevideo
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [_vc presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;//设置委托
    
}

//录制视频
- (void)startvideo
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [_vc presentViewController:ipc animated:YES completion:nil];
    ipc.videoMaximumDuration = 30.0f;//30秒
    ipc.delegate = self;//设置委托
    
}
- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}//此方法可以获取视频文件的时长。

//完成视频录制，并压缩后显示大小、时长
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:sourceURL]]);
    NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[sourceURL path]]]);
    NSURL *newVideoUrl ; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
}
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                 NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                 
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 
                 [self alertUploadVideo:outputURL];
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
    
}
-(void)alertUploadVideo:(NSURL*)URL{
    CGFloat size = [self getFileSize:[URL path]];
    NSString *sizeString;
    CGFloat sizemb= size/1024;
    if(size<=1024){
        sizeString = [NSString stringWithFormat:@"%.2fKB",size];
    }else{
        sizeString = [NSString stringWithFormat:@"%.2fMB",sizemb];
    }
    
    _vidoInfo = [[ResultVidoInfo alloc]init];
    _vidoInfo.filePath = [NSString stringWithFormat:@"%@",URL];
    _vidoInfo.fileSize = sizeString;
    
    if (_selectSucceedBlock) {
        _selectSucceedBlock(_vidoInfo);
        
    }
    
    
    
    
    
}

@end
