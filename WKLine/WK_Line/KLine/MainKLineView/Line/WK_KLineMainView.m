


//
//  WK_KLineMainView.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineMainView.h"
#import "UIColor+WK_StockChart.h"

#import "WK_KLine.h"
#import "WK_MALine.h"
#import "WK_KLinePositionModel.h"
#import "WK_StockChartGlobalVariable.h"
#import "Masonry.h"
@interface WK_KLineMainView()

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <WK_KLineModel *> *needDrawKLineModels;

/**
 *  需要绘制的model位置数组
 */
@property (nonatomic, strong) NSMutableArray *needDrawKLinePositionModels;


/**
 *  Index开始X的值
 */
@property (nonatomic, assign) NSInteger startXPosition;

/**
 *  旧的contentoffset值
 */
@property (nonatomic, assign) CGFloat oldContentOffsetX;

/**
 *  旧的缩放值
 */
@property (nonatomic, assign) CGFloat oldScale;

/**
 *  MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA7Positions;


/**
 *  MA30位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA30Positions;

@end

@implementation WK_KLineMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.needDrawKLineModels = @[].mutableCopy;
        self.needDrawKLinePositionModels = @[].mutableCopy;
        self.MA7Positions = @[].mutableCopy;
        self.MA30Positions = @[].mutableCopy;
        _needDrawStartIndex = 0;
        self.oldContentOffsetX = 0;
        self.oldScale = 0;
    }
    return self;
}

#pragma mark - 绘图相关方法

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //如果数组为空，则不进行绘制，直接设置本view为背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(!self.kLineModels)
    {
        CGContextClearRect(context, rect);
        CGContextSetFillColorWithColor(context, [UIColor backgroundColor].CGColor);
        CGContextFillRect(context, rect);
        return;
    }
    
    //设置View的背景颜色
    NSMutableArray *kLineColors = @[].mutableCopy;
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor backgroundColor].CGColor);
    CGContextFillRect(context, rect);
    
    //设置显示日期的区域背景颜色
    CGContextSetFillColorWithColor(context, [UIColor assistBackgroundColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, WK_StockChartKLineMainViewMaxY, self.frame.size.width, self.frame.size.height - WK_StockChartKLineMainViewMaxY));
    
    
    
    
    
    WK_MALine *MALine = [[WK_MALine alloc]initWithContext:context];
    
    if(self.MainViewType == WK_StockChartcenterViewTypeKline)
    {
        WK_KLine *kLine = [[WK_KLine alloc]initWithContext:context];
        kLine.maxY = WK_StockChartKLineMainViewMaxY;
        
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(WK_KLinePositionModel * _Nonnull kLinePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            kLine.kLinePositionModel = kLinePositionModel;
            kLine.kLineModel = self.needDrawKLineModels[idx];
            UIColor *kLineColor = [kLine draw];
            [kLineColors addObject:kLineColor];
        }];
    } else {
        NSMutableArray *positions = @[].mutableCopy;
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(WK_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            UIColor *strokeColor = positionModel.OpenPoint.y < positionModel.ClosePoint.y ? [UIColor increaseColor] : [UIColor decreaseColor];
            [kLineColors addObject:strokeColor];
            [positions addObject:[NSValue valueWithCGPoint:positionModel.ClosePoint]];
        }];
        MALine.MAPositions = positions;
        MALine.MAType = -1;
        [MALine draw];
        //
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(WK_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGPoint point = [positions[idx] CGPointValue];
            
            //日期
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.needDrawKLineModels[idx].Date.doubleValue/1000];
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"HH:mm";
            NSString *dateStr = [formatter stringFromDate:date];
            
            CGPoint drawDatePoint = CGPointMake(point.x + 1, WK_StockChartKLineMainViewMaxY + 1.5);
            CGPoint lastDrawDatePoint;
            if(CGPointEqualToPoint(lastDrawDatePoint, CGPointZero) || point.x - lastDrawDatePoint.x > 60 )
            {
                [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
                lastDrawDatePoint = drawDatePoint;
            }
        }];
    }
    
    if(self.targetLineStatus != WK_StockChartTargetLineStatusCloseMA){
        //画MA7线
        MALine.MAType = WK_MA7Type;
        MALine.MAPositions = self.MA7Positions;
        [MALine draw];
        
        //画MA30线
        MALine.MAType = WK_MA30Type;
        MALine.MAPositions = self.MA30Positions;
        [MALine draw];
    }
    
    
    if(self.delegate && kLineColors.count > 0)
    {
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineColors:)])
        {
            [self.delegate kLineMainViewCurrentNeedDrawKLineColors:kLineColors];
        }
    }
}

#pragma mark - 公有方法

#pragma mark 重新设置相关数据，然后重绘
- (void)drawMainView
{
    NSAssert(self.kLineModels, @"kLineModels不能为空");
    
    //提取需要的kLineModel
    [self private_extractNeedDrawModels];
    //转换model为坐标model
    [self private_convertToKLinePositionModelWithKLineModels];
    
    //间接调用drawRect方法
    [self setNeedsDisplay];
}

/**
 *  更新MainView的宽度
 */
- (void)updateMainViewWidth
{
    //根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
    CGFloat kLineViewWidth = self.kLineModels.count * [WK_StockChartGlobalVariable kLineWidth] + (self.kLineModels.count + 1) * [WK_StockChartGlobalVariable kLineGap] + 10;
    
    if(kLineViewWidth < self.parentScrollView.bounds.size.width) {
        kLineViewWidth = self.parentScrollView.bounds.size.width;
    }
    //    if (kLineViewWidth < [UIScreen mainScreen].bounds.size.width) {
    //        kLineViewWidth = [UIScreen mainScreen].bounds.size.width;
    //    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kLineViewWidth));
    }];
    
    [self layoutIfNeeded];
    
    //更新scrollview的contentsize
    self.parentScrollView.contentSize = CGSizeMake(kLineViewWidth, self.parentScrollView.contentSize.height);
    //    CGFloat offset = self.parentScrollView.contentSize.width - self.parentScrollView.bounds.size.width;
    //    if (offset > 0)
    //    {
    //        NSLog(@"计算出来的位移%f",offset);
    //        [self.parentScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    //    } else {
    //        NSLog(@"计算出来的位移%f",offset);
    //        [self.parentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    //    }
}

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (CGFloat)getExactXPositionWithOriginXPosition:(CGFloat)originXPosition
{
    CGFloat xPositoinInMainView = originXPosition;
    NSInteger startIndex = (NSInteger)((xPositoinInMainView - self.startXPosition) / ([WK_StockChartGlobalVariable kLineGap] + [WK_StockChartGlobalVariable kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        WK_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        
        CGFloat minX = kLinePositionModel.HighPoint.x - ([WK_StockChartGlobalVariable kLineGap] + [WK_StockChartGlobalVariable kLineWidth]/2);
        CGFloat maxX = kLinePositionModel.HighPoint.x + ([WK_StockChartGlobalVariable kLineGap] + [WK_StockChartGlobalVariable kLineWidth]/2);
        
        if(xPositoinInMainView > minX && xPositoinInMainView < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPressKLinePositionModel:kLineModel:)])
            {
                [self.delegate kLineMainViewLongPressKLinePositionModel:self.needDrawKLinePositionModels[index] kLineModel:self.needDrawKLineModels[index]];
            }
            return kLinePositionModel.HighPoint.x;
        }
        
    }
    return 0.f;
}

#pragma mark 私有方法
//提取需要绘制的数组
- (NSArray *)private_extractNeedDrawModels
{
    CGFloat lineGap = [WK_StockChartGlobalVariable kLineGap];
    CGFloat lineWidth = [WK_StockChartGlobalVariable kLineWidth];
    
    //数组个数
    CGFloat scrollViewWidth = self.parentScrollView.frame.size.width;
    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex ;
    
    if(self.pinchStartIndex > 0) {
        needDrawKLineStartIndex = self.pinchStartIndex;
        _needDrawStartIndex = self.pinchStartIndex;
        self.pinchStartIndex = -1;
    } else {
        needDrawKLineStartIndex = self.needDrawStartIndex;
    }
    
    
    NSLog(@"这是模型开始的index-----------%lu",needDrawKLineStartIndex);
    [self.needDrawKLineModels removeAllObjects];
    
    //赋值数组
    if(needDrawKLineStartIndex < self.kLineModels.count)
    {
        if(needDrawKLineStartIndex + needDrawKLineCount < self.kLineModels.count)
        {
            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
        } else{
            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
        }
    }
    //响应代理
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineModels:)])
    {
        [self.delegate kLineMainViewCurrentNeedDrawKLineModels:self.needDrawKLineModels];
    }
    return self.needDrawKLineModels;
}

#pragma mark 将model转化为Position模型
- (NSArray *)private_convertToKLinePositionModelWithKLineModels
{
    if(!self.needDrawKLineModels)
    {
        return nil;
    }
    
    NSArray *kLineModels = self.needDrawKLineModels;
    
    //计算最小单位
    WK_KLineModel *firstModel = kLineModels.firstObject;
    __block CGFloat minAssert = firstModel.Low.floatValue;
    __block CGFloat maxAssert = firstModel.High.floatValue;
    //    __block CGFloat minMA7 = CGFLOAT_MAX;
    //    __block CGFloat maxMA7 = CGFLOAT_MIN;
    //    __block CGFloat minMA30 = CGFLOAT_MAX;
    //    __block CGFloat maxMA30 = CGFLOAT_MIN;
    
    [kLineModels enumerateObjectsUsingBlock:^(WK_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if(kLineModel.High.floatValue > maxAssert)
        {
            maxAssert = kLineModel.High.floatValue;
        }
        if(kLineModel.Low.floatValue < minAssert)
        {
            minAssert = kLineModel.Low.floatValue;
        }
        if(kLineModel.MA7)
        {
            if (minAssert > kLineModel.MA7.floatValue) {
                minAssert = kLineModel.MA7.floatValue;
            }
            if (maxAssert < kLineModel.MA7.floatValue) {
                maxAssert = kLineModel.MA7.floatValue;
            }
        }
        if(kLineModel.MA30)
        {
            if (minAssert > kLineModel.MA30.floatValue) {
                minAssert = kLineModel.MA30.floatValue;
            }
            if (maxAssert < kLineModel.MA30.floatValue) {
                maxAssert = kLineModel.MA30.floatValue;
            }
        }
        
    }];
    
    
    
    maxAssert *= 1.0001;
    minAssert *= 0.9991;
    
    
    CGFloat minY = WK_StockChartKLineMainViewMinY;
    CGFloat maxY = self.parentScrollView.frame.size.height * [WK_StockChartGlobalVariable kLineMainViewRadio] - 15;
    
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);
    //    CGFloat ma7UnitValue = (maxMA7 - minMA7) / (maxY - minY);
    //    CGFloat ma30UnitValue = (maxMA30 - minMA30) / (maxY - minY);
    
    
    [self.needDrawKLinePositionModels removeAllObjects];
    [self.MA7Positions removeAllObjects];
    [self.MA30Positions removeAllObjects];
    
    NSInteger kLineModelsCount = kLineModels.count;
    for (NSInteger idx = 0 ; idx < kLineModelsCount; ++idx)
    {
        //K线坐标转换
        WK_KLineModel *kLineModel = kLineModels[idx];
        
        CGFloat xPosition = self.startXPosition + idx * ([WK_StockChartGlobalVariable kLineWidth] + [WK_StockChartGlobalVariable kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.Open.floatValue - minAssert)/unitValue));
        CGFloat closePointY = ABS(maxY - (kLineModel.Close.floatValue - minAssert)/unitValue);
        if(ABS(closePointY - openPoint.y) < WK_StockChartKLineMinWidth)
        {
            if(openPoint.y > closePointY)
            {
                openPoint.y = closePointY + WK_StockChartKLineMinWidth;
            } else if(openPoint.y < closePointY)
            {
                closePointY = openPoint.y + WK_StockChartKLineMinWidth;
            } else {
                if(idx > 0)
                {
                    WK_KLineModel *preKLineModel = kLineModels[idx-1];
                    if(kLineModel.Open.floatValue > preKLineModel.Close.floatValue)
                    {
                        openPoint.y = closePointY + WK_StockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + WK_StockChartKLineMinWidth;
                    }
                } else if(idx+1 < kLineModelsCount){
                    
                    //idx==0即第一个时
                    WK_KLineModel *subKLineModel = kLineModels[idx+1];
                    if(kLineModel.Close.floatValue < subKLineModel.Open.floatValue)
                    {
                        openPoint.y = closePointY + WK_StockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + WK_StockChartKLineMinWidth;
                    }
                }
            }
        }
        
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.High.floatValue - minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.Low.floatValue - minAssert)/unitValue));
        
        WK_KLinePositionModel *kLinePositionModel = [WK_KLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [self.needDrawKLinePositionModels addObject:kLinePositionModel];
        
        
        //MA坐标转换
        CGFloat ma7Y = maxY;
        CGFloat ma30Y = maxY;
        if(unitValue > 0.0000001)
        {
            if(kLineModel.MA7)
            {
                ma7Y = maxY - (kLineModel.MA7.floatValue - minAssert)/unitValue;
            }
            
        }
        if(unitValue > 0.0000001)
        {
            if(kLineModel.MA30)
            {
                ma30Y = maxY - (kLineModel.MA30.floatValue - minAssert)/unitValue;
            }
        }
        
        NSAssert(!isnan(ma7Y) && !isnan(ma30Y), @"出现NAN值");
        
        CGPoint ma7Point = CGPointMake(xPosition, ma7Y);
        CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
        
        if(kLineModel.MA7)
        {
            [self.MA7Positions addObject: [NSValue valueWithCGPoint: ma7Point]];
        }
        if(kLineModel.MA30)
        {
            [self.MA30Positions addObject: [NSValue valueWithCGPoint: ma30Point]];
        }
    }
    
    //响应代理方法
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentMaxPrice:minPrice:)])
        {
            [self.delegate kLineMainViewCurrentMaxPrice:maxAssert minPrice:minAssert];
        }
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLinePositionModels:)])
        {
            [self.delegate kLineMainViewCurrentNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
    return self.needDrawKLinePositionModels;
}

static char *observerContext = NULL;
#pragma mark 添加所有事件监听的方法
- (void)private_addAllEventListener
{
    //KVO监听scrollview的状态变化
    [_parentScrollView addObserver:self forKeyPath:WK_StockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:observerContext];
}
#pragma mark - setter,getter方法
- (NSInteger)startXPosition
{
    NSInteger leftArrCount = self.needDrawStartIndex;
    CGFloat startXPosition = (leftArrCount + 1) * [WK_StockChartGlobalVariable kLineGap] + leftArrCount * [WK_StockChartGlobalVariable kLineWidth] + [WK_StockChartGlobalVariable kLineWidth]/2;
    return startXPosition;
}

- (NSInteger)needDrawStartIndex
{
    CGFloat scrollViewOffsetX = self.parentScrollView.contentOffset.x < 0 ? 0 : self.parentScrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - [WK_StockChartGlobalVariable kLineGap]) / ([WK_StockChartGlobalVariable kLineGap] + [WK_StockChartGlobalVariable kLineWidth]);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

- (void)setKLineModels:(NSArray *)kLineModels
{
    _kLineModels = kLineModels;
    [self updateMainViewWidth];
}

#pragma mark - 系统方法
#pragma mark 已经添加到父view的方法,设置父scrollview
- (void)didMoveToSuperview
{
    _parentScrollView = (UIScrollView *)self.superview;
    [self private_addAllEventListener];
    [super didMoveToSuperview];
}

#pragma mark KVO监听实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:WK_StockChartContentOffsetKey])
    {
        CGFloat difValue = ABS(self.parentScrollView.contentOffset.x - self.oldContentOffsetX);
        if(difValue >= [WK_StockChartGlobalVariable kLineGap] + [WK_StockChartGlobalVariable kLineWidth])
        {
            self.oldContentOffsetX = self.parentScrollView.contentOffset.x;
            [self drawMainView];
        }
        
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 移除所有监听
- (void)removeAllObserver
{
    [_parentScrollView removeObserver:self forKeyPath:WK_StockChartContentOffsetKey context:observerContext];
}
@end

