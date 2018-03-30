//
//  SBTitleView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SBTitleView.h"

@implementation SBTitleView
- (instancetype)init{
    if (self = [super init]) {
        [self setupView];
        self.backgroundColor = UIColorMask;
        
    }
    return self;
    
}
- (void)setupView{
    _titleLabel = [[MarqueeLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _titleLabel.marqueeType = MLContinuous;
//    _titleLabel.scrollDuration = 3.0;
    _titleLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;
    _titleLabel. fadeLength = 15.0f;
    _titleLabel.trailingBuffer = 35.0f;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    
    [self addSubview:_titleLabel];
    
    _backButton = [[QMUIButton alloc] init];
    [_backButton setImage:[UIImage imageNamed:@"返回_白色"] forState:0];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.offset(40);
        
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(_backButton.mas_right).offset(10);
    }];
    
    [_backButton  addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backButtonClick{
    if (_backBlcok) {
        _backBlcok();
    }
}
@end
