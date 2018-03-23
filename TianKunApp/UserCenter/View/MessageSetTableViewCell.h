//
//  MessageSetTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *detilLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectSwitch;

@end
