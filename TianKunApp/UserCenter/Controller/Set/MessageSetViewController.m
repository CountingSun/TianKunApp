//
//  MessageSetViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MessageSetViewController.h"
#import "MessageSetTableViewCell.h"
#import "MessageSetVoiceTableViewCell.h"

@interface MessageSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) UISwitch *messageSwitch;
@property (nonatomic ,strong) UISwitch *recommendSwitch;
@property (nonatomic ,strong) UISwitch *voiceSwitch;
@property (nonatomic ,strong) UISwitch *shakegeSwitch;

@end

@implementation MessageSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}
- (void)setupUI{
    [self.titleView setTitle:@"消息设置"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MessageSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageSetTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MessageSetVoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageSetVoiceTableViewCell"];
    _tableView.tableFooterView = [UIView new];

    [self.tableView reloadData];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MessageSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageSetTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.mainLabel.text = @"系统消息";
            cell.detilLabel.text = @"系统通知、聊天消息等必提醒";
            _messageSwitch =  cell.selectSwitch;
            
            
        }else{
            cell.mainLabel.text = @"热门推荐";
            cell.detilLabel.text = @"为您推荐精准帖子、热门活动及内容";
            _recommendSwitch =  cell.selectSwitch;

        }
            return cell;
    }else{
        MessageSetVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageSetVoiceTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.mainLabel.text = @"声音";
            _voiceSwitch =  cell.selectSwicch;

        }else{
            cell.mainLabel.text = @"震动";
            _shakegeSwitch =  cell.selectSwicch;

        }
        return cell;
        }

    
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
