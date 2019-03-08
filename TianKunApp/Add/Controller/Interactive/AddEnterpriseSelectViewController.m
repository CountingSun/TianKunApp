//
//  AddEnterpriseSelectViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/6.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddEnterpriseSelectViewController.h"
#import "ClassTypeInfo.h"

@interface AddEnterpriseSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) ClassTypeInfo *classTypeInfo;

@end

@implementation AddEnterpriseSelectViewController
- (instancetype)initWithClassTypeInfo:(ClassTypeInfo *)classTypeInfo{
    if (self = [super init]) {
        _classTypeInfo = classTypeInfo;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"请选择板块"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    _tableView.tableFooterView = [UIView new];
    [self showLoadingView];
    [self getClass];
    

}
- (void)getClass{
    
    [[[NetWorkEngine alloc]init] getWithUrl:BaseUrl(@"find.forum.type.ancestor") succed:^(id responseObject) {
        [self hideLoadingView];
        if(!_arrData){
            _arrData = [NSMutableArray array];
            
        }
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1){
            
            NSMutableArray *arrClass = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            for(NSDictionary *dict in arrClass){
                ClassTypeInfo *info = [ClassTypeInfo mj_objectWithKeyValues:dict];
                [_arrData addObject:info];
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
    return _arrData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    ClassTypeInfo *jobTypeInfo = _arrData[indexPath.row];
    cell.textLabel.text = jobTypeInfo.typeName;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        ClassTypeInfo *classTypeInfo = _arrData[indexPath.row];
        
        if (_selectSucceedBlock) {
            _selectSucceedBlock(classTypeInfo);
            
        }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
