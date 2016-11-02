//
//  WK_MALine.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WK_KLineModel.h"
typedef NS_ENUM(NSInteger, WK_MAType){
    WK_MA7Type = 0,
    WK_MA30Type,
};

/**
 *  画均线的线
 */
@interface WK_MALine : NSObject

@property (nonatomic, strong) NSArray *MAPositions;

@property (nonatomic, assign) WK_MAType MAType;
/**
 *  k线的model
 */
@property (nonatomic, strong) WK_KLineModel *kLineModel;

/**
 *  最大的Y
 */
@property (nonatomic, assign) CGFloat maxY;

/**
 *  根据context初始化均线画笔
 */
- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;

@end

