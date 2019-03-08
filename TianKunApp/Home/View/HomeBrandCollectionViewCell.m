//
//  HomeBrandCollectionViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomeBrandCollectionViewCell.h"

@implementation HomeBrandCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.layer.masksToBounds = YES;
}

@end
