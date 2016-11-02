//
//  WK_KLine.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WK_KLinePositionModel.h"
#import "WK_KLineModel.h"
/**
 *  K线的线
 */
@interface WK_KLine : NSObject

/**
 *  K线的位置model
 */
@property (nonatomic, strong) WK_KLinePositionModel *kLinePositionModel;

/**
 *  k线的model
 */
@property (nonatomic, strong) WK_KLineModel *kLineModel;

/**
 *  最大的Y
 */
@property (nonatomic, assign) CGFloat maxY;

/**
 *  根据context初始化
 */
- (instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制K线
 */
- (UIColor *)draw;


@end

