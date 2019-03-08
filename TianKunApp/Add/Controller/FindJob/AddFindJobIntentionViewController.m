//
//  AddFindJobIntentionViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddFindJobIntentionViewController.h"
#import "ClassTypeInfo.h"


@interface AddFindJobIntentionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrClass;

@end

@implementation AddFindJobIntentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"期望领域"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    _tableView.tableFooterView = [UIView new];
    [self getClass];
    [self showLoadingView];

}
- (void)getClass{
    [[[NetWorkEngine alloc]init] postWithDict:@{@"pageNo":@"1",@"pageSize":@"30"} url:BaseUrl(@"find.tender.type.ancestor") succed:^(id responseObject) {
        [self hideLoadingView];
        if(!_arrClass){
            _arrClass = [NSMutableArray array];
            
        }
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1){
            
            NSMutableArray *arrClass = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            for(NSDictionary *dict in arrClass){
                ClassTypeInfo *info = [ClassTypeInfo mj_objectWithKeyValues:dict];
                [_arrClass addObject:info];
            }
            [self.tableView reloadData];
            
        }else{
            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getClass];
            }];
            
        }
        
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getClass];
        }];
        
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrClass.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    ClassTypeInfo *info = _arrClass[indexPath.row];
    
    cell.textLabel.text = info.typeName;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassTypeInfo *info = _arrClass[indexPath.row];
    if (_selectSucceedBlock) {
        _selectSucceedBlock(info);
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
}
- (NSMutableArray *)arrClass{
    if (!_arrClass) {
        _arrClass = [NSMutableArray arrayWithCapacity:11];
        
    }
    return _arrClass;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
