//
//  HistoryViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/23.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryTableViewHeaderView.h"
#import "MenuInfo.h"
#import "HistoryBottomView.h"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) HistoryBottomView *historyBottomView;

@property (nonatomic ,strong) QMUIButton *editButton;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"浏览足迹"];
    [self setupView];
    
}
- (void)setupView{
    
    
    
    _editButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_editButton setImage:[UIImage imageNamed:@"删除"] forState:0];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_editButton addTarget:self action:@selector(editButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_editButton];
    
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:0];
        
        
        for (NSInteger i = 0; i< 30; i++) {
            NSMutableArray *arrOne = [NSMutableArray array];
            for (NSInteger j = 0; j<20; j++) {
                MenuInfo *menuInfo = [[MenuInfo alloc]initWithMenuName:[NSString stringWithFormat:@"section%@  row%@",@(i),@(j)] menuIcon:@"" menuID:0];
                
                [arrOne addObject:menuInfo];
            }
            [_arrData addObject:arrOne];
        }
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoryTableViewCell"];
    
    [self.tableView beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView endRefresh];
        
    });
    
    [self.tableView reloadData];
    _historyBottomView = [[[NSBundle mainBundle] loadNibNamed:@"HistoryBottomView" owner:nil options:nil] firstObject];
    [self.view addSubview:_historyBottomView];
    [_historyBottomView.selectButton addTarget:self action:@selector(allSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_historyBottomView.clearnButton addTarget:self action:@selector(clearnSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_historyBottomView.unUseButton addTarget:self action:@selector(unUseButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [_historyBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView).offset(50);
        make.left.equalTo(self.view);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(50);
        
    }];
    

}
- (void)allSelectButtonClick{
    
    _historyBottomView.selectButton.selected =! _historyBottomView.selectButton.selected;
}
- (void)unUseButtonClick{
    
}
- (void)clearnSelectButtonClick{
    
}

- (void)editButtonEvent{
    
    if (_tableView.editing) {
        NSArray<NSIndexPath *> *arrRows =   [_tableView indexPathsForSelectedRows];
        
        [arrRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MenuInfo *menuInfo = _arrData[obj.section][obj.row];
            menuInfo.menuID = 1;
        }];
        TICK
        [self disposeArr];
        TOCK
        
        [_tableView reloadData];
        
        
        
        
        
        [_tableView setEditing:NO animated:YES];
        [_editButton setImage:[UIImage imageNamed:@"删除"] forState:0];
        [_editButton setTitle:@"" forState:0];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  );
            }];
            [self.view layoutIfNeeded];
        }];


    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-50);
            }];
            [self.view layoutIfNeeded];

        }];

        [_editButton setImage:nil forState:0];
        [_editButton setTitle:@"取消" forState:0];

        [_tableView setEditing:YES animated:YES];
        
    }
}
- (void)disposeArr{
    [_arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *arr = _arrData[idx];
        
        if (arr.count == 0) {
            [_arrData removeObject:arr];
            [self disposeArr];

            *stop = YES;

        }
        __block BOOL isBreak;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MenuInfo *menuInfo = obj;
            
            if (menuInfo.menuID == 1) {
                [arr removeObject:obj];
                [self disposeArr];
                isBreak = YES;
                *stop = YES;
                
                
            }
        }];
        if (isBreak) {
            *stop = YES;
        }
        
        
    }];

}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
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
#pragma makr- tableview delegate datasour

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrData[section] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HistoryTableViewHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HistoryTableViewHeaderView"];
    if (!view) {
        view = [[HistoryTableViewHeaderView alloc]initWithReuseIdentifier:@"HistoryTableViewHeaderView"];
        
    }
    view.label.text = @"今天";
    return view;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:nil options:nil] firstObject];
    }
    MenuInfo *menInfo =self.arrData[indexPath.section][indexPath.row];

    cell.titleLabel.text = menInfo.menuName;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
