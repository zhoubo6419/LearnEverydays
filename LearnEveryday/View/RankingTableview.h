//
//  RankingTableview.h
//  ESTDriver
//
//  Created by 周波 on 16/10/12.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingTableview : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArray;

@end
