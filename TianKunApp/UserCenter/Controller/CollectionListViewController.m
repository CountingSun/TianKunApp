
//
//  CollectionListViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/18.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CollectionListViewController.h"
#import "HistoryBottomView.h"
#import "MenuInfo.h"
#import "HistoryTableViewCell.h"
#import "UsercollectionInfo.h"
#import "ArticleDetailViewController.h"
#import "JobDetailViewController.h"
#import "FindJodDetailViewController.h"
#import "InteractionDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "EducationDetailViewController.h"
#import "PlayViewController.h"
#import "CooperationDetailViewController.h"

@interface CollectionListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) HistoryBottomView *historyBottomView;

@property (nonatomic ,strong) QMUIButton *editButton;

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic ,assign) ViewType viewType;

@property (nonatomic ,assign) BOOL canLoadMore;
@property (nonatomic ,strong) NSMutableArray<NSIndexPath *> *arrIndexPath;
@property (nonatomic ,strong) NSMutableIndexSet *tableIndexSet;

@end

@implementation CollectionListViewController
- (instancetype)initWithViewType:(ViewType)viewType{
    if (self = [super init]) {
        _viewType = viewType;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"我的收藏"];
    _pageSize = DEFAULT_PAGE_SIZE;
    _pageIndex = 1;
    
    [self setupView];
    [self showLoadingView];
    
    [self getData];
}
- (void)getData{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    
    NSString *urlStr;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    switch (_viewType) {
        case viewTypeNotice:{
            urlStr = BaseUrl(@"ArticleNotices/selectarticlenoticebyuseridandlimit.action");
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
            [dict setObject:@(_pageIndex) forKey:@"startnum"];
            [dict setObject:@(_pageSize) forKey:@"endnum"];

        }
            break;
        case viewTypePublic:
            urlStr = BaseUrl(@"Announcement/selectannouncementbyuseridandlimit.action");
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
            [dict setObject:@(_pageIndex) forKey:@"startnum"];
            [dict setObject:@(_pageSize) forKey:@"endnum"];

            break;
            
        case viewTypeWork:
            urlStr = BaseUrl(@"my/collecton_job_list.action");
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
            [dict setObject:@(_pageIndex) forKey:@"pageNum"];
            [dict setObject:@(_pageSize) forKey:@"pageSize"];

            break;
        case viewTypePeople:
            urlStr = BaseUrl(@"find.watchRecord.by.resumeCollectible");
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
            [dict setObject:@(_pageIndex) forKey:@"pageNo"];
            [dict setObject:@(_pageSize) forKey:@"pageSize"];
            
            break;
        case viewTypeInteraction:
            urlStr = BaseUrl(@"Forums/selectforumsbyuseridandlimit.action");
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
            [dict setObject:@(_pageIndex) forKey:@"startnum"];
            [dict setObject:@(_pageSize) forKey:@"endnum"];
            
            break;
        case viewTypeEducation:
            urlStr = BaseUrl(@"Learning/selectlearningbyuseridandlimit.action");
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
            [dict setObject:@(_pageIndex) forKey:@"startnum"];
            [dict setObject:@(_pageSize) forKey:@"endnum"];

            break;
        case viewTypeCompany:
            urlStr = BaseUrl(@"find.enterpriseWatchRecordExt.by.enterpriseCollectibleList");
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
            [dict setObject:@(_pageIndex) forKey:@"pageNo"];
            [dict setObject:@(_pageSize) forKey:@"pageSize"];
            
            break;
        case viewTypeCooperation:
            urlStr = BaseUrl(@"find.cooperationCollectibleList.by.userId");
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
            [dict setObject:@(_pageIndex) forKey:@"pageNo"];
            [dict setObject:@(_pageSize) forKey:@"pageSize"];
            
            break;

        default:
            break;
            
    }
    
    
    [self.netWorkEngine postWithDict:dict url:urlStr succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];
        [_tableView endRefresh];
        _canEdit = YES;
        if (code == 1) {
            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            if (_pageIndex == 1) {
                [_arrData removeAllObjects];
            }
            
            switch (_viewType) {
                case viewTypeNotice:{
                    NSArray *arr = [responseObject objectForKey:@"value"];
                    for (NSDictionary *dict in arr) {
                        UsercollectionInfo *info = [[UsercollectionInfo alloc]init];
                        info.collectDataID = [[dict objectForKey:@"id"] integerValue];
                        info.collectTime = [dict objectForKey:@"create_date"];
                        info.collectTitle = [dict objectForKey:@"article_title"];
                        info.collectImage = [dict objectForKey:@"article_pictures"];
                        info.collectReadNum = [[dict objectForKey:@"hits_show"] integerValue];
                        info.collectIsEffective = [[dict objectForKey:@"delete_flag"] integerValue];
                        info.collectID = [[dict objectForKey:@"ids"] integerValue];

                        [_arrData addObject:info];
                    }
                    [self.tableView reloadData];
                }
                    break;
                case viewTypePublic:{
                    NSArray *arr = [responseObject objectForKey:@"value"];
                    for (NSDictionary *dict in arr) {
                        UsercollectionInfo *info = [[UsercollectionInfo alloc]init];
                        info.collectDataID = [[dict objectForKey:@"id"] integerValue];
                        info.collectTime = [dict objectForKey:@"create_date"];
                        info.collectTitle = [dict objectForKey:@"announcement_title"];
                        info.collectImage = [dict objectForKey:@"announcement_pictures"];
                        info.collectReadNum = [[dict objectForKey:@"hits_show"] integerValue];
                        info.collectIsEffective = [[dict objectForKey:@"delete_flag"] integerValue];
                        info.collectID = [[dict objectForKey:@"ids"] integerValue];
                        [_arrData addObject:info];
                    }
                    [self.tableView reloadData];
                }
                    break;
                case viewTypeWork:{
                    NSArray *arr = [responseObject objectForKey:@"value"];
                    for (NSDictionary *dict in arr) {
                        UsercollectionInfo *info = [[UsercollectionInfo alloc]init];
                        info.collectDataID = [[dict objectForKey:@"jobid"] integerValue];
                        info.collectTime = [dict objectForKey:@"createdate"];
                        info.collectTitle = [dict objectForKey:@"name"];
                        info.collectImage = [dict objectForKey:@"imageurl"];
                        info.collectReadNum = [[dict objectForKey:@"clicknumber"] integerValue];
                        info.collectIsEffective = [[dict objectForKey:@"delete_flag"] integerValue];
                        info.collectID = [[dict objectForKey:@"collectionid"] integerValue];
                        [_arrData addObject:info];
                    }
                    [self.tableView reloadData];
                }
                    break;
                case viewTypePeople:{
                    NSArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
                    for (NSDictionary *dict in arr) {
                        UsercollectionInfo *info = [[UsercollectionInfo alloc]init];
                        info.collectDataID = [[dict objectForKey:@"data_id"] integerValue];
                        info.collectTime = [dict objectForKey:@"create_date"];
                        info.collectTitle = [dict objectForKey:@"data_title"];
                        info.collectImage = [dict objectForKey:@"data_picture_url"];
                        info.collectReadNum = [[dict objectForKey:@"hits_show"] integerValue];
                        info.collectIsEffective = [[dict objectForKey:@"delete_flag"] integerValue];
                        info.collectID = [[dict objectForKey:@"id"] integerValue];
                        [_arrData addObject:info];
                    }
                    [self.tableView reloadData];
                }
                    break;

                case viewTypeInteraction:{
                    NSArray *arr = [responseObject objectForKey:@"value"];
                    for (NSDictionary *dict in arr) {
                        UsercollectionInfo *info = [[UsercollectionInfo alloc]init];
                        info.collectDataID = [[dict objectForKey:@"id"] integerValue];
                        info.collectTime = [dict objectForKey:@"create_date"];
                        info.collectTitle = [dict objectForKey:@"title"];
                        info.collectImage = [dict objectForKey:@""];
                        info.collectReadNum = [[dict objectForKey:@"hits_show"] integerValue];
                        info.collectIsEffective = [[dict objectForKey:@"delete_flag"] integerValue];
                        info.collectID = [[dict objectForKey:@"ids"] integerValue];

                        [_arrData addObject:info];
                    }
                    [self.tableView reloadData];

                    
                }

                    break;
                case viewTypeEducation:{
                    NSArray *arr = [responseObject objectForKey:@"value"];
                    for (NSDictionary *dict in arr) {
                        UsercollectionInfo *info = [[UsercollectionInfo alloc]init];
                        info.collectDataID = [[dict objectForKey:@"id"] integerValue];
                        info.collectTime = [dict objectForKey:@"create_date"];
                        info.collectTitle = [dict objectForKey:@"data_title"];
                        info.collectImage = [dict objectForKey:@"video_image_url"];
                        info.collectReadNum = [[dict objectForKey:@"hits_show"] integerValue];
                        info.collectIsEffective = [[dict objectForKey:@"delete_flag"] integerValue];
                        info.collectID = [[dict objectForKey:@"ids"] integerValue];
                        info.collectType = [[dict objectForKey:@"type"] integerValue];
                        [_arrData addObject:info];
                    }
                    [self.tableView reloadData];
                    
                }
                    
                    break;
                case viewTypeCompany:{
                    NSArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
                    for (NSDictionary *dict in arr) {
                        UsercollectionInfo *info = [[UsercollectionInfo alloc]init];
                        info.collectDataID = [[dict objectForKey:@"data_id"] integerValue];
                        info.collectTime = [dict objectForKey:@"create_date"];
                        info.collectTitle = [dict objectForKey:@"data_title"];
                        info.collectImage = [dict objectForKey:@"data_picture_url"];
                        info.collectReadNum = [[dict objectForKey:@"hits_show"] integerValue];
                        info.collectIsEffective = [[dict objectForKey:@"delete_flag"] integerValue];
                        info.collectID = [[dict objectForKey:@"id"] integerValue];
                        info.collectType = [[dict objectForKey:@"type"] integerValue];
                        [_arrData addObject:info];
                    }
                    [self.tableView reloadData];
                    
                }
                    
                    break;
                case viewTypeCooperation:{
                    NSArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
                    for (NSDictionary *dict in arr) {
                        UsercollectionInfo *info = [[UsercollectionInfo alloc]init];
                        info.collectDataID = [[dict objectForKey:@"data_id"] integerValue];
                        info.collectTime = [dict objectForKey:@"create_date"];
                        info.collectTitle = [dict objectForKey:@"data_title"];
                        info.collectImage = [dict objectForKey:@"data_picture_url"];
                        info.collectReadNum = [[dict objectForKey:@"hits_show"] integerValue];
                        info.collectIsEffective = [[dict objectForKey:@"delete_flag"] integerValue];
                        info.collectID = [[dict objectForKey:@"id"] integerValue];
                        info.collectType = [[dict objectForKey:@"type"] integerValue];
                        [_arrData addObject:info];
                    }
                    [self.tableView reloadData];
                    
                }
                    
                    break;

                default:{
                }
                    break;
            }
            if (_arrData.count<_pageSize*_pageIndex) {
                _tableView.canLoadMore = NO;
                _canLoadMore = NO;
            }else{
                _tableView.canLoadMore = YES;
                _canLoadMore = YES;
            }
            if (!_arrData.count) {
                _canEdit = NO;

                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    [self getData];
                }];
                
            }
        }else{
            if (!_arrData.count) {
                _canEdit = NO;

                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    [self getData];
                }];
                
            }else{
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            }

        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        _canEdit = YES;
        [_tableView endRefresh];
        if (!_arrData.count) {
            _canEdit = NO;

            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];
            
        }else{
            [self showErrorWithStatus:NET_ERROR_TOST];
        }

    }];
    
    
}

- (void)deleteNoticeCollectWithIDS:(NSString *)ids{
    self.view.userInteractionEnabled = NO;
    _editButton.enabled = NO;
    [self showWithStatus:NET_WAIT_TOST];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *urlStr = @"";
    
    switch (_viewType) {
        case viewTypeNotice:
            {
                [dict setObject:ids forKey:@"ids"];
                urlStr = BaseUrl(@"ArticleNotices/deletearticlenoticecollectibleblebyids.action");
            }
            break;
        case viewTypePublic:{
            [dict setObject:ids forKey:@"ids"];
            urlStr = BaseUrl(@"Announcement/deleteannouncemenecollectiblebyids.action");

        }
            break;
            
        case viewTypeWork:{
            [dict setObject:ids forKey:@"collectionids"];
            [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"userid"];
            urlStr = BaseUrl(@"my/delete_collectionlist.action");
        }
            break;
        case viewTypePeople:{
            [dict setObject:ids forKey:@"ids"];
            urlStr = BaseUrl(@"delete.resumeCollectible.list.by.ids");

        }
            break;
        case viewTypeInteraction:{
            [dict setObject:ids forKey:@"ids"];
            urlStr = BaseUrl(@"Forums/deleteforumcollectiblebyids.action");

            

        }
            break;
        case viewTypeEducation:{
            [dict setObject:ids forKey:@"ids"];
            urlStr = BaseUrl(@"Learning/deletelearningcollectiblebyids.action");
        }
            break;
        case viewTypeCompany:{
            [dict setObject:ids forKey:@"ids"];
            urlStr = BaseUrl(@"delete.enterpriseCollectible.list.by.ids");

            
        }
            break;
        case viewTypeCooperation:{
            [dict setObject:ids forKey:@"ids"];
            urlStr = BaseUrl(@"delete.cooperationCollectibleList.by.ids");
            
            
        }
            break;

        default:
            break;
    }

    [self.netWorkEngine postWithDict:dict url:urlStr succed:^(id responseObject) {
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
- (void)beginEditWithEditButton:(QMUIButton *)editButton FinishBlock:(dispatch_block_t)block{
    _editButton = editButton;
    
        if (_tableView.editing) {
            _tableView.canRefresh = YES;
            _tableView.canLoadMore = _canLoadMore;

            [_tableView setEditing:NO animated:YES];
            [editButton setImage:[UIImage imageNamed:@"删除"] forState:0];
            [editButton setTitle:@"" forState:0];
    
            [UIView animateWithDuration:0.3 animations:^{
                [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(0);
                }];
                [self.view layoutIfNeeded];
            }];
            if (block) {
                block();
            }

    
        }else{
            _tableView.canRefresh = NO;
            _tableView.canLoadMore = NO;

            [UIView animateWithDuration:0.3 animations:^{
                [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(-50);
                }];
                [self.view layoutIfNeeded];
    
            }];
            [editButton setImage:nil forState:0];
            [editButton setTitle:@"完成" forState:0];
    
            [_tableView setEditing:YES animated:YES];
    
        }
    

}
- (void)setupView{
    
    
        [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoryTableViewCell"];
        
        _historyBottomView = [[[NSBundle mainBundle] loadNibNamed:@"HistoryBottomView" owner:nil options:nil] firstObject];
        [self.view addSubview:_historyBottomView];
        [_historyBottomView.selectButton addTarget:self action:@selector(allSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_historyBottomView.clearnButton addTarget:self action:@selector(clearnSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_historyBottomView.unUseButton addTarget:self action:@selector(unUseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_historyBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.left.equalTo(self.view);
            make.width.offset(SCREEN_WIDTH);
            make.height.offset(50);
            
        }];
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
        [_arrData enumerateObjectsUsingBlock:^(UsercollectionInfo *info, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!info.collectIsEffective) {
                idsString = [idsString stringByAppendingString:[NSString stringWithFormat:@"%@,",@(info.collectID)]];
                [_tableIndexSet addIndex:idx];
                [self.arrIndexPath addObject:[NSIndexPath indexPathForRow:idx inSection:0]];

            }
        }];
        if (idsString.length) {
            idsString  = [idsString qmui_stringByRemoveLastCharacter];
            [self deleteNoticeCollectWithIDS:idsString];

            
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

    [self.tableIndexSet removeAllIndexes];

    [arrRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [_tableIndexSet addIndex:indexPath.row];
        UsercollectionInfo *info = _arrData[indexPath.row];
        idsString = [idsString stringByAppendingString:[NSString stringWithFormat:@"%@,",@(info.collectID)]];
    }];
    if (idsString.length) {
        idsString  = [idsString qmui_stringByRemoveLastCharacter];
        [self deleteNoticeCollectWithIDS:idsString];
        
        
    }else{
        [self showErrorWithStatus:@"请选择要删除的内容"];
    }

    
    
}

- (void)editButtonEvent{
    
    if (_tableView.editing) {
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
        [_editButton setTitle:@"完成" forState:0];
        
        [_tableView setEditing:YES animated:YES];
        
    }
}
- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) delegate:self dataScource:self style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
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
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:nil options:nil] firstObject];
    }
    UsercollectionInfo *info =self.arrData[indexPath.row];
    cell.titleLabel.text = info.collectTitle;
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:info.collectImage] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE_11]];
    cell.timeLabel.text = [NSString timeReturnDateString:info.collectTime formatter:@"yyyy-MM-dd"];
    
    if (info.collectIsEffective) {
        cell.nimLabel.text = [NSString stringWithFormat:@"%@阅读",@(info.collectReadNum)];
        
    }else{
        cell.nimLabel.text = @"失效";
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
    switch (_viewType) {
        case viewTypeNotice:{
                ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] initWithArticleID:info.collectDataID fromType:1];
                [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case viewTypePublic:{
                ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] initWithArticleID:info.collectDataID fromType:0];
                [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case viewTypeWork:{
            JobDetailViewController *vc = [[JobDetailViewController alloc] initWithJobID:[NSString stringWithFormat:@"%@",@(info.collectDataID)]];
            [self.navigationController pushViewController:vc animated:YES];

            
        }
            break;
        case viewTypePeople:{
            
            FindJodDetailViewController *vc = [[FindJodDetailViewController alloc] initWithResumeID:[NSString stringWithFormat:@"%@",@(info.collectDataID)]];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
        case viewTypeEducation:{
            if (info.collectType == 1) {
                EducationDetailViewController *vc = [[EducationDetailViewController alloc]initWithDocumentID:info.collectDataID];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                PlayViewController *vc = [[PlayViewController alloc]initWithDocumentID:info.collectDataID];
                [self.navigationController pushViewController:vc animated:YES];
                
            }

        }
            break;
        case viewTypeInteraction:{
            
            InteractionDetailViewController *vc = [[InteractionDetailViewController alloc] initWithInteractionID:[NSString stringWithFormat:@"%@",@(info.collectDataID)]];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case viewTypeCompany:{
            CompanyDetailViewController *vc = [[CompanyDetailViewController alloc] initWithCompanyID:info.collectDataID];
            [self.navigationController pushViewController:vc animated:YES];

            
            
        }
            break;
        case viewTypeCooperation:{
            CooperationDetailViewController *vc = [[CooperationDetailViewController alloc] initWithcooperationID:info.collectDataID];
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
        _netWorkEngine = [[NetWorkEngine alloc]init];
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
