//
//  WQTableView.m
//  WeddingApp
//
//  Created by seekmac002 on 2017/12/5.
//  Copyright © 2017年 seek. All rights reserved.
//

#import "WQTableView.h"
#import "RefreshManager.h"

@implementation WQTableView

- (instancetype)initWithFrame:(CGRect)frame delegateAndDataScource:(id)delegateAndDataScource style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = delegateAndDataScource;
        self.dataSource = delegateAndDataScource;
        self.tableFooterView = [UIView new];
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate dataScource:(id)dataSource style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = delegate;
        self.dataSource = dataSource;
        self.tableFooterView = [UIView new];
        
    }
    return self;
}

- (void)headerWithRefreshingBlock:(dispatch_block_t)block{
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
            
        }
    }];

    
}
- (void)gifWithRefreshingBlock:(dispatch_block_t)block{
    
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                if (block) {
                    block();
                }

            }];
                // 隐藏更新时间
                header.lastUpdatedTimeLabel.hidden = YES;
                // 隐藏刷新状态
                header.stateLabel.hidden = YES;
            [self refreshOfheader:self refreshGifHeader:header];

}
- (void)footerWithRefreshingBlock:(dispatch_block_t)block{
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    
    
}

- (void)endRefresh{
    
    [self.header endRefreshing];
    [self.footer endRefreshing];
    
}
/**
 开始下拉刷新
 
 */
- (void)beginRefreshing{
    
    [self.header beginRefreshing];
    
    
}

- (void)refreshOfheader:(UITableView *)view refreshGifHeader:(MJRefreshGifHeader *)header{
    
    NSMutableArray *pullingImages = [NSMutableArray new];
    //    for (NSUInteger i = 1; i<=2; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_pull_refresh_%ld", i]];
    //        [pullingImages addObject:image];
    //    }
    
    UIImage *image = [UIImage imageNamed:@"ic_pull_refresh_normal"];
    [pullingImages addObject:image];
    UIImage *image2 = [UIImage imageNamed:@"ic_pull_refresh_ready"];
    [pullingImages addObject:image2];
    
    NSArray *arrimg = [NSArray arrayWithObject:[pullingImages firstObject]];
    [header setImages:arrimg  forState:MJRefreshStateIdle];
    NSArray *arrimg2 = [NSArray arrayWithObject:[pullingImages lastObject]];
    [header setImages:arrimg2  forState:MJRefreshStatePulling];
    NSMutableArray *progressImage = [NSMutableArray new];
    for (NSUInteger i = 0; i<9; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_pull_refresh_progress%ld", i]];
        [progressImage addObject:image];
    }
    [header setImages:progressImage forState:MJRefreshStateRefreshing];
    view.header = header;
}

@end
