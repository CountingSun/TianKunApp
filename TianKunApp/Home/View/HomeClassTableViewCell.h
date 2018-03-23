//
//  HomeClassTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuInfo;

@protocol HomeClassTableViewCellDelegate
- (void)didSelectCellWithMenuInfo:(MenuInfo *)menuInfo;
@end

@interface HomeClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,weak) id<HomeClassTableViewCellDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t noticeReloadCellHeight;


@end
