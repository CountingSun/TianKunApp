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

@interface HomePeopleInfoViewController ()<UITableViewDataSource,UITableViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) FSSegmentTitleView *segmentTitleView;
@property (nonatomic ,strong) PeopleInfo *peopleInfo;
@end

@implementation HomePeopleInfoViewController

- (instancetype)initWithPeopleInfo:(PeopleInfo *)peopleInfo{
    if (self = [super init]) {
        _peopleInfo = peopleInfo;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"建设信息"];
    [self showLoadingView];
    [self getData];
    
    
}
- (void)getData{
    [self showLoadingView];
    [[[NetWorkEngine alloc]init] postWithDict:@{@"id":_peopleInfo.people_id} url:BaseUrl(@"/PesonListXinXi/selectAppPesonsList.action") succed:^(id responseObject) {
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];
        
        if (code == 1) {
            NSDictionary *dict = [[[responseObject objectForKey:@"value"] objectForKey:@"CompanyInformation"] objectAtIndex:0];
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
    }
    return 14;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = 0;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            NSString *str = [NSString stringWithFormat:@"公司名称：%@",_companyInfo.companyName];
            
//            NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:str];
//            [mAttribute addAttribute:NSForegroundColorAttributeName
//                               value:COLOR_THEME
//                               range:NSMakeRange(5, str.length-5)];
            
//            cell.textLabel.attributedText = mAttribute;
        }else if(indexPath.row == 1){
//            cell.textLabel.text = [NSString stringWithFormat:@"法定代表人：%@",_companyInfo.companyLegalRepresentative];
            
        }else{
//            cell.textLabel.text = [NSString stringWithFormat:@"公司注册属地：%@",_companyInfo.companyAddress];
            ;
            
        }
    }else{
        cell.textLabel.text = @"";
        
    }
    
    
    return cell;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        static  UIView *backView;
        if (!_segmentTitleView) {
            
            backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40) titles:@[@"企业资质",@"注册人员",@"工程项目",@"不良",@"良好",@"黑名单",@"变更记录"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
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
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
