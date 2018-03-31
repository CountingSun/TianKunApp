//
//  UIImageView+WQSDWebImageView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/31.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WQSDWebImageView)

- (void)sd_imageDef11WithUrlStr:(NSString *)urlStr;
- (void)sd_imageDef21WithUrlStr:(NSString *)urlStr;
- (void)sd_imageWithUrlStr:(NSString *)urlStr placeholderImage:(NSString *)placeholderImage;


@end
