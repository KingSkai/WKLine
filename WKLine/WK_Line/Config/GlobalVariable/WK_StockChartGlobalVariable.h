//
//  WK_StockChartGlobalVariable.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WK_StockChartConstant.h"


@interface WK_StockChartGlobalVariable : NSObject

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth;

+(void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap;

+(void)setkLineGap:(CGFloat)kLineGap;

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio;
+ (void)setkLineMainViewRadio:(CGFloat)radio;

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio;
+ (void)setkLineVolumeViewRadio:(CGFloat)radio;


/**
 *  isEMA线
 */
+ (CGFloat)isEMALine;
+ (void)setisEMALine:(WK_StockChartTargetLineStatus)type;


@end
