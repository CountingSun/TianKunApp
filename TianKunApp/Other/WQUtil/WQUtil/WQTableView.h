//
//  WQTableView.h
//  WeddingApp
//
//  Created by seekmac002 on 2017/12/5.
//  Copyright © 2017年 seek. All rights reserved.
//

#import <UIKit/UIKit.h>

// 是否隐藏更新时间

#define lastUpdatedTimeLabelHidden YES
// 是否隐藏刷新状态

#define stateLabelHidden YES

@interface WQTableView : UITableView

/**
 初始化方法

 @param frame <#frame description#>
 @param delegateAndDataScource <#delegateAndDataScource description#>
 @param style <#style description#>
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame delegateAndDataScource:(id)delegateAndDataScource style:(UITableViewStyle)style;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate dataScource:(id)dataSource style:(UITableViewStyle)style;


/**
 下拉刷新

 @param block <#block description#>
 */
- (void)headerWithRefreshingBlock:(dispatch_block_t)block;


/**
 上拉加载更多

 @param block <#block description#>
 */
- (void)footerWithRefreshingBlock:(dispatch_block_t)block;

/**
 停止下拉刷新和下拉加载更多
 */
- (void)endRefresh;

/**
 开始下拉刷新

 */
- (void)beginRefreshing;


/**
 下拉刷新上面的提示块是图片
 
 须设置图片
 
 @param block <#block description#>
 */
- (void)gifWithRefreshingBlock:(dispatch_block_t)block;

@end
