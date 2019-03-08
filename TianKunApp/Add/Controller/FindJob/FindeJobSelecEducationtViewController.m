//
//  FindeJobSelecEducationtViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/4/3.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindeJobSelecEducationtViewController.h"
#import "MenuInfo.h"

@interface FindeJobSelecEducationtViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrData;

@end

@implementation FindeJobSelecEducationtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:@"学历"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    _tableView.tableFooterView = [UIView new];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    MenuInfo *info = _arrData[indexPath.row];
    
    cell.textLabel.text = info.menuName;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *info = _arrData[indexPath.row];
    
    if (_selectSucceedBlock) {
        _selectSucceedBlock(info);
    }
    [self.navigationController popViewControllerAnimated:YES];
    

}
- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithCapacity:11];
//        学历:0其它/1初中/2高中/3中技/4中专/5大专/6本科/7硕士/8MBA/9博士/10博士后
        MenuInfo *menInof0 = [[MenuInfo alloc]initWithMenuName:@"其他" menuIcon:@"" menuID:0];
        [_arrData addObject:menInof0];
        MenuInfo *menInof1 = [[MenuInfo alloc]initWithMenuName:@"初中" menuIcon:@"" menuID:1];
        [_arrData addObject:menInof1];
        MenuInfo *menInof2 = [[MenuInfo alloc]initWithMenuName:@"高中" menuIcon:@"" menuID:2];
        [_arrData addObject:menInof2];
        MenuInfo *menInof3 = [[MenuInfo alloc]initWithMenuName:@"中技" menuIcon:@"" menuID:3];
        [_arrData addObject:menInof3];
        MenuInfo *menInof4 = [[MenuInfo alloc]initWithMenuName:@"中专" menuIcon:@"" menuID:4];
        [_arrData addObject:menInof4];
        MenuInfo *menInof5 = [[MenuInfo alloc]initWithMenuName:@"大专" menuIcon:@"" menuID:5];
        [_arrData addObject:menInof5];
        MenuInfo *menInof6 = [[MenuInfo alloc]initWithMenuName:@"本科" menuIcon:@"" menuID:6];
        [_arrData addObject:menInof6];
        MenuInfo *menInof7 = [[MenuInfo alloc]initWithMenuName:@"硕士" menuIcon:@"" menuID:7];
        [_arrData addObject:menInof7];
        MenuInfo *menInof8 = [[MenuInfo alloc]initWithMenuName:@"MBA" menuIcon:@"" menuID:8];
        [_arrData addObject:menInof8];
        MenuInfo *menInof9 = [[MenuInfo alloc]initWithMenuName:@"博士" menuIcon:@"" menuID:9];
        [_arrData addObject:menInof9];
        MenuInfo *menInof10 = [[MenuInfo alloc]initWithMenuName:@"博士后" menuIcon:@"" menuID:10];
        [_arrData addObject:menInof10];

    }
    return _arrData;
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
