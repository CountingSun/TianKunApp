//
//  HomeInfoTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPScrollView.h"

@interface HomeInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (nonatomic ,strong) CCPScrollView *ccpView;
@property (nonatomic ,strong) CCPScrollView *ccpView2;
@property (nonatomic ,strong) NSMutableArray *arrData;

@property (nonatomic, copy) void(^clickWithIndexBlock)(NSInteger index);


@end
