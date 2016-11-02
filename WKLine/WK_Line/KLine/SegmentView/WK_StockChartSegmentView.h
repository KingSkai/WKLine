//
//  WK_StockChartSegmentView.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WK_StockChartSegmentView;

@protocol WK_StockChartSegmentViewDelegate <NSObject>

- (void)WK_StockChartSegmentView:(WK_StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index;

@end


@interface WK_StockChartSegmentView : UIView

- (instancetype)initWithItems:(NSArray *)items;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id <WK_StockChartSegmentViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger selectedIndex;

@end
