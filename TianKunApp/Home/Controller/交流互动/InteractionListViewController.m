//
//  InteractionListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "InteractionListViewController.h"
#import "InteractionListTableViewCell.h"

@interface InteractionListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@end

@implementation InteractionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InteractionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InteractionListTableViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
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
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        [_tableView headerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView endRefresh];
                
            });
            
        }];
        [self.view addSubview:_tableView];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InteractionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InteractionListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InteractionListTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = 0;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
