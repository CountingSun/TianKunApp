//
//  PointShopGoodsCollectionViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "PointShopGoodsCollectionViewCell.h"
#import "GoodsInfo.h"

@implementation PointShopGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}
- (void)setGoodsInfo:(GoodsInfo *)goodsInfo{
    [_imageView sd_imageDef11WithUrlStr:goodsInfo.picture];
    _titleLabel.text = goodsInfo.name;
    _moneyLabel.text = [NSString stringWithFormat:@"%@",@(goodsInfo.integral)];
    _numberLabel.text = [NSString stringWithFormat:@"库存：%@",@(goodsInfo.number)];
    
    
}
@end
