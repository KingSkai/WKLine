//
//  WK_KLineMainView.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WK_KLinePositionModel.h"
#import "WK_KLineModel.h"
#import "WK_StockChartConstant.h"
@protocol WK_KLineMainViewDelegate <NSObject>

@optional

/**
 *  长按显示手指按着的WK_KLinePosition和KLineModel
 */
- (void)kLineMainViewLongPressKLinePositionModel:(WK_KLinePositionModel*)kLinePositionModel kLineModel:(WK_KLineModel *)kLineModel;

/**
 *  当前MainView的最大值和最小值
 */
- (void)kLineMainViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice;

/**
 *  当前需要绘制的K线模型数组
 */
- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels;

/**
 *  当前需要绘制的K线位置模型数组
 */
- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels;

/**
 *  当前需要绘制的K线颜色数组
 */
- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors;

@end


@interface WK_KLineMainView : UIView


/**
 *  模型数组
 */
@property (nonatomic, strong) NSArray *kLineModels;


/**
 *  父ScrollView
 */
@property (nonatomic, weak, readonly) UIScrollView *parentScrollView;

/**
 *  代理
 */
@property (nonatomic, weak) id<WK_KLineMainViewDelegate> delegate;

/**
 *  是否为图表类型
 */
@property (nonatomic, assign) WK_StockChartCenterViewType MainViewType;

/**
 *  Accessory指标种类
 */
@property (nonatomic, assign) WK_StockChartTargetLineStatus targetLineStatus;

/**
 *  需要绘制Index开始值
 */
@property (nonatomic, assign) NSInteger needDrawStartIndex;

/**
 *  捏合点
 */
@property (nonatomic, assign) NSInteger pinchStartIndex;
#pragma event

/**
 *  画MainView的所有线
 */
- (void)drawMainView;

/**
 *  更新MainView的宽度
 */
- (void)updateMainViewWidth;

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (CGFloat)getExactXPositionWithOriginXPosition:(CGFloat)originXPosition;

/**
 *  移除所有的监听事件
 */
- (void)removeAllObserver;
@end
