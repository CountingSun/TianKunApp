//
//  RegisterGetCodeTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterGetCodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *dynamicButton;
@property (nonatomic, copy) void(^textBlock)(NSString *text);
//@property (nonatomic, copy) dispatch_block_t buttonClick;



@end
