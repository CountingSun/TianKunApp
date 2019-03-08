//
//  EducationBaseDetailViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "EducationBaseDetailViewController.h"
#import "EductationNetworkEngine.h"
#import "EducationDetailViewController.h"
#import "PlayViewController.h"
#import "DocumentInfo.h"
#import "AppDelegate.h"

@interface EducationBaseDetailViewController ()
@property (nonatomic ,assign) NSInteger documentID;
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic ,assign) NSInteger pageSize;
@property (nonatomic ,strong) EductationNetworkEngine *eductationNetworkEngine;
@property (nonatomic ,strong) DocumentInfo *documentInfo;

@end

@implementation EducationBaseDetailViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppDelegate sharedAppDelegate].allowRotation = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)initWithDocumentID:(NSInteger)documentID{
    if (self = [super init]) {
        _documentID = documentID;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingView];
    [self getData];
    
}
- (void)getData{
    if (!_eductationNetworkEngine) {
        _eductationNetworkEngine = [[EductationNetworkEngine alloc]init];
    }
    [_eductationNetworkEngine getEductationInfoWithDocumentID:_documentID returnBlock:^(NSInteger code, NSString *msg, DocumentInfo *documentInfo) {
        [self hideLoadingView];
        if (code == 1) {
            _documentInfo = documentInfo;
            [self setChildController];
            
        }else if(code == -1){
            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];
            [self showErrorWithStatus:NET_ERROR_TOST];
            
        }else{
            [self showGetDataErrorWithMessage:msg reloadBlock:^{
                [self showLoadingView];
                [self getData];
            }];
            [self showErrorWithStatus:msg];
            
        }
    }];
    
    
}
- (void)setChildController{
    if (_documentInfo.type == 1) {
        [self.titleView setTitle:@"正文"];

        EducationDetailViewController *vc = [[EducationDetailViewController alloc] initWithDocumentInfo:_documentInfo];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];

        vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [vc didMoveToParentViewController:self];

    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];

//        PlayViewController *vc = [[PlayViewController alloc] initWithDocumentInfo:_documentInfo];
//        [self addChildViewController:vc];
//        [self.view addSubview:vc.view];
//        
//        vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        [vc didMoveToParentViewController:self];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
