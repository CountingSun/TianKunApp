//
//  AptitudeSelectViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AptitudeSelectViewController.h"

@interface AptitudeSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrData;

@end

@implementation AptitudeSelectViewController
- (instancetype)initWithSelectSucceedBlock:(SelectAptitudeSucceedBlock)succeedBlock
{
    self = [super init];
    if (self) {
        _succeedBlock = succeedBlock;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];

}
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.arrData.count;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.backgroundColor = COLOR_WHITE;
    }
    cell.textLabel.text = self.arrData[indexPath.row];
    return cell;
}

-(NSMutableArray *)arrData{
    
    if (!_arrData) {
        _arrData = [NSMutableArray array];
        [_arrData addObject:@"工程设计1"];
        [_arrData addObject:@"工程设计2"];
        [_arrData addObject:@"工程设计3"];
        [_arrData addObject:@"工程设计4"];
        [_arrData addObject:@"工程设计5"];
        [_arrData addObject:@"工程设计6"];
        [_arrData addObject:@"工程设计7"];
        [_arrData addObject:@"工程设计8"];
        [_arrData addObject:@"工程设计9"];
        [_arrData addObject:@"工程设计10"];

    }
    return _arrData;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_succeedBlock) {
        _succeedBlock(self.arrData[indexPath.row]);
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
