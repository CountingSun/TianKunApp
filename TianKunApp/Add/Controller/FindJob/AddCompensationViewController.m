//
//  AddCompensationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/5.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddCompensationViewController.h"
#import "MenuInfo.h"

@interface AddCompensationViewController ()

@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) QMUIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;

@end

@implementation AddCompensationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"期望薪资"];
    _saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_saveButton setTitle:@"保存" forState:0];
    [_saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [_saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];
    _minTextField.keyboardType = UIKeyboardTypeNumberPad;
    _maxTextField.keyboardType = UIKeyboardTypeNumberPad;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
    
}

-(void)seve{
    if (!_minTextField.text.length&&!_maxTextField.text.length) {
        if (_selectSucceedBlock) {
            _selectSucceedBlock(0,0);
        }
        [self.navigationController popViewControllerAnimated:YES];

        return;
        
    }
    if ([_minTextField.text integerValue]>= [_maxTextField.text integerValue]) {
        [self showErrorWithStatus:@"最小薪资不能大于最大薪资"];
        return;
    }
    if (_selectSucceedBlock) {
        _selectSucceedBlock([_maxTextField.text integerValue],[_minTextField.text integerValue]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
