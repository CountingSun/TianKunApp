//
//  AptitudeSelectViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AptitudeSelectViewController.h"
#import "ClassTypeInfo.h"
#import "AptitudeSelectTableViewCell.h"

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
    [self.tableView registerNib:[UINib nibWithNibName:@"AptitudeSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"AptitudeSelectTableViewCell"];


}
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 200) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 45;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)setTableViewSize:(CGSize)tableViewSize{
    self.tableView.frame = CGRectMake(0, 0, tableViewSize.width, tableViewSize.height);
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _arrData.count;
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AptitudeSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AptitudeSelectTableViewCell"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AptitudeSelectTableViewCell" owner:nil options:nil] firstObject];
    }
    ClassTypeInfo *info = _arrData[indexPath.row];
    cell.titleLabel.text = info.typeName;
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
