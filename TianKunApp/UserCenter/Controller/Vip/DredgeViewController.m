//
//  DredgeViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "DredgeViewController.h"
#import "NSString+WQString.h"
#import "DredgeTableViewCell.h"

@interface DredgeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *hierLabel;

@end

@implementation DredgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"开通VIP"];
    [self setupUI];
    
    
}
- (void)setupUI{
    _vipLabel.textColor = COLOR_THEME;
    
    
    _tableView.tableHeaderView = self.headView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"DredgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"DredgeTableViewCell"];
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DredgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DredgeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"支付宝"];
        cell.label.text = @"支付宝";
        cell.iamgeView.image = [UIImage imageNamed:@"选中"];


    }else{
        cell.iconImageView.image = [UIImage imageNamed:@"微信"];
        cell.label.text = @"微信";
        
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DredgeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.iamgeView.image = [UIImage imageNamed:@"选中"];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    DredgeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.iamgeView.image = [UIImage imageNamed:@"未选中"];

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
