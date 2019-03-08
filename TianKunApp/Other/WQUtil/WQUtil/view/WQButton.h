//
//  WQButton.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/14.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQButton;

typedef void(^ClickEvent)(WQButton *button);


@interface WQButton : UIButton
@property (nonatomic,copy) ClickEvent clickEvent;

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
                    fontSize:(CGFloat)fontSize
                overstriking:(BOOL)overstriking
                  clickEvent:(ClickEvent)clickEvent;


@end
