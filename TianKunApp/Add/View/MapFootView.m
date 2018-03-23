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
    
    _editButton.layer.masksToBounds = YES;
    _editButton.layer.cornerRadius = 15;
    _editButton.qmui_borderWidth = 1;
    _editButton.qmui_borderColor = COLOR_TEXT_ORANGE;
    
    [_changeButton setBackgroundColor:COLOR_TEXT_ORANGE];
    
}

@end
