//
//  HomeInfoTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *choicenessLabel;
@property (weak, nonatomic) IBOutlet UILabel *choicenessDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionDetailLabel;
@end
