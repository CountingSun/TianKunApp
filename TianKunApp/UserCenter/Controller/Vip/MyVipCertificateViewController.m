//
//  MyVipCertificateViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyVipCertificateViewController.h"
#import "CertificateInfo.h"
#import "MyVipCertificateListTableViewCell.h"

@interface MyVipCertificateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) CertificateInfo *certificateInfo;
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic, strong)  WQTableView *tableView;

@end

@implementation MyVipCertificateViewController
- (instancetype)initWithType:(NSInteger)type certificateInfo:(CertificateInfo *)certificateInfo{
    if (self = [super init]) {
        _type = type;
        _certificateInfo = certificateInfo;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == 1) {
        [self.titleView setTitle:@"个人证书详情"];
        
    }else{
        [self.titleView setTitle:@"企业证书详情"];
        
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"MyVipCertificateListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyVipCertificateListTableViewCell"];
    [self.tableView reloadData];
    

}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 40;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyVipCertificateListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyVipCertificateListTableViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.nameLabel.text = @"企业名称：";
            cell.detailLabel.text = _certificateInfo.company_name;
        }
            break;
        case 1:
        {
            cell.nameLabel.text = @"证书类型：";
            cell.detailLabel.text = _certificateInfo.certificate_name;
            
        }
            break;
        case 2:
        {
            cell.nameLabel.text = @"发证日期：";
            cell.detailLabel.text = [NSString timeReturnDateString:_certificateInfo.opening_date formatter:@"yyyy-MM-dd"];
        }
            break;
        case 3:
        {
            cell.nameLabel.text = @"到期日期：";
            cell.detailLabel.text = [NSString timeReturnDateString:_certificateInfo.remind_date formatter:@"yyyy-MM-dd"];
        }
            break;
        case 4:
        {
            NSString *string = @"";
            
            if (_certificateInfo.certificate_type_names.count) {
                string = [string stringByAppendingString:_certificateInfo.certificate_type_names[0]];

            }
            string = [string stringTackOutBlankLine];
            cell.nameLabel.text = @"专业类别：";
            cell.detailLabel.text = string;
            
            
        }
            break;
        case 5:
        {
            cell.nameLabel.text = @"提醒内容：";
            cell.detailLabel.text = _certificateInfo.remind;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
