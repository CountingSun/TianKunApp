//
//  RegisterViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginTextTableViewCell.h"
#import "RegisterGetCodeTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "LoginAgreementViewController.h"
#import "AgreementPreviewController.h"

@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource,ClickSecureButtonDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) NSString *codeString;
@property (nonatomic, copy) NSString *passwordString;
@property (nonatomic ,strong) UIButton *dynamicButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic ,assign) NSInteger countTime;


@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (weak, nonatomic) IBOutlet QMUIButton *agreementButton;

@end

@implementation RegisterViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([[GCDTimer sharedInstance] existTimer:@"code"]) {
        [[GCDTimer sharedInstance] cancelTimerWithName:@"code"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headView;
    _tableView.tableFooterView = self.footView;
    _tableView.rowHeight = 45;
    _tableView.backgroundColor = COLOR_VIEW_BACK;
    _headView.backgroundColor = COLOR_VIEW_BACK;
    _footView.backgroundColor = COLOR_VIEW_BACK;
    _countTime = GET_CODE_TIME;

    [_registerButton setBackgroundColor:COLOR_THEME];
    [_loginButton setTitleColor:COLOR_TEXT_BLACK forState:0];

    [_tableView registerNib:[UINib nibWithNibName:@"LoginTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"LoginTextTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RegisterGetCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RegisterGetCodeTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeEditing)];
    [self.view addGestureRecognizer:tap];
    _agreeButton.selected = YES;
    
    [_agreeButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [_agreeButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];


    
}
-(void)closeEditing{
    [self.view endEditing:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        RegisterGetCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterGetCodeTableViewCell" forIndexPath:indexPath];
        
        cell.textBlock = ^(NSString *text) {
            _nameString = text;
        };
        _dynamicButton  = cell.dynamicButton;
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
        [_dynamicButton addTarget:self action:@selector(userGetVefCode) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 1){
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
        cell.textBlock = ^(NSString *text) {
            _codeString = text;
        };
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        return cell;

        
    }else{
        LoginTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginTextTableViewCell" forIndexPath:indexPath];
        cell.texeField.placeholder = @"密码";
        cell.delegate = self;
        cell.indexPath = indexPath;

        cell.textBlock = ^(NSString *text) {
            _passwordString = text;
        };
        cell.texeField.secureTextEntry = YES;
        cell.actionButton.hidden = NO;
        cell.texeField.keyboardType = UIKeyboardTypeDefault;

        return cell;

    }
}
- (IBAction)closeButtonClickEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginButtonClickEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registerButtonClickEvent:(id)sender {
    if (!_nameString.length) {
        [self showErrorWithStatus:@"请输入账号"];
        return;
    }
    if (![_nameString isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }

    if (!_codeString.length) {
        [self showErrorWithStatus:@"请输入动态码"];
        return;
    }
    
    if (!_passwordString.length) {
        [self showErrorWithStatus:@"请输入密码"];

        return;
    }
    if (_passwordString.length<6) {
        [self showErrorWithStatus:@"密码长度需不少于6位"];
        return;

        
    }
    if (_passwordString.length>18) {
        [self showErrorWithStatus:@"密码长度需不大于于18位"];
        return;
        
    }
    if ([_passwordString includeChinese]) {
        [self showErrorWithStatus:@"密码不能包含汉字"];
        return;

    }
    if (!_agreeButton.selected) {
        [self showErrorWithStatus:@"请同意用户协议"];
        return;
    }
    [self userRegister];
    
}
- (void)userGetVefCode{
    
    
    if (!_nameString.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
    }
    [self showWithStatus:NET_WAIT_TOST];
    [self.netWorkEngine postWithDict:@{@"iphone":_nameString,@"state":@"0"} url:BaseUrl(@"lg/getcode.action") succed:^(id responseObject) {

        
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 1) {
                [self setCodeButton];
                [self showSuccessWithStatus:@"获取验证码成功"];
        }else{
            NSString *msg = [responseObject objectForKey:@"msg"];
            [self showErrorWithStatus:msg];

        }


    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];

    }];

}
- (void)userRegister{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameter setValue:_nameString forKey:@"iphone"];
    [parameter setValue:_codeString forKey:@"yzm"];
    [parameter setValue:[_passwordString qmui_md5] forKey:@"pwd"];
    [self showWithStatus:NET_WAIT_TOST];
    self.view.userInteractionEnabled = NO;
    
    [self.netWorkEngine postWithDict:parameter url:BaseUrl(@"lg/registered.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        self.view.userInteractionEnabled = YES;

        if (code == 1) {
            [self.view endEditing: YES];
            [self showSuccessWithStatus:@"注册成功,请前去登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            NSString *msg = [responseObject objectForKey:@"msg"];
            [self showErrorWithStatus:msg];
            
        }
        

    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;

    }];
    
}
- (void)setCodeButton{
    _dynamicButton.enabled = NO;
    
    [[GCDTimer sharedInstance] scheduledDispatchTimerWithName:@"code" timeInterval:1 queue:dispatch_queue_create(0, 0) repeats:YES actionOption:AbandonPreviousAction action:^{
        _countTime--;
        NSLog(@"%@",@(_countTime));
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dynamicButton setTitle:[NSString stringWithFormat:@"%@秒后重发",@(_countTime)] forState:0];
            
        });
        
        
        if (_countTime == 0) {
            if ([[GCDTimer sharedInstance] existTimer:@"code"]) {
                [[GCDTimer sharedInstance] cancelTimerWithName:@"code"];
                _countTime = GET_CODE_TIME;
                
                _dynamicButton.enabled = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_dynamicButton setTitle:@"获取动态码" forState:0];
                    
                });
                
            }else{
                
            }
            
            
        }
    }];

}
- (void)clickSecureButton:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    LoginTextTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (cell.actionButton.selected) {
        cell.texeField.secureTextEntry = NO;
        
    }else{
        cell.texeField.secureTextEntry = YES;
        
    }

}
- (IBAction)agreementButtonClick:(id)sender {
    AgreementPreviewController *vc = [[AgreementPreviewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController presentViewController:[AgreementPreviewController new] animated:YES completion:^{
    
//    }];
    
}
- (IBAction)agreeButtonClick:(id)sender {
    _agreeButton.selected =! _agreeButton.selected;
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    
    NSLog(@"dealloc");
}
@end
