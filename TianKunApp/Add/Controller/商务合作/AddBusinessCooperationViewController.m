//
//  AddBusinessCooperationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddBusinessCooperationViewController.h"
#import "UserInfoEditTableViewCell.h"
#import "CooperationInfo.h"
#import "CooperationSelectAddressView.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "AddressInfo.h"
#import "NSString+WQString.h"

@interface AddBusinessCooperationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet QMUITextView *introductTextField;
@property (nonatomic ,strong) QMUIButton *saveButton;
@property (nonatomic ,strong) CooperationInfo *cooperationInfo;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) CooperationSelectAddressView *addressView;
@property (nonatomic ,assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic ,strong) NSMutableArray *arrResult;
@property (nonatomic, copy) NSString *addressIDsString;
@property (nonatomic, copy) NSString *addressNamesString;


@end

@implementation AddBusinessCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _footView;
    _tableView.rowHeight = 45;
    _cooperationInfo = [[CooperationInfo alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoEditTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoEditTableViewCell"];

    [self.titleView setTitle:@"商务合作"];
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
    if (!_cooperationInfo.initiator.length) {
        [self showErrorWithStatus:@"请输入单位名称"];
        return;
    }
    if (!_cooperationInfo.phone.length) {
        [self showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    if (![_cooperationInfo.phone isMobileNum]) {
        [self showErrorWithStatus:@"请输入正确的手机号码"];
        return;

    }
    if (!_arrResult.count) {
        [self showErrorWithStatus:@"请选择服务区域"];
        return;
    }
    if (!_cooperationInfo.linkman.length) {
        [self showErrorWithStatus:@"请输入联系人"];
        return;
    }
    if (!_cooperationInfo.address.length) {
        [self showErrorWithStatus:@"请选择商家地址"];
        return;
    }
    
    if (!_introductTextField.text.length) {
        [self showErrorWithStatus:@"请输入服务内容"];
        return;
    }
    [self showWithStatus:NET_WAIT_TOST];
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:_cooperationInfo.initiator forKey:@"initiator"];
    [dict setObject:_cooperationInfo.phone forKey:@"phone"];
    [dict setObject:_addressIDsString forKey:@"action_scope_list"];
    [dict setObject:_cooperationInfo.linkman forKey:@"linkman"];
    [dict setObject:_cooperationInfo.address forKey:@"address"];
    [dict setObject:_introductTextField.text forKey:@"content"];
    [dict setObject:_cooperationInfo.longitude forKey:@"longitude"];
    [dict setObject:_cooperationInfo.latitude forKey:@"latitude"];

    self.view.userInteractionEnabled = NO;
    
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"create.cooperationRequest") succed:^(id responseObject) {
        self.view.userInteractionEnabled = YES;

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
        self.view.userInteractionEnabled = YES;

    }];
    
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoEditTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoEditTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.indexPath = indexPath;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"名        称：";
            cell.textField.placeholder = @"请输入名称";
            cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                _cooperationInfo.initiator = string;
                
            };
            
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"手机号码：";
            cell.textField.placeholder = @"请输入手机号码";
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            
            cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                _cooperationInfo.phone = string;
            };

        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"服务区域：";
            cell.textField.placeholder = @"请选择服务区域";
            cell.textField.enabled = NO;
            if (_addressNamesString.length) {
                cell.textField.text = _addressNamesString;
            }

        }
            break;
        case 3:
        {
            cell.titleLabel.text = @"联  系  人：";
            cell.textField.placeholder = @"请输入联系人姓名";
            cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                _cooperationInfo.linkman = string;

            };

            
        }
            break;
        case 4:
        {
            cell.titleLabel.text = @"商家地址：";
            cell.textField.placeholder = @"请选择商家地址";
            if (_cooperationInfo.address.length) {
                cell.textField.text = [NSString stringWithFormat:@"%@%@",_cooperationInfo.address,_cooperationInfo.addressDetail] ;

            }
            cell.textField.enabled = NO;
        }
            break;
            
        default:
            break;
    }

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        self.addressView.hidden = NO;
        
        
    }
    if (indexPath.row == 4) {
        MapViewController *vc = [[MapViewController alloc]init];
        if (_centerCoordinate.latitude) {
            vc.centerCoordinate = _centerCoordinate;
        }
        if (_cooperationInfo.address.length) {
            vc.addressText = _cooperationInfo.address;
        }
        if (_cooperationInfo.addressDetail.length) {
            vc.addressDetail = _cooperationInfo.addressDetail;
            
        }

        vc.selectSucceedBlock = ^(CLLocationCoordinate2D centerCoordinate, NSString *addressText, NSString *addressDetail) {
            _centerCoordinate = centerCoordinate;
            
            _cooperationInfo.longitude = [NSString stringWithFormat:@"%@",@(centerCoordinate.longitude)];
            _cooperationInfo.latitude = [NSString stringWithFormat:@"%@",@(centerCoordinate.latitude)];

            _cooperationInfo.address = [NSString stringWithFormat:@"%@",addressText];
            _cooperationInfo.addressDetail = [NSString stringWithFormat:@"%@",addressDetail];

            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
            
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (CooperationSelectAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[CooperationSelectAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        [[AppDelegate sharedAppDelegate].window addSubview:self.addressView];
        _addressView.selectSucceed = ^(NSMutableArray *arrData) {
            _arrResult = arrData;
            _addressIDsString = @"";
            _addressNamesString = @"";

            [arrData enumerateObjectsUsingBlock:^(AddressInfo *addressInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                _addressIDsString = [_addressIDsString stringByAppendingString:addressInfo.addressID];
                _addressIDsString = [_addressIDsString stringByAppendingString:@","];
                _addressNamesString = [_addressNamesString stringByAppendingString:addressInfo.addressName];
                _addressNamesString = [_addressNamesString stringByAppendingString:@","];
            }];
            _addressIDsString = [_addressIDsString substringToIndex:_addressIDsString.length-1];
            _addressNamesString = [_addressNamesString substringToIndex:_addressNamesString.length-1];

        
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }
    
    return _addressView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
