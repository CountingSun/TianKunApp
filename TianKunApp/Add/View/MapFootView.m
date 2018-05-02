//
//  MapFootView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MapFootView.h"

@implementation MapFootView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    _changeButton.layer.masksToBounds = YES;
    _changeButton.layer.cornerRadius = 15;
    
    [_changeButton setBackgroundColor:COLOR_TEXT_ORANGE];
    
}

@end
