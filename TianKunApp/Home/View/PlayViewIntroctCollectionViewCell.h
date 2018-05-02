//
//  PlayViewIntroctCollectionViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewIntroctCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, copy) NSString *detailString;
@property (weak, nonatomic) IBOutlet UIView *linLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

+(CGSize)getCellHeightWithDetailString:(NSString *)detailString;
@end
