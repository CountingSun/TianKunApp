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
#import "Historyinfo.h"

@interface HistoryViewModel ()
@property (nonatomic, copy) NSString *time;
@property (nonatomic ,strong) NSMutableArray *arrInfo;
@end

@implementation HistoryViewModel
@end

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) HistoryBottomView *historyBottomView;

@property (nonatomic ,strong) QMUIButton *editButton;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic ,strong) NSMutableDictionary *resultDict;



@end


@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"浏览足迹"];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;
    
    [self setupView];
    [self showLoadingView];
    [self getData];
    
}
- (void)getData{
    
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
        
    }
    
    [_netWorkEngine postWithDict:@{@"userId":[UserInfoEngine getUserInfo].userID,@"pageNo":@(_pageIndex),@"pageSize":@(_pageSize)} url:BaseUrl(@"find.watchRecord.by.user.id") succed:^(id responseObject) {
        [self.tableView endRefresh];
        [self hideLoadingView];

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            if (arr.count) {
                [_arrData removeAllObjects];
                if (_pageIndex == 1) {
                    [_resultDict removeAllObjects];
                }
                for (NSDictionary *dict in arr) {
                    Historyinfo *info = [Historyinfo mj_objectWithKeyValues:dict];
                    [self dealHistoryInfo:info];
                    
                }
                [self dealDict];
                if (arr.count<_pageSize) {
                    self.tableView.canLoadMore = NO;
                }else{
                    self.tableView.canLoadMore = YES;
                }

            }else{
                if (!_arrData.count) {
                    [self showGetDataNullWithReloadBlock:^{
                        [self showLoadingView];
                        [self getData];
                    }];
                    _editButton.enabled = NO;

                }else{
                    _pageIndex--;
                    _editButton.enabled = YES;
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }

            }
            
            
        }else{
            if (!_arrData.count) {
                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    [self getData];
                }];
                _editButton.enabled = NO;

            }else{
                _pageIndex--;
                _editButton.enabled = YES;
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
            }
            
        }
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [_tableView endRefresh];
        if (_arrData.count) {
            _pageIndex = 1;
            _editButton.enabled = YES;
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            _editButton.enabled = NO;

            _pageIndex = 1;
            [self showGetDataFailViewWithReloadBlock:^{
                [self hideEmptyView];
                [self showLoadingView];
                [self getData];
            }];
            
        }
        
    }];
    
}
- (void)setupView{
    
    
    
    _editButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_editButton setImage:[UIImage imageNamed:@"删除"] forState:0];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_editButton addTarget:self action:@selector(editButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    _editButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_editButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoryTableViewCell"];
    
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
    if (_historyBottomView.selectButton.selected) {
        [_arrData enumerateObjectsUsingBlock:^(HistoryViewModel *info, NSUInteger section, BOOL * _Nonnull stop) {
            NSMutableArray *arr = info.arrInfo;
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
                [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionNone];
                
                
            }];
            
        }];

    }else{
        [_arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger section, BOOL * _Nonnull stop) {
            NSMutableArray *arr = obj;
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
                [_tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES];
                
                
            }];
            
        }];

    }
    
    
}
- (void)unUseButtonClick{
    
}
- (void)clearnSelectButtonClick{
    NSArray<NSIndexPath *> *arrRows =   [_tableView indexPathsForSelectedRows];
    
    __block NSString *idsString = @"";

    [arrRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        HistoryViewModel *model = _arrData[indexPath.section];
        
        Historyinfo *info = model.arrInfo[indexPath.row];
        idsString = [idsString stringByAppendingString:[NSString stringWithFormat:@"%@,",@(info.data_id)]];
    }];
    if (idsString.length) {
        idsString  = [idsString qmui_stringByRemoveLastCharacter];
        [self deleteCollectWithIDS:idsString succeedBlock:^{
            [arrRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                HistoryViewModel *model = _arrData[indexPath.section];
                Historyinfo *info = model.arrInfo[indexPath.row];
                info.isSelect = YES;
            }];
            [self disposeArr];
            [self.tableView reloadData];
            if (!_arrData.count) {
                [self getData];
            }

        }];
        
        
    }else{
        [self showErrorWithStatus:@"请选择要删除的内容"];
    }


    


}
- (void)deleteCollectWithIDS:(NSString *)ids succeedBlock:(dispatch_block_t)block{
    self.view.userInteractionEnabled = NO;
    _editButton.enabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    [self.netWorkEngine postWithDict:@{@"id":ids} url:BaseUrl(@"delete.watchRecord.by.id") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        self.view.userInteractionEnabled = YES;
        _editButton.enabled = YES;
        
        if (code == 1) {
            [self showSuccessWithStatus:@"删除成功"];
            if (block) {
                block();
            }
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        _editButton.enabled = YES;
        
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];

}
- (void)editButtonEvent{
    
    if (_tableView.editing) {
        _tableView.canLoadMore = YES;
        _tableView.canRefresh = YES;

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
        _tableView.canLoadMore = NO;
        _tableView.canRefresh = NO;

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
        HistoryViewModel *model = _arrData[idx];
        
        NSMutableArray *arr = model.arrInfo;
        
        if (arr.count == 0) {
            [_arrData removeObject:model];
            [self disposeArr];

            *stop = YES;

        }
        __block BOOL isBreak = NO;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Historyinfo *info = obj;
            
            if (info.isSelect == YES) {
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
        __weak typeof(self) weakSelf = self;
        [_tableView headerWithRefreshingBlock:^{
            _pageIndex = 1;
            [weakSelf getData];
        }];
        [_tableView footerWithRefreshingBlock:^{
            _pageIndex ++;
            [weakSelf getData];
            
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
    HistoryViewModel *model = _arrData[section];
    
    return model.arrInfo.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HistoryTableViewHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HistoryTableViewHeaderView"];
    if (!view) {
        view = [[HistoryTableViewHeaderView alloc]initWithReuseIdentifier:@"HistoryTableViewHeaderView"];
        
    }
    HistoryViewModel *model = _arrData[section];

    view.label.text = model.time;
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
    HistoryViewModel *model = _arrData[indexPath.section];

    Historyinfo *info =model.arrInfo[indexPath.row];
    cell.titleLabel.text = info.data_title;
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:info.data_picture_url] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_11]];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;

}
- (void)dealHistoryInfo:(Historyinfo *)historyinfo{
    
    if (!_resultDict) {
        _resultDict = [NSMutableDictionary dictionary];
    }
    NSString *key = [NSString timeReturnDateString:historyinfo.create_date formatter:@"yyyy-MM-dd"];
    
    NSMutableArray *arr = [_resultDict objectForKey:key];
    if (arr) {
        [arr addObject:historyinfo];
        [_resultDict setObject:arr forKeyedSubscript:key];

    }else{
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:historyinfo];
        [_resultDict setObject:arr forKeyedSubscript:key];

    }
    
    
    
}
- (void)dealDict{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
    }
    [_resultDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        HistoryViewModel *mode = [[HistoryViewModel alloc]init];
        mode.time = key;
        mode.arrInfo = obj;
        
        [_arrData addObject:mode];
        
    }];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    [_arrData sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.tableView reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
