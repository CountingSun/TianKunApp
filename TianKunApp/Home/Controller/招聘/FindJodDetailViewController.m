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

@interface FindJodDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@end

@implementation FindJodDetailViewController

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
    
    [_tableView registerNib:[UINib nibWithNibName:@"FindJobDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindJobDetailTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"FindJobTableViewCell." bundle:nil] forCellReuseIdentifier:@"FindJobTableViewCell."];
    
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
        }
        cell.selectionStyle = 0;
        return cell;
        
    }else {
        FindJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindJobTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FindJobTableViewCell" owner:nil options:nil] firstObject];
            cell.backgroundColor = COLOR_VIEW_BACK;

        }
        cell.selectionStyle = 0;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
