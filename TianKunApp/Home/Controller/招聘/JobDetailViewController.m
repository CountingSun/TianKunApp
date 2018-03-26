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

@interface JobDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;


@end

@implementation JobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@""];
    
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"JobDetailDescribeTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobDetailDescribeTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JobDetailCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobDetailCompanyTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JobDetailCompanyDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobDetailCompanyDescriptionTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JobViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobViewTableViewCell"];

    [self.tableView beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView endRefresh];
        
    });
    
    [self.tableView reloadData];
    
    
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 130;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_WHITE;
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
        cell.textLabel.text = @"XXXX有限公司®";
        return cell;
        
    }else if (indexPath.section == 1){
        
        JobDetailDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobDetailDescribeTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JobDetailDescribeTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        return cell;

    }else if(indexPath.section == 2){
        JobDetailCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobDetailCompanyTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JobDetailCompanyTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        return cell;

    }else if(indexPath.section == 3){
        JobDetailCompanyDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobDetailCompanyDescriptionTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JobDetailCompanyDescriptionTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        return cell;

    }else{
        JobViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobViewTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JobViewTableViewCell" owner:nil options:nil] firstObject];
            cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        cell.selectionStyle = 0;
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
