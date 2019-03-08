//
//  PlayViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class DocumentInfo;

@interface PlayViewController : WQBaseViewController

- (instancetype)initWithDocumentID:(NSInteger)documentID;

@property (nonatomic, copy) dispatch_block_t reloadBlock;

@end
