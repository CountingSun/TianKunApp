//
//  PlayViewShareCollectionViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DocumentInfo;

@interface PlayViewShareCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;
@property (weak, nonatomic) IBOutlet QMUIButton *shareButton;
@property (nonatomic ,strong) DocumentInfo *documentInfo;

@property (weak, nonatomic) IBOutlet UILabel *publicLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

+ (CGSize)getCellHeightWithDocumentInfo:(DocumentInfo *)documentInfo ;
@end
