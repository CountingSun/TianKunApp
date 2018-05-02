//
//  SexSelectView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/8.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SexPickerViewDelegate
- (void)clickSexCancelButton;
- (void)clickSexFinishButtonWithSex:(NSString *)sex;

@end

@interface SexSelectView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic ,strong) NSMutableArray *arrSex;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (nonatomic ,weak) id <SexPickerViewDelegate> delegate;

@property (nonatomic ,assign) BOOL isShow;

- (void)show;
- (void)hidden;


@end
