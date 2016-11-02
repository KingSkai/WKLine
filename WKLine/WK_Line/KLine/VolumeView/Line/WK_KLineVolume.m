

//
//  WK_KLineVolume.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineVolume.h"
#import "WK_StockChartGlobalVariable.h"
@interface WK_KLineVolume ()
@property (nonatomic, assign) CGContextRef context;
@end

@implementation WK_KLineVolume

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
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, [WK_StockChartGlobalVariable kLineWidth]);
    
    const CGPoint solidPoints[] = {self.positionModel.StartPoint, self.positionModel.EndPoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
}
@end
