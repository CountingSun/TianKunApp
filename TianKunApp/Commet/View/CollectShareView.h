//
//  CollectShareView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectShareView : UIView
@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;
@property (weak, nonatomic) IBOutlet QMUIButton *shareButton;

@property (nonatomic, copy) dispatch_block_t collectButtonBlock;
@property (nonatomic, copy) dispatch_block_t shareButtonBlock;


+(instancetype)collectShareView;



@end
