//
//  HomeSelectAddressViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/5/12.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class AddressInfo;

/**
 选择成功回调

 @param addressInfo 目前只返回了city id  和  name
 */
typedef void(^SelectAddressSuccedBlock)(AddressInfo *addressInfo);

@interface HomeSelectAddressViewController : WQBaseViewController

@property (nonatomic, copy) SelectAddressSuccedBlock selectAddressSuccedBlock;
@end
