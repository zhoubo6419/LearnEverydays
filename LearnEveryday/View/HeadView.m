//
//  HeadView.m
//  ESTDriver
//
//  Created by 周波 on 16/10/9.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import "HeadView.h"
#import "RankingLearnController.h"
#define ImageHeight 160 * KScreenHight/536
@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self cretesubviews];
    }
    return self;
}


- (void)cretesubviews{
    
    //创建视图
    UIImageView *imageview = [self creatImageViewFrme:CGRectMake(0, 0, self.width, ImageHeight) imageName:@"每天学习一点点" contentMode:UIViewContentModeScaleToFill backGroudColro:[UIColor redColor]];
    [self addSubview:imageview];
    
    
    UILabel *namelabel =  [self createLabelFrame:CGRectMake(10, ImageHeight + 10, 200, 30) textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:font1] textString:@"" textAlignment:NSTextAlignmentLeft];
    namelabel.text = [NSString stringWithFormat:@"学员：%@",Name];
    namelabel.tag = 10101833;
    [self addSubview:namelabel];
    
    //学习排行
    UIButton *learnbutton = [self creatsButton:@"paihang" frame:CGRectMake(self.width - 15 - 80, ImageHeight + 40, 80, 30) title:@"" backgroundCorlor:[UIColor clearColor] tintColor:[UIColor whiteColor]  tag:10101840];
    
    [self addSubview:learnbutton];
    
    
    //创建学时label
    for (int i =  0; i < 4; i ++) {
        
        UILabel *label = [self createLabelFrame:CGRectMake(i * 65 * KW  + 10 , ImageHeight + 80, 65 * KW, 30) textColor:[UIColor lightGrayColor] textFont:[UIFont systemFontOfSize:font1] textString:@"" textAlignment:NSTextAlignmentCenter];
        label.tag = 10108580 + i;
        [self addSubview:label];
        if (i == 0) {
            label.text = @"本月学时:";
        }else if ( i == 2){
            label.text = @"总获学时:";

        }else if(i == 1){
            label.text = @"10.56";
   
        }else{
            label.text = @"25.47";

        }
        [self addSubview:label];
        
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
//创建imageView的方法
- (UIImageView *)creatImageViewFrme:(CGRect)frame imageName:(NSString *)imageName contentMode:(UIViewContentMode)contentMode backGroudColro:(UIColor *)color {
    
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:frame];
    iamgeView.backgroundColor = color;
    iamgeView.image = [UIImage imageNamed:imageName];
    iamgeView.contentMode = contentMode;
    return iamgeView;
    
}


- (UIButton *)creatsButton:(NSString *)imageName frame:(CGRect)frame title:(NSString *)title backgroundCorlor:(UIColor *)colors tintColor:(UIColor *)tintColors tag:(NSInteger)tags {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =frame;
    button.tag = tags;
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTintColor:tintColors];
    button.backgroundColor = colors;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    NSArray *array = @[data[@"monthClassHour"],data[@"totalClassHour"]];
    for (int i = 0; i < 2; i ++) {
        UILabel *label = [self viewWithTag:10108580 + (i  + 1) * 2 - 1];
        label.text =array[i];
    }
    
}
//
- (void)buttonAction:(UIButton *)button{
    
    RankingLearnController *vc = [[RankingLearnController alloc] init];
    [self.viewcontroller.navigationController pushViewController:vc animated:YES];
}
@end
