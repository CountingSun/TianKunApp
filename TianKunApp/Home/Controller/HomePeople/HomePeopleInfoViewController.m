//
//  HomePeopleInfoViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomePeopleInfoViewController.h"
#import "FSSegmentTitleView.h"
#import "PeopleInfo.h"
#import "DetailListTableViewCell.h"
#import "RegisterInfo.h"
#import "ProjectInfo.h"
#import "SpecialBehaviorInfo.h"
#import "ChangeInfo.h"
#import "BlackListInfo.h"

@interface HomePeopleInfoViewController ()<UITableViewDataSource,UITableViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) FSSegmentTitleView *segmentTitleView;
@property (nonatomic ,strong) PeopleInfo *peopleInfo;

@property (nonatomic ,strong) NSMutableArray *arrInfo;
@property (nonatomic ,strong) NSMutableArray *arrSelf;
@property (nonatomic ,strong) NSMutableArray *arrBad;
@property (nonatomic ,strong) NSMutableArray *arrGood;
@property (nonatomic ,strong) NSMutableArray *arrBlack;
@property (nonatomic ,strong) NSMutableArray *arrChange;

/**
 当前选中的类型 良好  不良。。。
 */
@property (nonatomic ,assign) NSInteger currectIndex;

@property (nonatomic ,strong) UIView *footView;
@property (nonatomic ,strong) UIView *footViewBlank;
@property (nonatomic ,assign) NSInteger peopleID;
@end

@implementation HomePeopleInfoViewController

- (instancetype)initWithPeopleID:(NSInteger)peopleID{
    if (self = [super init]) {
        _peopleID = peopleID;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"从业人员"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailListTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailListTableViewCell"];
  
    [self showLoadingView];
    [self getData];
    _currectIndex = 0;
    

}
- (void)getData{
    [[[NetWorkEngine alloc]init] postWithDict:@{@"id":@(_peopleID)} url:BaseUrl(@"PesonListXinXi/findpesonslist.action") succed:^(id responseObject) {
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];
        
        if (code == 1) {
            
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"CompanyInformation"];
            if (arrData.count) {
                _peopleInfo = [PeopleInfo mj_objectWithKeyValues:arrData[0]];
            }
            if(!_arrInfo){
                _arrInfo = [NSMutableArray array];
            }
            if(!_arrSelf){
                _arrSelf = [NSMutableArray array];
            }
            if(!_arrBad){
                _arrBad = [NSMutableArray array];
            }
            if(!_arrGood){
                _arrGood = [NSMutableArray array];
            }
            if(!_arrBlack){
                _arrInfo = [NSMutableArray array];
            }
            if(!_arrChange){
                _arrChange = [NSMutableArray array];
            }

            NSMutableArray *arrZInfo = [[responseObject objectForKey:@"value"] objectForKey:@"zhixingzhuce"];
            
            for (NSDictionary *dict in arrZInfo){
                RegisterInfo *info =  [RegisterInfo mj_objectWithKeyValues:dict];
                [_arrInfo addObject:info];
            }
            
            NSMutableArray *arrProject = [[responseObject objectForKey:@"value"] objectForKey:@"gongchengxiangmu"];

            for (NSDictionary *dict in arrProject){
                ProjectInfo *info =  [ProjectInfo mj_objectWithKeyValues:dict];
                [_arrSelf addObject:info];
            }

            NSMutableArray *arrBehavior = [[responseObject objectForKey:@"value"] objectForKey:@"findblacklist"];
            
            for (NSDictionary *dict in arrBehavior){
                SpecialBehaviorInfo *info =  [SpecialBehaviorInfo mj_objectWithKeyValues:dict];
                if([info.behavior_type isEqualToString:@"1"]){
                    [_arrGood addObject:info];
                }else{
                    [_arrBad addObject:info];
                }
            }
            NSMutableArray *arrChanget = [[responseObject objectForKey:@"value"] objectForKey:@"change"];
            
            for (NSDictionary *dict in arrChanget){
                ChangeInfo *info =  [ChangeInfo mj_objectWithKeyValues:dict];
                [_arrChange addObject:info];
            }
            NSMutableArray *arrblack = [[responseObject objectForKey:@"value"] objectForKey:@"heimingdan"];
            
            for (NSDictionary *dict in arrblack){
                BlackListInfo *info =  [BlackListInfo mj_objectWithKeyValues:dict];
                [_arrBlack addObject:info];
            }

            if (!_arrInfo.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }

            [self.tableView reloadData];
            
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
        
        
        
        
    }
    return _tableView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    if (section == 2) {
        return CGFLOAT_MIN;
    }

    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        return CGFLOAT_MIN;
    }
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (_currectIndex) {
            case 0:
            return _arrInfo.count+2;
            break;
            case 1:
            return _arrSelf.count+2;

            break;
            case 2:
            return _arrBad.count+2;

            break;
            case 3:
            return _arrGood.count+2;

            break;
            case 4:
            return _arrBlack.count+2;

            break;
        default:
            return _arrChange.count+2;
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if(section == 1){
        return 1;
    }else{
        
        switch (_currectIndex) {
                case 0:
                return 6;
                break;
                case 1:
                return 6;
                
                break;
                case 2:
                return 5;
                
                break;
                case 3:
                return 5;
                
                break;
                case 4:
                return 5;
                
                break;
            default:
                return 2;
                
                break;
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailListTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.textColor = COLOR_TEXT_BLACK;
        cell.detailLabel.textColor = COLOR_TEXT_BLACK;

    if(indexPath.section == 0){
        switch (indexPath.row) {
                case 0:
                {
                    cell.titleLabel.text = @"姓名：";
                    cell.detailLabel.text = _peopleInfo.name;
                    
                }
                break;
                case 1:
            {
                cell.titleLabel.text = @"证件类型：";
                cell.detailLabel.text = _peopleInfo.certificate_type;

            }
                break;
                
                case 2:
            {
                cell.titleLabel.text = @"证件号码：";
                cell.detailLabel.text = _peopleInfo.certificate_number;

            }
                break;
                

            default:
                break;
        }
    }else if(indexPath.section == 1){
        cell.titleLabel.text = @"";
        cell.detailLabel.text = @"";

    }else{
        switch (_currectIndex) {
                case 0:
                {
                    RegisterInfo *info =  _arrInfo[indexPath.section-2];
                    switch (indexPath.row) {
                            case 0:
                            cell.titleLabel.text = @"注册类型：";
                            cell.detailLabel.text = info.type_name;
                            
                            break;
                        case 1:
                            cell.titleLabel.text = @"注册专业：";
                            cell.detailLabel.text = info.category_type;
                            
                            break;
                            case 2:
                            cell.titleLabel.text = @"证件编号：";
                            cell.detailLabel.text = info.credential_number;
                            
                            break;
                            case 3:
                            cell.titleLabel.text = @"执业印章号：";
                            cell.detailLabel.text = info.operation_seal_number;
                            
                            break;
                            case 4:
                            cell.titleLabel.text = @"有效日期：";
                            cell.detailLabel.text = info.useful_deadline;
                            
                            break;
                            case 5:
                            cell.titleLabel.text = @"注册单位：";
                            cell.detailLabel.text = info.registrant;
                            
                            break;

                        default:
                            break;
                    }
                }
                break;
                case 1:
            {
                ProjectInfo *info = _arrSelf[indexPath.section-2];
                switch (indexPath.row) {
                        case 0:
                        cell.titleLabel.text = @"序号：";
                        cell.detailLabel.text = [NSString stringWithFormat:@"%@",@(indexPath.row+1)];
                        break;
                        case 1:
                        cell.titleLabel.text = @"项目编号：";
                        cell.detailLabel.text = info.project_number;
                        break;
                        case 2:
                        cell.titleLabel.text = @"项目名称：";
                        cell.detailLabel.text = info.project_name;
                        break;
                        case 3:
                        cell.titleLabel.text = @"项目属地：";
                        cell.detailLabel.text = info.project_address;
                        break;
                        case 4:
                        cell.titleLabel.text = @"项目类别号：";
                        cell.detailLabel.text = info.project_number;
                        break;
                        case 5:
                        cell.titleLabel.text = @"建设单位：";
                        cell.detailLabel.text = info.development_organization;
                        break;

                    default:
                        break;
                }
                
            }
                break;
                case 2:
            {
                SpecialBehaviorInfo *info = _arrBad[indexPath.section-2];
                switch (indexPath.row) {
                        case 0:
                        cell.titleLabel.text = @"诚信记录编号：";
                        cell.detailLabel.text = info.record_number;
                        break;
                        case 1:
                        cell.titleLabel.text = @"诚信记录主体：";
                        cell.detailLabel.text = info.record_body;
                        break;
                        case 2:
                        cell.titleLabel.text = @"决定内容：";
                        cell.detailLabel.text = info.record_details;
                        break;
                        case 3:
                        cell.titleLabel.text = @"实施部门（文号）：";
                        cell.detailLabel.text = info.department_number;
                        break;
                        case 4:
                        cell.titleLabel.text = @"发布有效期：";
                        cell.detailLabel.text = info.expiration_date;
                        break;

                    default:
                        break;
                }
            }
                break;
                case 3:
            {
                SpecialBehaviorInfo *info = _arrGood        [indexPath.section-2];
                switch (indexPath.row) {
                        case 0:
                        cell.titleLabel.text = @"诚信记录编号：";
                        cell.detailLabel.text = info.record_number;
                        break;
                        case 1:
                        cell.titleLabel.text = @"诚信记录主体：";
                        cell.detailLabel.text = info.record_body;
                        break;
                        case 2:
                        cell.titleLabel.text = @"决定内容：";
                        cell.detailLabel.text = info.record_details;
                        break;
                        case 3:
                        cell.titleLabel.text = @"实施部门（文号）：";
                        cell.detailLabel.text = info.department_number;
                        break;
                        case 4:
                        cell.titleLabel.text = @"发布有效期：";
                        cell.detailLabel.text = info.expiration_date;
                        break;
                        
                    default:
                        break;
                }

            }
                break;
                case 4:
            {
                BlackListInfo *info = _arrBlack[indexPath.section-2];
                switch (indexPath.row) {
                        case 0:
                        cell.titleLabel.text = @"黑名单记录主体：";
                        cell.detailLabel.text = info.blacklist_body;
                        break;
                        case 1:
                        cell.titleLabel.text = @"记录原由：";
                        cell.detailLabel.text = info.cause;
                        break;
                        case 2:
                        cell.titleLabel.text = @"认定部门：";
                        cell.detailLabel.text = info.from_department;
                        break;
                        case 3:
                        cell.titleLabel.text = @"决定日期：";
                        cell.detailLabel.text = info.start_time;
                        break;
                        case 4:
                        cell.titleLabel.text = @"有效期截止：";
                        cell.detailLabel.text = info.end_time;
                        break;

                    default:
                        break;
                }
                
            }
                break;

            default:{
                ChangeInfo *info = _arrChange[indexPath.section-2];
                switch (indexPath.row) {
                    case 0:
                        cell.titleLabel.text = @"注册类别：";
                        cell.detailLabel.text = info.change_flag;
                        break;
                    case 1:
                        cell.titleLabel.text = @"变更记录：";
                        cell.detailLabel.text = info.change_contents;
                        break;
                        
                    default:
                        break;
                }
            }
                break;
        }
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        static  UIView *backView;
        if (!_segmentTitleView) {
            
            backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40) titles:@[@"执业注册信息",@"个人工程业绩",@"不良行为",@"良好行为",@"黑名单记录",@"变更记录"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
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
//            DetailListViewController *vc = [[DetailListViewController alloc]init];
//            vc.companyInfo = _companyDetailInfo;
            
//            [self.navigationController pushViewController:vc animated:YES];
            
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
    switch (_currectIndex) {
        case 0:
        {
            if (!_arrInfo.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 1:
        {
            if (!_arrSelf.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 2:
        {
            if (!_arrBad.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 3:
        {
            if (!_arrGood.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 4:
        {
            if (!_arrBlack.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footViewBlank;
            }
        }
            break;
        case 5:
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

    [self.tableView reloadData];
    
    
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
