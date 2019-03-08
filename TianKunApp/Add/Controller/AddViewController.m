//
//  AddViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddViewController.h"
#import "POP.h"
#import "MenuInfo.h"
#import "ComposeButton.h"
#import "PublicEnterpriseViewController.h"
#import "FindTalentsViewController.h"
#import "AddFindJobViewController.h"
#import "AddEnterpriseCcommunicationViewController.h"
#import "AddBusinessCooperationViewController.h"

@interface AddViewController ()
@property (nonatomic,strong) NSArray *arrMenu;
@property (nonatomic,strong) NSMutableArray *buttonsArray;
@property (nonatomic ,strong) UIVisualEffectView *effectView;

@property (nonatomic ,assign) CGFloat buttonY;
@property (nonatomic ,assign) CGFloat hiddenDistance;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _buttonY = SCREEN_HEIGHT - SCREEN_WIDTH/5 -60;
    _hiddenDistance = 350;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];


    [self showButton];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    [self hiddenButton];
}
- (void)showButton{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_buttonsArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self showAnimationWithButton:obj index:idx];
        }];
    });
}
- (void)hiddenButton{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_buttonsArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hiddenAnimationWithButton:obj index:idx];
                });
        }];
    });
}

- (void)showAnimationWithButton:(UIButton *)button index:(NSInteger)index{
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(button.center.x, _buttonY)];
    animation.springBounciness = 10;
    animation.springSpeed = 12;
    animation.beginTime = CACurrentMediaTime() + (CGFloat)index * 0.025;
    [button pop_addAnimation:animation forKey:nil];
}
- (void)hiddenAnimationWithButton:(UIButton *)button index:(NSInteger)index{
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(button.center.x, _buttonY  +_hiddenDistance)];
    animation.springBounciness = 10;
    animation.springSpeed = 12;
    animation.beginTime = CACurrentMediaTime() + (CGFloat)index * 0.025;
    [button pop_addAnimation:animation forKey:nil];
}

-(NSArray *)arrMenu{
    MenuInfo *menu0 = [[MenuInfo alloc]initWithMenuName:@"信息发布" menuIcon:@"信息发布" menuID:0];
    MenuInfo *menu1 = [[MenuInfo alloc]initWithMenuName:@"找人才" menuIcon:@"找人才" menuID:1];
    MenuInfo *menu2 = [[MenuInfo alloc]initWithMenuName:@"找工作" menuIcon:@"找工作" menuID:2];
    MenuInfo *menu3 = [[MenuInfo alloc]initWithMenuName:@"互动交流" menuIcon:@"活动交流" menuID:3];
    MenuInfo *menu4 = [[MenuInfo alloc]initWithMenuName:@"商务合作" menuIcon:@"商务合作1" menuID:4];

    _arrMenu = [NSArray arrayWithObjects:menu0,menu1,menu2,menu3,menu4, nil];
    
    return _arrMenu;
    
}
-(void)setupUI{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _effectView = effectView;
    self.view = effectView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackEvent)];
    [self.view addGestureRecognizer:tap];
    [self addButton];
    
}
-(void)addButton{
    CGFloat itemW = SCREEN_WIDTH/5;
    CGFloat itemH = SCREEN_WIDTH/5;
    _buttonsArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.arrMenu.count; i++) {
        MenuInfo *menuInfo = self.arrMenu[i];
        QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:menuInfo.menuName forState:0];
        [button setImage:[UIImage imageNamed:menuInfo.menuIcon] forState:0];
        [button setImagePosition:QMUIButtonImagePositionTop];
        [button setSpacingBetweenImageAndTitle:10];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:COLOR_TEXT_GENGRAL forState:0];
        button.frame = CGRectMake(i*itemW, _buttonY +_hiddenDistance, itemW, itemH);
        [_buttonsArray addObject:button];
        [_effectView.contentView addSubview:button];
        button.tag = menuInfo.menuID;
        [button addTarget:self action:@selector(childButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)childButtonClick:(UIButton *)button{
    
    if(![UserInfoEngine isLogin]){
        return;
    }
    switch (button.tag) {
        case 0:
        {
            PublicEnterpriseViewController *vc = [[PublicEnterpriseViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            
            break;
        case 1:{
            FindTalentsViewController *vc = [[FindTalentsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

            
        }
            break;
        case 2:{
            
            AddFindJobViewController *vc = [[AddFindJobViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 3:{
            AddEnterpriseCcommunicationViewController *vc = [[AddEnterpriseCcommunicationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 4:{
            AddBusinessCooperationViewController *vc = [[AddBusinessCooperationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
        default:{
            
            
        }
            break;
    }
    
    
}

-(void)tapBackEvent{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
