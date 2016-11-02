//
//  WK_KLineAccessoryView.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WK_StockChartConstant.h"
@protocol WK_KLineAccessoryViewDelegate <NSObject>

@optional

/**
 *  当前AccessoryView的最大值和最小值
 */
- (void)kLineAccessoryViewCurrentMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;

@end

@interface WK_KLineAccessoryView : UIView

/**
 * 需要绘制的K线模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineModels;

/**
 * 需要绘制的K线位置数组
 */
@property (nonatomic, strong) NSArray *needDrawKLinePositionModels;

/**
 *  K线的颜色
 */
@property (nonatomic, strong) NSArray *kLineColors;

/**
 *  代理
 */
@property (nonatomic, weak) id<WK_KLineAccessoryViewDelegate> delegate;

/**
 *  Accessory指标种类
 */
@property (nonatomic, assign) WK_StockChartTargetLineStatus targetLineStatus;

/**
 *  绘制
 */
- (void)draw;

@end
