//
//  WK_StockChartView.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WK_StockChartConstant.h"

//种类
typedef NS_ENUM(NSInteger, WK_KLineType) {
    KLineTypeTimeShare = 1,
    KLineType1Min,
    KLineType3MIn,
    KLineType5Min,
    KLineType10Min,
    KLineType15Min,
    KLineType30Min,
    KLineType1Hour,
    KLineType2Hour,
    KLineType4Hour,
    KLineType6Hour,
    KLineType12Hour,
    KLineType1Day,
    KLineType3Day,
    KLineType1Week
};

/**
 *  WK_StockChartView代理
 */

@protocol WK_StockChartViewDelegate <NSObject>


@end

/**
 *  WK_StockChartView数据源
 */
@protocol WK_StockChartViewDataSource <NSObject>

-(id) stockDatasWithIndex:(NSInteger)index;

@end


@interface WK_StockChartView : UIView

@property (nonatomic, strong) NSArray *itemModels;

/**
 *  数据源
 */
@property (nonatomic, weak) id<WK_StockChartViewDataSource> dataSource;

/**
 *  当前选中的索引
 */
@property (nonatomic, assign,readonly) WK_KLineType currentLineTypeIndex;


-(void) reloadData;

@end

/************************ItemModel类************************/
@interface WK_StockChartViewItemModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) WK_StockChartCenterViewType centerViewType;

+ (instancetype)itemModelWithTitle:(NSString *)title type:(WK_StockChartCenterViewType)type;

@end
