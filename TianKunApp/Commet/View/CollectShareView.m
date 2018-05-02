//
//  CollectShareView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CollectShareView.h"

@implementation CollectShareView

+(instancetype)collectShareView{
    return [[NSBundle mainBundle] loadNibNamed:@"CollectShareView" owner:nil options:nil].firstObject;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    _collectButton.selected = NO;
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];

}
- (IBAction)collectButtonClick:(QMUIButton *)sender {
    
    if (_collectButtonBlock) {
        _collectButtonBlock();
    }
}
- (IBAction)shareButtonClick:(QMUIButton *)sender {

    if (_shareButtonBlock) {
        _shareButtonBlock();
    }
}
@end
