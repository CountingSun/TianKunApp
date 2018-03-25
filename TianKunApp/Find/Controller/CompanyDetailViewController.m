
//
//  CompanyDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CompanyIntroduceTableViewCell.h"
#import "HomeListTableViewCell.h"
#import "AppShared.h"

@interface CompanyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *rightBarButtonView;
@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;

@property (weak, nonatomic) IBOutlet QMUIButton *shareButton;

@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"详情"];
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:0];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        [_arrData addObject:@""];
        
    }

    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBarButtonView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];



}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = _headView;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 45;
        [self.view addSubview:self.tableView];

        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return _arrData.count;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
        
    }
    if (section == 2) {
        return 40;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        view.backgroundColor = COLOR_WHITE;
        
        WQLabel *label = [[WQLabel alloc]initWithFrame:CGRectMake(15, 0, 200, 40) font:[UIFont systemFontOfSize:14] text:@"更多推荐" textColor:COLOR_TEXT_BLACK textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [view addSubview:label];
        
        return view;
    }
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellID = @"defCellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        switch (indexPath.row) {
            case 0:
                {
                    NSAttributedString *titleAttributedString = [self dealStringWithString:@"联系人：" color:COLOR_TEXT_LIGHT fontSize:14];
                    NSAttributedString *detailAttributedString = [self dealStringWithString:@"赵经理" color:COLOR_TEXT_BLACK fontSize:14];
                    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                    [attStr appendAttributedString:titleAttributedString];
                    [attStr appendAttributedString:detailAttributedString];

                    cell.textLabel.attributedText = attStr;
                    
                }
                break;
            case 1:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"联系电话：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:@"13111111111" color:COLOR_THEME fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 2:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"资质类型：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:@"专业承包" color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 3:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"商家地址：" color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:@"管城区区陇海路城东路" color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;

            default:
                break;
        }
        return cell;
        
    }else if (indexPath.section == 1){
        CompanyIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyIntroduceTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CompanyIntroduceTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        cell.contentLable.text = @"微处理器：Pentium4 2GHz / Athlon XP 2000+以上（推荐Pentium4 2.8GHz / Athlon 64 2800+以上）";
        
        return cell;
        
    }else{
        HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeListTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        
        return cell;

    }
    return [UITableViewCell new];

}
- (NSAttributedString *)dealStringWithString:(NSString *)str color:(UIColor *)color fontSize:(CGFloat)fontSize{
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                        NSForegroundColorAttributeName:color
                                                        }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}             
- (IBAction)collectButtonClick:(id)sender {
}

- (IBAction)shareButtonClick:(id)sender {
    [AppShared shared];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
