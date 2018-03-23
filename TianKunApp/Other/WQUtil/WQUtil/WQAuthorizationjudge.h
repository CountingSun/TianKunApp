//
//  WQAuthorizationjudge.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/22.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQAuthorizationjudge : NSObject

/**
 判断是否有相机权限

 @param showAleran 是否显示默认的Aleran
 @return BOOL
 */
+(BOOL)isHaveCameraAuthorizationAnIsshoAleran:(BOOL)showAleran;

/**
 判断是否有相册权限

 @param showAleran 是否显示默认的Aleran
 @return BOOL
 */
+(BOOL)isHavePhotoAuthorizationAnIsshoAleran:(BOOL)showAleran;

/**
 判断是否有定位权限

 @param showAleran 是否显示默认的Aleran
 @return BOOL
 */
+(BOOL)isHaveLocationAuthorizationAnIsshoAleran:(BOOL)showAleran;

@end
