//
//  FindViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/19.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FindViewController.h"
#import "FindTableViewCell.h"
#import "MenuInfo.h"
#import "FindeListViewController.h"
#import "FindImageListViewController.h"


@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    [_tableView registerNib:[UINib nibWithNibName:@"FindTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTableViewCell"];
    _tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrMenu.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTableViewCell" forIndexPath:indexPath];
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];
    cell.logoImageView.image = [UIImage imageNamed:menuInfo.menuIcon];
    cell.nameLabel.text = menuInfo.menuName;
    return cell;
    
}

- (NSMutableArray *)arrMenu{
    if (!_arrMenu) {
        _arrMenu = [NSMutableArray array];
        
        MenuInfo *menuInfo0 = [[MenuInfo alloc]initWithMenuName:@"企业信息" menuIcon:@"企业信息" menuID:0];
        [_arrMenu addObject:menuInfo0];
        MenuInfo *menuInfo1 = [[MenuInfo alloc]initWithMenuName:@"勘察设计" menuIcon:@"勘察设计" menuID:1];
        [_arrMenu addObject:menuInfo1];
        MenuInfo *menuInfo2 = [[MenuInfo alloc]initWithMenuName:@"工程监理" menuIcon:@"工程监理" menuID:2];
        [_arrMenu addObject:menuInfo2];
        MenuInfo *menuInfo3 = [[MenuInfo alloc]initWithMenuName:@"造价咨询" menuIcon:@"造价咨询" menuID:3];
        [_arrMenu addObject:menuInfo3];
        MenuInfo *menuInfo4 = [[MenuInfo alloc]initWithMenuName:@"建材设备" menuIcon:@"建材设备" menuID:4];
        [_arrMenu addObject:menuInfo4];
        MenuInfo *menuInfo5 = [[MenuInfo alloc]initWithMenuName:@"商务合作" menuIcon:@"商务合作" menuID:5];
        [_arrMenu addObject:menuInfo5];
        MenuInfo *menuInfo6 = [[MenuInfo alloc]initWithMenuName:@"招标代理" menuIcon:@"招标代理" menuID:6];
        [_arrMenu addObject:menuInfo6];
        MenuInfo *menuInfo7 = [[MenuInfo alloc]initWithMenuName:@"其他" menuIcon:@"其他" menuID:7];
        [_arrMenu addObject:menuInfo7];

    }
    return _arrMenu;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];
    switch (menuInfo.menuID) {
        case 0:
            {
                FindeListViewController *vc = [[FindeListViewController alloc]initWithViewTitle:menuInfo.menuName];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        default:{
            FindImageListViewController *vc = [[FindImageListViewController alloc]initWithViewTitle:menuInfo.menuName];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
    }
    

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
