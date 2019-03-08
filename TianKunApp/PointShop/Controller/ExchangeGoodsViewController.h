//
//  ExchangeGoodsViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/6/13.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class GoodsInfo;

@interface ExchangeGoodsViewController : WQBaseViewController

@property (nonatomic ,strong) GoodsInfo *goodsInfo;
@property (nonatomic, copy) dispatch_block_t succeedBlock;

@end
