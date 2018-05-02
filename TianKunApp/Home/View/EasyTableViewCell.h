//
//  EasyTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuInfo;

@interface EasyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (nonatomic, copy) void(^selectSucceed)(MenuInfo *menuInfo);
@end
