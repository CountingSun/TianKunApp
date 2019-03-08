//
//  ConstructionInfoViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ConstructionInfoViewController.h"
#import "FSSegmentTitleView.h"
#import "DetailListViewController.h"
#import "CompanyInfo.h"
#import "BlackListInfo.h"
#import "ProjectInfo.h"
#import "ChangeInfo.h"
#import "SpecialBehaviorInfo.h"
#import "AptitudeInfo.h"
#import "PeopleInfo.h"
#import "HomePeopleInfoViewController.h"


@interface ConstructionInfoViewController ()<UITableViewDataSource,UITableViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) FSSegmentTitleView *segmentTitleView;
@property (nonatomic ,strong) CompanyInfo *companyInfo;
@property (nonatomic ,strong) CompanyInfo *companyDetailInfo;
@property (nonatomic ,strong) NSMutableArray *arrProject;
@property (nonatomic ,strong) NSMutableArray *arrChange;
@property (nonatomic ,strong) NSMutableArray *arrBlack;
@property (nonatomic ,strong) NSMutableArray *arrGodBehavior;
@property (nonatomic ,strong) NSMutableArray *arrBadBehavior;
@property (nonatomic ,strong) NSMutableArray *arrPeople;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic ,assign) NSInteger currectIndex;

/**
 资质
 */
@property (nonatomic ,strong) NSMutableArray *arrZZ;
@property (nonatomic ,strong) UIView *footView;
@property (nonatomic ,strong) UIView *footViewBlank;

@end


@implementation ConstructionInfoViewController

- (instancetype)initWithCompanyInfo:(CompanyInfo *)companyInfo{
    if (self = [super init]) {
        _companyInfo = companyInfo;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"建设信息"];
    _currectIndex = 0;
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;

    [self showLoadingView];
    [self getData];
    
    
}
- (void)getData{
    [self showLoadingView];
    [[[NetWorkEngine alloc]init] postWithDict:@{@"id":@(_companyInfo.companyID)} url:BaseUrl(@"/CompanyListXinXi/findcompanyxinxilists.action") succed:^(id responseObject) {
        
    
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];

        if (code == 1) {
            NSDictionary *dict = [[[responseObject objectForKey:@"value"] objectForKey:@"CompanyInformation"] objectAtIndex:0];
            _companyDetailInfo = [CompanyInfo mj_objectWithKeyValues:dict];
            
            NSMutableArray *arrSpecialBehavior = [[responseObject objectForKey:@"value"] objectForKey:@"ndSpecialBehavior"];
            if(!_arrGodBehavior){
                _arrGodBehavior = [NSMutableArray array];
            }
            if(!_arrBadBehavior){
                _arrBadBehavior = [NSMutableArray array];
            }
            if(!_arrBlack){
                _arrBlack = [NSMutableArray array];
            }
            if(!_arrChange){
                _arrChange = [NSMutableArray array];
            }
            if(!_arrZZ){
                _arrZZ = [NSMutableArray array];
            }
            if(!_arrBlack){
                _arrBlack = [NSMutableArray array];
            }
            if (!_arrProject) {
                _arrProject = [NSMutableArray array];
            }

            for(NSDictionary *dict in arrSpecialBehavior){
                SpecialBehaviorInfo *specialBehaviorInfo = [SpecialBehaviorInfo mj_objectWithKeyValues:dict];
                if([specialBehaviorInfo.behavior_type isEqualToString:@"1"]){
                   [_arrGodBehavior addObject:specialBehaviorInfo];
                }else{
                    [_arrBadBehavior addObject:specialBehaviorInfo];
                }
            }
            
            NSMutableArray *arrProject = [[responseObject objectForKey:@"value"] objectForKey:@"findProject"];
            for(NSDictionary *dict in arrProject){
                ProjectInfo *info = [ProjectInfo mj_objectWithKeyValues:dict];
                    [_arrProject addObject:info];
            }

            NSMutableArray *arrChange = [[responseObject objectForKey:@"value"] objectForKey:@"change"];
            for(NSDictionary *dict in arrChange){
                ChangeInfo *info = [ChangeInfo mj_objectWithKeyValues:dict];
                [_arrChange addObject:info];
            }

            NSMutableArray *arrBlack = [[responseObject objectForKey:@"value"] objectForKey:@"findBlacklist"];
            for(NSDictionary *dict in arrBlack){
                BlackListInfo *info = [BlackListInfo mj_objectWithKeyValues:dict];
                [_arrBlack addObject:info];
            }

            NSMutableArray *arrFindgszzlb = [[responseObject objectForKey:@"value"] objectForKey:@"findgszzlb"];
            for(NSDictionary *dict in arrFindgszzlb){
                AptitudeInfo *info = [AptitudeInfo mj_objectWithKeyValues:dict];
                [_arrZZ addObject:info];
            }

            
            
            [self.tableView reloadData];
            if (!_arrZZ.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }


        }else{
            
            [self showGetDataFailViewWithReloadBlock:^{
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

- (void)getPeopleList{
    [self showWithStatus:NET_WAIT_TOST];
    
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_pageIndex) forKey:@"startnum"];
    [dict setObject:@(_pageSize) forKey:@"num"];
    [dict setObject:@(_companyInfo.companyID) forKey:@"id"];
    [dict setObject:@"" forKey:@"name"];
    [dict setObject:@"" forKey:@"number "];
    [dict setObject:@"" forKey:@"type1"];
    [dict setObject:@"" forKey:@"type2"];
    
    [_netWorkEngine postWithDict:dict url:BaseUrl(@"PesonListXinXi/selectAppPesonsList.action") succed:^(id responseObject) {
        [self dismiss];
        [_tableView endRefresh];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];

        if (code == 1) {
            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            if (arr.count) {
                if (!_arrPeople) {
                    _arrPeople = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
                    [_arrPeople removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    PeopleInfo *peopleInfo = [PeopleInfo mj_objectWithKeyValues:dict];
                    [_arrPeople addObject:peopleInfo];
                }
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                
                if(arr.count<_pageSize){
                    _tableView.canLoadMore = NO;
                }else{
                    _tableView.canLoadMore = YES;
                }
            }else{
                if (!_arrPeople.count) {
                }else{
                    _pageIndex--;
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
                _tableView.canLoadMore = NO;
                
                [self.tableView reloadData];
            }

        }else{
            if (!_arrPeople.count) {
                [self showErrorWithStatus:NET_WAIT_NO_DATA];

                
            }else{
                _pageIndex--;
                
                [self showErrorWithStatus:NET_WAIT_NO_DATA];
                
            }
            
        }
        if (!_arrPeople.count) {
            self.tableView.tableFooterView = self.footView;
        }else{
            self.tableView.tableFooterView = self.footViewBlank;
        }

    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [_tableView endRefresh];
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}

- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [self.view addSubview:_tableView];

        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        __weak typeof(self) weakSelf = self;

        [_tableView headerWithRefreshingBlock:^{
            weakSelf.pageIndex = 1;
            [weakSelf getPeopleList];
        }];
        [self.view addSubview:_tableView];
        
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex++;
            [weakSelf getPeopleList];
            
        }];
        _tableView.canLoadMore = NO;
        _tableView.canRefresh = NO;

        
        
    }
    return _tableView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        switch (_currectIndex) {
                case 0:
            {
                return _arrZZ.count;
            }
                break;
                case 1:
            {
                return _arrPeople.count;
            }
                break;
                case 2:
            {
                return _arrProject.count;

            }
                break;
                case 3:
            {
                return _arrBadBehavior.count;

            }
                break;
                case 4:
            {
                return _arrGodBehavior.count;

            }
                break;
                case 5:
            {
                return _arrBlack.count;

            }
                break;
                
            default:
                return _arrChange.count;

                break;
        }

    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.selectionStyle = 0;
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;

        if (indexPath.row == 0) {
            NSString *str = [NSString stringWithFormat:@"公司名称：%@",_companyInfo.companyName];
            
            NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:str];
            [mAttribute addAttribute:NSForegroundColorAttributeName
                               value:COLOR_THEME
                               range:NSMakeRange(5, str.length-5)];
            
            cell.textLabel.attributedText = mAttribute;
        }else if(indexPath.row == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"法定代表人：%@",_companyInfo.companyLegalRepresentative];
            
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"公司注册属地：%@",_companyInfo.companyAddress];
            ;

        }
    }else{
        switch (_currectIndex) {
                case 0:
                {
                    AptitudeInfo *info = _arrZZ[indexPath.row];
                    
                    cell.textLabel.text = info.name;
                    
                }
                break;
                case 1:
            {
                PeopleInfo *info = _arrPeople[indexPath.row];
                
                cell.textLabel.text = info.name;
            }
                break;
                case 2:
            {
                ProjectInfo *info = _arrProject[indexPath.row];
                
                cell.textLabel.text = info.project_name;
                
            }
                break;
                case 3:
            {
                SpecialBehaviorInfo *info = _arrBadBehavior[indexPath.row];
                
                cell.textLabel.text = info.record_number;
            }
                break;
                case 4:
            {
                SpecialBehaviorInfo *info = _arrGodBehavior[indexPath.row];
                
                cell.textLabel.text = info.record_number;
            }
                break;
                case 5:
            {
                BlackListInfo *info = _arrBlack[indexPath.row];
                
                cell.textLabel.text = info.blacklist_body;
            }
                break;

            default:{
                ChangeInfo *info = _arrChange[indexPath.row];
                cell.textLabel.text = info.company_change_number;

            }
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }

    
    return cell;

    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
       static  UIView *backView;
        if (!_segmentTitleView) {
            
            backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40) titles:@[@"企业资质",@"注册人员",@"工程项目",@"不良行为",@"良好行为",@"黑名单",@"变更记录"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
            _segmentTitleView.titleSelectColor = COLOR_THEME;
            _segmentTitleView.indicatorColor = COLOR_THEME;
            [backView addSubview:_segmentTitleView];
            _segmentTitleView.backgroundColor = COLOR_WHITE;
        }
        return backView;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DetailListViewController *vc = [[DetailListViewController alloc]init];
            vc.companyInfo = _companyDetailInfo;
            vc.viewTitle = @"公司详情";
            [self.navigationController pushViewController:vc animated:YES];

        }
    }else{
        switch (_currectIndex) {
                case 0:
                {
                    AptitudeInfo *info =  _arrZZ[indexPath.row];
                    
                    DetailListViewController *vc = [[DetailListViewController alloc]init];
                    vc.aptitudeInfo = info;
                    vc.viewTitle = @"资质详情";
                    [self.navigationController pushViewController:vc animated:YES];

                }
                break;
                case 1:{
                    PeopleInfo *peopleInfo = _arrPeople[indexPath.row];
                    
                    HomePeopleInfoViewController *vc = [[HomePeopleInfoViewController alloc]initWithPeopleID:[peopleInfo.people_id integerValue]];
                    [self.navigationController pushViewController:vc animated:YES];

                }
                break;
                case 2:{
                    ProjectInfo *info =  _arrProject[indexPath.row];
                    
                    DetailListViewController *vc = [[DetailListViewController alloc]init];
                    vc.projectInfo = info;
                    vc.viewTitle = @"工程详情";
                    [self.navigationController pushViewController:vc animated:YES];

                }
                break;
                
                case 3:{
                    SpecialBehaviorInfo *info =  _arrBadBehavior[indexPath.row];
                    
                    DetailListViewController *vc = [[DetailListViewController alloc]init];
                    vc.specialBehaviorInfo = info;
                    vc.viewTitle = @"不良行为";
                    [self.navigationController pushViewController:vc animated:YES];
                    

                }
                break;
                
                case 4:{
                    SpecialBehaviorInfo *info =  _arrGodBehavior[indexPath.row];
                    
                    DetailListViewController *vc = [[DetailListViewController alloc]init];
                    vc.specialBehaviorInfo = info;
                    vc.viewTitle = @"良好行为";
                    [self.navigationController pushViewController:vc animated:YES];

                }
                break;
                
                case 5:{
                    BlackListInfo *info =  _arrBlack[indexPath.row];
                    
                    DetailListViewController *vc = [[DetailListViewController alloc]init];
                    vc.blackListInfo = info;
                    vc.viewTitle = @"黑名单";
                    [self.navigationController pushViewController:vc animated:YES];

                }
                break;
                case 6:{
                    ChangeInfo *info =  _arrChange[indexPath.row];
                    
                    DetailListViewController *vc = [[DetailListViewController alloc]init];
                    vc.changeInfo = info;
                    vc.viewTitle = @"变更记录";
                    [self.navigationController pushViewController:vc animated:YES];

                }
                break;


            default:
                break;
        }
    }
    
}
/**
 切换标题
 
 @param titleView FSSegmentTitleView
 @param startIndex 切换前标题索引
 @param endIndex 切换后标题索引
 */
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    _currectIndex = endIndex;
    
    if(_currectIndex == 1){
        _tableView.canLoadMore = YES;
        _tableView.canRefresh = YES;
        [self.tableView reloadData];
        [self getPeopleList];
    }else{
        _tableView.canLoadMore = NO;
        _tableView.canRefresh = NO;

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    switch (_currectIndex) {
        case 0:
        {
            if (!_arrZZ.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
            if (!_arrProject.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 3:
        {
            if (!_arrBadBehavior.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 4:
        {
            if (!_arrGodBehavior.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 5:
        {
            if (!_arrBlack.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 6:
        {
            if (!_arrChange.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;

        default:
            break;
    }
    
}
- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:_footView.frame];
        [_footView addSubview:label];
        label.text = @"暂无数据";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =COLOR_TEXT_LIGHT;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _footView;
}
- (UIView *)footViewBlank{
    if (!_footViewBlank) {
        _footViewBlank = [UIView new];
    }
    return _footViewBlank;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
