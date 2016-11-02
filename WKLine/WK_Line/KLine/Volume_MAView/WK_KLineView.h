//
//  WK_KLineView.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WK_KLineModel.h"
#import "WK_StockChartConstant.h"
@interface WK_KLineView : UIView

/**
 *  第一个View的高所占比例
 */
@property (nonatomic, assign) CGFloat mainViewRatio;

/**
 *  第二个View(成交量)的高所占比例
 */
@property (nonatomic, assign) CGFloat volumeViewRatio;

/**
 *  数据
 */
@property(nonatomic, copy) NSArray<WK_KLineModel *> *kLineModels;

/**
 *  重绘
 */
- (void)reDraw;


/**
 *  K线类型
 */
@property (nonatomic, assign) WK_StockChartCenterViewType MainViewType;

/**
 *  Accessory指标种类
 */
@property (nonatomic, assign) WK_StockChartTargetLineStatus targetLineStatus;
@end
