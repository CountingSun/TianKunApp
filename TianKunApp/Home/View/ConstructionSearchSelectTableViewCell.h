//
//  ConstructionSearchSelectTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassTypeInfo;

@protocol ConstructionSearchSelectDelegate <NSObject>
- (void)selectWithClassTypeInfo:(ClassTypeInfo *)classTypeInfo index:(NSInteger)index;

@end


@interface ConstructionSearchSelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic, copy) dispatch_block_t reloadHeightBlock;
@property (nonatomic, copy) NSString *lastTitle;

@property (nonatomic ,weak) id<ConstructionSearchSelectDelegate> delegate;
+ (CGFloat)getCellHeightWithArr:(NSMutableArray *)arr;

@end
