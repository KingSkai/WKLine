//
//  WK_KLineAccessory.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineAccessory.h"
#import "WK_StockChartGlobalVariable.h"
#import "UIColor+WK_StockChart.h"
@interface WK_KLineAccessory()

@property (nonatomic, assign) CGContextRef context;

@end


@implementation WK_KLineAccessory
- (instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if(self)
    {
        _context = context;
    }
    return self;
}

- (void)draw
{
    if(!self.kLineModel || !self.positionModel || !self.context || !self.lineColor)
    {
        return;
    }
    CGContextRef context = self.context;
    CGContextSetStrokeColorWithColor(context, [UIColor increaseColor].CGColor);
    CGContextSetLineWidth(context, [WK_StockChartGlobalVariable kLineWidth]);
    
    CGPoint solidPoints[] = {self.positionModel.StartPoint, self.positionModel.EndPoint};
    
    if(self.kLineModel.MACD.floatValue > 0)
    {
        CGContextSetStrokeColorWithColor(context, [UIColor decreaseColor].CGColor);
    }
    CGContextStrokeLineSegments(context, solidPoints, 2);
}

@end
