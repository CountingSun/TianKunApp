//
//  ThirdAccountModel.h
//  TianKunApp
//
//  Created by 天堃 on 2018/6/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdAccountModel : NSObject
@property (nonatomic, copy) NSString *othername;

/**
 0 qq; 1 wx; 2 tb;
 */
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic, copy) NSString *uid;

@end
