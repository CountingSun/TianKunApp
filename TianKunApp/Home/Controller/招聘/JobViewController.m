//
//  JobViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "JobViewController.h"
#import "FilterView.h"
#import "UIView+Extension.h"
#import "JobViewTableViewCell.h"
#import "JobDetailViewController.h"

@interface JobViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet QMUIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet QMUIButton *thirdButton;
@property (nonatomic ,strong) FilterView *filterView;
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"招聘"];
    
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"JobViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobViewTableViewCell"];
    
    [self.tableView beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView endRefresh];
        
    });
    
    [self.tableView reloadData];
    

}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
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
            make.top.equalTo(self.view).offset(45);
        }];
        
        
        
        
    }
    return _tableView;
}
#pragma makr- tableview  d d
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobViewTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JobViewTableViewCell" owner:nil options:nil] firstObject];
        cell.contentView.backgroundColor = COLOR_VIEW_BACK;
    }
    cell.selectionStyle = 0;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobDetailViewController *vc = [[JobDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma makr- button click
- (IBAction)firstButtonClick:(id)sender {
    if (self.filterView.state == 1) {
        [self.filterView hiddenFilterView];
        self.filterView.state = 4;
        return;
    }
    if ([self.filterView isShow]) {
        [self.filterView reloadWithKey:@""];
    }else{
        [self.filterView showFilterView];
        
    }
    self.filterView.state = 1;
    
}
- (IBAction)secondButtonClick:(id)sender {
    if (self.filterView.state == 2) {
        [self.filterView hiddenFilterView];
        self.filterView.state = 4;
        return;
    }

    if ([self.filterView isShow]) {
        [self.filterView reloadWithKey:@""];
    }else{
        [self.filterView showFilterView];
        
    }
    self.filterView.state = 2;

}
- (IBAction)thirdButtonClick:(id)sender {
//    if (_currectType == 3) {
//        [self.filterView hiddenFilterView];
//        _currectType = 4;
//        return;
//    }
//
//    if ([self.filterView isShow]) {
//        [self.filterView reloadWithKey:@""];
//    }else{
//        [self.filterView showFilterView];
//
//    }
//    _currectType = 3;
    self.filterView.state = 4;

    [self.filterView hiddenFilterView];

}

#pragma mark- lazy init
- (FilterView *)filterView{
    if (!_filterView) {
        _filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0)];
        [self.view addSubview:_filterView];
        _filterView.hidden = YES;
    }
    return _filterView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
