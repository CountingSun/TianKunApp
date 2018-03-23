//
//  LoginTextTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickSecureButtonDelegate
- (void)clickSecureButton:(UIButton *)button indexPath:(NSIndexPath *)indexPath;

@end


@interface LoginTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet QMUITextField *texeField;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) id<ClickSecureButtonDelegate> delegate;
@property (nonatomic ,strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^textBlock)(NSString *text);

@end
