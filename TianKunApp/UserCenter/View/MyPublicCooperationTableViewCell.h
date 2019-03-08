//
//  MyPublicCooperationTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/4.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CooperationInfo;

@protocol MyPublicCooperationTableViewCellDelegate <NSObject>

- (void)clickEditButtonWithIndexPath:(NSIndexPath *)indexPath cooperationInfo:(CooperationInfo *)cooperationInfo;
- (void)clickDeleteButtonWithIndexPath:(NSIndexPath *)indexPath cooperationInfo:(CooperationInfo *)cooperationInfo;


@end



@interface MyPublicCooperationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *editButton;
@property (weak, nonatomic) IBOutlet QMUIButton *detailButton;

@property (nonatomic ,strong) CooperationInfo *cooperationInfo;
@property (nonatomic ,strong) NSIndexPath *indexPath;

@property (nonatomic,weak) id<MyPublicCooperationTableViewCellDelegate>delegate;


@end
