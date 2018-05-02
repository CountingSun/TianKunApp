//
//  AddEnterpriseCcommunicationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddEnterpriseCcommunicationViewController.h"
#import "UIView+AddTapGestureRecognizer.h"
#import "AddEnterpriseSelectViewController.h"
#import "ClassTypeInfo.h"

@interface AddEnterpriseCcommunicationViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) QMUIButton *saveButton;
@property (nonatomic ,strong) ClassTypeInfo *classTypeInfo;
@end

@implementation AddEnterpriseCcommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"互动交流"];

    [self setupUI];
}

- (void)setupUI{
    _textField.maximumTextLength = 20;
    [_selectView addTapGestureRecognizerWithActionBlock:^{
        AddEnterpriseSelectViewController *vc = [[AddEnterpriseSelectViewController alloc]init];
        vc.selectSucceedBlock = ^(ClassTypeInfo *classTypeInfo) {
            _classTypeInfo = classTypeInfo;
            
            _label.text = classTypeInfo.typeName;
        } ;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    _saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_saveButton setTitle:@"发布" forState:0];
    [_saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [_saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];

    
}
- (void)seve{
    if (!_textField.text.length) {
        [self showErrorWithStatus:@"请输入标题"];
        return;
    }
    if (!_classTypeInfo.typeID.length) {
        [self showErrorWithStatus:@"请选择板块"];
        return;

    }
    if (!_textView.text.length) {
        [self showErrorWithStatus:@"请输入内容"];
        return;
    }
    [self public];
    
}
- (void)public{
    [self showWithStatus:NET_WAIT_TOST];
    [[[NetWorkEngine alloc]init] postWithDict:@{@"user_id":[UserInfoEngine getUserInfo].userID,@"title":_textField.text,@"content":_textView.text,@"category":_classTypeInfo.typeID} url:BaseUrl(@"Forums/insertforum.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            
            [self showSuccessWithStatus:@"发布成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];

            });
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
                                                    
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
