//
//  WriteArticleViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface WriteArticleViewController : WQBaseViewController

/**
 <#Description#>

 @param articleID <#articleID description#>
 @param fromType 1 文件通知 2 公示公告
 @return <#return value description#>
 */
- (instancetype)initWithArticleID:(NSInteger)articleID fromType:(NSInteger)fromType;

@property (nonatomic, copy) dispatch_block_t succeedBlcok;

@end
