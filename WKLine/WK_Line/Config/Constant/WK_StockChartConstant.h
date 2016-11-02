//
//  WK_StockChartConstant.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#ifndef WK_StockChartConstant_h
#define WK_StockChartConstant_h



#endif /* WK_StockChartConstant_h */

/**
 *  K线图需要加载更多数据的通知
 */
#define WK_StockChartKLineNeedLoadMoreDataNotification @"WK_StockChartKLineNeedLoadMoreDataNotification"

/**
 *  K线图Y的View的宽度
 */
#define WK_StockChartKLinePriceViewWidth 47

/**
 *  K线图的X的View的高度
 */
#define WK_StockChartKLineTimeViewHeight 20

/**
 *  K线最大的宽度
 */
#define WK_StockChartKLineMaxWidth 20

/**
 *  K线图最小的宽度
 */
#define WK_StockChartKLineMinWidth 2

/**
 *  K线图缩放界限
 */
#define WK_StockChartScaleBound 0.03

/**
 *  K线的缩放因子
 */
#define WK_StockChartScaleFactor 0.03

/**
 *  UIScrollView的contentOffset属性
 */
#define WK_StockChartContentOffsetKey @"contentOffset"

/**
 *  时分线的宽度
 */
#define WK_StockChartTimeLineLineWidth 0.5

/**
 *  时分线图的Above上最小的X
 */
#define WK_StockChartTimeLineMainViewMinX 0.0

/**
 *  分时线的timeLabelView的高度
 */
#define WK_StockChartTimeLineTimeLabelViewHeight 19

/**
 *  时分线的成交量的线宽
 */
#define WK_StockChartTimeLineVolumeLineWidth 0.5

/**
 *  长按时的线的宽度
 */
#define WK_StockChartLongPressVerticalViewWidth 0.5

/**
 *  MA线的宽度
 */
#define WK_StockChartMALineWidth 0.8

/**
 *  上下影线宽度
 */
#define WK_StockChartShadowLineWidth 1
/**
 *  所有profileView的高度
 */
#define WK_StockChartProfileViewHeight 50

/**
 *  K线图上可画区域最小的Y
 */
#define WK_StockChartKLineMainViewMinY 20

/**
 *  K线图上可画区域最大的Y
 */
#define WK_StockChartKLineMainViewMaxY (self.frame.size.height - 15)

/**
 *  K线图的成交量上最小的Y
 */
#define WK_StockChartKLineVolumeViewMinY 20

/**
 *  K线图的成交量最大的Y
 */
#define WK_StockChartKLineVolumeViewMaxY (self.frame.size.height)

/**
 *  K线图的副图上最小的Y
 */
#define WK_StockChartKLineAccessoryViewMinY 20

/**
 *  K线图的副图最大的Y
 */
#define WK_StockChartKLineAccessoryViewMaxY (self.frame.size.height)

/**
 *  K线图的副图中间的Y
 */
//#define WK_StockChartKLineAccessoryViewMiddleY (self.frame.size.height-20)/2.f + 20
#define WK_StockChartKLineAccessoryViewMiddleY (maxY - (0.f-minValue)/unitValue)

/**
 *  时分线图的Above上最小的Y
 */
#define WK_StockChartTimeLineMainViewMinY 0

/**
 *  时分线图的Above上最大的Y
 */
#define WK_StockChartTimeLineMainViewMaxY (self.frame.size.height-WK_StockChartTimeLineTimeLabelViewHeight)


/**
 *  时分线图的Above上最大的Y
 */
#define WK_StockChartTimeLineMainViewMaxX (self.frame.size.width)

/**
 *  时分线图的Below上最小的Y
 */
#define WK_StockChartTimeLineVolumeViewMinY 0

/**
 *  时分线图的Below上最大的Y
 */
#define WK_StockChartTimeLineVolumeViewMaxY (self.frame.size.height)

/**
 *  时分线图的Below最大的X
 */
#define WK_StockChartTimeLineVolumeViewMaxX (self.frame.size.width)

/**
 * 时分线图的Below最小的X
 */
#define WK_StockChartTimeLineVolumeViewMinX 0

//Kline种类
typedef NS_ENUM(NSInteger, WK_StockChartCenterViewType) {
    WK_StockChartcenterViewTypeKline= 1, //K线
    WK_StockChartcenterViewTypeTimeLine,  //分时图
    WK_StockChartcenterViewTypeOther
};


//Accessory指标种类
typedef NS_ENUM(NSInteger, WK_StockChartTargetLineStatus) {
    WK_StockChartTargetLineStatusMACD = 100,    //MACD线
    WK_StockChartTargetLineStatusKDJ,    //KDJ线
    WK_StockChartTargetLineStatusAccessoryClose,    //关闭Accessory线
    WK_StockChartTargetLineStatusMA , //MA线
    WK_StockChartTargetLineStatusEMA,  //EMA线
    WK_StockChartTargetLineStatusCloseMA  //MA关闭线
    
};
