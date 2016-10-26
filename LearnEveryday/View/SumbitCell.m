//
//  SumbitCell.m
//  ESTDriver
//
//  Created by 周波 on 16/10/10.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import "SumbitCell.h"
#define period     @"0.09111"

@implementation SumbitCell
{
    //
    NSInteger _TYPE ;//0单选1多选2问答3大题
    NSInteger _OPTIONSNUM   ;//OPTIONSNUM
    UIImageView *_imagview;//轮播图片
    UILabel *_subjectlabel;////题目
    UILabel *_chooselable;////选择
    UILabel *_correctlabel1;//正确答案
    UIButton  *_playbutton;//声音播放按钮
    UIButton *_Answertips;//答案提示按钮
    CGFloat _cellheight;
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
    ItemListModel *_model;
    BOOL _isstart;//是否开始
    NSTimer *_timer;//定时器
    NSInteger _index;
    
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _OPTIONSNUM = 3;
        _TYPE = 1;
        _isstart = NO;
        _index = 0;
        [self crestesubviews];
        [self createIFlySpeechSynthesizer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidDisappearAction:) name:@"viewDidDisappear" object:nil];
        
    }
    return self;
}


- (void)crestesubviews{
    
    //题目
    _subjectlabel = [self createLabelFrame:CGRectMake(10, 0, KScreenWidth -  40, 30) textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:font1] textString:@"" textAlignment:NSTextAlignmentLeft];
    _subjectlabel.tag = 101014230;
    _subjectlabel.numberOfLines = 0;
    [self.contentView addSubview: _subjectlabel];
    
    //选择
    _chooselable = [self createLabelFrame:CGRectMake(10, 30, KScreenWidth -  40 , 30) textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:font1] textString:@"" textAlignment:NSTextAlignmentLeft];
    _chooselable.tag = 101014231;
    _chooselable.numberOfLines = 0;
    [self.contentView addSubview:_chooselable];
    
    
    //选中按钮
    _ABCview =[[ UIView alloc] initWithFrame:CGRectMake(0, 60, self.contentView.width, 40 * KH)];
    _ABCview.tag = 9211000;
    [self.contentView addSubview:_ABCview];
    if (_OPTIONSNUM > ABCrray.count) {//容错处理
        _OPTIONSNUM = ABCrray.count;
    }
    
    for (int i = 0; i < _OPTIONSNUM; i ++) {
        UIButton *button = [self creatsButton:@"" frame:CGRectMake(5 + (30 * KW + 10) * i, 0, 30 * KW, 40 * KH) title:ABCrray[i] backgroundCorlor:[UIColor whiteColor] tintColor:[UIColor lightGrayColor] tag:90911290 + i];
        button.hidden = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:font1];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth =  1;
        button.selected = NO;
        [_ABCview addSubview:button];
    }
    
    //提交后的下面的视图
    _analysisview =[[ UIView alloc] initWithFrame:CGRectMake(0,40 * KH + 60 , self.contentView.width, 200)];
    _analysisview.tag = 9211000;
    [self.contentView addSubview:_analysisview];
    
    //答案提示按钮的
    _Answertips = [self creatsButton:@"" frame:CGRectMake(KScreenWidth - 60, 0, 30,30) title:@"" backgroundCorlor:[UIColor clearColor] tintColor:[UIColor clearColor] tag:10259140];
    [_analysisview addSubview:_Answertips];
    
    
    //正确的答案
    UILabel *correctlabel = [self createLabelFrame:CGRectMake(10, 30 , 80 * KW, 40) textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:font1] textString:@"正确答案：" textAlignment:NSTextAlignmentLeft];
    _correctlabel1 = [self createLabelFrame:CGRectMake(10 + 80 * KW,30 , 20 * KW, 40) textColor:ESTgreenColor textFont:[UIFont boldSystemFontOfSize:font1 + 3] textString:@"B" textAlignment:NSTextAlignmentLeft];
    [_analysisview addSubview:correctlabel];
    [_analysisview addSubview:_correctlabel1];
    
    //轮播的图片
    _imagview = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth -  80 * KH)/2, 70, 80 * KH, 90 * KH)];
    [_analysisview addSubview:_imagview];
    
    //播放按钮
    _playbutton= [UIButton buttonWithType:UIButtonTypeCustom];
    _playbutton.frame = CGRectMake(10,_imagview.bottom + 15, 25 * KH, 25 * KH);
    [_playbutton addTarget:self action:@selector(playbutton:) forControlEvents:UIControlEventTouchUpInside];
    [_playbutton setBackgroundImage:[UIImage imageNamed:@"chat_receiver_audio_playing_full"] forState:UIControlStateNormal];
    [_analysisview addSubview:_playbutton];
    
    //学的学时
    UILabel *label1 = [self createLabelFrame:CGRectMake(25 * KH + 20, _imagview.bottom + 15,KScreenWidth - 25 * KH - 50 , 30) textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:font1] textString:@"" textAlignment:NSTextAlignmentRight];
    label1.text = [NSString stringWithFormat:@"本次获取的学时%@",period];
    label1.tag =  101018432;
    [_analysisview addSubview:label1];
    
    //答案解析
    UILabel *label2 = [self createLabelFrame:CGRectMake(10, _playbutton.bottom + 30 + 15,KScreenWidth -  20, 30) textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:font1] textString:@"" textAlignment:NSTextAlignmentLeft];
    label2.numberOfLines = 0;
    label2.tag =  101018431;
    [_analysisview addSubview:label2];
    
    
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
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleColor:tintColors forState:UIControlStateNormal];
    button.backgroundColor = colors;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}

#pragma mark - 语音初始化
- (void)createIFlySpeechSynthesizer{
    
    //1.创建合成对象
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate =
    self;
    //2.设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //音量,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]]; //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表” [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]]; //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
}

- (void)buttonAction:(UIButton *)button{
    
    //已经提交答案
    if (_isSubmitaAnswer == YES) {
        return;
    }
    
    //看是单选还是多选
    //这个是单选
    if (_TYPE == 0) {//单选
        
        //答案
        NSInteger index = button.tag - 90911290;
        if (index < ABCrray.count) {
            self.chooseblock(ABCrray[index]);
        }
        
        //改变选择状态
        for (int i = 0; i < _OPTIONSNUM; i ++) {
            UIView *view = [self.contentView viewWithTag:9211000];
            UIButton *buttons = [view viewWithTag:90911290 + i];
            
            if (buttons.selected == YES) {
                
                buttons.selected = NO;
                buttons.layer.borderColor = [UIColor lightGrayColor].CGColor;
                buttons.layer.borderWidth =  1;
                [buttons setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
            }
            
            button.layer.borderColor = MainRedColor.CGColor;
            button.layer.borderWidth =  2;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:font1];
            [button setTitleColor:MainRedColor forState:UIControlStateNormal];
            button.selected = YES;
        }
        
        
    }else if(_TYPE == 1){//选择
        
        if (button.selected == YES) {
            
            button.selected = NO;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth =  1;
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        }else{
            
            button.layer.borderColor = MainRedColor.CGColor;
            button.layer.borderWidth =  2;
            button.titleLabel.font  = [UIFont boldSystemFontOfSize:font1];
            [button setTitleColor:MainRedColor forState:UIControlStateNormal];
            button.selected = YES;
            
        }
        
        NSMutableArray *strArray  = [NSMutableArray array];
        for (int i = 0; i < _OPTIONSNUM; i ++) {
            UIView *view = [self.contentView viewWithTag:9211000];
            UIButton *buttons = [view viewWithTag:90911290 + i];
            if (buttons.selected == YES) {
                
                [strArray addObject:ABCrray[i]];
            }
            
            self.chooseblock(strArray);
            
        }
    }
    
}

#pragma mark - 播放声音
- (void)playbutton:(UIButton *)button{
    
    
    if (_isstart == YES) {
        
        //结束播放
        　 [_timer invalidate];
        _timer = nil;
        
        [_playbutton setBackgroundImage:[UIImage imageNamed:@"chat_receiver_audio_playing_full"] forState:UIControlStateNormal];
        
        [_iFlySpeechSynthesizer stopSpeaking];
        _isstart = NO;
        
    }else{
        
        //开始播放
        [MBProgressHUD showHUDAddedTo:nil animated:YES];
        [_iFlySpeechSynthesizer startSpeaking:_model.EXAMANALYSIS];
        _isstart = YES;
        
        
        
    }
}

#pragma mark -
- (void)playImage{
    
    [_playbutton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"chat_receiver_audio_playing00%ld",(long)_index]] forState:UIControlStateNormal];
    
    _index++;
    if (_index >= 3) {
        _index = 0;
    }
    
}


//接受到一个通知视图消失显示的时候暂停播放
#pragma mark - 通知的协议方法
- (void)viewDidDisappearAction:(NSNotification *)notification{
    
    if (_isstart == YES) {
        [_iFlySpeechSynthesizer stopSpeaking];
        _isstart = NO;
        
        [_playbutton setBackgroundImage:[UIImage imageNamed:@"chat_receiver_audio_playing_full"] forState:UIControlStateNormal];
        
        //结束播放
        [_timer invalidate];
        _timer = nil;
        
        
    }
}



#pragma mark - 数据信息
- (void)setmodel:(ItemListModel *)model{
    _model = model;
    //类型
    //    _TYPE = [model.TYPE integerValue];
    
    //题目和选择提示
    _subjectlabel.text = model.TITLE;
    _chooselable.text = model.ALLOPTIONS;
    
    _subjectlabel.frame = CGRectMake(10, 0, KScreenWidth -  40, model.TITLEheight);
    _chooselable.frame = CGRectMake(10, model.TITLEheight, KScreenWidth -  40, model.ALLOPTIONSheight);
    
    //A，B，C
    _ABCview.frame = CGRectMake(10, model.ALLOPTIONSheight + model.TITLEheight, KScreenWidth -  40, 40 * KH);
    _cellheight = model.ALLOPTIONSheight + model.TITLEheight+ 40 * KH;
    
    //展示的ABC按钮
    for (int i = 0; i < [model.OPTIONSNUM integerValue]; i ++) {
        UIButton *button = [self.contentView viewWithTag:90911290 + i];
        button.hidden =  NO;
    }
    _correctlabel1.text = model.ANSWERS;
    
    //是否是正确答案
    if ([model.answer isEqualToString:model.ANSWERS]) {
        
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"rightgif" ofType:@"gif"]];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake((KScreenWidth -  150)/2, 40, 150, 150)];
        webView.userInteractionEnabled = NO;//用户不可交互
        [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [_analysisview addSubview:webView];//wronggif
        
        [_Answertips setBackgroundImage:[UIImage imageNamed:@"正确按钮"] forState:UIControlStateNormal];
        
    }else{
        
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"wronggif" ofType:@"gif"]];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake((KScreenWidth -  150)/2, 40, 150, 96)];
        webView.userInteractionEnabled = NO;//用户不可交互
        [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [_analysisview addSubview:webView];//wronggif
        //提示正确的按钮
        [_Answertips setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
        
    }
    
    //🉐学时
    UILabel *EXAMANALYSISlabel2 = [_analysisview viewWithTag:101018432];
    if ([model.answer isEqualToString:model.ANSWERS]) {
        EXAMANALYSISlabel2.text = [NSString stringWithFormat:@"本次获取的学时%.2f",model.CORRECTHOUR];
    }else{
        EXAMANALYSISlabel2.text = [NSString stringWithFormat:@"本次获取的学时%.2f",model.INCORRECTHOUR];
    }
    NSMutableAttributedString *fromMuString = [[NSMutableAttributedString alloc]  initWithString:EXAMANALYSISlabel2.text];
    [fromMuString addAttribute:NSForegroundColorAttributeName value:MainRedColor range:NSMakeRange(7,EXAMANALYSISlabel2.text.length - 7)];
    [fromMuString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font1] range:NSMakeRange(7,EXAMANALYSISlabel2.text.length - 7)];
    EXAMANALYSISlabel2.attributedText = fromMuString;
    
    //解析
    UILabel *EXAMANALYSISlabel1 = [_analysisview viewWithTag:101018431];
    EXAMANALYSISlabel1.text = [NSString stringWithFormat:@"解析：%@",model.EXAMANALYSIS];
    EXAMANALYSISlabel1.numberOfLines = 0;
    EXAMANALYSISlabel1.frame = CGRectMake(10,115 * KH + 85,KScreenWidth - 40, model.EXAMANALYSISheight);
    
    
    //下面的视图
    _analysisview.frame = CGRectMake(0, model.ALLOPTIONSheight + model.TITLEheight+ 40 * KH, self.contentView.width, 80 + 115 * KH + model.EXAMANALYSISheight);
}


- (void)setTheSuccessBlock:(ChooseSuccessBlock)blok{
    self.chooseblock = blok;
}

#pragma mark - 科大讯飞delegate
- (void) onBufferProgress:(int) progress message:(NSString *)msg{
    [MBProgressHUD hideHUDForView:nil animated:YES];
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playImage) userInfo:nil repeats:YES];
    }
    
}


- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos{
    
    if (progress == 100) {
        //结束播放
        [_timer invalidate];
        _timer = nil;
        
        [_playbutton setBackgroundImage:[UIImage imageNamed:@"chat_receiver_audio_playing_full"] forState:UIControlStateNormal];
        _isstart = NO;
    }
}



@end
