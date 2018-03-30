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

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,assign) BOOL canEdit;



@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.titleView setTitle:@"个人详情"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoEditTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoEditTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoHeadTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoPhotoTableViewCell"];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateSelected];
    [button setTintColor:COLOR_TEXT_BLACK];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:COLOR_TEXT_BLACK forState:0];
    [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];

    [button addTarget:self action:@selector(editButtobClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEndEditing)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;



}
- (void)tapEndEditing{
    [self.view endEditing:YES];
}
- (void)editButtobClick:(UIButton *)button{
    if ([button isSelected]) {
        _canEdit = NO;
        button.selected = NO;
        [self.tableView reloadData];
        
    }else{
        _canEdit = YES;
        button.selected = YES;
        [self.tableView reloadData];


    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UserInfoHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHeadTableViewCell" forIndexPath:indexPath];
        if (_canEdit) {
            cell.headImage.userInteractionEnabled = YES;
        }else{
            cell.headImage.userInteractionEnabled = NO;

        }

        return cell;
    }else if (indexPath.section == 1){
        UserInfoEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoEditTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoEditTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.indexPath = indexPath;
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
                cell.titleLabel.text = @"姓        名：";
                cell.textField.placeholder = @"请输入姓名";
                
            }
                break;
            case 1:
            {
                cell.titleLabel.text = @"昵        称：";
                cell.textField.placeholder = @"请输入昵称";
                
            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"性        别：";
                cell.textField.placeholder = @"请输入性别";
                
            }
                break;
            case 3:
            {
                cell.titleLabel.text = @"手  机  号：";
                cell.textField.placeholder = @"请输入手机号";
                
            }
                break;
            case 4:
            {
                cell.titleLabel.text = @"企业名称：";
                cell.textField.placeholder = @"请输入企业名称";
                
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
            if (_canEdit) {
                cell.photoButton.enabled = YES;
                
            }else{
                cell.photoButton.enabled = NO;
            }
            cell.block = ^{
                [self.navigationController pushViewController:[BusinessLicenseViewController new] animated:YES];
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
        return 5;
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
    [[WQUploadSingleImage manager] showUpImagePickerWithVC:self compression:0.5 selectSucceedBlock:^(UIImage *image, NSString *filePath) {
        
        [self upLoadImageWithImage:image];
    }];
    
}
- (void)upLoadImageWithImage:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    [[[NetWorkEngine alloc] init] upLoadmageData:imageData Url:@"http://192.168.1.226/addjob/uploadimage.action" dict:@{@"uid":@"1"} succed:^(id responseObject) {
        
    } errorBlock:^(NSError *error) {
        
    }];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
