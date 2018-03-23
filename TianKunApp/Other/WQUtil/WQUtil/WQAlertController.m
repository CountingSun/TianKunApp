//
//  WQAlertController.m
//  WQUtil
//
//  Created by seekmac002 on 2017/8/22.
//  Copyright © 2017年 swq. All rights reserved.
//

#import "WQAlertController.h"

@implementation WQAlertController

+(void)showAlertControllerWithTitle:(NSString *)title
                            message:(NSString *)message
                    sureButtonTitle:(NSString *)sureButtonTitle
                        cancelTitle:(NSString *)cancelTitle
                          sureBlock:(sureBlock)sureBlock
                        cancelBlock:(cancelBlock)cancelBlock{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:sureButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureBlock(action);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock(action);

    }];
    [alertController addAction:setAction];
    [alertController addAction:cancelAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
    

    
}

@end
