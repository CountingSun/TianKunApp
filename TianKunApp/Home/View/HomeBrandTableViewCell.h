//
//  HomeBrandTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyInfo;

@interface HomeBrandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@property (nonatomic, copy) void(^collectionViewDidSelectItemBlock)(CompanyInfo *companyInfo,NSIndexPath *indexPath);
@end
