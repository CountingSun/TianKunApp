//
//  RefreshManager.m
//  SeekApp
//
//  Created by GuoMs on 16/7/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "RefreshManager.h"
#import "MJRefresh.h"
@implementation RefreshManager
+(RefreshManager *)shareInstance{
    static RefreshManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
-(void)refreshOfheader:(UITableView *)view refreshGifHeader:(MJRefreshGifHeader *)header{

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

-(void)refreshOfUICollectionViewheader:(UICollectionView *)view refreshGifHeader:(MJRefreshGifHeader *)footerOrHeader{
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
    [footerOrHeader setImages:arrimg  forState:MJRefreshStateIdle];
    NSArray *arrimg2 = [NSArray arrayWithObject:[pullingImages lastObject]];
    [footerOrHeader setImages:arrimg2  forState:MJRefreshStatePulling];
    NSMutableArray *progressImage = [NSMutableArray new];
    for (NSUInteger i = 0; i<9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_pull_refresh_progress%ld", i]];
        [progressImage addObject:image];
    }
    [footerOrHeader setImages:progressImage forState:MJRefreshStateRefreshing];
    view.header = footerOrHeader;
}
@end
