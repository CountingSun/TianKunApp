//
//  FindImageListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindImageListViewController.h"
#import "FindImageListTableViewCell.h"
#import "CompanyDetailViewController.h"

@interface FindImageListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic, copy) NSString *viwTitle;

@end

@implementation FindImageListViewController

- (instancetype)initWithViewTitle:(NSString *)viewTitle{
    if (self = [super init]) {
        _viwTitle = viewTitle;
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:_viwTitle];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FindImageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindImageListTableViewCell"];
    
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
        _tableView.rowHeight = 60;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindImageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindImageListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FindImageListTableViewCell" owner:nil options:nil] firstObject];
        cell.titleLabel.textColor = COLOR_TEXT_BLACK;
        cell.detailLabel.textColor = COLOR_TEXT_LIGHT;

    }
    cell.iconImageView.image = [UIImage imageNamed:DEFAULT_IMAGE_11];
    cell.titleLabel.text = @"标题标题标题标题标题标题标题";
    cell.detailLabel.text = @"详细详细详细详细详细详细详细";

    cell.selectionStyle = 0;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CompanyDetailViewController *viewController = [[CompanyDetailViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];

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
