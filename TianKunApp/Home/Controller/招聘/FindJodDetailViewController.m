//
//  FindJodDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/26.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindJodDetailViewController.h"
#import "FindJobDetailTableViewCell.h"
#import "FindJobTableViewCell.h"
#import "ResumeInfo.h"
#import "EducationModel.h"
#import "MenuInfo.h"
#import "CollectShareView.h"
#import "AppShared.h"

@interface FindJodDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) ResumeInfo *resumeInfo;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *resumeID;
@property (nonatomic ,strong) NSMutableArray *arrEducation;
@property (nonatomic ,strong) CollectShareView *collectShareView;
@end

@implementation FindJodDetailViewController
- (instancetype)initWithResumeID:(NSString *)resumeID{
    if (self = [super init]) {
        _resumeID = resumeID;
    }
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@""];
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;

    [self.tableView registerNib:[UINib nibWithNibName:@"FindJobDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindJobDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindJobTableViewCell." bundle:nil] forCellReuseIdentifier:@"FindJobTableViewCell."];
    [self showLoadingView];
    [self getJobDetail];
    
    
}
- (void)setNav{
    _collectShareView = [CollectShareView collectShareView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_collectShareView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];
    _collectShareView.collectButton.selected = _resumeInfo.isCollect;
    _collectShareView.shareButtonBlock = ^{
        [AppShared shared];
    };
    
    __weak typeof(self) weakSelf = self;
    
    _collectShareView.collectButtonBlock = ^{
        [weakSelf collectClick];
        
    };
    
    

}
- (void)getJobDetail{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([UserInfoEngine getUserInfo].userID) {
        [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userId"];
    }
    [dict setObject:_resumeID forKey:@"id"];
    
    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"find.pushResume.details.by.id") succed:^(id responseObject) {
        [self hideLoadingView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _resumeInfo = [ResumeInfo mj_objectWithKeyValues:[responseObject objectForKey:@"value"]];
            [self setNav];
            
            [self.tableView reloadData];
            [self getRecommend];
            
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
-(void)getRecommend{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    [self.netWorkEngine postWithDict:@{@"id":_resumeInfo.resume_id,@"pageSize":@(_pageSize),@"pageNo":@(_pageIndex)} url:BaseUrl(@"find.resume.recommendList.by.id") succed:^(id responseObject) {
        [self hideLoadingView];
        [_tableView endRefresh];
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            if (arr.count) {
                if (!_arrData) {
                    _arrData = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    ResumeInfo *jobInfo = [ResumeInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:jobInfo];
                    
                }
                [self.tableView reloadData];
                if (_pageSize>arr.count) {
                    self.tableView.canLoadMore = NO;
                }else{
                    self.tableView.canLoadMore = YES;
                }
            }else{
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                    [self.tableView reloadData];
                }
                _pageIndex--;
                
                [self showErrorWithStatus:NET_WAIT_NO_DATA];
            }
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }
        
    } errorBlock:^(NSError *error) {
        _pageIndex --;
        [_tableView endRefresh];
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];

}
- (void)collectClick{
    [self showWithStatus:NET_WAIT_TOST];
    _collectShareView.collectButton.enabled = NO;
    
    [self.netWorkEngine postWithDict:@{@"resumeId":_resumeInfo.resume_id,@"userId":[UserInfoEngine getUserInfo].userID,@"status":@(!_collectShareView.collectButton.selected)} url:BaseUrl(@"create.or.delete.resumeCollectible") succed:^(id responseObject) {
        _collectShareView.collectButton.enabled = YES;
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _collectShareView.collectButton.selected =! _collectShareView.collectButton.selected;
            if (_collectShareView.collectButton.selected) {
                [self showSuccessWithStatus:@"收藏成功"];
            }else{
                [self showSuccessWithStatus:@"取消收藏成功"];

            }
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
        }

    } errorBlock:^(NSError *error) {
        _collectShareView.collectButton.enabled = YES;

        [self showErrorWithStatus:NET_ERROR_TOST];
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
        _tableView.backgroundColor = COLOR_VIEW_BACK;
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
        
        
        
        
    }
    return _tableView;
}
#pragma makr- tableview  d d

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return _arrData.count;
    }
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        
        FindJobDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindJobDetailTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FindJobDetailTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = 0;

        }
        [cell.headImageView sd_imageWithUrlStr:_resumeInfo.portrait placeholderImage:@"头像"];
        cell.nameLabel.text = _resumeInfo.name;
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@元 - %@元",@(_resumeInfo.want_salary_start),@(_resumeInfo.want_salary_end)];
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
        
        UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(call)];
        [cell.phoneLabel addGestureRecognizer:tap];
        
        return cell;
        
    }else {
        FindJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindJobTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FindJobTableViewCell" owner:nil options:nil] firstObject];
            cell.backgroundColor = COLOR_VIEW_BACK;

        }
        cell.selectionStyle = 0;
        ResumeInfo *info = _arrData[indexPath.row];
        [cell.headImageView sd_imageWithUrlStr:info.portrait placeholderImage:@"头像"];
        cell.nameLabel.text = info.name;
        cell.jobTypeLabel.text = info.position_type_id_string;
        NSString *sexString ;
        if (info.sex == 1) {
            sexString = @"男";
        }else{
            sexString = @"女";
        }
        cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",info.want_salary,sexString,info.workplace_number_string,info.work_type_string];
        cell.contentLabel.text = info.self_evaluate;
        //    [NSString updateTimeForTimeString:info.]
        if (info.create_date.length) {
            cell.timeLabel.text = [NSString stringWithFormat:@"发布时间：%@",[NSString updateTimeForTimeString:info.create_date]];
        }
        cell.numLabel.text = [NSString stringWithFormat:@"%@人浏览·%@人收藏",@(info.hits_record),@(info.collect_count)];
        cell.selectionStyle = 0;
        return cell;

        return cell;
        
    }
    
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
    if (indexPath.section == 1) {
        ResumeInfo *info = _arrData[indexPath.row];
        
        FindJodDetailViewController *vc = [[FindJodDetailViewController alloc]initWithResumeID:info.resume_id];
        [self.navigationController pushViewController:vc animated:YES];

    }

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
