//
//  AddSelectJobTypeViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/29.
//  Copyright © 2018年 天堃. All rights reserved.
//


#import "AddSelectJobTypeViewController.h"
#import "ClassTypeInfo.h"


@interface AddSelectJobTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) ClassTypeInfo *classTypeInfo;
@end

@implementation AddSelectJobTypeViewController
- (instancetype)initWithClassTypeInfo:(ClassTypeInfo *)classTypeInfo{
    if (self = [super init]) {
        _classTypeInfo = classTypeInfo;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;

    [self.titleView setTitle:@"请选择职位类型"];
    [self showLoadingView];

    if (_classTypeInfo) {
        [self getJobTypeWithID:_classTypeInfo.typeID];
        
    }else{
        [self getJobTypeWithID:@"15"];

    }
    
    
}
- (void)getJobTypeWithID:(NSString *)typeID{
    
    
    [[[NetWorkEngine alloc]init] postWithDict:@{@"edificeid":typeID} url:BaseUrl(@"home/getcategory.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];
        if (!_arrData) {
            _arrData = [NSMutableArray array];
        }
        if (code == 1) {
            NSMutableArray *arrData = [[responseObject objectForKey:@"value"] objectForKey:@"zwlx"];
            for (NSDictionary *dict in arrData) {
                ClassTypeInfo *jobTypeInfo = [ClassTypeInfo mj_objectWithKeyValues:dict];
                [_arrData addObject:jobTypeInfo];
                
            }
            [_tableView reloadData];
            
        }else{
            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView ];
                if (_classTypeInfo) {
                    [self getJobTypeWithID:_classTypeInfo.typeID];
                    
                }else{
                    [self getJobTypeWithID:@"15"];
                    
                }

            }];
            
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView ];
            if (_classTypeInfo) {
                [self getJobTypeWithID:_classTypeInfo.typeID];
                
            }else{
                [self getJobTypeWithID:@"15"];
                
            }

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
    if (_classTypeInfo) {
        ClassTypeInfo *jobTypeInfo = _arrData[indexPath.row];
        
        if (_selectSucceedBlock) {
            _selectSucceedBlock(jobTypeInfo);
            
        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([NSStringFromClass([vc class]) isEqualToString:@"FindTalentsViewController"]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }

    }else{
        ClassTypeInfo *jobTypeInfo = _arrData[indexPath.row];

        AddSelectJobTypeViewController *addSelectJobTypeViewController = [[AddSelectJobTypeViewController alloc]initWithClassTypeInfo:jobTypeInfo];
        [self.navigationController pushViewController:addSelectJobTypeViewController animated:YES];
        
        addSelectJobTypeViewController.selectSucceedBlock = ^(ClassTypeInfo *classTypeInfo) {
            
            if (_selectSucceedBlock) {
                _selectSucceedBlock(classTypeInfo);
                
            }
        };
        
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
