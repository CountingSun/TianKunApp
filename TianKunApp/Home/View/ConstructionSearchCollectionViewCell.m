//
//  ConstructionSearchCollectionViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/10.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ConstructionSearchCollectionViewCell.h"

@implementation ConstructionSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.layer.borderColor = COLOR_VIEW_SEGMENTATION.CGColor;

}

@end
