//
//  RemindMessageViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "RemindMessageViewController.h"
#import "RemindMessageHeadTableViewCell.h"
#import "RemindMessageTableViewCell.h"

@interface RemindMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@end

@implementation RemindMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"到期提醒" ];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RemindMessageHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemindMessageHeadTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RemindMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemindMessageTableViewCell"];

    [self.tableView beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView endRefresh];
        
    });
    
    [self.tableView reloadData];
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.separatorColor = COLOR_VIEW_BACK;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [_tableView headerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView endRefresh];
                
            });
            
        }];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = COLOR_WHITE;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 2, 30)];
        [view addSubview:label];
        label.backgroundColor =COLOR_THEME;
        
        WQLabel *titleLabel = [[WQLabel alloc]initWithFrame:CGRectMake(18, 0, 0, 0) font:[UIFont systemFontOfSize:16] text:@"我的证书" textColor:COLOR_TEXT_BLACK textAlignment:NSTextAlignmentLeft numberOfLine:1];
        
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
        
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:lineView];
        
        
        
        
        return view;
    }else{
        return [UIView new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        RemindMessageHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindMessageHeadTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindMessageHeadTableViewCell" owner:nil options:nil] firstObject];
        }
        
        return cell;

    }else{
        RemindMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindMessageTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindMessageTableViewCell" owner:nil options:nil] firstObject];
        }
        
        return cell;

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
