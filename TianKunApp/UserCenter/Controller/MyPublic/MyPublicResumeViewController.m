//
//  MyPublicResumeViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/29.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyPublicResumeViewController.h"
#import "ResumeInfo.h"
#import "FindJobDetailTableViewCell.h"
#import "FindJobTableViewCell.h"
#import "MenuInfo.h"
#import "EducationModel.h"
#import "AddFindJobViewController.h"

@interface MyPublicResumeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) ResumeInfo *resumeInfo;
@property (nonatomic ,strong) NSMutableArray *arrEducation;
@property (nonatomic ,strong) UIView *footView;
@property (nonatomic ,strong) UIView *headView;
@property (nonatomic ,strong) WQLabel *refreTimeLabel;

@end

@implementation MyPublicResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingView];
    [self getJobDetail];

}
- (void)getJobDetail{
    [self.netWorkEngine postWithDict:@{@"user_id":[UserInfoEngine getUserInfo].userID} url:BaseUrl(@"find.pushResume.list.by.pushResume") succed:^(id responseObject) {
        [self hideLoadingView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            id objc = [responseObject objectForKey:@"value"];
            
            if ([objc isKindOfClass:[NSString class]] || objc == nil) {
            [self showEmptyViewWithText:@"提示" detailText:@"尚未编辑简历" buttonTitle:@"去编辑" buttonAction:@selector(goToPublic)];

            }else{
                NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
                if (arr.count) {
                    _resumeInfo = [ResumeInfo mj_objectWithKeyValues:arr[0]];
                    [self.tableView reloadData];
                    self.tableView.tableFooterView = self.footView;
                    if (_resumeInfo.update_date.length) {
                        self.tableView.tableHeaderView = self.headView;

                        _refreTimeLabel.text = [NSString stringWithFormat:@"置顶时间：%@",[NSString timeReturnDateString:_resumeInfo.update_date formatter:@"yyyy年MM月dd日 HH:mm:ss"]];
                        
                    }

                }else{
                    [self showEmptyViewWithText:@"提示" detailText:@"尚未编辑简历" buttonTitle:@"去编辑" buttonAction:@selector(goToPublic)];

                }

            }

//            }
            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getJobDetail];
                
            }];
            
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getJobDetail];
        }];
        
    }];
    
}
- (void)clickEditButton{
    AddFindJobViewController *vc = [[AddFindJobViewController alloc] init];
    vc.reloadBlock = ^{
        
        [self showLoadingView];
        [self hideEmptyView];

        [self getJobDetail];
        
    };

    [self.navigationController pushViewController:vc animated:YES];
    
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 130;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"FindJobDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindJobDetailTableViewCell"];

        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(0);
        }];
        
        
        
        
    }
    return _tableView;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _headView.backgroundColor = COLOR_VIEW_BACK;
        _refreTimeLabel = [[WQLabel alloc] initWithFrame:_headView.frame font:[UIFont systemFontOfSize:13] text:@"" textColor:COLOR_TEXT_LIGHT textAlignment:NSTextAlignmentCenter numberOfLine:1];
        [_headView addSubview:_refreTimeLabel];
        
    }
    return _headView;
}
- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 100)];
        
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topButton setTitle:@"置顶简历" forState:0];
        [topButton addTarget:self action:@selector(clickTopButton) forControlEvents:UIControlEventTouchUpInside];
        topButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [topButton setTitleColor:[UIColor whiteColor] forState:0];
        topButton.backgroundColor = COLOR_THEME;
        topButton.layer.masksToBounds = YES;
        topButton.layer.cornerRadius = 20;
        [_footView addSubview:topButton];
        [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.left.top.equalTo(_footView).offset(30);
            make.right.equalTo(_footView).offset(-10);
            make.height.offset(40);
            
        }];
        
    }
    return _footView;
}
#pragma makr- tableview  d d

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        FindJobDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindJobDetailTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FindJobDetailTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = 0;
            
        }
        [cell.headImageView sd_imageWithUrlStr:_resumeInfo.portrait placeholderImage:@"头像"];
        cell.nameLabel.text = _resumeInfo.resume_name;
    if (_resumeInfo.want_salary_end<=0) {
        cell.moneyLabel.text = @"面议";
    }else{
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@元 - %@元",@(_resumeInfo.want_salary_start),@(_resumeInfo.want_salary_end)];

    }
        cell.jobTypeLabel.text = _resumeInfo.position_type_id_string;
        
        NSString *sexString ;
        
        if (_resumeInfo.sex == 1) {
            sexString = @"男";
        }else{
            sexString = @"女";
        }
        MenuInfo *menuInfo = self.arrEducation[[_resumeInfo.degree integerValue]];
        
        
        cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",sexString,_resumeInfo.work_type_string,_resumeInfo.workplace_number_string,menuInfo.menuName];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@年经验 %@",_resumeInfo.position_type_id_string,@(_resumeInfo.worked),[NSString timeReturnDateString:_resumeInfo.birthday formatter:@"yyyy年MM月"]];
        cell.contentLabel.text = _resumeInfo.self_evaluate;
        cell.phoneLabel.text = _resumeInfo.phone;
        cell.phoneLabel.userInteractionEnabled = YES;
    cell.seeButton.hidden = YES;
    
        
    
        return cell;
        
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 1||section == 2||section == 3) {
    //        return 10;
    //    }
    if (section == 1) {
        return 40;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        WQLabel *label = [[WQLabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30) font:[UIFont systemFontOfSize:15] text:@"    相关职位推荐" textColor:COLOR_TEXT_BLACK textAlignment:NSTextAlignmentLeft numberOfLine:1];
        label.backgroundColor = COLOR_VIEW_BACK;
        return label;
    }
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return view;
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)goToPublic{
    AddFindJobViewController *vc = [[AddFindJobViewController alloc] init];
    vc.reloadBlock = ^{
        [self showLoadingView];
        [self getJobDetail];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)clickTopButton{
    [self showWithStatus:NET_WAIT_TOST];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_resumeInfo.resume_id forKey:@"id"];
    
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"set.top.resume") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self showSuccessWithStatus:@"置顶成功"];
            _resumeInfo.update_date = [responseObject objectForKey:@"value"];
            _refreTimeLabel.text = [NSString stringWithFormat:@"置顶时间：%@",[NSString timeReturnDateString:_resumeInfo.update_date formatter:@"yyyy年MM月dd日 HH:mm:ss"]];

        }else{
            
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
        
        
    }];
    
}
- (void)call{
    
    [WQTools callWithTel:_resumeInfo.phone];
    
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
