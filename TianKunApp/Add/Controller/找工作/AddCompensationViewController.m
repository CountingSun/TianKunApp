//
//  AddCompensationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/5.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "AddCompensationViewController.h"
#import "MenuInfo.h"

@interface AddCompensationViewController ()

@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) QMUIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;

@end

@implementation AddCompensationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"期望薪资"];
    _saveButton = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_saveButton setTitle:@"保存" forState:0];
    [_saveButton setTitleColor:COLOR_TEXT_BLACK forState:0];
    [_saveButton addTarget:self action:@selector(seve) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];
    _minTextField.keyboardType = UIKeyboardTypeNumberPad;
    _maxTextField.keyboardType = UIKeyboardTypeNumberPad;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
    
}

-(void)seve{
    if ([_minTextField.text integerValue]>= [_maxTextField.text integerValue]) {
        [self showErrorWithStatus:@"最小薪资不能大于最大薪资"];
        return;
    }
    if (_selectSucceedBlock) {
        _selectSucceedBlock([_maxTextField.text integerValue],[_minTextField.text integerValue]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellID = @"cell";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
//
//        cell.textLabel.textColor = COLOR_TEXT_BLACK;
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    MenuInfo *info = _arrData[indexPath.row];
//
//    cell.textLabel.text = info.menuName;
//
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MenuInfo *info = _arrData[indexPath.row];
//
//    if (_selectSucceedBlock) {
//        _selectSucceedBlock(info);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//
//
//}
//- (NSMutableArray *)arrData{
//    if (!_arrData) {
//        _arrData = [NSMutableArray arrayWithCapacity:11];
//        //        学历:0其它/1初中/2高中/3中技/4中专/5大专/6本科/7硕士/8MBA/9博士/10博士后
//        MenuInfo *menInof0 = [[MenuInfo alloc]initWithMenuName:@"1000元/月以下" menuIcon:@"" menuID:0];
//        [_arrData addObject:menInof0];
//        MenuInfo *menInof1 = [[MenuInfo alloc]initWithMenuName:@"1000-4000元/月" menuIcon:@"" menuID:1];
//        [_arrData addObject:menInof1];
//        MenuInfo *menInof2 = [[MenuInfo alloc]initWithMenuName:@"2000-4000元/月" menuIcon:@"" menuID:2];
//        [_arrData addObject:menInof2];
//        MenuInfo *menInof3 = [[MenuInfo alloc]initWithMenuName:@"4000-6000元/月" menuIcon:@"" menuID:3];
//        [_arrData addObject:menInof3];
//        MenuInfo *menInof4 = [[MenuInfo alloc]initWithMenuName:@"6000-8000元/月" menuIcon:@"" menuID:4];
//        [_arrData addObject:menInof4];
//        MenuInfo *menInof5 = [[MenuInfo alloc]initWithMenuName:@"8000-10000元/月" menuIcon:@"" menuID:5];
//        [_arrData addObject:menInof5];
//        MenuInfo *menInof6 = [[MenuInfo alloc]initWithMenuName:@"10000-15000元/月" menuIcon:@"" menuID:6];
//        [_arrData addObject:menInof6];
//        MenuInfo *menInof7 = [[MenuInfo alloc]initWithMenuName:@"15000-25000元/月" menuIcon:@"" menuID:7];
//        [_arrData addObject:menInof7];
//        MenuInfo *menInof8 = [[MenuInfo alloc]initWithMenuName:@"25000-50000元/月" menuIcon:@"" menuID:8];
//        [_arrData addObject:menInof8];
//        MenuInfo *menInof9 = [[MenuInfo alloc]initWithMenuName:@"50000-70000元/月" menuIcon:@"" menuID:9];
//        [_arrData addObject:menInof9];
//        MenuInfo *menInof10 = [[MenuInfo alloc]initWithMenuName:@"70000-100000元/月" menuIcon:@"" menuID:10];
//        [_arrData addObject:menInof10];
//        MenuInfo *menInof11 = [[MenuInfo alloc]initWithMenuName:@"100000元/月以上" menuIcon:@"" menuID:11];
//        [_arrData addObject:menInof11];
//        MenuInfo *menInof12 = [[MenuInfo alloc]initWithMenuName:@"面议" menuIcon:@"" menuID:12];
//        [_arrData addObject:menInof12];
//
//    }
//    return _arrData;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
