//
//  ConstructionSearchViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/22.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "ConstructionSearchViewController.h"
#import "ConstructionSearchTableViewCell.h"
#import "ConstructionSearchSelectTableViewCell.h"
#import "ConstructionSearchTextTableViewCell.h"
#import "AptitudeSelectViewController.h"

@interface ConstructionSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) QMUIButton *firstButton;
@property (nonatomic ,strong) QMUIButton *secondButton;
@property (nonatomic ,strong) QMUIButton *thirdButton;
@property (nonatomic ,strong) QMUIButton *fourtButton;
@property (nonatomic ,strong) QMUIButton *currectButton;



@end

@implementation ConstructionSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleView setTintColor:[UIColor blackColor]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"筛选"];
    
    _arrData = [NSMutableArray array];
    [_arrData addObject:@"1"];
    [_arrData addObject:@"2"];
    [_arrData addObject:@"3"];
    [_arrData addObject:@"4"];
    [_arrData addObject:@"5"];
    [_arrData addObject:@"6"];

    [self setupUI];
}
- (void)setupUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ConstructionSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConstructionSearchTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ConstructionSearchSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConstructionSearchSelectTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ConstructionSearchTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConstructionSearchTextTableViewCell"];
    _tableView.tableFooterView = [UIView new];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 90;
    }
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    return _arrData.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ConstructionSearchTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConstructionSearchTextTableViewCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1){
        ConstructionSearchSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConstructionSearchSelectTableViewCell" forIndexPath:indexPath];
        _firstButton = cell.firsetButton;
        _secondButton = cell.secondButton;
        _thirdButton = cell.thirdButton;
        _fourtButton = cell.fourButton;
        [_firstButton addTarget:self action:@selector(selectButtonEventWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [_secondButton addTarget:self action:@selector(selectButtonEventWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [_thirdButton addTarget:self action:@selector(selectButtonEventWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [_fourtButton addTarget:self action:@selector(selectButtonEventWithButton:) forControlEvents:UIControlEventTouchUpInside];

        return cell;

    }else{
        ConstructionSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConstructionSearchTableViewCell" forIndexPath:indexPath];
        return cell;

    }
    
}
-(void)selectButtonEventWithButton:(QMUIButton *)button{
    [UIView animateWithDuration:1 animations:^{
        button.selected =  YES;
    }];

    _currectButton = button;
    AptitudeSelectViewController *aptitudeSelectViewController = [[AptitudeSelectViewController alloc]initWithSelectSucceedBlock:^(NSString *areaCode) {
        [UIView animateWithDuration:1 animations:^{
            button.selected =  NO;
        }];
        [button setTitle:areaCode forState:0];
        
    }];
    // 设置大小
    aptitudeSelectViewController.preferredContentSize = CGSizeMake(button.frame.size.width, 200);
    // 设置 Sytle
    aptitudeSelectViewController.modalPresentationStyle = UIModalPresentationPopover;
    // 需要通过 sourceView 来判断位置的
    aptitudeSelectViewController.popoverPresentationController.sourceView = button;
    // 指定箭头所指区域的矩形框范围（位置和尺寸）,以sourceView的左上角为坐标原点
    // 这个可以 通过 Point 或  Size 调试位置
    aptitudeSelectViewController.popoverPresentationController.sourceRect = button.bounds;
    // 箭头方向
    aptitudeSelectViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    // 设置代理
    aptitudeSelectViewController.popoverPresentationController.delegate = self;
    [self presentViewController:aptitudeSelectViewController animated:YES completion:nil];
    
    
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone; //不适配
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    [UIView animateWithDuration:1 animations:^{
        _currectButton .selected = NO;
    }];
    
    return YES;   //点击蒙版popover消失， 默认YES
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
