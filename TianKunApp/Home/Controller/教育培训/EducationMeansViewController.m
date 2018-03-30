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

@interface EducationMeansViewController ()<FSPageContentViewDelegate>
@property (weak, nonatomic) IBOutlet QMUIButton *classButton;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet QMUIButton *ifFreeButton;
@property (nonatomic ,strong) QMUIPopupMenuView *popupMenuView;
@property (nonatomic ,strong) FSPageContentView *pageContentView;
@property (nonatomic ,strong) EducationVidoListViewController *vidoListViewController;
@property (nonatomic ,strong) EducationVidoListViewController *audioListViewController;

@property (nonatomic ,strong) EducationTextListViewController *textListViewController;

#define ITEM_HEIGHT 35
@end

@implementation EducationMeansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"培训资料"];
    [self setupView];
    [self setupPopupMenuView];
    
    __weak typeof(self) weakSelf = self;
    
//    [self.view addTapGestureRecognizerWithActionBlock:^{
//        [weakSelf.popupMenuView hideWithAnimated:YES];
//
//    }];
    
    
}
- (void)setupView{
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    _vidoListViewController = [[EducationVidoListViewController alloc]init];
    [childVCs addObject:_vidoListViewController];
    _audioListViewController = [[EducationVidoListViewController alloc]init];
    [childVCs addObject:_audioListViewController];

    _textListViewController = [[EducationTextListViewController alloc]init];
    [childVCs addObject:_textListViewController];

    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, CGRectGetHeight(self.view.bounds) - 40) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_pageContentView];
    self.pageContentView.contentViewCanScroll = NO;
    self.pageContentView.scrollAnimation = NO;

}
- (void)setupPopupMenuView{
    QMUIPopupMenuItem *item0 = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:@"视频" handler:^{
        [self.pageContentView setContentViewCurrentIndex:0];

        [_popupMenuView hideWithAnimated:YES];
        
    }];
    QMUIPopupMenuItem *item1 = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:@"音频" handler:^{
        [self.pageContentView setContentViewCurrentIndex:1];
        [_popupMenuView hideWithAnimated:YES];

    }];
    QMUIPopupMenuItem *item2 = [QMUIPopupMenuItem itemWithImage:[UIImage imageNamed:@""] title:@"文本" handler:^{
        [self.pageContentView setContentViewCurrentIndex:2];
        [_popupMenuView hideWithAnimated:YES];

    }];
    
    _popupMenuView = [[QMUIPopupMenuView alloc]init];
    _popupMenuView.itemHeight = ITEM_HEIGHT;
    
    _popupMenuView.items = @[item0,item1,item2];
    _popupMenuView.hidden = YES;
    _popupMenuView.maximumWidth = SCREEN_WIDTH/3;
    [self.view addSubview:_popupMenuView];

}
- (IBAction)classButtonClick:(id)sender {
}
- (IBAction)typeButtonClick:(id)sender {
    _popupMenuView.hidden = NO;
    [_popupMenuView layoutWithTargetView:_typeButton];
    [_popupMenuView showWithAnimated:YES];
}
- (IBAction)ifFreeButtonClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
