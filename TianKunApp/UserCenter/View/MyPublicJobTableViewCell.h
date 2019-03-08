//
//  MyPublicJobTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JobInfo;

@protocol MyPublicJobTableViewCellDelegate <NSObject>

- (void)clickEditButtonWithIndexPath:(NSIndexPath *)indexPath jobInfo:(JobInfo *)jobInfo;
- (void)clickDeleteButtonWithIndexPath:(NSIndexPath *)indexPath jobInfo:(JobInfo *)jobInfo;
- (void)clickmakeTopButtonWithIndexPath:(NSIndexPath *)indexPath jobInfo:(JobInfo *)jobInfo;


@end

@interface MyPublicJobTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *editButton;
@property (weak, nonatomic) IBOutlet QMUIButton *detailButton;
@property (weak, nonatomic) IBOutlet QMUIButton *makeTopButton;
@property (nonatomic ,strong) JobInfo *jobInfo;
@property (nonatomic ,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *refreshTimeLabel;

@property (nonatomic,weak) id<MyPublicJobTableViewCellDelegate>delegate;

@end
