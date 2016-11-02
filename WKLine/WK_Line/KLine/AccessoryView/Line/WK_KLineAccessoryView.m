
//
//  WK_KLineAccessoryView.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineAccessoryView.h"
#import "WK_KLineModel.h"

#import "UIColor+WK_StockChart.h"
#import "WK_KLineAccessory.h"
#import "WK_KLineVolumePositionModel.h"
#import "WK_KLinePositionModel.h"
#import "WK_MALine.h"
@interface WK_KLineAccessoryView()

/**
 *  需要绘制的Volume_MACD位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineAccessoryPositionModels;

/**
 *  Volume_DIF位置数组
 */
@property (nonatomic, strong) NSMutableArray *AccessorWK_DIFPositions;

/**
 *  Volume_DEA位置数组
 */
@property (nonatomic, strong) NSMutableArray *AccessorWK_DEAPositions;

/**
 *  KDJ_K位置数组
 */
@property (nonatomic, strong) NSMutableArray *AccessorWK_KDJ_KPositions;

/**
 *  KDJ_D位置数组
 */
@property (nonatomic, strong) NSMutableArray *AccessorWK_KDJ_DPositions;

/**
 *  KDJ_J位置数组
 */
@property (nonatomic, strong) NSMutableArray *AccessorWK_KDJ_JPositions;

@end

@implementation WK_KLineAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor backgroundColor];
        self.AccessorWK_DIFPositions = @[].mutableCopy;
        self.AccessorWK_DEAPositions = @[].mutableCopy;
        self.AccessorWK_KDJ_KPositions = @[].mutableCopy;
        self.AccessorWK_KDJ_DPositions = @[].mutableCopy;
        self.AccessorWK_KDJ_JPositions = @[].mutableCopy;
        
    }
    return self;
}

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if(!self.needDrawKLineAccessoryPositionModels)
    {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /**
     *  副图，需要区分是MACD线还是KDJ线，进而选择不同的数据源和绘制方法
     */
    if(self.targetLineStatus != WK_StockChartTargetLineStatusKDJ)
    {
        /**
         MACD
         */
        WK_KLineAccessory *kLineAccessory = [[WK_KLineAccessory alloc]initWithContext:context];
        [self.needDrawKLineAccessoryPositionModels enumerateObjectsUsingBlock:^(WK_KLineVolumePositionModel * _Nonnull volumePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            kLineAccessory.positionModel = volumePositionModel;
            kLineAccessory.kLineModel = self.needDrawKLineModels[idx];
            kLineAccessory.lineColor = self.kLineColors[idx];
            [kLineAccessory draw];
        }];
        
        WK_MALine *MALine = [[WK_MALine alloc]initWithContext:context];
        
        //画DIF线
        MALine.MAType = WK_MA7Type;
        MALine.MAPositions = self.AccessorWK_DIFPositions;
        [MALine draw];
        
        //画DEA线
        MALine.MAType = WK_MA30Type;
        MALine.MAPositions = self.AccessorWK_DEAPositions;
        [MALine draw];
    } else {
        /**
         KDJ
         */
        WK_MALine *MALine = [[WK_MALine alloc]initWithContext:context];
        
        //画KDJ_K线
        MALine.MAType = WK_MA7Type;
        MALine.MAPositions = self.AccessorWK_KDJ_KPositions;
        [MALine draw];
        
        //画KDJ_D线
        MALine.MAType = WK_MA30Type;
        MALine.MAPositions = self.AccessorWK_KDJ_DPositions;
        [MALine draw];
        
        //画KDJ_J线
        MALine.MAType = -1;
        MALine.MAPositions = self.AccessorWK_KDJ_JPositions;
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
    self.needDrawKLineAccessoryPositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
#pragma mark 根据KLineModel转换成Position数组
- (NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    CGFloat minY = WK_StockChartKLineAccessoryViewMinY;
    CGFloat maxY = WK_StockChartKLineAccessoryViewMaxY;
    
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = CGFLOAT_MIN;
    
    NSMutableArray *volumePositionModels = @[].mutableCopy;
    
    if(self.targetLineStatus != WK_StockChartTargetLineStatusKDJ)
    {
        [kLineModels enumerateObjectsUsingBlock:^(WK_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.DIF)
            {
                if(model.DIF.floatValue < minValue) {
                    minValue = model.DIF.floatValue;
                }
                if(model.DIF.floatValue > maxValue) {
                    maxValue = model.DIF.floatValue;
                }
            }
            
            if(model.DEA)
            {
                if (minValue > model.DEA.floatValue) {
                    minValue = model.DEA.floatValue;
                }
                if (maxValue < model.DEA.floatValue) {
                    maxValue = model.DEA.floatValue;
                }
            }
            if(model.MACD)
            {
                if (minValue > model.MACD.floatValue) {
                    minValue = model.MACD.floatValue;
                }
                if (maxValue < model.MACD.floatValue) {
                    maxValue = model.MACD.floatValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.AccessorWK_DIFPositions removeAllObjects];
        [self.AccessorWK_DEAPositions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(WK_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            WK_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            
            
            CGFloat yPosition = -(model.MACD.floatValue - 0)/unitValue + WK_StockChartKLineAccessoryViewMiddleY;
            
            //            CGFloat yPosition = ABS(minY + (model.MACD.floatValue - minValue)/unitValue);
            
            CGPoint startPoint = CGPointMake(xPosition, yPosition);
            
            CGPoint endPoint = CGPointMake(xPosition,WK_StockChartKLineAccessoryViewMiddleY);
            WK_KLineVolumePositionModel *volumePositionModel = [WK_KLineVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint];
            [volumePositionModels addObject:volumePositionModel];
            
            //MA坐标转换
            CGFloat DIFY = maxY;
            CGFloat DEAY = maxY;
            if(unitValue > 0.0000001)
            {
                if(model.DIF)
                {
                    DIFY = -(model.DIF.floatValue - 0)/unitValue + WK_StockChartKLineAccessoryViewMiddleY;
                    //                    DIFY = maxY - (model.DIF.floatValue - minValue)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(model.DEA)
                {
                    DEAY = -(model.DEA.floatValue - 0)/unitValue + WK_StockChartKLineAccessoryViewMiddleY;
                    //                    DEAY = maxY - (model.DEA.floatValue - minValue)/unitValue;
                    
                }
            }
            
            NSAssert(!isnan(DIFY) && !isnan(DEAY), @"出现NAN值");
            
            CGPoint DIFPoint = CGPointMake(xPosition, DIFY);
            CGPoint DEAPoint = CGPointMake(xPosition, DEAY);
            
            if(model.DIF)
            {
                [self.AccessorWK_DIFPositions addObject: [NSValue valueWithCGPoint: DIFPoint]];
            }
            if(model.DEA)
            {
                [self.AccessorWK_DEAPositions addObject: [NSValue valueWithCGPoint: DEAPoint]];
            }
        }];
    } else {
        [kLineModels enumerateObjectsUsingBlock:^(WK_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.KDJ_K)
            {
                if (minValue > model.KDJ_K.floatValue) {
                    minValue = model.KDJ_K.floatValue;
                }
                if (maxValue < model.KDJ_K.floatValue) {
                    maxValue = model.KDJ_K.floatValue;
                }
            }
            
            if(model.KDJ_D)
            {
                if (minValue > model.KDJ_D.floatValue) {
                    minValue = model.KDJ_D.floatValue;
                }
                if (maxValue < model.KDJ_D.floatValue) {
                    maxValue = model.KDJ_D.floatValue;
                }
            }
            if(model.KDJ_J)
            {
                if (minValue > model.KDJ_J.floatValue) {
                    minValue = model.KDJ_J.floatValue;
                }
                if (maxValue < model.KDJ_J.floatValue) {
                    maxValue = model.KDJ_J.floatValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.AccessorWK_KDJ_KPositions removeAllObjects];
        [self.AccessorWK_KDJ_DPositions removeAllObjects];
        [self.AccessorWK_KDJ_JPositions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(WK_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            WK_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            //MA坐标转换
            CGFloat KDJ_K_Y = maxY;
            CGFloat KDJ_D_Y = maxY;
            CGFloat KDJ_J_Y = maxY;
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_K)
                {
                    KDJ_K_Y = maxY - (model.KDJ_K.floatValue - minValue)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_D)
                {
                    KDJ_D_Y = maxY - (model.KDJ_D.floatValue - minValue)/unitValue;
                }
            }
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_J)
                {
                    KDJ_J_Y = maxY - (model.KDJ_J.floatValue - minValue)/unitValue;
                }
            }
            
            NSAssert(!isnan(KDJ_K_Y) && !isnan(KDJ_D_Y) && !isnan(KDJ_J_Y), @"出现NAN值");
            
            CGPoint KDJ_KPoint = CGPointMake(xPosition, KDJ_K_Y);
            CGPoint KDJ_DPoint = CGPointMake(xPosition, KDJ_D_Y);
            CGPoint KDJ_JPoint = CGPointMake(xPosition, KDJ_J_Y);
            
            
            if(model.KDJ_K)
            {
                [self.AccessorWK_KDJ_KPositions addObject: [NSValue valueWithCGPoint: KDJ_KPoint]];
            }
            if(model.KDJ_D)
            {
                [self.AccessorWK_KDJ_DPositions addObject: [NSValue valueWithCGPoint: KDJ_DPoint]];
            }
            if(model.KDJ_J)
            {
                [self.AccessorWK_KDJ_JPositions addObject: [NSValue valueWithCGPoint: KDJ_JPoint]];
            }
        }];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineAccessoryViewCurrentMaxValue:minValue:)])
    {
        [self.delegate kLineAccessoryViewCurrentMaxValue:maxValue minValue:minValue];
    }
    return volumePositionModels;
}
@end
