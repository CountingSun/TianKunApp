//
//  AptitudeSelectViewController.h
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WQBaseViewController.h"

@class ClassTypeInfo;


typedef void(^SelectAptitudeSucceedBlock)(ClassTypeInfo *classTypeInfo,NSIndexPath *indexPath);

@interface AptitudeSelectViewController : WQBaseViewController

@property (nonatomic,copy) SelectAptitudeSucceedBlock succeedBlock;
@property (nonatomic ,strong) NSMutableArray *arrData;

@property (nonatomic ,strong) NSIndexPath *indexPath;


-(instancetype)initWithSelectSucceedBlock:(SelectAptitudeSucceedBlock)succeedBlock;

@end
