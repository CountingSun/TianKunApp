//
//  PlayViewAuthorCollectionViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DocumentInfo;


@interface PlayViewAuthorCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introctLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookAllButton;
@property (nonatomic ,strong) DocumentInfo *documentInfo;

@property (nonatomic ,assign) BOOL isShowAll;
@property (nonatomic, copy) dispatch_block_t reloadCellBlock;
+ (CGSize)getCellHeightWithDocumentInfo:(DocumentInfo *)documentInfo isShowAll:(BOOL)isShowAll;

@end
