//
//  WriteArticleViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "WriteArticleViewController.h"

@interface WriteArticleViewController ()
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation WriteArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"留言"];
    _commitButton.layer.masksToBounds = YES;
    _commitButton.layer.cornerRadius = _commitButton.qmui_height/2;
    [_commitButton setBackgroundColor:COLOR_THEME];
    QMUIEmotionInputManager *inputManager = [[QMUIEmotionInputManager alloc]init];
    inputManager.boundTextView = _textView;
    
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
