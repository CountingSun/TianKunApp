//
//  DetailListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "DetailListViewController.h"
#import "CompanyInfo.h"

@interface DetailListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.titleView setTitle:@"公司详情"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"公司名称：%@",_companyInfo.companyName];
        }
            break;
        case 1:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"企业法定代表人：%@",_companyInfo.companyLegalRepresentative];
        }
            break;

        case 2:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"企业注册属地：%@",_companyInfo.registered_address];
        }
            break;

        case 3:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"统一社会信用代码：：%@",_companyInfo.companySocialNum];
        }            break;
            break;

        case 4:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"企业登记注册类型：%@",_companyInfo.companyType];
        }
            break;

        case 5:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"企业经营地址：%@",_companyInfo.companyAddress];
        }
            break;

        default:
            break;
    }
    
    
    return cell;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
