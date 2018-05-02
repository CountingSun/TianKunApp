//
//  ArticleDetailTimeTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleDetailTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *shareButton;

@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;
@end
