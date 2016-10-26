//
//  RankingCell.m
//  ESTDriver
//
//  Created by 周波 on 16/10/11.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import "RankingCell.h"

@implementation RankingCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self crestesubviews];
    }
    return self;
}

- (void)crestesubviews{
    
    NSArray *array = @[@"1",@"杨曦",@"22.25"];
    for (int i=  0; i < 3; i ++) {
        
        UILabel *label = [self createLabelFrame:CGRectMake(KScreenWidth/3 * i, 0,KScreenWidth/3 , 60) textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:font1 + 3] textString:array[i] textAlignment:NSTextAlignmentCenter];
        label.tag = 101109250  + i;
        [self.contentView addSubview:label];
        
        if (i == 0) {
            label.textColor = YRGBColor(47, 149, 113);
            label.font = [UIFont systemFontOfSize:font1 + 2];
        }else if ( i == 1){
            label.font = [UIFont systemFontOfSize:font1 + 4];
 
        }else{
            label.textColor = YRGBColor(219, 179, 16);

            label.font = [UIFont systemFontOfSize:font1 + 3];
 
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


- (void)setmodel:(RankingModel *)model{
   
    NSArray *data = @[model.RANK,model.NAME,[NSString stringWithFormat:@"%.2f",model.SUMTOTALCLASSHOUR]];
    for (int i = 0; i < data.count; i ++) {
        UILabel *label = [self.contentView viewWithTag:101109250 + i];
        label.text = [NSString stringWithFormat:@"%@",data[i]];
    }
    
}

@end
