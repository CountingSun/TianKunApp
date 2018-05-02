//
//  CommentTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentInfo;

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic ,strong) CommentInfo *commentInfo;
@property (nonatomic, copy) void(^clickButtonBlock)(CommentInfo *commentInfo);
@end
