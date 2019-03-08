//
//  HomeInfoTableViewCell.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/20.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLoopScrollView.h"

@interface HomeInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (nonatomic ,strong) FSLoopScrollView *loopScrollView1;
@property (nonatomic ,strong) FSLoopScrollView *loopScrollView2;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (nonatomic ,strong) NSMutableArray *arrData;

@property (nonatomic, copy) void(^clickWithIndexBlock)(NSInteger index);

@property (nonatomic, copy) dispatch_block_t clickMainImageBlock;


@end
