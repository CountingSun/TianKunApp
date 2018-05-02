//
//  AptitudeSelectViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AptitudeSelectViewController.h"
#import "ClassTypeInfo.h"

@interface AptitudeSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

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
- (void)setArrData:(NSMutableArray *)arrData{
    _arrData = arrData;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    

}
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.qmui_width, 200) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
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
    ClassTypeInfo *info = self.arrData[indexPath.row];
    cell.textLabel.text = info.typeName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassTypeInfo *info = self.arrData[indexPath.row];

    if (_succeedBlock) {
        _succeedBlock(info,_indexPath);
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
