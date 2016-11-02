

//
//  WK_KLineVolumeView.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineVolumeView.h"
#import "WK_KLineModel.h"
#import "WK_StockChartConstant.h"
#import "UIColor+WK_StockChart.h"
#import "WK_KLineVolume.h"
#import "WK_KLineVolumePositionModel.h"
#import "WK_KLinePositionModel.h"
#import "WK_MALine.h"
@interface WK_KLineVolumeView()

/**
 *  需要绘制的成交量的位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineVolumePositionModels;

/**
 *  Volume_MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA7Positions;


/**
 *  Volume_MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA30Positions;

@end

@implementation WK_KLineVolumeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor backgroundColor];
        self.Volume_MA7Positions = @[].mutableCopy;
        self.Volume_MA30Positions = @[].mutableCopy;
    }
    return self;
}

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if(!self.needDrawKLineVolumePositionModels)
    {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    WK_KLineVolume *kLineVolume = [[WK_KLineVolume alloc]initWithContext:context];
    
    [self.needDrawKLineVolumePositionModels enumerateObjectsUsingBlock:^(WK_KLineVolumePositionModel * _Nonnull volumePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        kLineVolume.positionModel = volumePositionModel;
        kLineVolume.kLineModel = self.needDrawKLineModels[idx];
        kLineVolume.lineColor = self.kLineColors[idx];
        [kLineVolume draw];
    }];
    
    if(self.targetLineStatus != WK_StockChartTargetLineStatusCloseMA){
        WK_MALine *MALine = [[WK_MALine alloc]initWithContext:context];
        
        //画MA7线
        MALine.MAType = WK_MA7Type;
        MALine.MAPositions = self.Volume_MA7Positions;
        [MALine draw];
        
        //画MA30线
        MALine.MAType = WK_MA30Type;
        MALine.MAPositions = self.Volume_MA30Positions;
        [MALine draw];
    }
    
}

#pragma mark - 公有方法
#pragma mark 绘制volume方法
- (void)draw
{
    NSInteger kLineModelcount = self.needDrawKLineModels.count;
    NSInteger kLinePositionModelCount = self.needDrawKLinePositionModels.count;
    NSInteger kLineColorCount = self.kLineColors.count;
    NSAssert(self.needDrawKLineModels && self.needDrawKLinePositionModels && self.kLineColors && kLineColorCount == kLineModelcount && kLinePositionModelCount == kLineModelcount, @"数据异常，无法绘制Volume");
    self.needDrawKLineVolumePositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
#pragma mark 根据KLineModel转换成Position数组
- (NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    CGFloat minY = WK_StockChartKLineVolumeViewMinY;
    CGFloat maxY = WK_StockChartKLineVolumeViewMaxY;
    
    WK_KLineModel *firstModel = kLineModels.firstObject;
    
    __block CGFloat minVolume = firstModel.Volume;
    __block CGFloat maxVolume = firstModel.Volume;
    
    [kLineModels enumerateObjectsUsingBlock:^(WK_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(model.Volume < minVolume)
        {
            minVolume = model.Volume;
        }
        
        if(model.Volume > maxVolume)
        {
            maxVolume = model.Volume;
        }
        if(model.Volume_MA7)
        {
            if (minVolume > model.Volume_MA7.floatValue) {
                minVolume = model.Volume_MA7.floatValue;
            }
            if (maxVolume < model.Volume_MA7.floatValue) {
                maxVolume = model.Volume_MA7.floatValue;
            }
        }
        if(model.Volume_MA30)
        {
            if (minVolume > model.Volume_MA30.floatValue) {
                minVolume = model.Volume_MA30.floatValue;
            }
            if (maxVolume < model.Volume_MA30.floatValue) {
                maxVolume = model.Volume_MA30.floatValue;
            }
        }
    }];
    
    CGFloat unitValue = (maxVolume - minVolume) / (maxY - minY);
    
    NSMutableArray *volumePositionModels = @[].mutableCopy;
    [self.Volume_MA7Positions removeAllObjects];
    [self.Volume_MA30Positions removeAllObjects];
    
    [kLineModels enumerateObjectsUsingBlock:^(WK_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        WK_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
        CGFloat xPosition = kLinePositionModel.HighPoint.x;
        CGFloat yPosition = ABS(maxY - (model.Volume - minVolume)/unitValue);
        if(ABS(yPosition - WK_StockChartKLineVolumeViewMaxY) < 0.5)
        {
            yPosition = WK_StockChartKLineVolumeViewMaxY - 1;
        }
        CGPoint startPoint = CGPointMake(xPosition, yPosition);
        CGPoint endPoint = CGPointMake(xPosition, WK_StockChartKLineVolumeViewMaxY);
        WK_KLineVolumePositionModel *volumePositionModel = [WK_KLineVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint];
        [volumePositionModels addObject:volumePositionModel];
        
        //MA坐标转换
        CGFloat ma7Y = maxY;
        CGFloat ma30Y = maxY;
        if(unitValue > 0.0000001)
        {
            if(model.Volume_MA7)
            {
                ma7Y = maxY - (model.Volume_MA7.floatValue - minVolume)/unitValue;
            }
            
        }
        if(unitValue > 0.0000001)
        {
            if(model.Volume_MA30)
            {
                ma30Y = maxY - (model.Volume_MA30.floatValue - minVolume)/unitValue;
            }
        }
        
        NSAssert(!isnan(ma7Y) && !isnan(ma30Y), @"出现NAN值");
        
        CGPoint ma7Point = CGPointMake(xPosition, ma7Y);
        CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
        
        if(model.Volume_MA7)
        {
            [self.Volume_MA7Positions addObject: [NSValue valueWithCGPoint: ma7Point]];
        }
        if(model.Volume_MA30)
        {
            [self.Volume_MA30Positions addObject: [NSValue valueWithCGPoint: ma30Point]];
        }
    }];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineVolumeViewCurrentMaxVolume:minVolume:)])
    {
        [self.delegate kLineVolumeViewCurrentMaxVolume:maxVolume minVolume:minVolume];
    }
    return volumePositionModels;
}
@end
