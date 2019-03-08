//
//  PointGoodsDetailViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/6/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface PointGoodsDetailViewController : WQBaseViewController
- (instancetype)initWithGoodsID:(NSInteger)goodsID;
@property (nonatomic, copy) dispatch_block_t buySucceedBlock;


@end
