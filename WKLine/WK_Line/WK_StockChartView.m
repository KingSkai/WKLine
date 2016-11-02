//
//  WK_StockChartView.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_StockChartView.h"
#import "WK_KLineView.h"
#import "Masonry.h"
#import "WK_StockChartSegmentView.h"
#import "WK_StockChartGlobalVariable.h"
@interface WK_StockChartView() <WK_StockChartSegmentViewDelegate>

/**
 *  K线图View
 */
@property (nonatomic, strong) WK_KLineView *kLineView;

/**
 *  底部选择View
 */
@property (nonatomic, strong) WK_StockChartSegmentView *segmentView;

/**
 *  图表类型
 */
@property(nonatomic,assign) WK_StockChartCenterViewType currentCenterViewType;

/**
 *  当前索引
 */
@property(nonatomic,assign,readwrite) NSInteger currentIndex;
@end


@implementation WK_StockChartView

- (WK_KLineView *)kLineView
{
    if(!_kLineView)
    {
        _kLineView = [WK_KLineView new];
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.top.equalTo(self);
            make.left.equalTo(self.segmentView.mas_right);
        }];
    }
    return _kLineView;
}

- (WK_StockChartSegmentView *)segmentView
{
    if(!_segmentView)
    {
        _segmentView = [WK_StockChartSegmentView new];
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.top.equalTo(self);
            make.width.equalTo(@50);
        }];
    }
    return _segmentView;
}

- (void)setItemModels:(NSArray *)itemModels
{
    _itemModels = itemModels;
    if(itemModels)
    {
        NSMutableArray *items = [NSMutableArray array];
        for(WK_StockChartViewItemModel *item in itemModels)
        {
            [items addObject:item.title];
        }
        self.segmentView.items = items;
        WK_StockChartViewItemModel *firstModel = itemModels.firstObject;
        self.currentCenterViewType = firstModel.centerViewType;
    }
    if(self.dataSource)
    {
        self.segmentView.selectedIndex = 4;
    }
}

- (void)setDataSource:(id<WK_StockChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if(self.itemModels)
    {
        self.segmentView.selectedIndex = 4;
    }
}
- (void)reloadData
{
    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
}

#pragma mark - 代理方法

- (void)WK_StockChartSegmentView:(WK_StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index
{
    self.currentIndex = index;
    if(index >= 100)
    {
        [WK_StockChartGlobalVariable setisEMALine:index];
        //        if(index == WK_StockChartTargetLineStatusMA)
        //        {
        //            [WK_StockChartGlobalVariable setisEMALine:WK_StockChartTargetLineStatusMA];
        //        } else {
        //            [WK_StockChartGlobalVariable setisEMALine:WK_StockChartTargetLineStatusEMA];
        //        }
        self.kLineView.targetLineStatus = index;
        [self.kLineView reDraw];
        [self bringSubviewToFront:self.segmentView];
        
    } else {
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)])
        {
            id stockData = [self.dataSource stockDatasWithIndex:index];
            
            if(!stockData)
            {
                return;
            }
            
            WK_StockChartViewItemModel *itemModel = self.itemModels[index];
            
            
            WK_StockChartCenterViewType type = itemModel.centerViewType;
            
            
            
            if(type != self.currentCenterViewType)
            {
                //移除当前View，设置新的View
                self.currentCenterViewType = type;
                switch (type) {
                    case WK_StockChartcenterViewTypeKline:
                    {
                        self.kLineView.hidden = NO;
                        //                    [self bringSubviewToFront:self.kLineView];
                        [self bringSubviewToFront:self.segmentView];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if(type == WK_StockChartcenterViewTypeOther)
            {
                
            } else {
                self.kLineView.kLineModels = (NSArray *)stockData;
                self.kLineView.MainViewType = type;
                [self.kLineView reDraw];
            }
            [self bringSubviewToFront:self.segmentView];
        }
    }
    
}

@end


/************************ItemModel类************************/
@implementation WK_StockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title type:(WK_StockChartCenterViewType)type
{
    WK_StockChartViewItemModel *itemModel = [WK_StockChartViewItemModel new];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}

@end
