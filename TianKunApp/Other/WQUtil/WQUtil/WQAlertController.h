//
//  WQAlertController.h
//  WQUtil
//
//  Created by seekmac002 on 2017/8/22.
//  Copyright © 2017年 swq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class QMUIAlertAction;

typedef void(^sureBlock)(QMUIAlertAction * action);
typedef void(^cancelBlock)(QMUIAlertAction * action);

@interface WQAlertController : NSObject

+(void)showAlertControllerWithTitle:(NSString *)title
                            message:(NSString *)message
                    sureButtonTitle:(NSString *)sureButtonTitle
                        cancelTitle:(NSString *)cancelTitle
                          sureBlock:(sureBlock)sureBlock
                        cancelBlock:(cancelBlock)cancelBlock;

@end
