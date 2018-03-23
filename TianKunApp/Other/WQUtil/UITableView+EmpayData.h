//
//  UITableView+EmpayData.h
//  KMEEN.ZF
//
//  Created by Rookie on 16/5/12.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmpayData)

- (void)tableViewDisplayWitMsg:(NSString *) message withImage:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger) rowCount;

- (void)tableViewDisplayWitMsg:(NSString *)message withImage:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger) rowCount width:(CGFloat)widthIs height:(CGFloat)heightIs;

- (void)tableViewDisplayWitMsg:(NSString *)message  ifNecessaryForRowCount:(NSUInteger)rowCount;

- (void)tableViewDisplayWitMsg:(NSString *)message  ifNecessaryForRowCount:(NSUInteger)rowCount offset:(CGFloat)offset;


@end
