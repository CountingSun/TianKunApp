//
//  HomePeopleSearchViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/24.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "HomePeopleSearchViewController.h"
#import "AptitudeSelectViewController.h"
#import "ClassTypeInfo.h"

@interface HomePeopleSearchViewController ()<UIPopoverPresentationControllerDelegate>
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet QMUIButton *firstTypeButton;
@property (weak, nonatomic) IBOutlet QMUIButton *secondButton;
@property (nonatomic ,strong) NSMutableArray *arrFirstType;
@property (nonatomic ,strong) NSMutableArray *arrSecondType;


@property (nonatomic, copy) NSString *firstTypeStr;
@property (nonatomic, copy) NSString *secondTypeStr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *numStr;


@property (nonatomic ,strong) AptitudeSelectViewController *aptitudeSelectViewController;

@end

@implementation HomePeopleSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self showLoadingView];
    [self getFirstType];
    
}
- (void)setupUI{
    [self.titleView setTitle:@"筛选"];
    QMUIButton *saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [saveButton setTitle:@"确定" forState:0];
    [saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];
    
    
    [_firstTypeButton setImage:[UIImage imageNamed:@"三角下"] forState:UIControlStateNormal];
    [_firstTypeButton setImage:[UIImage imageNamed:@"三角上"] forState:UIControlStateSelected];
    _firstTypeButton.tag = 1;
    [_firstTypeButton setImagePosition:QMUIButtonImagePositionLeft];
    _firstTypeButton.spacingBetweenImageAndTitle = 5;
    
    [_secondButton setImage:[UIImage imageNamed:@"三角下"] forState:UIControlStateNormal];
    [_secondButton setImage:[UIImage imageNamed:@"三角上"] forState:UIControlStateSelected];
    [_secondButton setImagePosition:QMUIButtonImagePositionLeft];
    _secondButton.spacingBetweenImageAndTitle = 5;
    _secondButton.tag = 2;
}
- (void)getFirstType{
    [self.netWorkEngine  getWithUrl:BaseUrl(@"find.personnel.type.ancestor") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        [self hideLoadingView];
        if (code == 1) {
            if (!_arrFirstType) {
                _arrFirstType = [NSMutableArray array];
            }
            [_arrFirstType removeAllObjects];
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            
            for (NSDictionary *dict in arr) {
                ClassTypeInfo *info = [[ClassTypeInfo alloc]init];
                info.typeName = [dict objectForKey:@"type_name"];
                info.typeID = [[dict objectForKey:@"id"] stringValue];
                [_arrFirstType addObject:info];
                
            }
            
        }else{

            [self showGetDataErrorWithMessage:[responseObject objectForKey:@"msg"] reloadBlock:^{
                [self showLoadingView];
                [self getFirstType];
            }];
            
        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];
            [self getFirstType];

        }];
    }];
    
}
- (void)getSecondtypeWithFatherID:(NSString *)fatherID{
    NSString *urlStr = BaseUrl(@"find.typeEdifice.by.father.id?fatherId=");
    urlStr = [urlStr stringByAppendingString:fatherID];
    [self.netWorkEngine  getWithUrl:urlStr succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1) {
            [self dismiss];

            if (!_arrSecondType) {
                _arrSecondType = [NSMutableArray array];
            }
            [_arrSecondType removeAllObjects];
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            
            for (NSDictionary *dict in arr) {
                ClassTypeInfo *info = [[ClassTypeInfo alloc]init];
                info.typeName = [dict objectForKey:@"type_name"];
                info.typeID = [[dict objectForKey:@"id"] stringValue];
                [_arrSecondType addObject:info];
                
            }
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];

}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    return _netWorkEngine;
}
- (void)seve{
    _nameStr = _nameTextField.text.length?_nameTextField.text:@"";
    _numStr = _numTextField.text.length?_numTextField.text:@"";
    _firstTypeStr = _firstTypeStr.length?_firstTypeStr:@"";
    _secondTypeStr = _secondTypeStr.length?_secondTypeStr:@"";

    if (_sureButtonClickBlock) {
        _sureButtonClickBlock(_nameStr,_numStr,_firstTypeStr,_secondTypeStr);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)firstButtonClick:(id)sender {
    if (!_arrFirstType) {
        return;
    }
    [self showSelectViewWithButton:sender arrData:_arrFirstType];
    
}
- (IBAction)secondButtonClick:(id)sender {
    
    if (!_arrSecondType) {
        return;
    }
    [self showSelectViewWithButton:sender arrData:_arrSecondType];

}
- (void)showSelectViewWithButton:(QMUIButton *)button arrData:(NSMutableArray *)arrData{
    {
        button.selected = YES;
        __weak typeof(self) weakSelf = self;

        _aptitudeSelectViewController = [[AptitudeSelectViewController alloc]initWithSelectSucceedBlock:^(ClassTypeInfo *classTypeInfo,NSIndexPath *indexPaths) {
            if (button.tag == 1) {
                [weakSelf showWithStatus:NET_WAIT_TOST];
                [weakSelf getSecondtypeWithFatherID:classTypeInfo.typeID];
                [weakSelf.firstTypeButton setTitle:classTypeInfo.typeName forState:0];
                weakSelf.firstTypeStr = classTypeInfo.typeID;
                
            }else{
                if (!weakSelf.firstTypeStr.length) {
                    [weakSelf showErrorWithStatus:@"请选选择一级类别"];
                }else{
                    [weakSelf.secondButton setTitle:classTypeInfo.typeName forState:0];
                    weakSelf.secondTypeStr = classTypeInfo.typeID;

                }
                
            }

        }];
        
        _aptitudeSelectViewController.modalPresentationStyle = UIModalPresentationPopover;
        
        _aptitudeSelectViewController.preferredContentSize = CGSizeMake(button.frame.size.width, 200);
        // 需要通过 sourceView 来判断位置的
        _aptitudeSelectViewController.popoverPresentationController.sourceView = button;
        // 指定箭头所指区域的矩形框范围（位置和尺寸）,以sourceView的左上角为坐标原点
        // 这个可以 通过 Point 或  Size 调试位置
        _aptitudeSelectViewController.popoverPresentationController.sourceRect = button.bounds;
        _aptitudeSelectViewController.tableViewSize = CGSizeMake(button.frame.size.width, 200);
        
        // 箭头方向
        _aptitudeSelectViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        // 设置代理
        _aptitudeSelectViewController.popoverPresentationController.delegate = self;
        if (button.tag == 1) {
            _aptitudeSelectViewController.arrData = _arrFirstType;
        }else{
            _aptitudeSelectViewController.arrData = _arrSecondType;
        }
        [self presentViewController:_aptitudeSelectViewController animated:YES completion:nil];
        
        
    }
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone; //不适配
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    _firstTypeButton.selected = NO;
    _secondButton.selected = NO;

    
    return YES;   //点击蒙版popover消失， 默认YES
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
