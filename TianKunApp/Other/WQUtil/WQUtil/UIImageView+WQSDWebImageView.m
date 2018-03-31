//
//  UIImageView+WQSDWebImageView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/31.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UIImageView+WQSDWebImageView.h"

@implementation UIImageView (WQSDWebImageView)
- (void)sd_imageDef11WithUrlStr:(NSString *)urlStr{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_11]];
}
- (void)sd_imageDef21WithUrlStr:(NSString *)urlStr{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_21]];
}
- (void)sd_imageWithUrlStr:(NSString *)urlStr placeholderImage:(NSString *)placeholderImage{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeholderImage]];

}

@end
