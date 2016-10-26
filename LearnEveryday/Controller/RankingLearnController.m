//
//  RankingLearnController.m
//  ESTDriver
//
//  Created by 周波 on 16/10/11.
//  Copyright © 2016年 颜学妹. All rights reserved.
//

#import "RankingLearnController.h"
#import "RankingCell.h"
#import "TableviewHeaderView.h"
#import "RankingTableview.h"
#import "RankingModel.h"

@interface RankingLearnController ()
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,assign)NSInteger index;
@end

@implementation RankingLearnController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = viewcolor;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = YRGBColor(220, 71, 62);
    self.delege  = self;
    
    
    self.title = @"学习排行";
    
    //创建headview
    [self creteheadviw];

    //创建scrollview
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 124, KScreenWidth, KScreenHight - 124)];
    _scrollview.pagingEnabled = YES;
    [self.view addSubview:_scrollview];
    _scrollview.delegate = self;
    _scrollview.contentSize = CGSizeMake(KScreenWidth * 2,  KScreenHight - 124);
    _scrollview.showsVerticalScrollIndicator = FALSE;
    _scrollview.showsHorizontalScrollIndicator = FALSE;

    //创建表视图
    
    for (int i = 0; i < 2; i ++) {
        TableviewHeaderView *view = [[TableviewHeaderView alloc] initWithFrame:CGRectMake(i * KScreenWidth, 0, KScreenWidth, 100)];
        view.tag = 101113210 + i;
        view.type = i;
        [_scrollview addSubview:view];
        
        //表视图
        RankingTableview *tabelview = [[RankingTableview alloc] initWithFrame:CGRectMake(i * KScreenWidth, 100, KScreenWidth, _scrollview.height - 100) style:UITableViewStyleGrouped];
        tabelview.tag =  101110040 + i;
        [_scrollview addSubview:tabelview];
    }
    
    //网络请求
    [self request];
}


- (void)request{
   
    //取得
    //单位内排名
    NSString *url1 = [NSString stringWithFormat:@"%@/test/getRank",ROOT_URL];
    NSDictionary *dic1 = @{@"type":@"0"};
    [MHNetworkManager postReqeustWithURL:url1 params:dic1 successBlock:^(NSDictionary *returnData) {
        
        RankingTableview *tabelview = [_scrollview viewWithTag:101110040];
        TableviewHeaderView *headerview = [_scrollview viewWithTag:101113210];

        NSArray *Array = returnData[@"data"];
        Array = [self deleteEmptyArr:Array];
        
        //数据处理
        if (Array.count > 0) {
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in Array) {
                RankingModel *modle = [RankingModel mj_objectWithKeyValues:dic];
                [dataArray addObject:modle];
            }
            tabelview.dataArray = dataArray;
            headerview.dataArray = dataArray;
            [tabelview reloadData];
        }
        
        
        
    } failureBlock:^(NSError *error) {
      
        
    } showHUD:YES];
    
    
    //在线排名
    NSString *url2 = [NSString stringWithFormat:@"%@/test/getRank",ROOT_URL];
    NSDictionary *dic2 = @{@"type":@"1"};
    [MHNetworkManager postReqeustWithURL:url2 params:dic2 successBlock:^(NSDictionary *returnData) {
        
        RankingTableview *tabelview = [_scrollview viewWithTag:101110041];
        TableviewHeaderView *headerview = [_scrollview viewWithTag:101113211];
        
        NSArray *Array = returnData[@"data"];
        Array = [self deleteEmptyArr:Array];
        
        //数据处理
        if (Array.count > 0) {
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in Array) {
                RankingModel *modle = [RankingModel mj_objectWithKeyValues:dic];
                [dataArray addObject:modle];
            }
            tabelview.dataArray = dataArray;
            headerview.dataArray = dataArray;
            [tabelview reloadData];
        }
        


    } failureBlock:^(NSError *error) {
        
        
    } showHUD:YES];

    
    
}


//头视图
- (void)creteheadviw{
    
    //
    NSArray *array = @[@"单位排名",@"在线排名"];
    for (int i = 0; i  < 2; i ++) {
        
       // UIButton *button = [self creatsButton:@"" frame:CGRectMake(KScreenWidth/2 * i, 64, KScreenWidth/2, 55) title:array[i] backgroundCorlor:[UIColor whiteColor] tintColor:[UIColor blackColor] tag:101110100 + i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame =CGRectMake(KScreenWidth/2 * i, 64, KScreenWidth/2, 55);
        button.tag = 101110100 + i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(buttonActions1:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:font1 + 1];
        [self.view addSubview:button];
        
        _index = 0;
        
        //创建label
        UILabel *label = [self createLabelFrame:CGRectMake(KScreenWidth/2 * i, 64 + 55, KScreenWidth/2, 3) textColor:YRGBColor(40, 165, 220) textFont:[UIFont systemFontOfSize:font1] textString:@"" textAlignment:NSTextAlignmentLeft];
        label.tag = 101110170 + i;
        [self.view addSubview:label];
        
        if (i == _index) {
            label.backgroundColor = YRGBColor(40, 165, 220) ;

        }
        
        
    }
    
    //下面的线
    UILabel *linlabels = [self createLabelFrame:CGRectMake(0, 64 + 58, KScreenWidth, 2) textColor:YRGBColor(40, 165, 220) textFont:[UIFont systemFontOfSize:font1] textString:@"" textAlignment:NSTextAlignmentLeft];
    linlabels.backgroundColor = YRGBColor(40, 165, 220) ;
    [self.view addSubview:linlabels];
    
    
}



#pragma mark - 按钮的点击方法
- (void)buttonActions1:(UIButton *)button{
    NSInteger i = button.tag - 101110100;
    
    //一个是改变label
    if (_index != i) {
        
        UILabel *label = [self.view viewWithTag:101110170 + _index];
        label.backgroundColor = [UIColor whiteColor];
        _index = i;
        UILabel *label1 = [self.view viewWithTag:101110170 + i];
        label1.backgroundColor = YRGBColor(40, 165, 220);
        
    }
    
    //滑动scrollview
    _scrollview.contentOffset = CGPointMake(KScreenWidth * i,0);
 }


#pragma mark - Scrollviewdelege协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //if
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        return;
    }
    
    NSInteger page = scrollView.contentOffset.x/KScreenWidth;
    if (page != _index) {
        
        UILabel *label = [self.view viewWithTag:101110170 + _index];
        label.backgroundColor = [UIColor whiteColor];
        
        _index = page;
        UILabel *label1 = [self.view viewWithTag:101110170 + page];
        label1.backgroundColor = YRGBColor(40, 165, 220);

        
    }

}


@end
