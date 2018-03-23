//
//  UIView+AddTapGestureRecognizer.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UIView+AddTapGestureRecognizer.h"
#import <objc/runtime.h>


@implementation UIView (AddTapGestureRecognizer)

- (void)addTapGestureRecognizerWithActionBlock:(dispatch_block_t)block{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSel)];
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self, @"ASSOCIATIONTapGestureRecognizer", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
}
-(void)tapSel{
    
    dispatch_block_t block = objc_getAssociatedObject(self, @"ASSOCIATIONTapGestureRecognizer");
    if (block) {
        block();
    }
    
}
@end
