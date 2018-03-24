//
//  UserInfoEditTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^editBlock)(NSString *string,NSIndexPath *indexPath);
@interface UserInfoEditTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) editBlock editBlock;
@property (nonatomic ,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
