//
//  MapViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@interface MapViewController : WQBaseViewController
@property (nonatomic, copy) void(^selectSucceedBlock)(CLLocationCoordinate2D centerCoordinate,NSString *addressText,NSString *addressDetail);

@property (nonatomic ,assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, copy) NSString *addressText;
@property (nonatomic, copy) NSString *addressDetail;

@end
