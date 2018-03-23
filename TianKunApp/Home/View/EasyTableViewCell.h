//
//  EasyTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet QMUIButton *gsQueryButton;
@property (weak, nonatomic) IBOutlet QMUIButton *zzQueryButton;
@property (weak, nonatomic) IBOutlet QMUIButton *peopleQueryButton;

@property (weak, nonatomic) IBOutlet QMUIButton *projectQueryButton;
@property (weak, nonatomic) IBOutlet QMUIButton *cxQueryButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic ,strong) NSMutableArray *arrMenu;
@end
