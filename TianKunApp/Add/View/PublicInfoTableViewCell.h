//
//  PublicInfoTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIImageView *rowImageView;
@property (nonatomic, copy) void(^textBlock)(NSString *text);

@end
