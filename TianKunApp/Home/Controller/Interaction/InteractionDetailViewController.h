//
//  InteractionDetailViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class InteractionInfo;



@interface InteractionDetailViewController : WQBaseViewController
- (instancetype)initWithInteractionID:(NSString *)interactionID;
@property (nonatomic, copy) dispatch_block_t reloadBlock;

@end
