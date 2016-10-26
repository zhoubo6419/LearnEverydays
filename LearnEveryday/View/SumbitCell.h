//
//  SumbitCell.h
//  ESTDriver
//
//  Created by 周波 on 16/10/10.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemListModel.h"

#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

typedef void (^ChooseSuccessBlock)(NSMutableArray *strArray);
@interface SumbitCell : UITableViewCell<IFlySpeechSynthesizerDelegate>

- (void)setmodel:(ItemListModel *)model;

@property(nonatomic,strong)UIView *analysisview;//解析的视图
@property(nonatomic,strong) UIView *ABCview;//选择按钮
@property(nonatomic,assign)BOOL isSubmitaAnswer;//是否提交答案

@property(nonatomic,copy)ChooseSuccessBlock chooseblock;
- (void)setTheSuccessBlock:(ChooseSuccessBlock)blok;
@end
