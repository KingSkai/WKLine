//
//  WK_KLineGroupModel.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineGroupModel.h"

#import "WK_KLineGroupModel.h"
#import "WK_KLineModel.h"
@implementation WK_KLineGroupModel
+ (instancetype) objectWithArray:(NSArray *)arr {
    
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组");
    
    WK_KLineGroupModel *groupModel = [WK_KLineGroupModel new];
    NSMutableArray *mutableArr = @[].mutableCopy;
    __block WK_KLineModel *preModel = [[WK_KLineModel alloc]init];
    
    //设置数据
    for (NSArray *valueArr in arr)
    {
        WK_KLineModel *model = [WK_KLineModel new];
        model.PreviousKlineModel = preModel;
        [model initWithArray:valueArr];
        model.ParentGroupModel = groupModel;
        
        [mutableArr addObject:model];
        
        preModel = model;
    }
    
    groupModel.models = mutableArr;
    
    //初始化第一个Model的数据
    WK_KLineModel *firstModel = mutableArr[0];
    [firstModel initFirstModel];
    
    //初始化其他Model的数据
    [mutableArr enumerateObjectsUsingBlock:^(WK_KLineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model initData];
    }];
    
    return groupModel;
}
@end

