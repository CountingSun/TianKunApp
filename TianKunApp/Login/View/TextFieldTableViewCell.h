//
//  TextFieldTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) void(^textBlock)(NSString *text);

@end
