//
//  HistoryTableViewHeaderView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HistoryTableViewHeaderView.h"

@implementation HistoryTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    _label = [[QMUILabel alloc]init];
    _label.textColor = COLOR_TEXT_BLACK;
    _label.font = [UIFont systemFontOfSize:14];
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(15);
        make.top.bottom.equalTo(self);
    }];
    
}
@end
