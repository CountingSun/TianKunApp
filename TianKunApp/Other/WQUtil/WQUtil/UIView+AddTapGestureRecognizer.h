//
//  UIView+AddTapGestureRecognizer.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddTapGestureRecognizer)

/**
 为view添加单击手势

 @param block <#block description#>
 */
- (void)addTapGestureRecognizerWithActionBlock:(dispatch_block_t)block;

@end
