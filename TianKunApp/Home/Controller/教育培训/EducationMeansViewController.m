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

@interface EducationMeansViewController ()<FSPageContentViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *buttonBaseView;
@property (weak, nonatomic) IBOutlet QMUIButton *classButton;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet QMUIButton *ifFreeButton;
@property (nonatomic ,strong) QMUIPopupMenuView *popupMenuView;
@property (nonatomic ,strong) FSPageContentView *pageContentView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
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
    [self setupPopupMenuView];
    
}
- (void)getClass{
    
    [self.netWorkEngine postWithDict:@{@"fatherId":@(_classID)} url:BaseUrl(@"find.typeEdifice.by.father.id") succed:^(id responseObject) {
        [self hideLoadingView];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            
            for (NSDictionary *dict in arr) {
                MenuInfo *info = [[MenuInfo alloc]init];
                info.menuID = [[dict objectForKey:@"id"] integerValue];
                info.menuName = [dict objectForKey:@"type_name"];
                info.menuIcon = [dict objectForKey:@"picture_url"];
                [_arrMenu addObject:info];
                QMUIPopupMenuItem *item = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:info.menuName handler:^{
                    [_popupMenuView hideWithAnimated:YES];
                    [_classButton setTitle:info.menuName forState:0];
                    
                    
                    self.documentPropertyInfo.classType = info.menuID;
                    
                    if (_currectVC == _textListViewController) {
                        [_textListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
                    }else if(_currectVC == _vidoListViewController){
                        [_vidoListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
                        
                    }else{
                        [_audioListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
                    }                    
                }];
                [self.arrItemClass addObject:item];

                
            }
            
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
- (void)tapBack{
    [self.popupMenuView hideWithAnimated:YES];

}
- (void)setupView{
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    _textListViewController = [[EducationTextListViewController alloc]init];
    [childVCs addObject:_textListViewController];
    _currectVC = _textListViewController;
    
    _vidoListViewController = [[EducationVidoListViewController alloc]initWithClassID:_classID];
    [childVCs addObject:_vidoListViewController];
    _audioListViewController = [[EducationVidoListViewController alloc]initWithClassID:_classID];
    [childVCs addObject:_audioListViewController];


    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, CGRectGetHeight(self.view.bounds) - 40) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_pageContentView];
    self.pageContentView.contentViewCanScroll = NO;
    self.pageContentView.scrollAnimation = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

}
- (void)setupPopupMenuView{

    _popupMenuView = [[QMUIPopupMenuView alloc]init];
    _popupMenuView.itemHeight = ITEM_HEIGHT;
    _popupMenuView.hidden = YES;
    
    
    [self.view addSubview:_popupMenuView];
}
- (IBAction)classButtonClick:(id)sender {
    if (_popupMenuView.hidden) {
        _popupMenuView.items = self.arrItemClass;
        [_popupMenuView showWithAnimated:YES];

        _popupMenuView.maximumWidth = SCREEN_WIDTH/3*2;
        _popupMenuView.hidden = NO;
        [_popupMenuView layoutWithTargetView:_classButton];
        

        
    }else{
        [_popupMenuView hideWithAnimated:YES];
        
    }

}
- (IBAction)typeButtonClick:(id)sender {
    if (_popupMenuView.hidden) {
        _popupMenuView.items = self.arrItemType;
        [_popupMenuView showWithAnimated:YES];

        _popupMenuView.maximumWidth = SCREEN_WIDTH/3;
        _popupMenuView.hidden = NO;
        [_popupMenuView layoutWithTargetView:_typeButton];


    }else{
        [_popupMenuView hideWithAnimated:YES];

    }
}
- (IBAction)ifFreeButtonClick:(id)sender {
    if (_popupMenuView.hidden) {
        _popupMenuView.items = self.arrItemFree;
        [_popupMenuView showWithAnimated:YES];

        _popupMenuView.maximumWidth = SCREEN_WIDTH/3;
        _popupMenuView.hidden = NO;
        [_popupMenuView layoutWithTargetView:_ifFreeButton];
        

    }else{
        [_popupMenuView hideWithAnimated:YES];
        
    }

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (_popupMenuView.hidden) {
        return NO;
    }else{
        return YES;

    }
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
        QMUIPopupMenuItem *item3 = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:@"收费" handler:^{
            [_popupMenuView hideWithAnimated:YES];
            [_ifFreeButton setTitle:@"收费" forState:0];
            self.documentPropertyInfo.isFree = 1;
            
            if (_currectVC == _textListViewController) {
                [_textListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
            }else if(_currectVC == _vidoListViewController){
                [_vidoListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
                
            }else{
                [_audioListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
            }


        }];
        [_arrItemFree addObject:item3];
        
        QMUIPopupMenuItem *item4 = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:@"免费" handler:^{
            [_popupMenuView hideWithAnimated:YES];
            [_ifFreeButton setTitle:@"免费" forState:0];
            self.documentPropertyInfo.isFree = 0;
            
            if (_currectVC == _textListViewController) {
                [_textListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
            }else if(_currectVC == _vidoListViewController){
                [_vidoListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
                
            }else{
                [_audioListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
            }

        }];
        [_arrItemFree addObject:item4];
    }
    return _arrItemFree;
    
}
- (NSMutableArray *)arrItemType{
    if (!_arrItemType) {
        _arrItemType = [NSMutableArray array];
        QMUIPopupMenuItem *item2 = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:@"文本" handler:^{
            [self.pageContentView setContentViewCurrentIndex:0];
            [_popupMenuView hideWithAnimated:YES];
            [_typeButton setTitle:@"文本" forState:0];
            self.documentPropertyInfo.documentClass = 1;
            _currectVC = _textListViewController;
            
            [_textListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];
            
            
        }];
        [_arrItemType addObject:item2];

        QMUIPopupMenuItem *item0 = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:@"视频" handler:^{
            [self.pageContentView setContentViewCurrentIndex:1];
            [_popupMenuView hideWithAnimated:YES];
            [_typeButton setTitle:@"视频" forState:0];
            self.documentPropertyInfo.documentClass = 3;
            _currectVC = _vidoListViewController;

            [_vidoListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];

            
        }];
        [_arrItemType addObject:item0];
        
        QMUIPopupMenuItem *item1 = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:@"音频" handler:^{
            [self.pageContentView setContentViewCurrentIndex:2];
            [_popupMenuView hideWithAnimated:YES];
            [_typeButton setTitle:@"音频" forState:0];
            self.documentPropertyInfo.documentClass = 2;
            _currectVC = _audioListViewController;

            [_audioListViewController reloadWithDocumentPropertyInfo:self.documentPropertyInfo];

        }];
        [_arrItemType addObject:item1];


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
