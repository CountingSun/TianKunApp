//
//  MyPublicInteractionListTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/14.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InteractionInfo;

@protocol MyPublicInteractionListTableViewCellDelegate  <NSObject>

- (void)deleteInteractionWithInteractionInfo:(InteractionInfo *)interactionInfo indexPath:(NSIndexPath *)indexPath;

@end

@interface MyPublicInteractionListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *deleteButton;


@property (nonatomic ,strong) InteractionInfo *interactionInfo;
@property (nonatomic ,strong) NSIndexPath *indexPath;


@property (nonatomic, weak) id<MyPublicInteractionListTableViewCellDelegate>delegate;
@end
