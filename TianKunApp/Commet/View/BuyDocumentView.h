//
//  BuyDocumentView.h
//  TianKunApp
//
//  Created by 天堃 on 2018/4/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BuyDocumentViewDelegate <NSObject>

- (void)buyVIPButtonClickDelegate;
- (void)buyDocumentButtonClickDelegate;

@end

@interface BuyDocumentView : UIView
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UIButton *buyVIPButton;
@property (weak, nonatomic) IBOutlet UIButton *buyDocumentButton;

@property (nonatomic,weak) id<BuyDocumentViewDelegate> delegate;

- (instancetype)initWithNib;
- (void)showBuyDocumentView;

- (void)hiddenBuyDocumentView;

@end
