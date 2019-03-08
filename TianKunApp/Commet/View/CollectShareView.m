//
//  CollectShareView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CollectShareView.h"

@implementation CollectShareView

- (instancetype)initWithFrame:(CGRect)frame collectButtonBlock:(collectButtonBlock)collectButtonBlock shareButtonBlock:(shareButtonBlock)shareButtonBlock{
    if (self = [super initWithFrame:frame]) {
        
        _collectButtonBlock = collectButtonBlock;
        _shareButtonBlock = shareButtonBlock;
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI{
    _collectButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(0, 0, 40, 40);
    [self addSubview:_collectButton];
    [_collectButton addTarget:self action:@selector(collectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];
    _collectButton.selected = NO;
    
    _shareButton = [QMUIButton buttonWithType:UIButtonTypeCustom];

    _shareButton.frame = CGRectMake(40, 0, 40, 40);
    [self addSubview:_shareButton];
    [_shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_shareButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];

}
- (void)collectButtonClick {
    
    if (_collectButtonBlock) {
        _collectButtonBlock();
    }
}
- (void)shareButtonClick {

    if (_shareButtonBlock) {
        _shareButtonBlock();
    }
}
@end
