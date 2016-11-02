//
//  WK_KLineView.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineView.h"
#import "WK_KLineMainView.h"
#import "WK_KLineMAView.h"
#import "WK_VolumeMAView.h"
#import "WK_AccessoryMAView.h"
#import "Masonry.h"
#import "UIColor+WK_StockChart.h"

#import "WK_StockChartGlobalVariable.h"
#import "WK_KLineVolumeView.h"
#import "WK_StockChartRightYView.h"
#import "WK_KLineAccessoryView.h"
@interface WK_KLineView() <UIScrollViewDelegate, WK_KLineMainViewDelegate, WK_KLineVolumeViewDelegate, WK_KLineAccessoryViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  主K线图
 */
@property (nonatomic, strong) WK_KLineMainView *kLineMainView;

/**
 *  成交量图
 */
@property (nonatomic, strong) WK_KLineVolumeView *kLineVolumeView;

/**
 *  副图
 */
@property (nonatomic, strong) WK_KLineAccessoryView *kLineAccessoryView;

/**
 *  右侧价格图
 */
@property (nonatomic, strong) WK_StockChartRightYView *priceView;

/**
 *  右侧成交量图
 */
@property (nonatomic, strong) WK_StockChartRightYView *volumeView;

/**
 *  右侧Accessory图
 */
@property (nonatomic, strong) WK_StockChartRightYView *accessoryView;

/**
 *  旧的scrollview准确位移
 */
@property (nonatomic, assign) CGFloat oldExactOffset;

/**
 *  kLine-MAView
 */
@property (nonatomic, strong) WK_KLineMAView *kLineMAView;

/**
 *  Volume-MAView
 */
@property (nonatomic, strong) WK_VolumeMAView *volumeMAView;

/**
 *  Accessory-MAView
 */
@property (nonatomic, strong) WK_AccessoryMAView *accessoryMAView;

/**
 *  长按后显示的View
 */
@property (nonatomic, strong) UIView *verticalView;


@property (nonatomic, strong) MASConstraint *kLineMainViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *kLineVolumeViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *priceViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *volumeViewHeightConstraint;

@end

@implementation WK_KLineView

//initWithFrame设置视图比例
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.mainViewRatio = [WK_StockChartGlobalVariable kLineMainViewRadio];
        self.volumeViewRatio = [WK_StockChartGlobalVariable kLineVolumeViewRadio];
    }
    return self;
}

- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        //        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pichMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self).offset(-48);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self layoutIfNeeded];
    }
    return _scrollView;
}

- (WK_KLineMAView *)kLineMAView
{
    if (!_kLineMAView) {
        _kLineMAView = [WK_KLineMAView view];
        [self addSubview:_kLineMAView];
        [_kLineMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self).offset(5);
            make.height.equalTo(@10);
        }];
    }
    return _kLineMAView;
}

- (WK_VolumeMAView *)volumeMAView
{
    if (!_volumeMAView) {
        _volumeMAView = [WK_VolumeMAView view];
        [self addSubview:_volumeMAView];
        [_volumeMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self.kLineVolumeView.mas_top);
            make.height.equalTo(@10);
        }];
    }
    return _volumeMAView;
}

- (WK_AccessoryMAView *)accessoryMAView
{
    if(!_accessoryMAView) {
        _accessoryMAView = [WK_AccessoryMAView new];
        [self addSubview:_accessoryMAView];
        [_accessoryMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self.kLineAccessoryView.mas_top);
            make.height.equalTo(@10);
        }];
    }
    return _accessoryMAView;
}

- (WK_KLineMainView *)kLineMainView
{
    if (!_kLineMainView && self) {
        _kLineMainView = [WK_KLineMainView new];
        _kLineMainView.delegate = self;
        [self.scrollView addSubview:_kLineMainView];
        [_kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(5);
            make.left.equalTo(self.scrollView);
            self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy(self.mainViewRatio);
            make.width.equalTo(@0);
        }];
        
    }
    //加载rightYYView
    self.priceView.backgroundColor = [UIColor clearColor];
    self.volumeView.backgroundColor = [UIColor clearColor];
    self.accessoryView.backgroundColor = [UIColor clearColor];
    return _kLineMainView;
}

- (WK_KLineVolumeView *)kLineVolumeView
{
    if(!_kLineVolumeView && self)
    {
        _kLineVolumeView = [WK_KLineVolumeView new];
        _kLineVolumeView.delegate = self;
        [self.scrollView addSubview:_kLineVolumeView];
        [_kLineVolumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineMainView);
            make.top.equalTo(self.kLineMainView.mas_bottom).offset(10);
            make.width.equalTo(self.kLineMainView.mas_width);
            self.kLineVolumeViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.volumeViewRatio);
        }];
        [self layoutIfNeeded];
    }
    return _kLineVolumeView;
}

- (WK_KLineAccessoryView *)kLineAccessoryView
{
    if(!_kLineAccessoryView && self)
    {
        _kLineAccessoryView = [WK_KLineAccessoryView new];
        _kLineAccessoryView.delegate = self;
        [self.scrollView addSubview:_kLineAccessoryView];
        [_kLineAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineVolumeView);
            make.top.equalTo(self.kLineVolumeView.mas_bottom).offset(10);
            make.width.equalTo(self.kLineVolumeView.mas_width);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy(0.2);
        }];
        [self layoutIfNeeded];
    }
    return _kLineAccessoryView;
}

- (WK_StockChartRightYView *)priceView
{
    if(!_priceView)
    {
        _priceView = [WK_StockChartRightYView new];
        [self insertSubview:_priceView aboveSubview:self.scrollView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(WK_StockChartKLinePriceViewWidth));
            make.bottom.equalTo(self.kLineMainView.mas_bottom).offset(-15);
        }];
    }
    return _priceView;
}

- (WK_StockChartRightYView *)volumeView
{
    if(!_volumeView)
    {
        _volumeView = [WK_StockChartRightYView new];
        [self insertSubview:_volumeView aboveSubview:self.scrollView];
        [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineVolumeView.mas_top).offset(10);
            make.right.width.equalTo(self.priceView);
            //            make.height.equalTo(self).multipliedBy(self.volumeViewRatio);
            make.bottom.equalTo(self.kLineVolumeView);
        }];
    }
    return _volumeView;
}

- (WK_StockChartRightYView *)accessoryView
{
    if(!_accessoryView)
    {
        _accessoryView = [WK_StockChartRightYView new];
        [self insertSubview:_accessoryView aboveSubview:self.scrollView];
        [_accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineAccessoryView.mas_top).offset(10);
            make.right.width.equalTo(self.volumeView);
            make.height.equalTo(self.kLineAccessoryView.mas_height);
        }];
    }
    return _accessoryView;
}
#pragma mark - set方法

#pragma mark kLineModels设置方法
- (void)setKLineModels:(NSArray *)kLineModels
{
    if(!kLineModels) {
        return;
    }
    _kLineModels = kLineModels;
    [self private_drawKLineMainView];
    //设置contentOffset
    CGFloat kLineViewWidth = self.kLineModels.count * [WK_StockChartGlobalVariable kLineWidth] + (self.kLineModels.count + 1) * [WK_StockChartGlobalVariable kLineGap] + 10;
    CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
    if (offset > 0)
    {
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    WK_KLineModel *model = [kLineModels lastObject];
    [self.kLineMAView maProfileWithModel:model];
    [self.volumeMAView maProfileWithModel:model];
    self.accessoryMAView.targetLineStatus = self.targetLineStatus;
    [self.accessoryMAView maProfileWithModel:model];
}
- (void)setTargetLineStatus:(WK_StockChartTargetLineStatus)targetLineStatus
{
    _targetLineStatus = targetLineStatus;
    if(targetLineStatus < 103)
    {
        if(targetLineStatus == WK_StockChartTargetLineStatusAccessoryClose){
            
            [WK_StockChartGlobalVariable setkLineMainViewRadio:0.65];
            [WK_StockChartGlobalVariable setkLineVolumeViewRadio:0.28];
            
        } else {
            [WK_StockChartGlobalVariable setkLineMainViewRadio:0.5];
            [WK_StockChartGlobalVariable setkLineVolumeViewRadio:0.2];
            
        }
        
        [self.kLineMainViewHeightConstraint uninstall];
        [_kLineMainView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy([WK_StockChartGlobalVariable kLineMainViewRadio]);
        }];
        [self.kLineVolumeViewHeightConstraint uninstall];
        [self.kLineVolumeView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.kLineVolumeViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy([WK_StockChartGlobalVariable kLineVolumeViewRadio]);
        }];
        [self reDraw];
    }
    
}
#pragma mark - event事件处理方法
#pragma mark 缩放执行方法
- (void)event_pichMethod:(UIPinchGestureRecognizer *)pinch
{
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if(ABS(difValue) > WK_StockChartScaleBound) {
        CGFloat oldKLineWidth = [WK_StockChartGlobalVariable kLineWidth];
        
        NSInteger oldNeedDrawStartIndex = self.kLineMainView.needDrawStartIndex;
        NSLog(@"原来的index%ld",self.kLineMainView.needDrawStartIndex);
        [WK_StockChartGlobalVariable setkLineWith:oldKLineWidth * (difValue > 0 ? (1 + WK_StockChartScaleFactor) : (1 - WK_StockChartScaleFactor))];
        oldScale = pinch.scale;
        //更新MainView的宽度
        [self.kLineMainView updateMainViewWidth];
        
        if( pinch.numberOfTouches == 2 ) {
            CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
            CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
            CGPoint centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
            NSUInteger oldLeftArrCount = ABS((centerPoint.x - self.scrollView.contentOffset.x) - [WK_StockChartGlobalVariable kLineGap]) / ([WK_StockChartGlobalVariable kLineGap] + oldKLineWidth);
            NSUInteger newLeftArrCount = ABS((centerPoint.x - self.scrollView.contentOffset.x) - [WK_StockChartGlobalVariable kLineGap]) / ([WK_StockChartGlobalVariable kLineGap] + [WK_StockChartGlobalVariable kLineWidth]);
            
            self.kLineMainView.pinchStartIndex = oldNeedDrawStartIndex + oldLeftArrCount - newLeftArrCount;
            //            self.kLineMainView.pinchPoint = centerPoint;
            NSLog(@"计算得出的index%lu",self.kLineMainView.pinchStartIndex);
        }
        [self.kLineMainView drawMainView];
    }
}
#pragma mark 长按手势执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress
{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self.scrollView];
        if(ABS(oldPositionX - location.x) < ([WK_StockChartGlobalVariable kLineWidth] + [WK_StockChartGlobalVariable kLineGap])/2)
        {
            return;
        }
        
        //暂停滑动
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        
        //初始化竖线
        if(!self.verticalView)
        {
            self.verticalView = [UIView new];
            self.verticalView.clipsToBounds = YES;
            [self.scrollView addSubview:self.verticalView];
            self.verticalView.backgroundColor = [UIColor longPressLineColor];
            [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(15);
                make.width.equalTo(@(WK_StockChartLongPressVerticalViewWidth));
                make.height.equalTo(self.scrollView.mas_height);
                make.left.equalTo(@(-10));
            }];
        }
        
        //更新竖线位置
        CGFloat rightXPosition = [self.kLineMainView getExactXPositionWithOriginXPosition:location.x];
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(rightXPosition));
        }];
        [self.verticalView layoutIfNeeded];
        self.verticalView.hidden = NO;
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        //取消竖线
        if(self.verticalView)
        {
            self.verticalView.hidden = YES;
        }
        oldPositionX = 0;
        //恢复scrollView的滑动
        self.scrollView.scrollEnabled = YES;
        
        WK_KLineModel *lastModel = self.kLineModels.lastObject;
        [self.kLineMAView maProfileWithModel:lastModel];
        [self.volumeMAView maProfileWithModel:lastModel];
        [self.accessoryMAView maProfileWithModel:lastModel];
    }
}

#pragma mark 重绘
- (void)reDraw
{
    self.kLineMainView.MainViewType = self.MainViewType;
    if(self.targetLineStatus >= 103)
    {
        self.kLineMainView.targetLineStatus = self.targetLineStatus;
    }
    [self.kLineMainView drawMainView];
}


#pragma mark - 私有方法
#pragma mark 画KLineMainView
- (void)private_drawKLineMainView
{
    self.kLineMainView.kLineModels = self.kLineModels;
    [self.kLineMainView drawMainView];
}
- (void)private_drawKLineVolumeView
{
    NSAssert(self.kLineVolumeView, @"kLineVolume不存在");
    //更新约束
    [self.kLineVolumeView layoutIfNeeded];
    [self.kLineVolumeView draw];
}
- (void)private_drawKLineAccessoryView
{
    //更新约束
    self.accessoryMAView.targetLineStatus = self.targetLineStatus;
    [self.accessoryMAView maProfileWithModel:_kLineModels.lastObject];
    [self.kLineAccessoryView layoutIfNeeded];
    [self.kLineAccessoryView draw];
}
#pragma mark VolumeView代理
- (void)kLineVolumeViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume
{
    self.volumeView.maxValue = maxVolume;
    self.volumeView.minValue = minVolume;
    self.volumeView.middleValue = (maxVolume - minVolume)/2 + minVolume;
}
- (void)kLineMainViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice
{
    self.priceView.maxValue = maxPrice;
    self.priceView.minValue = minPrice;
    self.priceView.middleValue = (maxPrice - minPrice)/2 + minPrice;
}
- (void)kLineAccessoryViewCurrentMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue
{
    self.accessoryView.maxValue = maxValue;
    self.accessoryView.minValue = minValue;
    self.accessoryView.middleValue = (maxValue - minValue)/2 + minValue;
}
#pragma mark MainView更新时通知下方的view进行相应内容更新
- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels
{
    self.kLineVolumeView.needDrawKLineModels = needDrawKLineModels;
    self.kLineAccessoryView.needDrawKLineModels = needDrawKLineModels;
}
- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels
{
    self.kLineVolumeView.needDrawKLinePositionModels = needDrawKLinePositionModels;
    self.kLineAccessoryView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}
- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors
{
    self.kLineVolumeView.kLineColors = kLineColors;
    if(self.targetLineStatus >= 103)
    {
        self.kLineVolumeView.targetLineStatus = self.targetLineStatus;
    }
    [self private_drawKLineVolumeView];
    self.kLineAccessoryView.kLineColors = kLineColors;
    if(self.targetLineStatus < 103)
    {
        self.kLineAccessoryView.targetLineStatus = self.targetLineStatus;
    }
    [self private_drawKLineAccessoryView];
}
- (void)kLineMainViewLongPressKLinePositionModel:(WK_KLinePositionModel *)kLinePositionModel kLineModel:(WK_KLineModel *)kLineModel
{
    //更新ma信息
    [self.kLineMAView maProfileWithModel:kLineModel];
    [self.volumeMAView maProfileWithModel:kLineModel];
    [self.accessoryMAView maProfileWithModel:kLineModel];
}
#pragma mark - UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    static BOOL isNeedPostNotification = YES;
    //    if(scrollView.contentOffset.x < scrollView.frame.size.width * 2)
    //    {
    //        if(isNeedPostNotification)
    //        {
    //            self.oldExactOffset = scrollView.contentSize.width - scrollView.contentOffset.x;
    //            isNeedPostNotification = NO;
    //        }
    //    } else {
    //        isNeedPostNotification = YES;
    //    }
    
    NSLog(@"这是  %f-----%f=====%f",scrollView.contentSize.width,scrollView.contentOffset.x,self.kLineMainView.frame.size.width);
}

- (void)dealloc
{
    [_kLineMainView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

