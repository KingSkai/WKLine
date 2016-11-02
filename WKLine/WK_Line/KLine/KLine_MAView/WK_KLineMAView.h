//
//  WK_KLineMAView.h
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WK_KLineModel;
@interface WK_KLineMAView : UIView

+(instancetype)view;

-(void)maProfileWithModel:(WK_KLineModel *)model;
@end

