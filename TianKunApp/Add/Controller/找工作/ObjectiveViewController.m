//
//  ObjectiveViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ObjectiveViewController.h"
#import "MenuInfo.h"
#import "SelectAddressViewController.h"
#import "AddFindJobIntentionViewController.h"
#import "AddCompensationViewController.h"
#import "SelectJobTypeViewController.h"

#import "JobIntensionInfo.h"
#import "FilterInfo.h"
#import "ClassTypeInfo.h"

@interface ObjectiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@property (nonatomic ,strong) UIButton *allButton;
@property (nonatomic ,strong) UIButton *partButton;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;

@property (nonatomic ,assign) BOOL isOpen;

@property (nonatomic ,strong) JobIntensionInfo *jobIntensionInfo;
@property (nonatomic ,strong) UIButton *editButton;

@end

@implementation ObjectiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"求职意向"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    _tableView.tableFooterView = [UIView new];
    _isOpen = NO;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [button setTitle:@"保存" forState:0];
    [button setTintColor:COLOR_TEXT_BLACK];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:COLOR_TEXT_BLACK forState:0];
    [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];
    _editButton =  button;
    
    [button addTarget:self action:@selector(editButtobClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    [self showLoadingView];
    [self getData];
    

}
- (void)editButtobClick:(UIButton *)button{
    _editButton.enabled = NO;
    self.view.userInteractionEnabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self showWithStatus:NET_WAIT_TOST];
    
    if (_jobIntensionInfo.work_type) {
        [dict setObject:@(_jobIntensionInfo.work_type) forKey:@"work_type"];
    }
    if (_jobIntensionInfo.workplace_number) {
        [dict setObject:@(_jobIntensionInfo.workplace_number) forKey:@"workplace_number"];
    }
    
    if (_jobIntensionInfo.position_territory_ids) {
        [dict setObject:@(_jobIntensionInfo.position_territory_ids) forKey:@"position_territory_ids"];
        
    }
    if (_jobIntensionInfo.position_type_id) {
        [dict setObject:@(_jobIntensionInfo.position_type_id) forKey:@"position_type_id"];
        
    }
    if (_jobIntensionInfo.want_salary_start) {
        [dict setObject:@(_jobIntensionInfo.want_salary_start) forKey:@"want_salary_start"];
        
    }
    if (_jobIntensionInfo.want_salary_end) {
        [dict setObject:@(_jobIntensionInfo.want_salary_end) forKey:@"want_salary_end"];
        
    }

    [dict setObject:@(_jobIntensionInfo.jobIntensionID) forKey:@"id"];
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
        
    }
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"update.jobIntension") succed:^(id responseObject) {
        _editButton.enabled = YES;
        self.view.userInteractionEnabled = YES;
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _editButton.selected = NO;
            [self.tableView reloadData];
            [self showSuccessWithStatus:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
        

    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        _editButton.enabled = YES;
        self.view.userInteractionEnabled = YES;

    }];
    
    
    

}

- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
        
    }
    [_netWorkEngine postWithDict:@{@"id":_resumeID} url:BaseUrl(@"find.jobIntension.by.id") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1) {
            _jobIntensionInfo = [JobIntensionInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            
            
            
            
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_isOpen) {
            return 2;
        }
    }
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1&&indexPath.section == 0) {
        
        static NSString *showCellID = @"showCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:showCellID];
            cell.selectionStyle = 0;
            cell.contentView.backgroundColor = COLOR_VIEW_BACK;
            _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_allButton setTitleColor:COLOR_TEXT_BLACK forState:0];
            [_allButton setTitle:@"全职" forState:0];
            _allButton.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [cell.contentView addSubview:_allButton];
            [_allButton addTarget:self action:@selector(allButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            _partButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_partButton setTitleColor:COLOR_TEXT_BLACK forState:0];
            [_partButton setTitle:@"兼职" forState:0];
            _partButton.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [cell.contentView addSubview:_partButton];
            [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(cell.contentView);
                make.width.offset(SCREEN_WIDTH/2);
            }];
            [_partButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.bottom.equalTo(cell.contentView);
                make.width.offset(SCREEN_WIDTH/2);
            }];
            [_partButton addTarget:self action:@selector(partButtonClick) forControlEvents:UIControlEventTouchUpInside];


            
            
        }
        
        return cell;

    }
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = 0;
        
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = COLOR_TEXT_LIGHT;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];

        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"table_accrow"];
        cell.accessoryView = imageView;
        
        
    }
    MenuInfo *info = _arrData[indexPath.section];
    
    cell.textLabel.text = info.menuName;
    cell.detailTextLabel.text = info.menuDetail;

    if (indexPath.row == 0&&indexPath.section == 0) {
        if (_isOpen) {
            
        }else{
            
        }

    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (_jobIntensionInfo.work_type) {
                case 1:
                    cell.detailTextLabel.text = @"实习";
                    break;
                case 2:
                    cell.detailTextLabel.text = @"兼职";
                    break;
                case 3:
                    cell.detailTextLabel.text = @"全职";
                    break;
                case 4:
                    cell.detailTextLabel.text = @"不限";
                    break;

                default:
                    break;
            }
        }
            break;
        case 1:{
            cell.detailTextLabel.text = _jobIntensionInfo.workplace;

        }
            break;
        case 2:{
            cell.detailTextLabel.text = _jobIntensionInfo.position_territory_name;
        }
            break;
        case 3:{
            cell.detailTextLabel.text = _jobIntensionInfo.position_type_name;
        }
            break;
        case 4:{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/月-%@/月",@(_jobIntensionInfo.want_salary_start),@(_jobIntensionInfo.want_salary_end)];
        }
            break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            
            _isOpen =! _isOpen;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        case 1:{
            SelectAddressViewController *vc  = [[SelectAddressViewController alloc]init];
            vc.selectSucceedBlock = ^(FilterInfo *provinceInfo, FilterInfo *cityInfo) {
                _jobIntensionInfo.workplace = cityInfo.propertyName;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                _jobIntensionInfo.workplace_number = [cityInfo.propertyID integerValue]                    ;
                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        
        case 2:{
            AddFindJobIntentionViewController *vc  = [[AddFindJobIntentionViewController alloc]init];
            vc.selectSucceedBlock = ^(ClassTypeInfo *classTypeInfo) {
                _jobIntensionInfo.position_territory_name = classTypeInfo.typeName;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                _jobIntensionInfo.position_territory_ids = [classTypeInfo.typeID integerValue];

            };
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3:{
            
            SelectJobTypeViewController *vc  = [[SelectJobTypeViewController alloc]init];
            vc.selectJobSucceedBlock = ^(FilterInfo *first, FilterInfo *second) {
                _jobIntensionInfo.position_type_name = second.propertyName;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                _jobIntensionInfo.position_type_id = [second.propertyID integerValue];

            };
            
            
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;

        case 4:{
            AddCompensationViewController *vc  = [[AddCompensationViewController alloc]init];
            vc.selectSucceedBlock = ^(NSInteger max, NSInteger min) {
                _jobIntensionInfo.want_salary_start = min;
                _jobIntensionInfo.want_salary_end = max;

                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            
            
            [self.navigationController pushViewController:vc animated:YES];
//
        }
            break;

        default:
            break;
    }
    
}

- (void)allButtonClick{
    _isOpen = NO;
    _jobIntensionInfo.work_type = 3;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    

}
- (void)partButtonClick{
    _isOpen = NO;
    _jobIntensionInfo.work_type = 2;

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

}
- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:5];
        MenuInfo *menInof0 = [[MenuInfo alloc]initWithMenuName:@"工作性质" menuIcon:@"" menuID:0 menuDetail:@""];
        [_arrData addObject:menInof0];
        MenuInfo *menInof1 = [[MenuInfo alloc]initWithMenuName:@"工作地点" menuIcon:@"" menuID:1 menuDetail:@""];
        [_arrData addObject:menInof1];
        MenuInfo *menInof2 = [[MenuInfo alloc]initWithMenuName:@"期望领域" menuIcon:@"" menuID:2 menuDetail:@""];
        [_arrData addObject:menInof2];
        MenuInfo *menInof3 = [[MenuInfo alloc]initWithMenuName:@"期望职位" menuIcon:@"" menuID:3 menuDetail:@""];
        [_arrData addObject:menInof3];
        MenuInfo *menInof4 = [[MenuInfo alloc]initWithMenuName:@"期望薪资" menuIcon:@"" menuID:4 menuDetail:@""];
        [_arrData addObject:menInof4];
        
    }
    return _arrData;
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
