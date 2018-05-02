//
//  AddFindJobViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddFindJobViewController.h"
#import "AddinputTextTableViewCell.h"
#import "UIView+AddTapGestureRecognizer.h"
#import "WQUploadSingleImage.h"
#import "AddUserInfoViewController.h"
#import "ObjectiveViewController.h"
#import "ResumeInfo.h"
#import "AddResumeIntructViewController.h"
#import "AddFindJobEditNetEngine.h"
#import "FindJodDetailViewController.h"

@interface AddFindJobViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) ResumeInfo *resumeInfo;
@property (nonatomic, assign) BOOL isInfoFinish;
@property (nonatomic, assign) BOOL isIntentionFinish;
@property (nonatomic, assign) BOOL isIntroduceFinish;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;
@property (nonatomic ,strong) AddFindJobEditNetEngine *editNetEngine;
@property (nonatomic ,strong) UIButton *previewButton;

@property (nonatomic ,strong) UITextField *nameTextField;
@property (nonatomic ,strong) UIImage *currectHeadImg;


@end

@implementation AddFindJobViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    self.view.userInteractionEnabled = YES;
    _previewButton.enabled = YES;

    [self getData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [self showLoadingView];
    [self getData];
//
}
- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    [_netWorkEngine postWithDict:@{@"userId":[UserInfoEngine getUserInfo].userID} url:BaseUrl(@"find.resume.by.user_id") succed:^(id responseObject) {
        [self hideLoadingView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _resumeInfo = [ResumeInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"value"] objectForKey:@"resume"]];
            
            _isInfoFinish = [[[responseObject objectForKey:@"value"] objectForKey:@"jobIntensionIsIntact"]boolValue];
            _isIntentionFinish = [[[responseObject objectForKey:@"value"] objectForKey:@"resumeIsIntact"]boolValue];
            _isIntroduceFinish = [[[responseObject objectForKey:@"value"] objectForKey:@"gerenjieshao"]boolValue];
            [self setupHeadView];
            _previewButton.hidden = NO;

            [self.tableView reloadData];
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];

                [self getData];
            }];
            
        }
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getData];
        }];
        
    }];
    
    
}
- (void)setupHeadView{
    [_headImageView sd_imageWithUrlStr:_resumeInfo.portrait placeholderImage:@"头像"];
    _nameLabel.text = _resumeInfo.name;
    
    NSString *sexString;
    
    if (_resumeInfo.sex == 1) {
        sexString = @"男";
    }else{
        sexString = @"女";
        
    }
    _propertyLabel.text = [NSString stringWithFormat:@"%@    |    %@年    |    %@",sexString,@(_resumeInfo.worked),_resumeInfo.address];

}
- (void)setupUI{
    self.title = @"编辑简历";

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    _tableView.tableHeaderView = _headView;
    _tableView.tableFooterView = [UIView new];
    [_tableView  registerNib:[UINib nibWithNibName:@"AddinputTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddinputTextTableViewCell"];

    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius =  _headImageView.qmui_width/2;
    _headImageView.userInteractionEnabled = YES;
    [_headImageView addTapGestureRecognizerWithActionBlock:^{
        
        [[WQUploadSingleImage manager] showUpImagePickerWithVC:self compression:0.5 selectSucceedBlock:^(UIImage *image, NSString *filePath) {
            if (!_editNetEngine) {
                _editNetEngine = [[AddFindJobEditNetEngine alloc]init];
                
            }
            
            [self showWithStatus:NET_WAIT_TOST];
            self.view.userInteractionEnabled = NO;
            
            [_editNetEngine upLoadHeadImage:UIImageJPEGRepresentation(image, 1) resumeID:_resumeInfo.resume_id succeedBlock:^(NSInteger code, NSString *msg) {
                self.view.userInteractionEnabled = YES;

                if (code == 1) {
                    [self showSuccessWithStatus:@"上传成功"];
                    _headImageView.image = image;

                }else{
                    [self showErrorWithStatus:msg];
                }
            } errorBlock:^(NSError *error) {
                self.view.userInteractionEnabled = YES;

                [self showErrorWithStatus:NET_ERROR_TOST];
            }];
            
        }];
    }];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [button setTitle:@"保存并预览" forState:UIControlStateNormal];
    [button setTintColor:COLOR_TEXT_BLACK];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:COLOR_TEXT_BLACK forState:0];
    [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];
    [button addTarget:self action:@selector(previewButtobClick) forControlEvents:UIControlEventTouchUpInside];
    _previewButton = button;
    _previewButton.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    
}
- (void)previewButtobClick{
    
    if (!_nameTextField.text.length) {
        [self showErrorWithStatus:@"请输入简历名称"];
        return;
    }
    if (!_editNetEngine) {
        _editNetEngine = [[AddFindJobEditNetEngine alloc]init];
        
    }
    _previewButton.enabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_nameTextField.text forKey:@"resume_name"];
    [dict setObject:_resumeInfo.resume_id forKey:@"id"];
    
    [_editNetEngine editWithParameterDict:dict succeedBlock:^(NSInteger code,NSString *msg) {
        if (code == 1) {
            [self showSuccessWithStatus:@"保存成功"];
            _resumeInfo.resume_name = _nameTextField.text;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_nameTextField endEditing:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.view.userInteractionEnabled = YES;
                _previewButton.enabled = YES;
                FindJodDetailViewController *vc = [[FindJodDetailViewController alloc]initWithResumeID:_resumeInfo.resume_id];
                
                [self.navigationController pushViewController:vc animated:YES];

            });

        }else{
            [self showErrorWithStatus:msg];
            
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];

    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AddinputTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddinputTextTableViewCell" forIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(texeFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.textField.textColor = COLOR_TEXT_LIGHT;
        cell.textField.placeholder = @"请输入简历名称";
//        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.delegate = self;
        cell.textField.text = _resumeInfo.resume_name;
        cell.textField.textAlignment = NSTextAlignmentRight;
        cell.titleLabel.text = @"简历名称";
        _nameTextField = cell.textField;
        
        
        return cell;

    }else{
        static NSString *cellID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.selectionStyle = 0;
            cell.textLabel.textColor = COLOR_TEXT_BLACK;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = COLOR_TEXT_LIGHT;
            cell.detailTextLabel.font =[UIFont systemFontOfSize:13];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"个人信息";
                if(_isInfoFinish){
                    cell.detailTextLabel.text = @"完整";
                }else{
                    cell.detailTextLabel.text = @"去完善";
                }
                
                break;
            case 2:
                cell.textLabel.text = @"求职意向";
                if (_isIntentionFinish) {
                    cell.detailTextLabel.text = @"完整";
                }else{
                    cell.detailTextLabel.text = @"去完善";
                }
                
                break;
            case 3:
                cell.textLabel.text = @"个人介绍";
                if (_isIntroduceFinish) {
                    cell.detailTextLabel.text = @"完整";
                }else{
                    cell.detailTextLabel.text = @"去完善";
                }
                
                break;

            default:
                break;
        }
        return cell;
        
    }
    
    
}
- (void)texeFieldTextChange:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!textField.text.length) {
        [self showErrorWithStatus:@"请输入简历名称"];
        return NO;
    }
    if (!_editNetEngine) {
        _editNetEngine = [[AddFindJobEditNetEngine alloc]init];
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:textField.text forKey:@"resume_name"];
    [dict setObject:_resumeInfo.resume_id forKey:@"id"];

    [_editNetEngine editWithParameterDict:dict succeedBlock:^(NSInteger code,NSString *msg) {
        if (code == 1) {
            [self showSuccessWithStatus:@"保存成功"];
            _resumeInfo.resume_name = textField.text;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [textField endEditing:YES];
        }else{
            [self showErrorWithStatus:msg];
            
        }
        
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];

    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        AddUserInfoViewController *vc = [[AddUserInfoViewController alloc]initWithResumeInfo:_resumeInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }if (indexPath.row == 2) {
        ObjectiveViewController *vc = [[ObjectiveViewController alloc]init];
        vc.resumeID = _resumeInfo.resume_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        AddResumeIntructViewController *vc = [[AddResumeIntructViewController alloc]init];
        vc.textChangeBlock = ^(NSString *text) {
            if (text) {
                _isIntroduceFinish = YES;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
        };
        vc.textStr = _resumeInfo.self_evaluate;
        vc.resumeID = _resumeInfo.resume_id;
        [self.navigationController pushViewController:vc animated:YES];

        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
