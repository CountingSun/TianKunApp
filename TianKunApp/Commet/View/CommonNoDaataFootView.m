//
//  CommonNoDaataFootView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/9.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CommonNoDaataFootView.h"

@implementation CommonNoDaataFootView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    
    _label = [[WQLabel alloc] initWithFrame:self.frame font:[UIFont systemFontOfSize:14] text:@"暂无数据" textColor:COLOR_TEXT_LIGHT textAlignment:NSTextAlignmentCenter numberOfLine:1];
    
    [self addSubview:_label];
    
}
@end
