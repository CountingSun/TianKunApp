//
//  UserInfoPhotoTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoPhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UILabel *goLabel;

@property (nonatomic, copy) dispatch_block_t block;
@end
