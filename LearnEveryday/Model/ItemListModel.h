//
//  ItemListModel.h
//  ESTDriver
//
//  Created by 周波 on 16/10/11.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemListModel : NSObject

@property(nonatomic,copy)NSString *ALLOPTIONS;//A...B...
@property(nonatomic,copy)NSString *ANSWERS;//
@property(nonatomic,assign)CGFloat CORRECTHOUR;//
@property(nonatomic,copy)NSString *EXAMANALYSIS;//
@property(nonatomic,assign)CGFloat INCORRECTHOUR;//
@property(nonatomic,copy)NSNumber *ITEMID;//
@property(nonatomic,copy)NSNumber *LIBID;//
@property(nonatomic,copy)NSNumber *OPTIONSNUM;//
@property(nonatomic,copy)NSNumber *RANGE;//
@property(nonatomic,copy)NSNumber *SCORE;//
@property(nonatomic,copy)NSNumber *TEMPCOLUMN;//
@property(nonatomic,strong)NSNumber *TEMPROWNUMBER;//
@property(nonatomic,copy)NSString *TITLE;//道路货物运输经营者应当要求其聘用的车辆驾驶员随车携带
@property(nonatomic,copy)NSString *TYPE;//


//内容的高度
@property(nonatomic,assign)CGFloat ALLOPTIONSheight;
@property(nonatomic,assign)CGFloat TITLEheight;
@property(nonatomic,assign)CGFloat EXAMANALYSISheight;//解析内容的高度

//答案
@property(nonatomic,copy)NSString *answer;

@end
