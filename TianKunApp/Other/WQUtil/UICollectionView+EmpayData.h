//
//  UICollectionView+EmpayData.h
//  JRMedical
//
//  Created by a on 16/11/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (EmpayData)

- (void)collectionViewDisplayWitMsg:(NSString *) message withImage:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger) rowCount;

- (void)collectionViewDisplayWitMsg:(NSString *)message  ifNecessaryForRowCount:(NSUInteger)rowCount widthDuiQi:(NSInteger)tag;

@end
