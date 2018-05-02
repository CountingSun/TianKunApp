//
//  DataPickerView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "DataPickerView.h"

@interface DataPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,strong) NSMutableArray *arrYear;
@property (nonatomic ,strong) NSMutableArray *arrMonth;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@end


@implementation DataPickerView

- (void)awakeFromNib{
    [super awakeFromNib];
    
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

    _datePicker.delegate = self;
    _datePicker.dataSource = self;
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
    
    [_datePicker mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_baseView);
        make.top.equalTo(_lineView.mas_bottom);
        make.bottom.equalTo(_baseView.mas_bottom);
        
        
    }];

    _year = [NSString stringWithFormat:@"%@年",self.arrYear[0]];
    _month = [NSString stringWithFormat:@"%@月",self.arrMonth[0]];

    
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.arrYear.count;
    }
    return self.arrMonth.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [NSString stringWithFormat:@"%@年",self.arrYear[row]];
        
    }else{
        return [NSString stringWithFormat:@"%@月",self.arrMonth[row]];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        [self getMonthWithYear:[_arrYear[row] integerValue]];
        [_datePicker reloadComponent:1];
        _year = [NSString stringWithFormat:@"%@年",self.arrYear[row]];

    }else{
        _month = [NSString stringWithFormat:@"%@月",self.arrMonth[row]];
    }
}
- (NSMutableArray *)arrYear{
    if (!_arrYear) {
        _arrYear = [NSMutableArray arrayWithCapacity:100];
       NSString *now =  [self getCurrentTimesWithFommatterStr:@"YYYY"];
        for (NSInteger i = 0; i<150; i++) {
            
            NSInteger year = [now integerValue];
            year = year-i;
            [_arrYear addObject:@(year)];
            if (i == 0) {
                [self getMonthWithYear:year];
            }
        }
    }
    return _arrYear;
}
- (NSMutableArray *)arrMonth{
    if (!_arrMonth) {
        _arrMonth = [NSMutableArray arrayWithCapacity:12];
    }
    return _arrMonth;
}
- (NSMutableArray *)getMonthWithYear:(NSInteger)year{
    
    
    if (year == [[self getCurrentTimesWithFommatterStr:@"YYYY"] integerValue]) {
        [self.arrMonth removeAllObjects];

        NSInteger month = [[self getCurrentTimesWithFommatterStr:@"M"] integerValue];
        
        for (NSInteger i = 0; i<month; i++) {
            [self.arrMonth addObject:@(i+1)];
            
        }

    }else{
        if (self.arrMonth.count == 12) {
            return self.arrMonth;
        }
        else{
            [self.arrMonth removeAllObjects];
        }
        for (NSInteger i = 0; i<12; i++) {
            [self.arrMonth addObject:@(i+1)];
            
        }
    }
    return _arrMonth;
}
- (NSString*)getCurrentTimesWithFommatterStr:(NSString *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:str];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
- (IBAction)cancelButtonClick:(id)sender {
    if (_delegate) {
        [_delegate clickCancelButton];
        
    }
}
- (IBAction)finishButtonClick:(id)sender {
    if (_delegate) {
        [_delegate clickFinishButtonWithNowDateYear:_year month:_month];
        
    }
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
