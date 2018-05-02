//
//  JobDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "JobDetailViewController.h"
#import "JobViewTableViewCell.h"
#import "JobDetailDescribeTableViewCell.h"
#import "JobDetailCompanyTableViewCell.h"
#import "JobDetailCompanyDescriptionTableViewCell.h"
#import "JobInfo.h"
#import "CompanyInfo.h"
#import "AppShared.h"

@interface JobDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic, copy) NSString *jobID;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) JobInfo *jobInfo;
@property (nonatomic ,strong) CompanyInfo *companyInfo;
@property (strong, nonatomic) IBOutlet UIView *rightBarButtonView;
@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;


@end

@implementation JobDetailViewController
- (instancetype)initWithJobID:(NSString *)jobID{
    if (self = [super init]) {
        _jobID = jobID;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@""];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed) name:LOGIN_SUCCEED_NOTICE object:nil];
    
    
    [self showLoadingView];
    [self getData];
    
}
- (void)loginSucceed{
    [self getData];
}
- (void)setNav{
    _rightBarButtonView.frame = CGRectMake(0, 0, 100, 40);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBarButtonView];
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];

}

- (void)getData{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    NSDictionary *dict;
    
    if ([UserInfoEngine getUserInfo].userID) {
        dict = @{@"jobid":_jobID,@"userid":[UserInfoEngine getUserInfo].userID};
        
    }else{
        dict = @{@"jobid":_jobID};
    }
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"home/invitationAsDetail.action") succed:^(id responseObject) {
        [self hideLoadingView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            [self setNav];
            
            if (!_arrData) {
                _arrData = [NSMutableArray arrayWithCapacity:0];
            }
            
            NSDictionary *dict = [[responseObject objectForKey:@"value"] objectForKey:@"job"];
            _jobInfo = [JobInfo mj_objectWithKeyValues:dict];
            _companyInfo = [CompanyInfo mj_objectWithKeyValues:dict];
            _companyInfo.picture_url = [dict objectForKey:@"imageurl"];
            _companyInfo.companyIntroduce = [dict objectForKey:@"introduce"];
            _companyInfo.companyAddress = [dict objectForKey:@"address"];
            _companyInfo.companyName = [dict objectForKey:@"enterpriseName"];

            
            
            if (_companyInfo.collectionid.length) {
                _collectButton.selected = YES;
                
            }else{
                _collectButton.selected = NO;
            }
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"jobList"];

            for (NSDictionary *dicts in arr) {
                JobInfo *jobInfo = [JobInfo mj_objectWithKeyValues:dicts];
                [_arrData addObject:jobInfo];
                
            }
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
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 130;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView headerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView endRefresh];
                
            });
            
        }];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(0);
        }];
        [_tableView registerNib:[UINib nibWithNibName:@"JobDetailDescribeTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobDetailDescribeTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JobDetailCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobDetailCompanyTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JobDetailCompanyDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobDetailCompanyDescriptionTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JobViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobViewTableViewCell"];

        
        
        
    }
    return _tableView;
}
#pragma makr- tableview  d d

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        return _arrData.count;
    }
    return 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            cell.textLabel.textColor = COLOR_TEXT_BLACK;
        }
        cell.textLabel.text = _jobInfo.name;
        return cell;
        
    }else if (indexPath.section == 1){
        
        JobDetailDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobDetailDescribeTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JobDetailDescribeTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        cell.label.text = _jobInfo.work_describe;
        
        
        cell.timeLabel.text = [NSString timeReturnDate:[NSNumber numberWithInteger:[_jobInfo.update_date integerValue]]];
        
        return cell;

    }else if(indexPath.section == 2){
        JobDetailCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobDetailCompanyTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JobDetailCompanyTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.companyInfo = _companyInfo;
        cell.clickPhoneLabelBlock = ^(NSString *phoneNumber) {
            [WQTools callWithTel:phoneNumber];
        };
        
        return cell;

    }else if(indexPath.section == 3){
        JobDetailCompanyDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobDetailCompanyDescriptionTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JobDetailCompanyDescriptionTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        cell.contentLabel.text = _companyInfo.companyIntroduce;
        
        return cell;

    }else{
        JobViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobViewTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JobViewTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];

        cell.jobInfo = _arrData[indexPath.row];
        return cell;

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1||section == 2||section == 3) {
        return 10;
    }
    if (section == 4) {
        return 50;
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
    
    if (section == 4) {
        
        WQLabel *label = [[WQLabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) font:[UIFont systemFontOfSize:16] text:@"其他职位" textColor:COLOR_TEXT_BLACK textAlignment:NSTextAlignmentCenter numberOfLine:1];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return label;
    }
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        JobInfo *jobInfo = _arrData[indexPath.row];
        JobDetailViewController *vc = [[JobDetailViewController alloc]initWithJobID:jobInfo.job_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)collectButtonClick:(id)sender {
    if ([UserInfoEngine isLogin]) {
        if (!_netWorkEngine) {
            _netWorkEngine = [[NetWorkEngine alloc]init];
        }
        [self showWithStatus:NET_WAIT_TOST];
        _collectButton.enabled = NO;
        
        [_netWorkEngine postWithDict:@{@"userid":[UserInfoEngine getUserInfo].userID,
                                       @"jobid":_jobID,
                                       @"username":[UserInfoEngine getUserInfo].nickname,
                                       @"state":@(_collectButton.selected)
                                       }
                                 url:BaseUrl(@"home/jobcollection.action") succed:^(id responseObject) {
                                     NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                                     _collectButton.enabled = YES;

                                     if (code == 1) {
                                         _collectButton.selected =!_collectButton.selected;
                                         if (_collectButton.selected) {
                                             [self showSuccessWithStatus:@"收藏成功"];
                                         }else{
                                             [self showSuccessWithStatus:@"取消收藏成功"];
                                         }
                                         
                                     }else{
                                         [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                                     }
                                     
                                 } errorBlock:^(NSError *error) {
                                     [self showErrorWithStatus:NET_ERROR_TOST];
                                 }];

    }
    
}
- (IBAction)shareButtonClick:(id)sender {
    [AppShared shared];
    
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
