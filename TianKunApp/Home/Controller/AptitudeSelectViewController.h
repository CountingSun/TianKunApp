//
//  AptitudeSelectViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"
typedef void(^SelectAptitudeSucceedBlock)(NSString *areaCode);

@interface AptitudeSelectViewController : WQBaseViewController
@property (nonatomic,copy) SelectAptitudeSucceedBlock succeedBlock;
-(instancetype)initWithSelectSucceedBlock:(SelectAptitudeSucceedBlock)succeedBlock;

@end
