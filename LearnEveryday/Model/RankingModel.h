//
//  RankingModel.h
//  ESTDriver
//
//  Created by 周波 on 16/10/12.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingModel : NSObject

@property(nonatomic,copy)NSString *NAME;//名字
@property(nonatomic,assign)NSNumber *RANK;//名次
@property(nonatomic,assign)NSNumber *USERID;
@property(nonatomic,assign)CGFloat SUMTOTALCLASSHOUR;//学时

@end
