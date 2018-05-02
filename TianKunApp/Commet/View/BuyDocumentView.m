//
//  BuyDocumentView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "BuyDocumentView.h"

@implementation BuyDocumentView

- (instancetype)initWithNib{
    return [[NSBundle mainBundle] loadNibNamed:@"BuyDocumentView" owner:nil options:nil].firstObject;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = UIColorMask;
    _reviewButton.layer.masksToBounds = YES;
    _reviewButton.layer.cornerRadius = _reviewButton.qmui_height/2;
    _buyVIPButton.layer.masksToBounds = YES;
    _buyVIPButton.layer.cornerRadius = _reviewButton.qmui_height/2;

    
}
- (IBAction)reviewButtonClick:(UIButton *)sender {
    [self hiddenBuyDocumentView];
    
}
- (IBAction)buyVipButtonClick:(id)sender {
    [self hiddenBuyDocumentView];

    if (_delegate) {
        [_delegate buyVIPButtonClickDelegate];
    }
}
- (IBAction)buyDocumentButtonClick:(id)sender {
    [self hiddenBuyDocumentView];
    if (_delegate) {
        [_delegate buyDocumentButtonClickDelegate];
        
    }
}
- (void)showBuyDocumentView{
    self.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hiddenBuyDocumentView{
    self.hidden = YES;
    [self removeFromSuperview];

}

@end
