//
//  WQButton.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/14.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQButton.h"


@implementation WQButton

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize overstriking:(BOOL)overstriking clickEvent:(ClickEvent)clickEvent{
    _clickEvent = clickEvent;

    if (self = [super initWithFrame:frame]) {
        
        [self setTitle:title forState:0];
        [self setTitleColor:titleColor forState:0];
        if (overstriking) {
            self.titleLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
        }else{
            self.titleLabel.font =  [UIFont systemFontOfSize:fontSize];

        }
        [self addTarget:self action:@selector(buttonEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;

}
-(void)buttonEvent{
    if (_clickEvent) {
        _clickEvent(self);
        
    }
    
}
@end
