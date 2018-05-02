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
#import "CooperationViewController.h"


@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet WQTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *arrMenu;
@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    [_tableView registerNib:[UINib nibWithNibName:@"FindTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTableViewCell"];
    _tableView.tableFooterView = [UIView new];
    [self showLoadingView];
    [self getAppIonList];
    
    
}
- (void)getAppIonList{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc]init];
    }
    [_netWorkEngine postWithDict:@{@"fatherId":@"2"} url:BaseUrl(@"find.typeEdifice.by.father.id") succed:^(id responseObject) {
        [self hideLoadingView];
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1) {
            
            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            for (NSDictionary *dict in arr) {
                MenuInfo *menuInfo = [[MenuInfo alloc]init];
                
                menuInfo.menuName = [dict objectForKey:@"type_name"];
                menuInfo.menuID = [[dict objectForKey:@"id"] integerValue];
                menuInfo.menuIcon = [dict objectForKey:@"picture_url"];

                [self.arrMenu addObject:menuInfo];
                
            }
            [self.tableView reloadData];
            
        }else{
            [self showGetDataFailViewWithReloadBlock:^{
                [self showLoadingView];
                [self getAppIonList];
            }];

        }
    } errorBlock:^(NSError *error) {
        [self hideLoadingView];
        [self showGetDataFailViewWithReloadBlock:^{
            [self showLoadingView];

            [self getAppIonList];
        }];
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrMenu.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTableViewCell" forIndexPath:indexPath];
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];
    [cell.logoImageView sd_imageDef11WithUrlStr:BaseUrl(menuInfo.menuIcon)];
    cell.nameLabel.text = menuInfo.menuName;
    return cell;
    
}

- (NSMutableArray *)arrMenu{
    if (!_arrMenu) {
        _arrMenu = [NSMutableArray array];
    }
    return _arrMenu;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuInfo *menuInfo = self.arrMenu[indexPath.row];
    
    
    if (menuInfo.menuID == 28) {
        CooperationViewController *vc = [[CooperationViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        FindImageListViewController *vc = [[FindImageListViewController alloc]initWithViewTitle:menuInfo.menuName classID:[NSString stringWithFormat:@"%@",@(menuInfo.menuID)]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        

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
