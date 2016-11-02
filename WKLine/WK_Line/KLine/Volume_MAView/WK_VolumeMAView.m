//
//  WK_VolumeMAView.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_VolumeMAView.h"
#import "Masonry.h"
#import "UIColor+WK_StockChart.h"
#import "WK_KLineModel.h"
@interface WK_VolumeMAView ()
@property (strong, nonatomic) UILabel *VolumeMA7Label;

@property (strong, nonatomic) UILabel *VolumeMA30Label;

@property (strong, nonatomic) UILabel *volumeDescLabel;

@end
@implementation WK_VolumeMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _VolumeMA7Label = [self private_createLabel];
        _VolumeMA30Label = [self private_createLabel];
        _volumeDescLabel = [self private_createLabel];
        
        
        
        _VolumeMA7Label.textColor = [UIColor ma7Color];
        _VolumeMA30Label.textColor = [UIColor ma30Color];
        
        [_volumeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        [_VolumeMA7Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_volumeDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        [_VolumeMA30Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_VolumeMA7Label.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

+(instancetype)view
{
    WK_VolumeMAView *MAView = [[WK_VolumeMAView alloc]init];
    
    return MAView;
}
-(void)maProfileWithModel:(WK_KLineModel *)model
{
    
    
    _volumeDescLabel.text = [NSString stringWithFormat:@" 成交量(7,30):%.4f ",model.Volume];
    
    _VolumeMA7Label.text = [NSString stringWithFormat:@"  MA7：%.8f ",model.Volume_MA7.floatValue];
    _VolumeMA30Label.text = [NSString stringWithFormat:@"  MA30：%.8f",model.Volume_MA30.floatValue];
}
- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor assistTextColor];
    [self addSubview:label];
    return label;
}

@end

