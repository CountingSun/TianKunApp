//
//  EducationTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *isFreeLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@end
