//
//  SubmitAnwerController.m
//  ESTDriver
//
//  Created by 周波 on 16/10/9.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import "SubmitAnwerController.h"
#import "HeadView.h"
#import "SumbitCell.h"
#import "ItemListModel.h"
#import "BaseNavigationController.h"
#import "ViewController.h"

@interface SubmitAnwerController ()
@property(nonatomic,strong)UIButton *sumbitbutton;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,strong)NSDictionary *totaldata;//学时
@property(nonatomic,assign)BOOL isSubmitaAnswer;//是否已经提交答案
@property(nonatomic,strong)HeadView *heaview;//前面的头视图
@end

@implementation SubmitAnwerController{
    ItemListModel *_model;//请求数据
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //对取出的cookie进行反归档处理
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    
    //对取出的cookie进行反归档处理
    NSArray *cookies1 = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults1 objectForKey:@"cookie"]];
    if(cookies1) {
        //设置cookie
        NSHTTPCookieStorage*cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for(id cookie in cookies1) {
            
            [cookieStorage setCookie:(NSHTTPCookie*)cookie];
        }
    }else{
        
        NSLog(@"cookie设置失败");
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    self.delege = self;
    _isSubmitaAnswer = NO;
    
    //前面的视图，有图片，学员，学习，
    _heaview = [[HeadView alloc] initWithFrame:CGRectMake(10, 20, KScreenWidth - 20, 160 * KScreenHight/536 + 110)];
    _heaview.backgroundColor = YRGBColor(252, 244, 245);
    [self.view addSubview:_heaview];
    
    //提交answerbutton
    _sumbitbutton =  [self creatsButton:@"tijiao" frame:CGRectMake(10, KScreenHight - 100, KScreenWidth - 20, (KScreenWidth - 20)/632 * 77) title:@"" backgroundCorlor:[UIColor clearColor] tintColor:[UIColor whiteColor] tag:101011300];
    [self.view addSubview:_sumbitbutton];
    
    //创建示图
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(10,160 * KScreenHight/536 + 130, KScreenWidth -  20, KScreenHight - 160 * KScreenHight/536 - 250) style:UITableViewStyleGrouped];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableview];
    
    //网络请求获取题目
    [self request];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.backgroundColor = YRGBColor(223, 96, 88);
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //视图消失显示的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"viewDidDisappear" object:self];
    
}

#pragma mark - 网络请求
- (void)request{
    
    NSString *url = [NSString stringWithFormat:@"%@/test/getAddTest",ROOT_URL];
    NSDictionary *parmes = @{};
    [MHNetworkManager postReqeustWithURL:url params:parmes successBlock:^(NSDictionary *returnData) {
        
        //
        _data = [NSDictionary dictionary];
        _data = returnData[@"data"];
        NSArray *array = _data[@"itemList"];
        array = [self deleteEmptyArr:array];
        
        NSDictionary *dic = array.firstObject;
        _model = [ItemListModel mj_objectWithKeyValues:dic];
        _model.ALLOPTIONSheight = [self getstring:_model.ALLOPTIONS forCGSize:CGSizeMake(KScreenWidth -40, 1000)];
        _model.TITLEheight = [self getstring:_model.TITLE forCGSize:CGSizeMake(KScreenWidth- 40, 1000)];
        _model.EXAMANALYSISheight = [self getstring:[NSString stringWithFormat:@"解析：%@",_model.EXAMANALYSIS] forCGSize:CGSizeMake(KScreenWidth- 40, 1000)];
        //刷新数据
        [_tableview reloadData];
        
    } failureBlock:^(NSError *error) {
        
        /*自动登录*/
        [self setlogin:^{
            
            [self request];
        }];
        
    } showHUD:YES];
    
    //积分请求
    NSString *url1  = [NSString stringWithFormat:@"%@/test/getClassHour",ROOT_URL];
    [MHNetworkManager postReqeustWithURL:url1 params:nil successBlock:^(NSDictionary *returnData) {
        
        _totaldata = [NSDictionary dictionary];
        _totaldata = returnData[@"data"];
        _heaview.data = _totaldata;
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:YES];
    
}


//获取高度
- (CGFloat)getstring:(NSString *)text forCGSize:(CGSize)size{
    CGSize  S2 = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font1]} context:nil].size;
    if (S2.height >= 30) {
        return S2.height;
    }else{
        return 30;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ss = @"SumbitCell";
    SumbitCell *cell = [tableView dequeueReusableCellWithIdentifier:ss];
    if (cell == nil) {
        cell = [[SumbitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.isSubmitaAnswer = _isSubmitaAnswer;
    
    //选择答案
    [cell setTheSuccessBlock:^(NSMutableArray *strArray) {
        
        NSString *str;
        if (strArray.count == 1) {
            str = strArray[0];
            _model.answer = str;
            
        }else if (strArray.count > 1){//拼接
            str = [strArray componentsJoinedByString:@","];
            _model.answer = str;
            
        }
        
    }];
    
    //提交答案是否成功
    if ( _isSubmitaAnswer == YES) {
        
        cell.analysisview.hidden = NO;
    }else{
        cell.analysisview.hidden = YES;
    }
    
    //数据的展示
    if (_model != nil) {
        [cell setmodel:_model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //提交答案是否成功
    if ( _isSubmitaAnswer == NO) {
        //修改一下table的frame
        
        if (KScreenHight - 160 * KScreenHight/536 - 250 >  _model.ALLOPTIONSheight + _model.TITLEheight+ 40 * KH) {
            
            _tableview.frame = CGRectMake(10,160 * KScreenHight/536 + 130, KScreenWidth -  20,  _model.ALLOPTIONSheight + _model.TITLEheight+ 40 * KH + 10);
        }else{
            
            _tableview.frame = CGRectMake(10,160 * KScreenHight/536 + 130, KScreenWidth -  20,  KScreenHight - 160 * KScreenHight/536 - 250 );
            
        }
        return _model.ALLOPTIONSheight + _model.TITLEheight+ 40 * KH;
        
    }else{
        
        _tableview.frame = CGRectMake(10,160 * KScreenHight/536 + 130, KScreenWidth -  20,  KScreenHight - 160 * KScreenHight/536 - 250 );
        
        return _model.ALLOPTIONSheight + _model.TITLEheight+ 40 * KH + 70 + 115 * KH + _model.EXAMANALYSISheight;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.01)];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - 提交答案代理的协议方法
- (void)buttonAction:(UIButton *)button{
    //
    if (_isSubmitaAnswer == YES) {
        
        //调转界面(已经提交答案成功)
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
        [window makeKeyAndVisible];
        return;
    }
    
    //提交答案
    if (_model.answer == nil) {
        
        [MBProgressHUD showError:@"请选择答案" toView:self.view];
        return;
        
    }else{
        
        //
        NSString *url = [NSString stringWithFormat:@"%@/test/saveAnswer",ROOT_URL];
        NSDictionary *dic =  @{@"testId":_model.ITEMID,@"userAnswer":_model.answer};
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dic];
        
        //json字符
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:nil error:nil];
        NSString *jsonstr =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *parmes = @{@"data":jsonstr,@"testId":_data[@"testId"]};
        
        [MHNetworkManager postReqeustWithURL:url params:parmes successBlock:^(NSDictionary *returnData) {
            
            NSLog(@"%@",returnData);
            NSNumber *flag = returnData[@"flag"];
            if ([flag isEqual: @(1)]) {
                
                //提交答案成功
                _isSubmitaAnswer = YES;
                _sumbitbutton.hidden = YES;
                [_sumbitbutton setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
                [_tableview reloadData];
                
                
                //积分请求
                NSString *url1  = [NSString stringWithFormat:@"%@/test/getClassHour",ROOT_URL];
                [MHNetworkManager postReqeustWithURL:url1 params:nil successBlock:^(NSDictionary *returnData) {
                    
                    _totaldata = [NSDictionary dictionary];
                    _totaldata = returnData[@"data"];
                    _heaview.data = _totaldata;
                    
                    
                } failureBlock:^(NSError *error) {
                    
                    
                } showHUD:NO];
                
                
            }
            
        } failureBlock:^(NSError *error) {
            
            
            [MBProgressHUD showError:@"提交答案失败" toView:self.view];
            
        } showHUD:YES];
        
    }
    
}


#pragma mark -

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"viewDidDisappear" object:nil];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > _model.ALLOPTIONSheight + _model.TITLEheight + 40 * KH) {
        _sumbitbutton.hidden = NO;
        
    }
}
@end
