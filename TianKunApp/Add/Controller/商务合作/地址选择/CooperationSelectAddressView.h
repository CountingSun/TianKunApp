//
//  CooperationSelectAddressView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CooperationSelectAddressView : UIView

@property (nonatomic, copy) void(^selectSucceed)(NSMutableArray *arrData);

@end
