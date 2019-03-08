//
//  CollectionViewHorizontalLayout.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/9.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewHorizontalLayout : UICollectionViewFlowLayout
//  一行中 cell 的个数
@property (nonatomic,assign) NSUInteger itemCountPerRow;
//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;

@end
