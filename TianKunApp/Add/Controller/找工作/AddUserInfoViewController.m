//
//  AddUserInfoViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddUserInfoViewController.h"
#import "UserInfoEditTableViewCell.h"
#import "RegisterGetCodeTableViewCell.h"
#import "DataPickerView.h"
#import "FindeJobSelecEducationtViewController.h"
#import "MenuInfo.h"
#import "ResumeInfo.h"
#import "AddFindJobEditNetEngine.h"
#import "SexSelectView.h"
#import "EducationModel.h"
#import "AddEditPhoneViewController.h"


@interface AddUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,DataPickerViewDelegate,SexPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,assign) BOOL canEdit;
@property (nonatomic ,strong) DataPickerView *datePickerView;
@property (nonatomic ,strong) SexSelectView *sexSelectView;

@property (nonatomic ,strong) ResumeInfo *resumeInfo;
@property (nonatomic ,strong) AddFindJobEditNetEngine *editNetEngine;
@property (nonatomic ,strong) UIButton *editButton;
@property (nonatomic ,strong) NSMutableArray *arrEducation;
@property (nonatomic ,strong) UITextField *firstTextField;
@end

@implementation AddUserInfoViewController
- (instancetype)initWithResumeInfo:(ResumeInfo *)resumeInfo{
    if (self = [super init]) {
        _resumeInfo = resumeInfo;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"个人信息"];
    [self setupUI];
}
- (void)setupUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    _tableView.tableFooterView = [UIView new];
    [self.titleView setTitle:@"个人信息"];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateSelected];
    [button setTintColor:COLOR_TEXT_BLACK];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:COLOR_TEXT_BLACK forState:0];
    [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];
    _editButton =  button;

    [button addTarget:self action:@selector(editButtobClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoEditTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoEditTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RegisterGetCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RegisterGetCodeTableViewCell"];

}
- (void)editButtobClick:(UIButton *)button{
    if ([button isSelected]) {

        [self.view endEditing:YES];
        [self editUserInfo];
        
    }else{
        _canEdit = YES;
        button.selected = YES;
        [_firstTextField becomeFirstResponder];
        [self.tableView reloadData];


    }
    
    
}
- (void)editUserInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self showWithStatus:NET_WAIT_TOST];
    
    if (_resumeInfo.name.length) {
        [dict setObject:_resumeInfo.name forKey:@"name"];
    }
    if (_resumeInfo.sex == 1||_resumeInfo.sex == 2) {
        [dict setObject:@(_resumeInfo.sex) forKey:@"sex"];
    }
    
    if (_resumeInfo.degree.length) {
        [dict setObject:_resumeInfo.degree forKey:@"degree"];

    }
    if (_resumeInfo.worked) {
        [dict setObject:@(_resumeInfo.worked) forKey:@"worked"];
        
    }
    
    if (_resumeInfo.birthday.length) {
        [dict setObject:[NSString timeReturnDateString:_resumeInfo.birthday formatter:@"yyyy-MM"] forKey:@"birthday"];
        
    }
    if (_resumeInfo.phone.length) {
        [dict setObject:_resumeInfo.phone forKey:@"phone"];
        
    }

    [dict setObject:_resumeInfo.resume_id forKey:@"id"];
    if (!_editNetEngine) {
        _editNetEngine = [[AddFindJobEditNetEngine alloc]init];
        
    }
    _editButton.enabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    [_editNetEngine editWithParameterDict:dict succeedBlock:^(NSInteger code,NSString *msg) {
        _editButton.enabled = YES;

        if (code == 1) {
            _canEdit = NO;
            _editButton.selected = NO;
            [self.tableView reloadData];
            [self showSuccessWithStatus:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _editButton.enabled = NO;
                self.view.userInteractionEnabled = NO;

                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }else{
            [self showErrorWithStatus:msg];
            
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        _editButton.enabled = YES;

    }];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
        
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0||indexPath.row == 4) {
            UserInfoEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoEditTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoEditTableViewCell" owner:nil options:nil] firstObject];
            }
            cell.indexPath = indexPath;
            cell.textField.textAlignment = NSTextAlignmentRight;
            
            cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
            };
            if (_canEdit) {
                cell.textField.enabled = YES;
                
            }else{
                cell.textField.enabled = NO;
            }
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.titleLabel.text = @"姓名";
                    cell.textField.placeholder = @"请输入姓名";
                    cell.textField.text = _resumeInfo.name;
                    cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                        _resumeInfo.name = string;
                        
                    };
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    _firstTextField = cell.textField;
                    
                    
                }
                    break;
                case 4:
                {
                    cell.titleLabel.text = @"工作经验";
                    cell.textField.text = [NSString stringWithFormat:@"%@年",@(_resumeInfo.worked)];
                    cell.textField.placeholder = @"请输入工作经验";
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.textField.delegate = self;
                    cell.textField.tag = 1000;
                    
                    cell.editBlock = ^(NSString *string, NSIndexPath *indexPath) {
                        _resumeInfo.worked = [string integerValue];
                        
                    };

                }
                    break;
                default:
                    break;
            }
            return cell;

        }else{
            static NSString *cellID =@"CELLID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
                cell.textLabel.textColor = COLOR_TEXT_BLACK;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.detailTextLabel.textColor = COLOR_TEXT_BLACK;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = 0;
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"性别";
                if (_resumeInfo.sex == 1) {
                    cell.detailTextLabel.text = @"男";
                }else{
                    cell.detailTextLabel.text = @"女";
                }
                
            }else if (indexPath.row == 2){
                cell.textLabel.text = @"出生年月";
                if (_resumeInfo.birthday.length) {
                    cell.detailTextLabel.text = [NSString timeReturnDateString:_resumeInfo.birthday formatter:@"yyyy年MM月"];

                }else{
                    cell.detailTextLabel.text = @"请选择生日";
                }
            }else if (indexPath.row == 3){
                cell.textLabel.text = @"学历";
                if (_resumeInfo.degree.length) {
                    [self.arrEducation enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        MenuInfo *info = obj;
                        if ([_resumeInfo.degree integerValue] == info.menuID) {
                            cell.detailTextLabel.text = info.menuName;
                            *stop = YES;
                            
                        }
                    }];
                    
                }else{
                    cell.detailTextLabel.text = @"请选择学历";
                }
            
            }

            
            return cell;
        }
    }else{
        UserInfoEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoEditTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoEditTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = 0;

        }
        cell.indexPath = indexPath;
        cell.textField.textAlignment = NSTextAlignmentRight;
        cell.textField.enabled = NO;
        cell.titleLabel.text = @"手机号";
        cell.textField.text = _resumeInfo.phone;
        cell.textField.textAlignment = NSTextAlignmentRight;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;

        
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_canEdit) {
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                if (self.sexSelectView.isShow) {
                    [self.sexSelectView hidden];
                    
                }else{
                    [self.sexSelectView show];
                }

                
            }else if (indexPath.row == 2) {
                if (self.datePickerView.isShow) {
                    [self.datePickerView hidden];
                    
                }else{
                    [self.datePickerView show];
                }
                
            }else if (indexPath.row == 3){
                FindeJobSelecEducationtViewController *vc = [[FindeJobSelecEducationtViewController alloc]init];
                vc.selectSucceedBlock = ^(MenuInfo *menuInfo) {
                    _resumeInfo.degree = [NSString stringWithFormat:@"%@",@(menuInfo.menuID)];

                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }else{
            AddEditPhoneViewController *vc = [[AddEditPhoneViewController alloc]init];
            vc.succeedBlock = ^(NSString *phone) {
                _resumeInfo.phone = phone;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
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

- (DataPickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DataPickerView" owner:nil options:nil] firstObject];
        [self.view addSubview:_datePickerView];
        [_datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.view);
        }];
        _datePickerView.delegate = self;
        
    }
    return _datePickerView;
}

- (void)clickSexCancelButton{
    [_sexSelectView hidden];
}
- (void)clickSexFinishButtonWithSex:(NSString *)sex{
    _resumeInfo.sex = [sex integerValue];
    [_sexSelectView hidden];

    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

}

- (void)clickCancelButton{
    [_datePickerView hidden];
}
- (void)clickFinishButtonWithNowDateYear:(NSString *)year month:(NSString *)month{
    [_datePickerView hidden];
    _resumeInfo.birthday = [NSString getMillisecondWithTimeString:[NSString stringWithFormat:@"%@%@",year,month] formatter:@"yyyy年MM月"];
    
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 1000) {
        textField.text = [NSString stringWithFormat:@"%@",@(_resumeInfo.worked)];
    }
    
    return YES;
}

- (NSMutableArray *)arrEducation{
    if (!_arrEducation) {
        _arrEducation = [EducationModel arrEducation];
    }
    return _arrEducation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
