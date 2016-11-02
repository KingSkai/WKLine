//
//  WK_StockChartGlobalVariable.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_StockChartGlobalVariable.h"

/**
 *  K线图的宽度，默认20
 */
static CGFloat WK_StockChartKLineWidth = 2;

/**
 *  K线图的间隔，默认1
 */
static CGFloat WK_StockChartKLineGap = 1;


/**
 *  MainView的高度占比,默认为0.5
 */
static CGFloat WK_StockChartKLineMainViewRadio = 0.5;

/**
 *  VolumeView的高度占比,默认为0.5
 */
static CGFloat WK_StockChartKLineVolumeViewRadio = 0.2;


/**
 *  是否为EMA线
 */
static WK_StockChartTargetLineStatus WK_StockChartKLineIsEMALine = WK_StockChartTargetLineStatusMA;


@implementation WK_StockChartGlobalVariable

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth
{
    return WK_StockChartKLineWidth;
}
+(void)setkLineWith:(CGFloat)kLineWidth
{
    if (kLineWidth > WK_StockChartKLineMaxWidth) {
        kLineWidth = WK_StockChartKLineMaxWidth;
    }else if (kLineWidth < WK_StockChartKLineMinWidth){
        kLineWidth = WK_StockChartKLineMinWidth;
    }
    WK_StockChartKLineWidth = kLineWidth;
}


/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap
{
    return WK_StockChartKLineGap;
}

+(void)setkLineGap:(CGFloat)kLineGap
{
    WK_StockChartKLineGap = kLineGap;
}

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio
{
    return WK_StockChartKLineMainViewRadio;
}
+ (void)setkLineMainViewRadio:(CGFloat)radio
{
    WK_StockChartKLineMainViewRadio = radio;
}

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio
{
    return WK_StockChartKLineVolumeViewRadio;
}
+ (void)setkLineVolumeViewRadio:(CGFloat)radio
{
    WK_StockChartKLineVolumeViewRadio = radio;
}


/**
 *  isEMA线
 */

+ (CGFloat)isEMALine
{
    return WK_StockChartKLineIsEMALine;
}
+ (void)setisEMALine:(WK_StockChartTargetLineStatus)type
{
    WK_StockChartKLineIsEMALine = type;
}

@end
