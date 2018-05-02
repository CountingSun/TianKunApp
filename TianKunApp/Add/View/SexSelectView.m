//
//  SexSelectView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/8.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SexSelectView.h"
@interface SexSelectView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (nonatomic, copy) NSString *sex;

@end

@implementation SexSelectView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    self.backgroundColor = UIColorMask;
    [_cancelButton setTitleColor:COLOR_THEME forState:0];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = 15;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.borderColor = COLOR_VIEW_SEGMENTATION.CGColor;
    _cancelButton.backgroundColor = [UIColor whiteColor];
    
    [_finishButton setTitleColor:COLOR_WHITE forState:0];
    _finishButton.layer.masksToBounds = YES;
    _finishButton.layer.cornerRadius = 15;
    _finishButton.backgroundColor = COLOR_THEME;
    
    _isShow = NO;
    [_cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_baseView).offset(10);
        make.width.offset(80);
        make.height.offset(30);
    }];
    [_finishButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_baseView).offset(10);
        make.width.offset(80);
        make.height.offset(30);
    }];
    
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_baseView);
        make.height.offset(1);
        make.top.equalTo(_finishButton.mas_bottom).offset(10);
    }];
    
    [_pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_baseView);
        make.top.equalTo(_lineView.mas_bottom);
        make.bottom.equalTo(_baseView.mas_bottom);
        
        
    }];
    _sex = @"1";

    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrSex.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.arrSex[row] isEqualToString:@"1"]) {
        return @"男";
    }else{
        return @"女";

    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _sex = self.arrSex[row];

}

- (IBAction)cancelButtonClick:(id)sender {
    if (_delegate) {
        [_delegate clickSexCancelButton];
        
    }

}
- (IBAction)finishButtonClick:(id)sender {
    if (_delegate) {
        [_delegate clickSexFinishButtonWithSex:_sex];
        
        }
}
- (NSMutableArray *)arrSex{
    if (!_arrSex) {
        _arrSex = [NSMutableArray array];
        [_arrSex addObject:@"1"];
        [_arrSex addObject:@"2"];

    }
    return _arrSex;
}
- (void)show{
    _isShow = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = NO;
        [_baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.offset(210);
        }];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)hidden{
    _isShow = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        [_baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(210);
            make.bottom.equalTo(self).offset(_baseView.qmui_width);
            
        }];
        [self layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

@end
