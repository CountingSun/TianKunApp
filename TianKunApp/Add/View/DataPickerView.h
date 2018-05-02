//
//  DataPickerView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataPickerViewDelegate
- (void)clickCancelButton;
- (void)clickFinishButtonWithNowDateYear:(NSString *)year month:(NSString *)month;

@end


@interface DataPickerView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic ,weak) id <DataPickerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (nonatomic ,assign) BOOL isShow;
- (void)show;
- (void)hidden;

@end
