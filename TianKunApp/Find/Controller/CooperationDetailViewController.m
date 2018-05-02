//
//  CooperationDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/15.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "CooperationDetailViewController.h"
#import "CooperationInfo.h"
#import "HomeListTableViewCell.h"
#import "CompanyIntroduceTableViewCell.h"
#import "AppShared.h"
#import "CooperationTableViewCell.h"

@interface CooperationDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,assign) NSInteger cooperationID;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,strong) CooperationInfo *cooperationInfo;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *rightBarButtonView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicTimeIaLbel;
@property (weak, nonatomic) IBOutlet UILabel *hadSeeLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *collectButton;
@property (weak, nonatomic) IBOutlet QMUIButton *shareButton;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;

@end

@implementation CooperationDetailViewController
- (instancetype)initWithcooperationID:(NSInteger)cooperationID{
    if (self = [super init]) {
        _cooperationID = cooperationID;
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [self showLoadingView];
    
    [self getData];

}
- (void)setupUI{
    [self.titleView setTitle:@"详情"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBarButtonView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];
    
    [_collectButton setImage:[UIImage imageNamed:@"收藏-1"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];
    _pageIndex = 1;
    _pageSize = DEFAULT_PAGE_SIZE;

    _rightBarButtonView.userInteractionEnabled = NO;

}
- (void)getData{
    NSString *urlStr = BaseUrl(@"find.cooperationRequestExt.by.id?");
   urlStr =  [urlStr stringByAppendingString:[NSString stringWithFormat:@"id=%@",@(_cooperationID)]];
    if ([UserInfoEngine getUserInfo].userID) {
        
  urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[UserInfoEngine getUserInfo].userID]];
    }
    [self.netWorkEngine getWithUrl:urlStr succed:^(id responseObject) {
        [self hideLoadingView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            _rightBarButtonView.userInteractionEnabled = YES;

            NSDictionary *dict = [responseObject objectForKey:@"value"];
            _cooperationInfo = [CooperationInfo mj_objectWithKeyValues:dict];
            _companyNameLabel.text = _cooperationInfo.initiator;
            _publicTimeIaLbel.text = [NSString stringWithFormat:@"发布时间：%@",[NSString timeReturnDate:[NSNumber numberWithInteger:[_cooperationInfo.create_date integerValue]]]];
            _cooperationInfo.action_scope_name = [_cooperationInfo.action_scope_name stringByReplacingOccurrencesOfString:@"[" withString:@""];
           _cooperationInfo.action_scope_name = [_cooperationInfo.action_scope_name stringByReplacingOccurrencesOfString:@"]" withString:@""];
           _cooperationInfo.action_scope_name = [_cooperationInfo.action_scope_name stringByReplacingOccurrencesOfString:@"\"" withString:@""];

            
            _hadSeeLabel.text = [NSString stringWithFormat:@"已有%@人浏览",@(_cooperationInfo.hits_show)];

            _cooperationInfo.arrAddressName = [dict objectForKey:@""];
            
            if (_cooperationInfo.isCollect) {
                _collectButton.selected = YES;
            }else{
                _collectButton.selected = NO;

            }
            [self.tableView reloadData];
            [self getRecommend];
            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getData];
                
            }];
        }
    } errorBlock:^(NSError *error) {
        _rightBarButtonView.userInteractionEnabled = YES;

        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getData];
        }];
        
    }];
    
}
- (void)getRecommend{
    if (_pageIndex<1) {
        _pageIndex = 1;
    }
    
    [self.netWorkEngine postWithDict:@{@"pageNo":@(_pageIndex),@"pageSize":@(_pageSize)} url:BaseUrl(@"find.cooperationRequestList.by.userid") succed:^(id responseObject) {
        [self hideLoadingView];
        [self.tableView endRefresh];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            if (arr.count) {
                if (!_arrData) {
                    _arrData = [NSMutableArray array];
                }
                if (_pageIndex == 1) {
                    [_arrData removeAllObjects];
                }
                
                for (NSDictionary *dict in arr) {
                    CooperationInfo *info = [CooperationInfo mj_objectWithKeyValues:dict];
                    [_arrData addObject:info];
                    
                }
                [self.tableView reloadData];
                if(arr.count<_pageSize){
                    _tableView.canLoadMore = NO;
                }else{
                    _tableView.canLoadMore = YES;
                }
                
            }else{
                if (!_arrData.count) {
                    [self showGetDataNullWithReloadBlock:^{
                        [self showLoadingView];
                        [self getData];
                    }];
                    
                    
                }else{
                    _pageIndex--;
                    
                    [self showErrorWithStatus:NET_WAIT_NO_DATA];
                    
                }
            }
            
        }else{
            if (!_arrData.count) {
                [self showGetDataNullWithReloadBlock:^{
                    [self showLoadingView];
                    [self getData];
                }];
                
                
            }else{
                _pageIndex--;
                
                [self showErrorWithStatus:NET_WAIT_NO_DATA];
                
            }
            
        }
        
        
        
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [_tableView endRefresh];
        if (_arrData.count) {
            _pageIndex = 1;
            
            [self showErrorWithStatus:NET_ERROR_TOST];
        }else{
            _pageIndex = 1;
            [self showGetDataFailViewWithReloadBlock:^{
                [self hideEmptyView];
                [self showLoadingView];
                [self getData];
            }];
            
        }
        
    }];
    
}


- (WQTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WQTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self dataScource:self style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = _headView;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 45;
        [self.view addSubview:self.tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return _arrData.count;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
        
    }
    if (section == 2) {
        return 40;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        view.backgroundColor = COLOR_WHITE;
        
        WQLabel *label = [[WQLabel alloc]initWithFrame:CGRectMake(15, 0, 200, 40) font:[UIFont systemFontOfSize:14] text:@"更多推荐" textColor:COLOR_TEXT_BLACK textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [view addSubview:label];
        
        return view;
    }
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellID = @"defCellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.selectionStyle = 0;
        }
        switch (indexPath.row) {
            case 0:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"服务区域    " color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_cooperationInfo.action_scope_name color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 1:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"联系人    " color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_cooperationInfo.linkman color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 2:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"联系电话    " color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_cooperationInfo.phone color:COLOR_THEME fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
            case 3:
            {
                NSAttributedString *titleAttributedString = [self dealStringWithString:@"商家地址    " color:COLOR_TEXT_LIGHT fontSize:14];
                NSAttributedString *detailAttributedString = [self dealStringWithString:_cooperationInfo.address color:COLOR_TEXT_BLACK fontSize:14];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [attStr appendAttributedString:titleAttributedString];
                [attStr appendAttributedString:detailAttributedString];
                
                cell.textLabel.attributedText = attStr;
                
            }
                break;
                
            default:
                break;
        }
        return cell;
        
    }else if (indexPath.section == 1){
        CompanyIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyIntroduceTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CompanyIntroduceTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = 0;
        cell.contentLable.text = _cooperationInfo.content;
        
        return cell;
        
    }else{
        CooperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CooperationTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CooperationTableViewCell" owner:nil options:nil] firstObject];
        }
        CooperationInfo *info = _arrData[indexPath.row];
        
        cell.titleLabel.text = info.initiator;
        cell.detailLabel.text = info.content;
        
        cell.selectionStyle = 0;
        return cell;

    }
    return [UITableViewCell new];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        CooperationInfo *info = _arrData[indexPath.row];
        
        CooperationDetailViewController *viewController = [[CooperationDetailViewController alloc]initWithcooperationID:info.cooperationID];
        [self.navigationController pushViewController:viewController animated:YES];

    }
}
- (NSAttributedString *)dealStringWithString:(NSString *)str color:(UIColor *)color fontSize:(CGFloat)fontSize{
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                        NSForegroundColorAttributeName:color
                                                        }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (IBAction)collectButtonClick:(id)sender {
    
    if ([UserInfoEngine isLogin]) {
        [self showWithStatus:NET_WAIT_TOST];
        [self.netWorkEngine postWithDict:@{@"id":@(_cooperationID),@"user_id":[UserInfoEngine getUserInfo].userID,@"status":@(!_collectButton.selected)} url:BaseUrl(@"create.or.update.cooperationCollectible") succed:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1) {
                _collectButton.selected =! _collectButton.selected;
                if (_collectButton.selected) {
                    [self showSuccessWithStatus:@"收藏成功"];
                }else{
                    [self showSuccessWithStatus:@"取消收藏成功"];
                }
                
            }
            else{
                [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                
            }
        } errorBlock:^(NSError *error) {
            [self showErrorWithStatus:NET_ERROR_TOST];
            
            
        }];

    }
    
}

- (IBAction)shareButtonClick:(id)sender {
    [AppShared shared];
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
