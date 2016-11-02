//
//  WK_KLineGroupModel.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <math.h>
@class WK_KLineModel;

@interface WK_KLineGroupModel : NSObject


@property (nonatomic, copy) NSArray<WK_KLineModel *> *models;

//初始化Model
+ (instancetype) objectWithArray:(NSArray *)arr;
@end

//初始化第一个Model
//第一个 EMA(12) 是前n1个c相加和后除以n1,第一个 EMA(26) 是前n2个c相加和后除以n2
