//
//  SBPlayerErrorView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SBPlayerErrorView.h"

@implementation SBPlayerErrorView

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"net_fail"];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.offset(self.qmui_width/2);
    }];
    
    
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"视频出现错误";
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.offset(20);
    }];
    
    
}
@end
