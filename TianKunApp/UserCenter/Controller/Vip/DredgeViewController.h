//
//  DredgeViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface DredgeViewController : WQBaseViewController
@property (nonatomic ,assign) NSInteger messageID;
@property (nonatomic, copy) dispatch_block_t succeedBlock;
@end
