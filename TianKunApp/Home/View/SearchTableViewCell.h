//
//  SearchTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *liShiImg;
@property (nonatomic, strong) UIButton *deleBtn;

@property (nonatomic, strong) NSDictionary *dataDic;

@end
