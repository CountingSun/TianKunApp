//
//  AddResumeIntructViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/5.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddResumeIntructViewController.h"
#import "AddFindJobEditNetEngine.h"

@interface AddResumeIntructViewController ()
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (nonatomic ,strong) QMUIButton *saveButton;
@property (nonatomic ,strong) AddFindJobEditNetEngine *editNetEngine;

@end

@implementation AddResumeIntructViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"个人介绍"];
    _textView.autoResizable = YES;
    _textView.text = _textStr;
    _saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_saveButton setTitle:@"保存" forState:0];
    [_saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [_saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];

}
-(void)seve{
    [self editUserInfo];
    
}

- (void)editUserInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self showWithStatus:NET_WAIT_TOST];
    
    if (_textView.text.length) {
        [dict setObject:_textView.text forKey:@"self_evaluate"];
    }else{
        [self showErrorWithStatus:@"请输入个人简介"];
    }
    
    [dict setObject:_resumeID forKey:@"id"];
    
    if (!_editNetEngine) {
        _editNetEngine = [[AddFindJobEditNetEngine alloc]init];
        
    }
    
    [_editNetEngine editWithParameterDict:dict succeedBlock:^(NSInteger code,NSString *msg) {
        if (code == 1) {
            [self showSuccessWithStatus:@"保存成功"];
            if (_textChangeBlock) {
                _textChangeBlock(_textView.text);
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [self showErrorWithStatus:msg];
            
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
