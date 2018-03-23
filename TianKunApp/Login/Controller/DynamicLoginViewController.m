//
//  DynamicLoginViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "DynamicLoginViewController.h"
#import "RegisterGetCodeTableViewCell.h"
#import "TextFieldTableViewCell.h"

@interface DynamicLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (nonatomic ,assign) NSInteger countTime;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) NSString *codeString;
@property (nonatomic ,strong) UIButton *dynamicButton;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation DynamicLoginViewController

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
    
    [_loginButton setTitleColor:COLOR_WHITE forState:0];
    [_loginButton setBackgroundColor:COLOR_TEXT_ORANGE];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RegisterGetCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RegisterGetCodeTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeEditing)];
    [self.view addGestureRecognizer:tap];
    
    
}
-(void)closeEditing{
    [self.view endEditing:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
    
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
    }else{
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
        cell.textBlock = ^(NSString *text) {
            _codeString = text;
        };
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        return cell;
        
        
    }
    
}
- (void)userGetVefCode{
    
    
    if (!_nameString.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    [self.netWorkEngine postWithDict:@{@"iphone":_nameString,@"state":@"1"} url:BaseUrl(@"lg/getcode.action") succed:^(id responseObject) {
        
        
        NSString *msg = [responseObject objectForKey:@"value"];
        
        if (msg) {
            [self setCodeButton];
            [self showSuccessWithStatus:@"获取验证码成功"];
        }
        
        
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (void)setCodeButton{
    _dynamicButton.enabled = NO;
    
    [[GCDTimer sharedInstance] scheduledDispatchTimerWithName:@"code" timeInterval:1 queue:dispatch_queue_create(0, 0) repeats:YES actionOption:AbandonPreviousAction action:^{
        _countTime--;
        NSLog(@"%@",@(_countTime));
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dynamicButton setTitle:[NSString stringWithFormat:@"%@秒后从发",@(_countTime)] forState:0];
            
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
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}
- (IBAction)closeButtonClickEvetn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)backButtonClickEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)loginButtonClickEvent:(id)sender {
    if (!_nameString.length) {
        [self showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (!_codeString) {
        [self showErrorWithStatus:@"请输入动态码"];
        return;
    }
    [self userLogin];

}
- (void)userLogin{
    [self showWithStatus:NET_WAIT_TOST];
    
    [self.netWorkEngine postWithDict:@{@"iphone":_nameString,@"yzm":_codeString} url:BaseUrl(@"lg/login.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self.view endEditing:YES];
            [self showSuccessWithStatus:@"登录成功"];
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            [UserInfoEngine setUserInfo:userInfo];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEED_NOTICE object:nil];
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
