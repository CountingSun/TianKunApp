//
//  ExpertMessageViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/25.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ExpertMessageViewController.h"
#import "ExpertTableViewCell.h"
#import "ExpertMessageInfo.h"

@interface ExpertMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@end

@implementation ExpertMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"专家消息"];
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:0];
        
        for (NSInteger i = 0; i < 15 ; i++) {
            ExpertMessageInfo *info = [[ExpertMessageInfo alloc]init];
            info.messageTitle = [NSString stringWithFormat:@"初音未来%@",@(i)];
            info.messageTime = [NSString stringWithFormat:@"2018-3-20 16:%@",@(i)];
            info.messageDetail = [NSString stringWithFormat:@"初音未来（初音ミク/Hatsune Miku），是2007年8月31日由CRYPTON FUTURE MEDIA以Yamaha的VOCALOID系列语音合成程序为基础开发的音源库，音源数据资料采样于日本声优藤田咲。\n  2010年4月30日，发布初音未来6种不同声调的版本“初音未来Append”。2013年8月31日，初音未来英文版本同VOCALOID3一并发行。[1]  此外，初音未来还担任日本音乐团体Sound Horizon的演唱与合唱。随着“初音未来”声库的发售，这种成功的营销方式大幅改变了电子音乐人对于音乐业的认知和整个行业的格局。在衍生文化现象后，初音未来可指代包装封面上的那位葱色头发的少女形象，还可指活跃在动画漫画中出现的“人气歌手”。%@",@(i)];
            info.isOpen = NO;
            
            [_arrData addObject:info];

        }
        
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ExpertTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExpertTableViewCell"];
    
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
        _tableView.estimatedRowHeight = 138;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertTableViewCell" forIndexPath:indexPath];
    cell.messageInfo = self.arrData[indexPath.row];
    cell.cellIndexPath = indexPath;
    
    cell.clickLookAllButtonBlock = ^(NSIndexPath *cellIndexPath) {
    
        [_tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
