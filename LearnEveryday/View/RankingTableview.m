//
//  RankingTableview.m
//  ESTDriver
//
//  Created by 周波 on 16/10/12.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import "RankingTableview.h"
#import "RankingCell.h"

@implementation RankingTableview

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource =  self;
        self.delegate  = self;
    }
    return self;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ss = @"RankingCell";
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
    if (cell == nil) {
        cell = [[RankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    RankingModel *model = _dataArray[indexPath.row];
    [cell setmodel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.01)];
    return label;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.01)];
    return label;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


@end
