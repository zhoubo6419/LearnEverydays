//
//  TableviewHeaderView.m
//  ESTDriver
//
//  Created by 周波 on 16/10/11.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import "TableviewHeaderView.h"

@implementation TableviewHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //判断
        [self cretesubview];
        [self request];
    }
    return self;
}

- (void)request{
    NSString *url1 = [NSString stringWithFormat:@"%@/test/getRankSum",ROOT_URL];
    NSDictionary *dic1 = @{@"type":@(_type)};
    [MHNetworkManager postReqeustWithURL:url1 params:dic1 successBlock:^(NSDictionary *returnData) {
        
        NSDictionary *data = returnData[@"data"];
        
          NSMutableArray *datas = [NSMutableArray array];
        [datas addObject:[NSString stringWithFormat:@"%@",data[@"rank"] ]];
        [datas addObject:[NSString stringWithFormat:@"%@",data[@"classHour"] ]];
        [datas addObject:[NSString stringWithFormat:@"%@",data[@"beyond"] ]];
        
        for (int i = 0; i < data.count; i ++) {
            UILabel *label = [self viewWithTag: 101113160 + i];
             label.text = [NSString stringWithFormat:@"%@",datas[i]];
        }
                

        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];

    
}


- (void)cretesubview{
    
    self.backgroundColor = YRGBColor(27, 199, 138);
    NSArray *array = @[@"当前排名",@"获得学时",@"超过人数"];
    //循环创建
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 2; j ++) {
            
            UILabel *label = [self createLabelFrame:CGRectMake(KScreenWidth/3 * i, 50 * j, KScreenWidth/3, 50) textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:font1 + 1] textString:@"" textAlignment:NSTextAlignmentCenter];
            [self addSubview:label];
            if (j == 0) {
                label.tag = 101113160 + i;
            }else{
                label.text = array[i];
            }
        }
    }
    
}

//封装label的方法
- (UILabel *)createLabelFrame:(CGRect)rect  textColor:(UIColor *)color  textFont:(UIFont *)font textString:(NSString *)textString  textAlignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = textString;
    label.textColor = color;
    label.backgroundColor = [UIColor whiteColor];
    label.font  = font;
    label.textAlignment = textAlignment ;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

//- (void)setDataArray:(NSMutableArray *)dataArray{
//    _dataArray = dataArray;
//    NSMutableArray *data = [NSMutableArray array];
//    NSLog(@"%@,%@",UserID,usrename);
//    for (RankingModel *model in _dataArray) {
//        if ([model.NAME isEqualToString:Name]) {
//            
//            //计算
//            [data addObject:model.RANK];//名次
//            [data addObject:[NSString stringWithFormat:@"%.2f",model.SUMTOTALCLASSHOUR]];//学时
//            
//             CGFloat f =  (_dataArray.count - [model.RANK intValue]) * 1.0/ _dataArray.count * 1.0 * 100;
//            [data addObject:[NSString stringWithFormat:@"%.2f%@",f,@"%"]];
//            
//        }
//    }
//   
//    for (int i = 0; i < data.count; i ++) {
//        UILabel *label = [self viewWithTag: 101113160 + i];
//        label.text = [NSString stringWithFormat:@"%@",data[i]];
//    }
//    
//}
@end
