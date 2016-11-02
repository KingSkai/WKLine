//
//  WK_StockChartRightYView.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WK_StockChartRightYView : UIView
@property(nonatomic,assign) CGFloat maxValue;

@property(nonatomic,assign) CGFloat middleValue;

@property(nonatomic,assign) CGFloat minValue;

@property(nonatomic,copy) NSString *minLabelText;


@end

