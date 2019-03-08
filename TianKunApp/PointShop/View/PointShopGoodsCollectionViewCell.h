//
//  PointShopGoodsCollectionViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/6/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsInfo;

@interface PointShopGoodsCollectionViewCell : UICollectionViewCell


@property (nonatomic ,strong) GoodsInfo *goodsInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
