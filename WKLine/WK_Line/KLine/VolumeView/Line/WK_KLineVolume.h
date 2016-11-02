//
//  WK_KLineVolume.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WK_KLineVolumePositionModel.h"
#import "WK_KLineModel.h"
@interface WK_KLineVolume : NSObject

/**
 *  位置model
 */
@property (nonatomic, strong) WK_KLineVolumePositionModel *positionModel;

/**
 *  k线model
 */
@property (nonatomic, strong) WK_KLineModel *kLineModel;

/**
 *  线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  根据context初始化均线画笔
 */
- (instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制成交量
 */
- (void)draw;
@end
