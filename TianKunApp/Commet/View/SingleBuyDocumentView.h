//
//  SingleBuyDocumentView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleBuyDocumentView : UIView
@property (weak, nonatomic) IBOutlet QMUIButton *alyButton;
@property (weak, nonatomic) IBOutlet QMUIButton *wxButton;

@property (nonatomic ,assign) NSInteger documentID;

@property (nonatomic, copy) dispatch_block_t pauSucceedBlock;
- (instancetype)initWithNib;
- (void)showSingleBuyDocumentView;

- (void)hiddenSingleBuyDocumentView;

@end
