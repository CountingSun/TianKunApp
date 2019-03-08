//
//  MyCollectViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/7/6.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "MyCollectViewController.h"
#import "HistoryBottomView.h"
#import "UsercollectionInfo.h"
#import "MyCollectListTableViewCell.h"
#import "InvitationDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "JobDetailViewController.h"
#import "FindJodDetailViewController.h"
#import "InteractionDetailViewController.h"
#import "EducationDetailViewController.h"
#import "PlayViewController.h"
#import "CompanyDetailViewController.h"
#import "CooperationDetailViewController.h"

@interface MyCollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) QMUIButton *editButton;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) NSMutableArray<NSIndexPath *> *arrIndexPath;
@property (nonatomic ,strong) NSMutableIndexSet *tableIndexSet;
@property (nonatomic ,strong) HistoryBottomView *historyBottomView;
@property (nonatomic ,assign) BOOL canEdit;

@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"我的收藏"];
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    
    [self setupView];
    [self showLoadingView];
    _editButton.enabled = NO;
    
    [self getData];

}
- (void)getData{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
    [dict setObject:@(_pageIndex) forKey:@"page"];
    [dict setObject:@(_pageSize) forKey:@"count"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"MyCollectibleController/selectmycollectible.action") succed:^(id responseObject) {
      
        [self hideLoadingView];
        [_tableView endRefresh];

        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
            }

            NSMutableArray *arr = [responseObject objectForKey:@"value"];
            
            
            if (arr.count) {
                
                for (NSDictionary *dict in arr) {
                    UsercollectionInfo *info = [[UsercollectionInfo alloc] init];
                    info.collectTime = [dict objectForKey:@"createtime"];
                    info.collectTitle = [dict objectForKey:@"title"];
                    info.collectType = [[dict objectForKey:@"type"] integerValue];
                    info.collectDataID = [[dict objectForKey:@"ttid"] integerValue];
                    info.collectID = [[dict objectForKey:@"id"] integerValue];
                    info.collectIsEffective = [[dict objectForKey:@"deleteflag"] integerValue] ;
                    [_arrData addObject:info];
                }
                [self.tableView reloadData];
                
                
            }
            if (_arrData.count<_pageSize*_pageIndex) {
                _tableView.canLoadMore = NO;
            }else{
                _tableView.canLoadMore = YES;
            }
            if (!_arrData.count) {
                _editButton.enabled = NO;

                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    [self getData];
                }];
                
            }else{
                _editButton.enabled = YES;

            }
        }else{

            if (!_arrData.count) {
                _editButton.enabled = NO;

                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    [self getData];
                }];
                
            }else{
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                _editButton.enabled = YES;

            }
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [_tableView endRefresh];
        if (!_arrData.count) {
            _editButton.enabled = NO;

            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];
            
        }else{
            [self showErrorWithStatus:NET_ERROR_TOST];
            _editButton.enabled = YES;

        }

    }];
}
- (void)setupView{
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoryTableViewCell"];
    
    _historyBottomView = [[[NSBundle mainBundle] loadNibNamed:@"HistoryBottomView" owner:nil options:nil] firstObject];
    [self.view addSubview:_historyBottomView];
    [_historyBottomView.selectButton addTarget:self action:@selector(allSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_historyBottomView.clearnButton addTarget:self action:@selector(clearnSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_historyBottomView.unUseButton addTarget:self action:@selector(unUseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _historyBottomView.unUseButton.hidden = YES;
    [_historyBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(50);
        
    }];
    _editButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_editButton setImage:[UIImage imageNamed:@"删除"] forState:0];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_editButton addTarget:self action:@selector(editButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_editButton];

}
- (void)allSelectButtonClick{
    
    _historyBottomView.selectButton.selected =! _historyBottomView.selectButton.selected;
    if (_historyBottomView.selectButton.selected) {
        [_arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
    }else{
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView deselectRowAtIndexPath:obj animated:NO];
        }];
        
    }
    
    
}
- (void)unUseButtonClick{
    [WQAlertController showAlertControllerWithTitle:@"提示" message:@"您确定要清除失效的收藏吗？" sureButtonTitle:@"确定" cancelTitle:@"取消" sureBlock:^(QMUIAlertAction *action) {
        [self.arrIndexPath removeAllObjects];
        [self.tableIndexSet removeAllIndexes];
        
        __block NSString *idsString = @"";
        __block NSString *types = @"";

        [_arrData enumerateObjectsUsingBlock:^(UsercollectionInfo *info, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!info.collectIsEffective) {
                idsString = [idsString stringByAppendingString:[NSString stringWithFormat:@"%@,",@(info.collectID)]];
                types = [types stringByAppendingString:[NSString stringWithFormat:@"%@,",@(info.collectType)]];

                [_tableIndexSet addIndex:idx];
                [self.arrIndexPath addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                
            }
        }];
        if (idsString.length) {
            idsString  = [idsString qmui_stringByRemoveLastCharacter];
            types  = [types qmui_stringByRemoveLastCharacter];

            [self deleteNoticeCollectWithIDS:idsString types:types];
            
            
        }else{
            [self showErrorWithStatus:@"暂无失效收藏"];
        }
        
        
    } cancelBlock:^(QMUIAlertAction *action) {
        
        
    }];
    
    
    
    
    
}
- (void)clearnSelectButtonClick{
    [self.arrIndexPath removeAllObjects];
    
    NSArray<NSIndexPath *> *arrRows =   [_tableView indexPathsForSelectedRows];
    [self.arrIndexPath addObjectsFromArray:arrRows];
    __block NSString *idsString = @"";
    __block NSString *types = @"";

    [self.tableIndexSet removeAllIndexes];
    
    [arrRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [_tableIndexSet addIndex:indexPath.row];
        UsercollectionInfo *info = _arrData[indexPath.row];
        idsString = [idsString stringByAppendingString:[NSString stringWithFormat:@"%@,",@(info.collectID)]];
        types = [types stringByAppendingString:[NSString stringWithFormat:@"%@,",@(info.collectType)]];

    }];
    if (idsString.length) {
        idsString  = [idsString qmui_stringByRemoveLastCharacter];
        types  = [types qmui_stringByRemoveLastCharacter];

        [self deleteNoticeCollectWithIDS:idsString types:types];
        
        
    }else{
        [self showErrorWithStatus:@"请选择要删除的内容"];
    }
    
    
    
}

- (void)editButtonEvent{
    
    if (_tableView.editing) {
        _tableView.canRefresh = YES;
        _tableView.canLoadMore = YES;
        
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
        _tableView.canRefresh = NO;
        _tableView.canLoadMore = NO;

        [UIView animateWithDuration:0.3 animations:^{
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-50);
            }];
            [self.view layoutIfNeeded];
            
        }];
        [_editButton setImage:nil forState:0];
        [_editButton setTitle:@"完成" forState:0];
        
        [_tableView setEditing:YES animated:YES];
        
    }
}
- (void)deleteNoticeCollectWithIDS:(NSString *)ids types:(NSString *)types{
    self.view.userInteractionEnabled = NO;
    _editButton.enabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:ids forKey:@"list1"];
    [dict setObject:types forKey:@"list2"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"MyCollectibleController/deletemycollectible.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        self.view.userInteractionEnabled = YES;
        _editButton.enabled = YES;
        
        if (code == 1) {
            [self editButtonEvent];
            [self showSuccessWithStatus:@"删除成功"];
            [self.arrData removeObjectsAtIndexes:_tableIndexSet];
            [self.tableView deleteRowsAtIndexPaths:_arrIndexPath withRowAnimation:UITableViewRowAnimationFade];
            if (!_arrData.count) {
                [self getData];
            }
            _tableView.canRefresh = YES;
            
            
            
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        _editButton.enabled = YES;
        
        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];

}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.backgroundColor = COLOR_VIEW_BACK;
        
        __weak typeof(self) weakSelf = self;
        
        [_tableView headerWithRefreshingBlock:^{
            weakSelf.pageIndex = 1;
            [self getData];
        }];
        [_tableView footerWithRefreshingBlock:^{
            weakSelf.pageIndex ++;
            [self getData];
            
        }];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
#pragma makr- tableview delegate datasour

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCollectListTableViewCell" owner:nil options:nil] firstObject];
    }
    UsercollectionInfo *info =self.arrData[indexPath.row];
    cell.titleLabel.text = info.collectTitle;
    
    if (info.collectIsEffective) {
        cell.timeLabel.text = [NSString timeReturnDateString:info.collectTime formatter:@"yyyy-MM-dd"];

    }else{
        cell.timeLabel.text = @"失效";

    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.isEditing) {
        return;
    }
    UsercollectionInfo *info =self.arrData[indexPath.row];
    if (!info.collectIsEffective) {
        return;

    }
//    招标：（type=1）
//
//    中标：（type=11）
//
//    行业资讯：（type=2）
//
//    文件通知：（type=3）
//
//    公示公告：（type=4）
//
//    企业招聘：（type=5）
//
//    人才求职：（type=6）
//
//    互动交流：（type=7）
//
//    教育培训：（type=8）文本
//
//    教育培训：（type=12）音频
//
//    教育培训：（type=13）视频
//
//    企业收藏：（type=9）
//
//    商务合作：tk_cooperation_collectible（type=10）
    switch (info.collectType) {
        case 1:
            {
                
            InvitationDetailViewController *vc = [[InvitationDetailViewController alloc] initWithInvitationID:info.collectDataID fromType:1];
                vc.deleteCollectBlock = ^{
                    [_arrData removeObjectAtIndex:indexPath.row];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    if (!_arrData.count) {
                        [self showLoadingView];
                        [self getData];
                    }

                };
                
            [self.navigationController pushViewController:vc animated:YES];

            }
            break;
        case 11:{
            InvitationDetailViewController *vc = [[InvitationDetailViewController alloc] initWithInvitationID:info.collectDataID fromType:2];
            vc.deleteCollectBlock = ^{
                [_arrData removeObjectAtIndex:indexPath.row];
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (!_arrData.count) {
                    [self showLoadingView];
                    [self getData];
                }

            };

            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 2:{
            ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] initWithArticleID:info.collectDataID fromType:3];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 3:{
            ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] initWithArticleID:info.collectDataID fromType:1];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 4:{
            ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] initWithArticleID:info.collectDataID fromType:2];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5:{
            JobDetailViewController *vc = [[JobDetailViewController alloc] initWithJobID:[NSString stringWithFormat:@"%@",@(info.collectDataID)]];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
        case 6:{
            FindJodDetailViewController *vc = [[FindJodDetailViewController alloc] initWithResumeID:[NSString stringWithFormat:@"%@",@(info.collectDataID)]];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 7:{
            InteractionDetailViewController *vc = [[InteractionDetailViewController alloc] initWithInteractionID:[NSString stringWithFormat:@"%@",@(info.collectDataID)]];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 8:{
            EducationDetailViewController *vc = [[EducationDetailViewController alloc]initWithDocumentID:info.collectDataID];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 9:{
            CompanyDetailViewController *vc = [[CompanyDetailViewController alloc] initWithCompanyID:info.collectDataID];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 10:{
            CooperationDetailViewController *vc = [[CooperationDetailViewController alloc] initWithcooperationID:info.collectDataID];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 12:{
            PlayViewController *vc = [[PlayViewController alloc]initWithDocumentID:info.collectDataID];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 13:{
            PlayViewController *vc = [[PlayViewController alloc]initWithDocumentID:info.collectDataID];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;

            
        default:
            break;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}

- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc] init];
    }
    return _netWorkEngine;
    
}
- (NSMutableArray<NSIndexPath *> *)arrIndexPath{
    if (!_arrIndexPath ) {
        _arrIndexPath = [NSMutableArray array];
    }
    return _arrIndexPath;
}
- (NSMutableIndexSet *)tableIndexSet{
    if (!_tableIndexSet) {
        _tableIndexSet = [NSMutableIndexSet indexSet];
    }
    return _tableIndexSet;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
