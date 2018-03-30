//
//  FilterTableView.m
//  TianKunApp
//
//  Created by 天堃 on 2018/3/21.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "FilterTableView.h"
#import "FilterInfo.h"

@interface FilterTableView()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation FilterTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI{
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [UIView new];
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
}
- (void)setArrData:(NSMutableArray *)arrData{
    _arrData = arrData;
    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"cellID";
    FilterInfo *filterInfo = _arrData[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = filterInfo.propertyName;
    
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterInfo *filterInfo = _arrData[indexPath.row];

    if (_selectTableViewBlock) {
        _selectTableViewBlock(filterInfo);
    }
}


@end
