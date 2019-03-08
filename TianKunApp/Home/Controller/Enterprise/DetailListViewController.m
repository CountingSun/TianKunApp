//
//  DetailListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "DetailListViewController.h"
#import "DetailListTableViewCell.h"

#import "CompanyInfo.h"
#import "MenuInfo.h"
#import "BlackListInfo.h"
#import "ProjectInfo.h"
#import "ChangeInfo.h"
#import "SpecialBehaviorInfo.h"
#import "AptitudeInfo.h"
#import "PeopleInfo.h"



@interface DetailListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@end

@implementation DetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"DetailListTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailListTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 45;

}
- (void)setViewTitle:(NSString *)viewTitle{
    [self.titleView setTitle:viewTitle];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailListTableViewCell" forIndexPath:indexPath];
    MenuInfo *menuInfo = self.arrData[indexPath.row];
    cell.titleLabel.text = menuInfo.menuName;
    cell.titleLabel.textColor = COLOR_TEXT_BLACK;
    
    cell.detailLabel.text = menuInfo.menuDetail;
    cell.detailLabel.textColor = COLOR_TEXT_BLACK;

    return cell;
    
    
}
#pragma mark- data handle
- (void)setCompanyInfo:(CompanyInfo *)companyInfo{
    
    MenuInfo *info1 = [[MenuInfo alloc] initWithMenuName:@"公司名称：" menuIcon:@"" menuID:0 menuDetail:companyInfo.companyName];
    [self.arrData addObject:info1];
    
    MenuInfo *info2 = [[MenuInfo alloc] initWithMenuName:@"企业法定代表人：" menuIcon:@"" menuID:0 menuDetail:companyInfo.companyLegalRepresentative];
    [self.arrData addObject:info2];
    MenuInfo *info3 = [[MenuInfo alloc] initWithMenuName:@"企业注册属地：" menuIcon:@"" menuID:0 menuDetail:companyInfo.registered_address];
    [self.arrData addObject:info3];
    MenuInfo *info4 = [[MenuInfo alloc] initWithMenuName:@"统一社会信用代码：" menuIcon:@"" menuID:0 menuDetail:companyInfo.companySocialNum];
    [self.arrData addObject:info4];
    MenuInfo *info5 = [[MenuInfo alloc] initWithMenuName:@"企业登记注册类型：" menuIcon:@"" menuID:0 menuDetail:companyInfo.companyType];
    [self.arrData addObject:info5];
    MenuInfo *info6 = [[MenuInfo alloc] initWithMenuName:@"企业经营地址：" menuIcon:@"" menuID:0 menuDetail:companyInfo.companyAddress];
    [self.arrData addObject:info6];
     
    [ self.tableView reloadData];
    
}
- (void)setAptitudeInfo:(AptitudeInfo *)aptitudeInfo{
    MenuInfo *info1 = [[MenuInfo alloc] initWithMenuName:@"资质类别：" menuIcon:@"" menuID:0 menuDetail:aptitudeInfo.lbname];
    [self.arrData addObject:info1];
    
    MenuInfo *info2 = [[MenuInfo alloc] initWithMenuName:@"资质证书号：" menuIcon:@"" menuID:0 menuDetail:aptitudeInfo.zsbh];
    [self.arrData addObject:info2];
    MenuInfo *info3 = [[MenuInfo alloc] initWithMenuName:@"资质名称：" menuIcon:@"" menuID:0 menuDetail:aptitudeInfo.name];
    [self.arrData addObject:info3];
    MenuInfo *info4 = [[MenuInfo alloc] initWithMenuName:@"发证日期：" menuIcon:@"" menuID:0 menuDetail:[NSString timeReturnDateString:aptitudeInfo.fzdate formatter:@"yyyy-MM-dd"]];
    [self.arrData addObject:info4];
    MenuInfo *info5 = [[MenuInfo alloc] initWithMenuName:@"证书有效日期：" menuIcon:@"" menuID:0 menuDetail:[NSString timeReturnDateString:aptitudeInfo.jzdate formatter:@"yyyy-MM-dd"]];
    [self.arrData addObject:info5];
    MenuInfo *info6 = [[MenuInfo alloc] initWithMenuName:@"发证机关：" menuIcon:@"" menuID:0 menuDetail:aptitudeInfo.jg];
    [self.arrData addObject:info6];
    
    [ self.tableView reloadData];

}
- (void)setSpecialBehaviorInfo:(SpecialBehaviorInfo *)specialBehaviorInfo{
    
    MenuInfo *info1 = [[MenuInfo alloc] initWithMenuName:@"诚信记录编号：" menuIcon:@"" menuID:0 menuDetail:specialBehaviorInfo.record_number];
    [self.arrData addObject:info1];
    
    MenuInfo *info2 = [[MenuInfo alloc] initWithMenuName:@"诚信记录主体：" menuIcon:@"" menuID:0 menuDetail:specialBehaviorInfo.record_body];
    [self.arrData addObject:info2];
    MenuInfo *info3 = [[MenuInfo alloc] initWithMenuName:@"决定内容：" menuIcon:@"" menuID:0 menuDetail:specialBehaviorInfo.record_details];
    [self.arrData addObject:info3];
    MenuInfo *info4 = [[MenuInfo alloc] initWithMenuName:@"实施部门（文号）：" menuIcon:@"" menuID:0 menuDetail:specialBehaviorInfo.department_number];
    [self.arrData addObject:info4];
    MenuInfo *info5 = [[MenuInfo alloc] initWithMenuName:@"发布有效期：" menuIcon:@"" menuID:0 menuDetail:[NSString timeReturnDateString:specialBehaviorInfo.expiration_date formatter:@"yyyy-MM-dd"]];
    [self.arrData addObject:info5];
    [ self.tableView reloadData];

}
- (void)setBlackListInfo:(BlackListInfo *)blackListInfo{
    MenuInfo *info1 = [[MenuInfo alloc] initWithMenuName:@"黑名单记录主体：" menuIcon:@"" menuID:0 menuDetail:blackListInfo.blacklist_body];
    [self.arrData addObject:info1];
    
    MenuInfo *info2 = [[MenuInfo alloc] initWithMenuName:@"黑名单认定依据：" menuIcon:@"" menuID:0 menuDetail:blackListInfo.cause];
    [self.arrData addObject:info2];
    MenuInfo *info3 = [[MenuInfo alloc] initWithMenuName:@"认定部门：" menuIcon:@"" menuID:0 menuDetail:blackListInfo.from_department];
    [self.arrData addObject:info3];
    MenuInfo *info4 = [[MenuInfo alloc] initWithMenuName:@"列入黑名单日期：" menuIcon:@"" menuID:0 menuDetail:[NSString timeReturnDateString:blackListInfo.start_time formatter:@"yyyy-MM-dd"]];
    [self.arrData addObject:info4];
    MenuInfo *info5 = [[MenuInfo alloc] initWithMenuName:@"移出黑名单日期：" menuIcon:@"" menuID:0 menuDetail:[NSString timeReturnDateString:blackListInfo.end_time formatter:@"yyyy-MM-dd"]];
    [self.arrData addObject:info5];
    [ self.tableView reloadData];

}
- (void)setChangeInfo:(ChangeInfo *)changeInfo{
    MenuInfo *info1 = [[MenuInfo alloc] initWithMenuName:@"序号：" menuIcon:@"" menuID:0 menuDetail:changeInfo.company_change_number];
    [self.arrData addObject:info1];
    
    MenuInfo *info2 = [[MenuInfo alloc] initWithMenuName:@"变更日期：" menuIcon:@"" menuID:0 menuDetail:[NSString timeReturnDateString:changeInfo.change_date formatter:@"yyyy-MM-dd"]];
    [self.arrData addObject:info2];
    MenuInfo *info3 = [[MenuInfo alloc] initWithMenuName:@"变更内容：" menuIcon:@"" menuID:0 menuDetail:changeInfo.change_contents];
    [self.arrData addObject:info3];

    [ self.tableView reloadData];

}
- (void)setProjectInfo:(ProjectInfo *)projectInfo{
    MenuInfo *info1 = [[MenuInfo alloc] initWithMenuName:@"项目编号：" menuIcon:@"" menuID:0 menuDetail:projectInfo.project_number];
    [self.arrData addObject:info1];
    
    MenuInfo *info2 = [[MenuInfo alloc] initWithMenuName:@"项目名称：" menuIcon:@"" menuID:0 menuDetail:projectInfo.project_name];
    [self.arrData addObject:info2];
    MenuInfo *info3 = [[MenuInfo alloc] initWithMenuName:@"项目属地：" menuIcon:@"" menuID:0 menuDetail:projectInfo.project_address];
    [self.arrData addObject:info3];
    MenuInfo *info4 = [[MenuInfo alloc] initWithMenuName:@"项目类别：" menuIcon:@"" menuID:0 menuDetail:projectInfo.project_type_id];
    [self.arrData addObject:info4];
    MenuInfo *info5 = [[MenuInfo alloc] initWithMenuName:@"建设单位：" menuIcon:@"" menuID:0 menuDetail:projectInfo.development_organization];
    [self.arrData addObject:info5];
    [ self.tableView reloadData];

}
- (NSMutableArray *)arrData{
    if(!_arrData){
        
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
