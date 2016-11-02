//
//  WKLineViewController.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WKLineViewController.h"
#import "Masonry.h"
#import "WK_StockChartView.h"
#import "NetWorking.h"
#import "WK_KLineGroupModel.h"
#import "UIColor+WK_StockChart.h"
#import "AppDelegate.h"

@interface WKLineViewController () <WK_StockChartViewDataSource>

@property (nonatomic, strong) WK_StockChartView *stockChartView;

@property (nonatomic, strong) WK_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, WK_KLineGroupModel*> *modelsDict;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;

@end

@implementation WKLineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentIndex = -1;
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
}

- (NSMutableDictionary<NSString *,WK_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

-(id) stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"1min";
        }
            break;
        case 2:
        {
            type = @"1min";
        }
            break;
        case 3:
        {
            type = @"5min";
        }
            break;
        case 4:
        {
            type = @"30min";
        }
            break;
        case 5:
        {
            type = @"1hour";
        }
            break;
        case 6:
        {
            type = @"1day";
        }
            break;
        case 7:
        {
            type = @"1week";
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDict objectForKey:type])
    {
        [self reloadData];
    } else {
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}

- (void)reloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.type;
    param[@"symbol"] = @"huobibtccny";
    param[@"size"] = @"300";
    
    [NetWorking requestWithApi:@"https://www.btc123.com/kline/klineapi" param:param thenSuccess:^(NSDictionary *responseObject) {
        if ([responseObject[@"isSuc"] boolValue]) {
            WK_KLineGroupModel *groupModel = [WK_KLineGroupModel objectWithArray:responseObject[@"datas"]];
            
            self.groupModel = groupModel;
            [self.modelsDict setObject:groupModel forKey:self.type];
            NSLog(@"%@",groupModel);
            [self.stockChartView reloadData];
        }
        
    } fail:^{
        
    }];
}
- (WK_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [WK_StockChartView new];
        _stockChartView.itemModels = @[
                                       [WK_StockChartViewItemModel itemModelWithTitle:@"指标" type:WK_StockChartcenterViewTypeOther],
                                       [WK_StockChartViewItemModel itemModelWithTitle:@"分时" type:WK_StockChartcenterViewTypeTimeLine],
                                       [WK_StockChartViewItemModel itemModelWithTitle:@"1分" type:WK_StockChartcenterViewTypeKline],
                                       [WK_StockChartViewItemModel itemModelWithTitle:@"5分" type:WK_StockChartcenterViewTypeKline],
                                       [WK_StockChartViewItemModel itemModelWithTitle:@"30分" type:WK_StockChartcenterViewTypeKline],
                                       [WK_StockChartViewItemModel itemModelWithTitle:@"60分" type:WK_StockChartcenterViewTypeKline],
                                       [WK_StockChartViewItemModel itemModelWithTitle:@"日线" type:WK_StockChartcenterViewTypeKline],
                                       [WK_StockChartViewItemModel itemModelWithTitle:@"周线" type:WK_StockChartcenterViewTypeKline],
                                       
                                       ];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tap];
    }
    return _stockChartView;
}
- (void)dismiss
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.isEable = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
