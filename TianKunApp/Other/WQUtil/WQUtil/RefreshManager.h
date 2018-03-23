//
//  RefreshManager.h
//  SeekApp
//
//  Created by GuoMs on 16/7/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
@interface RefreshManager : NSObject
-(void)refreshOfheader:(UITableView *)view refreshGifHeader:(MJRefreshGifHeader *)header;
-(void)refreshOfUICollectionViewheader:(UICollectionView *)view refreshGifHeader:(MJRefreshGifHeader *)footerOrHeader;
+(RefreshManager *)shareInstance;
@end
