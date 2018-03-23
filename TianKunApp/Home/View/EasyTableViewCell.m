//
//  EasyTableViewCell.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EasyTableViewCell.h"
#import "MenuInfo.h"

@implementation EasyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.backgroundColor = COLOR_THEME;
    
    [_gsQueryButton setImagePosition:QMUIButtonImagePositionTop];
    [_gsQueryButton setSpacingBetweenImageAndTitle:10];
    
    [_zzQueryButton setImagePosition:QMUIButtonImagePositionTop];
    [_zzQueryButton setSpacingBetweenImageAndTitle:10];

    [_peopleQueryButton setImagePosition:QMUIButtonImagePositionTop];
    [_peopleQueryButton setSpacingBetweenImageAndTitle:10];

    [_projectQueryButton setImagePosition:QMUIButtonImagePositionTop];
    [_projectQueryButton setSpacingBetweenImageAndTitle:10];

    [_cxQueryButton setImagePosition:QMUIButtonImagePositionTop];
    [_cxQueryButton setSpacingBetweenImageAndTitle:10];

    
}
- (void)setArrMenu:(NSMutableArray *)arrMenu{
    _arrMenu = arrMenu;
    [_arrMenu enumerateObjectsUsingBlock:^(MenuInfo *menuInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                [_gsQueryButton setTitle:menuInfo.menuName forState:0];
                [_gsQueryButton setImage:[UIImage imageNamed:menuInfo.menuIcon] forState:0];
                break;
            case 1:
                [_zzQueryButton setTitle:menuInfo.menuName forState:0];
                [_zzQueryButton setImage:[UIImage imageNamed:menuInfo.menuIcon] forState:0];
                break;
            case 2:
                [_peopleQueryButton setTitle:menuInfo.menuName forState:0];
                [_peopleQueryButton setImage:[UIImage imageNamed:menuInfo.menuIcon] forState:0];
                break;
            case 3:
                [_projectQueryButton setTitle:menuInfo.menuName forState:0];
                [_projectQueryButton setImage:[UIImage imageNamed:menuInfo.menuIcon] forState:0];
                break;
            case 4:
                [_cxQueryButton setTitle:menuInfo.menuName forState:0];
                [_cxQueryButton setImage:[UIImage imageNamed:menuInfo.menuIcon] forState:0];
                break;

            default:{
                
            }
                break;
        }
        
    }];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
