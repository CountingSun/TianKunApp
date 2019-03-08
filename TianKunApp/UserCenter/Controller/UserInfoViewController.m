//
//  UserInfoViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoEditTableViewCell.h"
#import "UserInfoHeadTableViewCell.h"
#import "UserInfoPhotoTableViewCell.h"
#import "UIView+AddTapGestureRecognizer.h"
#import "BusinessLicenseViewController.h"
#import "WQUploadSingleImage.h"
#import "EditPhoneViewController.h"
#import "SexSelectView.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,SexPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,assign) BOOL canEdit;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;

@property (nonatomic ,strong) UserInfo *userInfo;
@property (nonatomic ,strong) SexSelectView *sexSelectView;

@property (nonatomic ,strong) UIButton *editButton;


@end

@implementation UserInfoViewController
- (instancetype)initWithUserInfo:(UserInfo *)userInfo{
    if (self = [super init]) {
        _userInfo = userInfo;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    _canEdit = YES;
    _editButton.selected = YES;

    [self showLoadingView];
    
    [self getUserInfo];
    


}
- (void)getUserInfo{
    _editButton.enabled = NO;
    
    [self.netWorkEngine postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} url:BaseUrl(@"my/userdetail.action") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSLog(@"responseObject:%@",responseObject);
        if(code == 1 ){
            _editButton.enabled = YES;

            _userInfo = [UserInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"value"] objectForKey:@"usermessage"]];
            [UserInfoEngine setUserInfo:_userInfo];
            [self.tableView reloadData];
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];

        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        [self hideLoadingView];

    }];
    
}
- (void)tapEndEditing{
    [self.view endEditing:YES];
}
- (void)editButtobClick:(UIButton *)button{
//    if ([button isSelected]) {

        [self editUserInfo];
//    }else{
//        _canEdit = YES;
//        button.selected = YES;
//        [self.tableView reloadData];
//
//
//    }
    
    
    
}
- (void)editUserInfo{
    _editButton.enabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [dict setObject:_userInfo.name forKey:@"name"];
    [dict setObject:_userInfo.nickname forKey:@"nickname"];
    [dict setObject:@(_userInfo.sex) forKey:@"sex"];
    [dict setObject:_userInfo.company_name forKey:@"company_name"];

    [self showWithStatus:NET_WAIT_TOST];
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"my/editusermessage.action") succed:^(id responseObject) {
        _editButton.enabled = YES;
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"修改成功"];
            [UserInfoEngine setUserInfo:_userInfo];
            [self.tableView reloadData];

        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        _editButton.enabled = YES;
    }];
    
}

- (void)setupView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.titleView setTitle:@"个人详情"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoEditTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoEditTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoHeadTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoPhotoTableViewCell"];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTintColor:COLOR_TEXT_BLACK];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:COLOR_TEXT_BLACK forState:0];
    [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(editButtobClick:) forControlEvents:UIControlEventTouchUpInside];
    _editButton = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEndEditing)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;

}
- (void)setupNav{
    
}
- (SexSelectView *)sexSelectView{
    if (!_sexSelectView) {
        _sexSelectView = [[[NSBundle mainBundle] loadNibNamed:@"SexSelectView" owner:nil options:nil] firstObject];
        [self.view addSubview:_sexSelectView];
        [_sexSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        _sexSelectView.delegate = self;
        
    }
    return _sexSelectView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UserInfoHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHeadTableViewCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (_canEdit) {
            cell.headImage.userInteractionEnabled = NO;
        }else{
            cell.headImage.userInteractionEnabled = NO;

        }
        [cell.headImage sd_imageWithUrlStr:_userInfo.headimg placeholderImage:@"头像"];
        
        return cell;
    }else if (indexPath.section == 1){
        UserInfoEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoEditTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoEditTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.indexPath = indexPath;
        if (_canEdit) {
            cell.textField.enabled = YES;

        }else{
            cell.textField.enabled = NO;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;

        switch (indexPath.row) {
            case 0:
            {
                cell.titleLabel.text = @"姓        名：";
                cell.textField.placeholder = @"请输入姓名";
                cell.textField.text = _userInfo.name;
                cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                    _userInfo.name = string;
                };

            }
                break;
            case 1:
            {
                cell.titleLabel.text = @"昵        称：";
                cell.textField.placeholder = @"请输入昵称";
                cell.textField.text = _userInfo.nickname;
                cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                    _userInfo.nickname = string;
                };

            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"性        别：";
                cell.textField.placeholder = @"请选择性别";
                cell.textField.enabled = NO;

                if (_userInfo.sex == 1) {
                    cell.textField.text = @"男";
                }else{
                    cell.textField.text = @"女";
                }
                
            }
                break;
            case 3:
            {
                cell.titleLabel.text = @"手  机  号：";
                cell.textField.placeholder = @"请输入手机号";
                cell.textField.text = _userInfo.phone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textField.userInteractionEnabled = NO;
                
            }
                break;
            case 4:
            {
                cell.titleLabel.text = @"企业名称：";
                cell.textField.placeholder = @"请输入企业名称";
                cell.textField.text = _userInfo.company_name;
                cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                    _userInfo.company_name = string;
                };

            }
                break;
                
            default:
                break;
        }
        return cell;

    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
                cell.textLabel.textColor = COLOR_TEXT_BLACK;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }
            cell.textLabel.text = @"我的认证";
            cell.selectionStyle = 0;
            return cell;
        }else{
            UserInfoPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoPhotoTableViewCell" forIndexPath:indexPath];
            [cell.upImageView sd_imageWithUrlStr:_userInfo.picture_url placeholderImage:@"上传-image"];
            
            BOOL canChange = YES;
            
            switch (_userInfo.status) {
                case 1:
                    {
                    cell.goLabel.text = @"待审核";
                        canChange = NO;
                        
                    }
                    break;
                case 2:
                {
                    cell.goLabel.text = @"审核中";
                    canChange = NO;

                }
                    break;
                case 3:
                {
                    cell.goLabel.text = @"审核通过";
                    canChange = NO;

                }
                    break;
                case 4:
                {
                    cell.goLabel.text = @"审核未通过";
                }
                    break;

                default:{
                    cell.goLabel.text = @"去认证";
                }
                    break;
            }
            cell.block = ^{
                    BusinessLicenseViewController *vc = [[BusinessLicenseViewController alloc]initWithUserInfo:_userInfo succeedBlock:^(NSString *urlStr) {
                        [self getUserInfo];
                    }];
                    vc.canEdit = canChange;
                    [self.navigationController pushViewController:vc animated:YES];

            };
            

            return cell;

        }
        
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 4;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 105;
    }else if (indexPath.section == 1) {
        return 45;
        
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else{
            return 140;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_canEdit) {
        return;
    }
    if (indexPath.section == 0) {
            [[WQUploadSingleImage manager] showUpImagePickerWithVC:self compression:0.5 selectSucceedBlock:^(UIImage *image, NSString *filePath) {
        
                [self upLoadImageWithImage:image];
            }];
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            if (self.sexSelectView.isShow) {
                [self.sexSelectView hidden];
                
            }else{
                [self.sexSelectView show];
            }

        }
        if (indexPath.row == 3) {
            
            if (_userInfo.phone.length) {
                EditPhoneViewController *vc = [[EditPhoneViewController alloc]initWithType:1 userTel:_userInfo.phone];
                vc.succeedBlock = ^{
                    _userInfo.phone = [UserInfoEngine getUserInfo].phone;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:vc animated:YES];

            }else{
                EditPhoneViewController *vc = [[EditPhoneViewController alloc]initWithType:2 userTel:@""];
                vc.succeedBlock = ^{
                    _userInfo.phone = [UserInfoEngine getUserInfo].phone;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:vc animated:YES];

            }
        }

    }
}
- (void)upLoadImageWithImage:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    self.view.userInteractionEnabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    
    [self.netWorkEngine upLoadmageData:imageData imageName:@"file" Url:BaseUrl(@"my/edituserimage.action") dict:@{@"userid":[UserInfoEngine getUserInfo].userID,@"username":[UserInfoEngine getUserInfo].nickname} succed:^(id responseObject) {
        self.view.userInteractionEnabled = YES;

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"修改成功"];
            UserInfoHeadTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.headImage.image = image;
            
            _userInfo.headimg = [[responseObject objectForKey:@"value"] objectForKey:@"imageurl"];
            
            
            UserInfo *info = [UserInfoEngine getUserInfo];
            info.headimg = _userInfo.headimg;
            [UserInfoEngine setUserInfo:info];
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        self.view.userInteractionEnabled = YES;
    }];
    
    
}
#pragma mark- SexPickerViewDelegate
- (void)clickSexCancelButton{
    [_sexSelectView hidden];

}
- (void)clickSexFinishButtonWithSex:(NSString *)sex{
    _userInfo.sex = [sex integerValue];
    [_sexSelectView hidden];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}
-(NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
