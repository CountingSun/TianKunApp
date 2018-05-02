//
//  AddressTableViewCell.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressInfo;
@interface AddressTableViewCell : UITableViewCell
@property (nonatomic,strong) AddressInfo * addressInfo;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;
@end
