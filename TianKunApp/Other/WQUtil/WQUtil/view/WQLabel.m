//
//  HMLabel.m
//  CubeSugarEnglishStudent
//
//  Created by seekmac002 on 2017/8/1.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WQLabel.h"

@implementation WQLabel


-(instancetype)initWithFrame:(CGRect)frame
                        font:(UIFont *)font
                        text:(NSString *)text
                   textColor:(UIColor *)textColor
               textAlignment:(NSTextAlignment)textAlignment
                numberOfLine:(NSInteger)numberOfLine;
{

    if (self = [super initWithFrame:frame]) {
        self.font = font;
        self.text = text;
        self.textColor = textColor;
        self.textAlignment = textAlignment;
        self.numberOfLines =numberOfLine;
        
        
    }
    return self;
    
}
@end
