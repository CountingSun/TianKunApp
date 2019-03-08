//
//  SignInView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/6/13.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SignInView.h"

@interface SignInView()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end
@implementation SignInView
- (instancetype)initNib{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
        
    }
    return self;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = UIColorMask;
    
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 5;
    
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
    tap.delegate = self;
    
    [self addGestureRecognizer:tap];
    

}
- (void)setPoint:(NSString *)point{
    NSMutableAttributedString *resString = [[NSMutableAttributedString alloc] init];

    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"签到成功，获得" attributes:@{NSForegroundColorAttributeName:COLOR_TEXT_LIGHT}];
    [resString appendAttributedString:str1];

    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:point attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
    [resString appendAttributedString:str2];

    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:@"积分" attributes:@{NSForegroundColorAttributeName:COLOR_TEXT_LIGHT}];
    [resString appendAttributedString:str3];
    
    [_pointLabel setAttributedText:resString];
    
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(_baseView.frame, touchPoint)) {
        return NO;
    }
    
    return YES;
}

- (void)tapBack{
    [self removeFromSuperview];

}
- (IBAction)sureButtonClick:(id)sender {
    if (_finishBlock) {
        _finishBlock();
        
    }
    [self removeFromSuperview];
    
}

@end
