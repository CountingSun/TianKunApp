//
//  WQAuthorizationjudge.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/22.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQAuthorizationjudge.h"
//相机权限
#import <AVFoundation/AVFoundation.h>
//相册权限
#import <AssetsLibrary/AssetsLibrary.h>
//位置权限
#import <CoreLocation/CLLocationManager.h>

#import "WQAlertController.h"


@implementation WQAuthorizationjudge
+(BOOL)isHaveCameraAuthorizationAnIsshoAleran:(BOOL)showAleran{

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        if (showAleran) {
            [WQAlertController showAlertControllerWithTitle:@"相机权限未开启" message:@"相机权限未开启，请进入系统【设置】>【隐私】>【相机】中打开开关,开启相机功能" sureButtonTitle:@"立即开启" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

            } cancelBlock:^(QMUIAlertAction *action) {
                
            }];
            
        }
        return NO;

    }else{
        //获取了权限，直接调用相机接口
        return YES;

    }
    
}
+(BOOL)isHavePhotoAuthorizationAnIsshoAleran:(BOOL)showAleran{

    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted) {
        // 没有权限
        if (showAleran) {
            [WQAlertController showAlertControllerWithTitle:@"相册权限未开启" message:@"相册权限未开启，请进入系统【设置】>【隐私】>【照片】中打开开关,开启相册功能" sureButtonTitle:@"立即开启" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
            } cancelBlock:^(QMUIAlertAction *action) {
                
            }];

        }

        return  NO;
        
    }else{
        // 已经获取权限
        return YES;
    }
    
}
+(BOOL)isHaveLocationAuthorizationAnIsshoAleran:(BOOL)showAleran{

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        // 没有权限，
        if (showAleran) {
            [WQAlertController showAlertControllerWithTitle:@"定位权限未开启" message:@"相册权限未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关,开启定位功能" sureButtonTitle:@"立即开启" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
            } cancelBlock:^(QMUIAlertAction *action) {
                
            }];
            
        }
        return NO;

    }else{
    
        return YES;
        
    }
    
}

@end
