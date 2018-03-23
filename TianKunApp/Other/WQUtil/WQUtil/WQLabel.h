//
//  HMLabel.h
//  CubeSugarEnglishStudent
//
//  Created by seekmac002 on 2017/8/1.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQLabel : UILabel

-(instancetype)initWithFrame:(CGRect)frame
                        font:(UIFont *)font
                        text:(NSString *)text
                   textColor:(UIColor *)textColor
               textAlignment:(NSTextAlignment)textAlignment
                numberOfLine:(NSInteger)numberOfLine;





@end
