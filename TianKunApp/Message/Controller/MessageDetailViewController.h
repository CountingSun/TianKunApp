//
//  MessageDetailViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface MessageDetailViewController : WQBaseViewController

@property (nonatomic, copy) dispatch_block_t readBlock;

- (instancetype)initWithMessageID:(NSInteger)messageID isRead:(NSInteger)isRead;


@end
