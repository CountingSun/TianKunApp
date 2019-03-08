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
#import "LocationManager.h"

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
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];

    [_saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [view addSubview:_saveButton];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];

    
}
- (void)seve{
    if (!_textField.text.length) {
        [self showErrorWithStatus:@"请输入标题"];
        return;
    }
//    if (!_classTypeInfo.typeID.length) {
//        [self showErrorWithStatus:@"请选择板块"];
//        return;
//
//    }
    if (!_textView.text.length) {
        [self showErrorWithStatus:@"请输入内容"];
        return;
    }
    [self public];
    
}
- (void)public{
    self.view.userInteractionEnabled = NO;
    
    [self showWithStatus:NET_WAIT_TOST];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLng] forKey:@"lng"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeLat] forKey:@"lat"];
    [dict setObject:[[LocationManager manager] getLoactionInfoWithType:LocationTypeCityCode] forKey:@"citiid"];

    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:_textField.text forKey:@"title"];
    [dict setObject:_textView.text forKey:@"content"];
    [dict setObject:@(0) forKey:@"category"];

    [[[NetWorkEngine alloc]init] postWithDict:dict url:BaseUrl(@"Forums/insertforum.action") succed:^(id responseObject) {

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (_succeedBlock) {
                _succeedBlock();
            }
            
            [self showSuccessWithStatus:@"发布成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];

            });
        }else{
            self.view.userInteractionEnabled = YES;

            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
                                                    
        
    } errorBlock:^(NSError *error) {
        self.view.userInteractionEnabled = YES;

        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
