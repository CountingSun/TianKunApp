//
//  EducationVidoCollectionViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationVidoCollectionViewCell.h"

@implementation EducationVidoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _freeType.layer.cornerRadius = 3;
    _freeType.layer.masksToBounds = YES;
    _vidoImageView.layer.masksToBounds = YES;
}

@end
