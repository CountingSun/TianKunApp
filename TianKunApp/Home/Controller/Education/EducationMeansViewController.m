//
//  EducationMeansViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/27.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationMeansViewController.h"
#import "FSPageContentView.h"
#import "EducationVidoListViewController.h"
#import "EducationTextListViewController.h"
#import "UIView+AddTapGestureRecognizer.h"
#import "MenuInfo.h"
#import "DocumentPropertyInfo.h"
#import "SingleFilterView.h"
#import "FilterInfo.h"


@interface EducationMeansViewController ()<FSPageContentViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *buttonBaseView;
@property (weak, nonatomic) IBOutlet QMUIButton *classButton;
@property (weak, nonatomic) IBOutlet QMUIButton *typeButton;
@property (weak, nonatomic) IBOutlet QMUIButton *ifFreeButton;
@property (nonatomic ,strong) FSPageContentView *pageContentView;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;

@property (nonatomic ,strong) EducationVidoListViewController *vidoListViewController;
@property (nonatomic ,strong) EducationVidoListViewController *audioListViewController;
@property (nonatomic ,strong) EducationTextListViewController *textListViewController;

@property (nonatomic ,strong) NSMutableArray *arrItemClass;
@property (nonatomic ,strong) NSMutableArray *arrItemType;
@property (nonatomic ,strong) NSMutableArray *arrItemFree;

@property (nonatomic ,strong) DocumentPropertyInfo *documentPropertyInfo;

@property (nonatomic ,assign) NSInteger classID;
@property (nonatomic, copy) NSString *viewTitle;

@property (nonatomic ,strong) UIViewController *currectVC;

@property (nonatomic ,strong) SingleFilterView *oneFilterTableView;
@property (nonatomic ,strong) SingleFilterView *twoFilterTableView;
@property (nonatomic ,strong) SingleFilterView *threeFilterTableView;

#define ITEM_HEIGHT 35
@end

@implementation EducationMeansViewController
- (instancetype)initWithClassID:(NSInteger)classID viewTitle:(NSString *)viewTitle{
    if (self = [super init]) {
        _classID = classID;
        _viewTitle = viewTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:_viewTitle];
    [self showLoadingView];
    
    [self getClass];
    
    [self setupView];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)getClass{
    
    [self.netWorkEngine postWithDict:@{@"fatherId":@(_classID)} url:BaseUrl(@"find.typeEdifice.by.father.id") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            
            for (NSDictionary *dict in arr) {
                FilterInfo *info = [[FilterInfo alloc]init];
                info.propertyID = [dict objectForKey:@"id"];
                info.propertyName = [dict objectForKey:@"type_name"];
                [self.arrItemClass addObject:info];
                
            }
            self.oneFilterTableView.arrData1 = self.arrItemClass;
            self.twoFilterTableView.arrData1 = self.arrItemType;
            self.threeFilterTableView.arrData1 = self.arrItemFree;

            [self setupParameter];
            
        }else{
            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
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
- (void)setupParameter{
    self.documentPropertyInfo.classType = -1;
    self.documentPropertyInfo.documentClass = 1;
    self.documentPropertyInfo.isFree = -1;
    self.documentPropertyInfo.documentType = _classID;
    [_textListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
    

}
- (void)setupView{
    
    [_classButton setImage:[UIImage imageNamed:@"jian_tou下"] forState:UIControlStateNormal];
    [_classButton setImage:[UIImage imageNamed:@"jian_tou"] forState:UIControlStateSelected];
    [_typeButton setImage:[UIImage imageNamed:@"jian_tou下"] forState:UIControlStateNormal];
    [_typeButton setImage:[UIImage imageNamed:@"jian_tou"] forState:UIControlStateSelected];
    [_ifFreeButton setImage:[UIImage imageNamed:@"jian_tou下"] forState:UIControlStateNormal];
    [_ifFreeButton setImage:[UIImage imageNamed:@"jian_tou"] forState:UIControlStateSelected];

    [_classButton setImagePosition:QMUIButtonImagePositionRight];
    [_classButton setSpacingBetweenImageAndTitle:5];
    [_typeButton setImagePosition:QMUIButtonImagePositionRight];
    [_typeButton setSpacingBetweenImageAndTitle:5];
    [_ifFreeButton setImagePosition:QMUIButtonImagePositionRight];
    [_ifFreeButton setSpacingBetweenImageAndTitle:5];

    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    _textListViewController = [[EducationTextListViewController alloc]init];
    [childVCs addObject:_textListViewController];
    _currectVC = _textListViewController;
    
    _vidoListViewController = [[EducationVidoListViewController alloc]initWithClassID:_classID];
    [childVCs addObject:_vidoListViewController];
    _audioListViewController = [[EducationVidoListViewController alloc]initWithClassID:_classID];
    [childVCs addObject:_audioListViewController];

    CGFloat barHeight = NavBarHeight;
    

    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-barHeight) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_pageContentView];
    

    self.pageContentView.contentViewCanScroll = NO;
    self.pageContentView.scrollAnimation = NO;

}
- (IBAction)classButtonClick:(id)sender {

    if (self.oneFilterTableView.hidden == NO) {
        [self.oneFilterTableView hiddenFilterView];
        _classButton.selected = NO;
    }else{
        [self.oneFilterTableView showFilterView];

        [self.twoFilterTableView hiddenFilterView];
        [self.threeFilterTableView hiddenFilterView];
        
        _classButton.selected = YES;
        _typeButton.selected = NO;
        _ifFreeButton.selected = NO;
        
    }
}
- (IBAction)typeButtonClick:(id)sender {
    if (self.twoFilterTableView.hidden == NO) {
        [self.twoFilterTableView hiddenFilterView];
        _typeButton.selected = NO;

    }else{
        [self.twoFilterTableView showFilterView];
        [self.oneFilterTableView hiddenFilterView];
        [self.threeFilterTableView hiddenFilterView];
        _typeButton.selected = YES;
        _classButton.selected = NO;
        _ifFreeButton.selected = NO;

    }

}
- (IBAction)ifFreeButtonClick:(id)sender {
    if (self.threeFilterTableView.hidden == NO) {
        [self.threeFilterTableView hiddenFilterView];
        _ifFreeButton.selected = NO;

    }else{
        [self.threeFilterTableView showFilterView];
        [self.oneFilterTableView hiddenFilterView];
        [self.twoFilterTableView hiddenFilterView];
        _typeButton.selected = NO;
        _classButton.selected = NO;
        _ifFreeButton.selected = YES;

    }

}
- (SingleFilterView *)oneFilterTableView{
    if (!_oneFilterTableView) {
        _oneFilterTableView = [[SingleFilterView alloc] init];
        [self.view addSubview:_oneFilterTableView];
        [_oneFilterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_buttonBaseView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
            
        }];
        __weak typeof(self) weakSelf = self;
        
        _oneFilterTableView.firseSelectBlock = ^(FilterInfo *filterInfo) {
            [weakSelf.classButton setTitle:filterInfo.propertyName forState:0];
            weakSelf.documentPropertyInfo.classType = [filterInfo.propertyID integerValue];
            
            if (weakSelf.currectVC == weakSelf.textListViewController) {
                [weakSelf.textListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
            }else if(weakSelf.currectVC == weakSelf.vidoListViewController){
                [weakSelf.vidoListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
                
            }else{
                [weakSelf.audioListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
            }
            [weakSelf.oneFilterTableView hiddenFilterView];

            weakSelf.classButton.selected = NO;
        };
        [_oneFilterTableView hiddenFilterView];

    }
    return _oneFilterTableView;
    
}
- (SingleFilterView *)twoFilterTableView{
    if (!_twoFilterTableView) {
        _twoFilterTableView = [[SingleFilterView alloc] init];
        [self.view addSubview:_twoFilterTableView];
        [_twoFilterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_buttonBaseView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
            
        }];
        __weak typeof(self) weakSelf = self;
        
        _twoFilterTableView.firseSelectBlock = ^(FilterInfo *filterInfo) {
            [weakSelf.typeButton setTitle:filterInfo.propertyName forState:0];

            if ([filterInfo.propertyID isEqualToString:@"1"]) {
                [weakSelf.pageContentView setContentViewCurrentIndex:0];
                weakSelf.documentPropertyInfo.documentClass = [filterInfo.propertyID integerValue];
                _currectVC = _textListViewController;
                
                [weakSelf.textListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
                [weakSelf.twoFilterTableView hiddenFilterView];

            }else if([filterInfo.propertyID isEqualToString:@"2"]){
                [weakSelf.pageContentView setContentViewCurrentIndex:2];
                weakSelf.documentPropertyInfo.documentClass = [filterInfo.propertyID integerValue];
                _currectVC = weakSelf.audioListViewController;
                
                [weakSelf.audioListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
                [weakSelf.twoFilterTableView hiddenFilterView];

            }else{
                [weakSelf.pageContentView setContentViewCurrentIndex:1];
                weakSelf.documentPropertyInfo.documentClass = [filterInfo.propertyID integerValue];
                _currectVC = weakSelf.vidoListViewController;
                
                [weakSelf.vidoListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
                [weakSelf.twoFilterTableView hiddenFilterView];

            }
            weakSelf.typeButton.selected = NO;

        };
        [_twoFilterTableView hiddenFilterView];

    }
    return _twoFilterTableView;
    
}

- (SingleFilterView *)threeFilterTableView{
    if (!_threeFilterTableView) {
        _threeFilterTableView = [[SingleFilterView alloc] init];
        [self.view addSubview:_threeFilterTableView];
        [_threeFilterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_buttonBaseView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
            
        }];
        __weak typeof(self) weakSelf = self;
        
        _threeFilterTableView.firseSelectBlock = ^(FilterInfo *filterInfo) {
            [weakSelf.ifFreeButton setTitle:filterInfo.propertyName forState:0];
            weakSelf.documentPropertyInfo.isFree = [filterInfo.propertyID integerValue];
            
            if (_currectVC == _textListViewController) {
                [weakSelf.textListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
            }else if(_currectVC == _vidoListViewController){
                [weakSelf.vidoListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
                
            }else{
                [weakSelf.audioListViewController reloadWithDocumentPropertyInfo:weakSelf.documentPropertyInfo];
            }
            [weakSelf.threeFilterTableView hiddenFilterView];

            weakSelf.ifFreeButton.selected = NO;

        };
        [_threeFilterTableView hiddenFilterView];

    }
    return _threeFilterTableView;
    
}

- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
    
}
- (NSMutableArray *)arrItemFree{
    if (!_arrItemFree) {
        _arrItemFree = [NSMutableArray array];
        
        FilterInfo *info = [[FilterInfo alloc] init];
        info.propertyID = @"1";
        info.propertyName = @"收费";
        [_arrItemFree addObject:info];
        
        FilterInfo *info2= [[FilterInfo alloc] init];
        info2.propertyID = @"0";
        info2.propertyName = @"免费";
        [_arrItemFree addObject:info2];

    }
    return _arrItemFree;
    
}
- (NSMutableArray *)arrItemType{
    if (!_arrItemType) {
        _arrItemType = [NSMutableArray array];
        FilterInfo *info = [[FilterInfo alloc] init];
        info.propertyID = @"1";
        info.propertyName = @"文本";
        [_arrItemType addObject:info];
        FilterInfo *info2= [[FilterInfo alloc] init];
        info2.propertyID = @"3";
        info2.propertyName = @"视频";
        [_arrItemType addObject:info2];

        FilterInfo *info3= [[FilterInfo alloc] init];
        info3.propertyID = @"2";
        info3.propertyName = @"音频";
        [_arrItemType addObject:info3];


    }
    return _arrItemType;
    
}
- (NSMutableArray *)arrItemClass{
    if (!_arrItemClass) {
        _arrItemClass = [NSMutableArray array];
    }
    return _arrItemClass;
}
-(DocumentPropertyInfo *)documentPropertyInfo{
    if (!_documentPropertyInfo) {
        _documentPropertyInfo = [[DocumentPropertyInfo alloc]init];

    }
    return _documentPropertyInfo;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
