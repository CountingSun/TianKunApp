//
//  SignInView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/6/13.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInView : UIView
- (instancetype)initNib;
@property (nonatomic ,assign) NSString *point;
@property (nonatomic, copy) dispatch_block_t finishBlock;



@end
