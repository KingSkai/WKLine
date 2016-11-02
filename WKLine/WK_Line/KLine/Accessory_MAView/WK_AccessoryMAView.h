//
//  WK_AccessoryMAView.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WK_StockChartConstant.h"
@class WK_KLineModel;
@interface WK_AccessoryMAView : UIView

+(instancetype)view;

-(void)maProfileWithModel:(WK_KLineModel *)model;

/**
 *  Accessory指标种类
 */
@property (nonatomic, assign) WK_StockChartTargetLineStatus targetLineStatus;

@end
