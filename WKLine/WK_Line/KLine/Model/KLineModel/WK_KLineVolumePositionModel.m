//
//  WK_KLineVolumePositionModel.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineVolumePositionModel.h"

@implementation WK_KLineVolumePositionModel

+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    WK_KLineVolumePositionModel *volumePositionModel = [WK_KLineVolumePositionModel new];
    volumePositionModel.StartPoint = startPoint;
    volumePositionModel.EndPoint = endPoint;
    return volumePositionModel;
}

@end
