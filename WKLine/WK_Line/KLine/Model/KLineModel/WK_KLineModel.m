
//
//  WK_KLineModel.m
//  WKLine
//
//  Created by 王凯 on 2016/11/2.
//  Copyright © 2016年 王凯. All rights reserved.
//

#import "WK_KLineModel.h"
#import "WK_KLineGroupModel.h"
#import "WK_StockChartGlobalVariable.h"

@implementation WK_KLineModel

- (NSNumber *)RSV_9
{
    if (!_RSV_9) {
        if(self.NineClocksMinPrice == self.NineClocksMaxPrice) {
            _RSV_9 = @100;
        } else {
            _RSV_9 = @((self.Close.floatValue - self.NineClocksMinPrice.floatValue) * 100 / (self.NineClocksMaxPrice.floatValue - self.NineClocksMinPrice.floatValue));
        }
    }
    return _RSV_9;
}
- (NSNumber *)KDJ_K
{
    if (!_KDJ_K) {
        _KDJ_K = @((self.RSV_9.floatValue + 2 * (self.PreviousKlineModel.KDJ_K ? self.PreviousKlineModel.KDJ_K.floatValue : 50) )/3);
    }
    return _KDJ_K;
}

- (NSNumber *)KDJ_D
{
    if(!_KDJ_D) {
        _KDJ_D = @((self.KDJ_K.floatValue + 2 * (self.PreviousKlineModel.KDJ_D ? self.PreviousKlineModel.KDJ_D.floatValue : 50))/3);
    }
    return _KDJ_D;
}
- (NSNumber *)KDJ_J
{
    if(!_KDJ_J) {
        _KDJ_J = @(3*self.KDJ_K.floatValue - 2*self.KDJ_D.floatValue);
    }
    return _KDJ_J;
}

- (NSNumber *)MA7
{
    if([WK_StockChartGlobalVariable isEMALine] == WK_StockChartTargetLineStatusMA)
    {
        if (!_MA7) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 6) {
                if (index > 6) {
                    _MA7 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 7].SumOfLastClose.floatValue) / 7);
                } else {
                    _MA7 = @(self.SumOfLastClose.floatValue / 7);
                }
            }
        }
    } else {
        return self.EMA7;
    }
    return _MA7;
}

- (NSNumber *)Volume_MA7
{
    if([WK_StockChartGlobalVariable isEMALine] == WK_StockChartTargetLineStatusMA)
    {
        if (!_Volume_MA7) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 6) {
                if (index > 6) {
                    _Volume_MA7 = @((self.SumOfLastVolume.floatValue - self.ParentGroupModel.models[index - 7].SumOfLastVolume.floatValue) / 7);
                } else {
                    _Volume_MA7 = @(self.SumOfLastVolume.floatValue / 7);
                }
            }
        }
    } else {
        return self.Volume_EMA7;
    }
    return _Volume_MA7;
}
- (NSNumber *)Volume_EMA7
{
    if(!_Volume_EMA7) {
        _Volume_EMA7 = @((self.Volume + 3 * self.PreviousKlineModel.Volume_EMA7.floatValue)/4);
    }
    return _Volume_EMA7;
}
//// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
- (NSNumber *)EMA7
{
    if(!_EMA7) {
        _EMA7 = @((self.Close.floatValue + 3 * self.PreviousKlineModel.EMA7.floatValue)/4);
    }
    return _EMA7;
}

- (NSNumber *)EMA30
{
    if(!_EMA30) {
        _EMA30 = @((2 * self.Close.floatValue + 29 * self.PreviousKlineModel.EMA30.floatValue)/31);
    }
    return _EMA30;
}

- (NSNumber *)EMA12
{
    if(!_EMA12) {
        _EMA12 = @((2 * self.Close.floatValue + 11 * self.PreviousKlineModel.EMA12.floatValue)/13);
    }
    return _EMA12;
}

- (NSNumber *)EMA26
{
    if (!_EMA26) {
        _EMA26 = @((2 * self.Close.floatValue + 25 * self.PreviousKlineModel.EMA26.floatValue)/27);
    }
    return _EMA26;
}

- (NSNumber *)MA30
{
    if([WK_StockChartGlobalVariable isEMALine] == WK_StockChartTargetLineStatusMA)
    {
        if (!_MA30) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 29) {
                if (index > 29) {
                    _MA30 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 30].SumOfLastClose.floatValue) / 30);
                } else {
                    _MA30 = @(self.SumOfLastClose.floatValue / 30);
                }
            }
        }
    } else {
        return self.EMA30;
    }
    return _MA30;
}

- (NSNumber *)Volume_MA30
{
    if([WK_StockChartGlobalVariable isEMALine] == WK_StockChartTargetLineStatusMA)
    {
        if (!_Volume_MA30) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 29) {
                if (index > 29) {
                    _Volume_MA30 = @((self.SumOfLastVolume.floatValue - self.ParentGroupModel.models[index - 30].SumOfLastVolume.floatValue) / 30);
                } else {
                    _Volume_MA30 = @(self.SumOfLastVolume.floatValue / 30);
                }
            }
        }
    } else {
        return self.Volume_EMA30;
    }
    return _Volume_MA30;
}

- (NSNumber *)Volume_EMA30
{
    if(!_Volume_EMA30) {
        _Volume_EMA30 = @((2 * self.Volume + 29 * self.PreviousKlineModel.Volume_EMA30.floatValue)/31);
    }
    return _Volume_EMA30;
}
- (NSNumber *)MA12
{
    if (!_MA12) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 11) {
            if (index > 11) {
                _MA12 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 12].SumOfLastClose.floatValue) / 12);
            } else {
                _MA12 = @(self.SumOfLastClose.floatValue / 12);
            }
        }
    }
    return _MA12;
}

- (NSNumber *)MA26
{
    if (!_MA26) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 25) {
            if (index > 25) {
                _MA26 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 26].SumOfLastClose.floatValue) / 26);
            } else {
                _MA26 = @(self.SumOfLastClose.floatValue / 26);
            }
        }
    }
    return _MA26;
}

- (NSNumber *)SumOfLastClose
{
    if(!_SumOfLastClose) {
        _SumOfLastClose = @(self.PreviousKlineModel.SumOfLastClose.floatValue + self.Close.floatValue);
    }
    return _SumOfLastClose;
}

- (NSNumber *)SumOfLastVolume
{
    if(!_SumOfLastVolume) {
        _SumOfLastVolume = @(self.PreviousKlineModel.SumOfLastVolume.floatValue + self.Volume);
    }
    return _SumOfLastVolume;
}

- (NSNumber *)NineClocksMinPrice
{
    if (!_NineClocksMinPrice) {
        //        if([self.ParentGroupModel.models indexOfObject:self] >= 8)
        //        {
        [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedDescending];
        //        } else {
        //            _NineClocksMinPrice = @0;
        //        }
    }
    return _NineClocksMinPrice;
}

- (NSNumber *)NineClocksMaxPrice {
    if (!_NineClocksMaxPrice) {
        if([self.ParentGroupModel.models indexOfObject:self] >= 8)
        {
            [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
        } else {
            _NineClocksMaxPrice = @0;
        }
    }
    return _NineClocksMaxPrice;
}


////DIF=EMA（12）-EMA（26）         DIF的值即为红绿柱；
//
////今日的DEA值=前一日DEA*8/10+今日DIF*2/10.

- (NSNumber *)DIF
{
    if(!_DIF) {
        _DIF = @(self.EMA12.floatValue - self.EMA26.floatValue);
    }
    return _DIF;
}

//已验证
-(NSNumber *)DEA
{
    if(!_DEA) {
        _DEA = @(self.PreviousKlineModel.DEA.floatValue * 0.8 + 0.2*self.DIF.floatValue);
    }
    return _DEA;
}

//已验证
- (NSNumber *)MACD
{
    if(!_MACD) {
        _MACD = @(2*(self.DIF.floatValue - self.DEA.floatValue));
    }
    return _MACD;
}

- (WK_KLineModel *)PreviousKlineModel
{
    if (!_PreviousKlineModel) {
        _PreviousKlineModel = [WK_KLineModel new];
        _PreviousKlineModel.DIF = @(0);
        _PreviousKlineModel.DEA = @(0);
        _PreviousKlineModel.MACD = @(0);
        _PreviousKlineModel.MA7 = @(0);
        _PreviousKlineModel.MA12 = @(0);
        _PreviousKlineModel.MA26 = @(0);
        _PreviousKlineModel.MA30 = @(0);
        _PreviousKlineModel.EMA7 = @(0);
        _PreviousKlineModel.EMA12 = @(0);
        _PreviousKlineModel.EMA26 = @(0);
        _PreviousKlineModel.EMA30 = @(0);
        _PreviousKlineModel.Volume_MA7 = @(0);
        _PreviousKlineModel.Volume_MA30 = @(0);
        _PreviousKlineModel.Volume_EMA7 = @(0);
        _PreviousKlineModel.Volume_EMA30 = @(0);
        _PreviousKlineModel.SumOfLastClose = @(0);
        _PreviousKlineModel.SumOfLastVolume = @(0);
        _PreviousKlineModel.KDJ_K = @(50);
        _PreviousKlineModel.KDJ_D = @(50);
        
        
    }
    return _PreviousKlineModel;
}
- (WK_KLineGroupModel *)ParentGroupModel
{
    if(!_ParentGroupModel) {
        _ParentGroupModel = [WK_KLineGroupModel new];
    }
    return _ParentGroupModel;
}
//对Model数组进行排序，初始化每个Model的最新9Clock的最低价和最高价
- (void)rangeLastNinePriceByArray:(NSArray<WK_KLineModel *> *)models condition:(NSComparisonResult)cond
{
    switch (cond) {
            //最高价
        case NSOrderedAscending:
        {
            //            第一个循环结束后，ClockFirstValue为最小值
            for (NSInteger j = 7; j >= 1; j--)
            {
                NSNumber *emMaxValue = @0;
                
                NSInteger em = j;
                
                while ( em >= 0 )
                {
                    if([emMaxValue compare:models[em].High] == cond)
                    {
                        emMaxValue = models[em].High;
                    }
                    em--;
                }
                NSLog(@"%f",emMaxValue.floatValue);
                models[j].NineClocksMaxPrice = emMaxValue;
            }
            //第一个循环结束后，ClockFirstValue为最小值
            for (NSInteger i = 0, j = 8; j < models.count; i++,j++)
            {
                NSNumber *emMaxValue = @0;
                
                NSInteger em = j;
                
                while ( em >= i )
                {
                    if([emMaxValue compare:models[em].High] == cond)
                    {
                        emMaxValue = models[em].High;
                    }
                    em--;
                }
                NSLog(@"%f",emMaxValue.floatValue);
                
                models[j].NineClocksMaxPrice = emMaxValue;
            }
        }
            break;
        case NSOrderedDescending:
        {
            //第一个循环结束后，ClockFirstValue为最小值
            
            for (NSInteger j = 7; j >= 1; j--)
            {
                NSNumber *emMinValue = @(10000000000);
                
                NSInteger em = j;
                
                while ( em >= 0 )
                {
                    if([emMinValue compare:models[em].Low] == cond)
                    {
                        emMinValue = models[em].Low;
                    }
                    em--;
                }
                models[j].NineClocksMinPrice = emMinValue;
            }
            
            for (NSInteger i = 0, j = 8; j < models.count; i++,j++)
            {
                NSNumber *emMinValue = @(10000000000);
                
                NSInteger em = j;
                
                while ( em >= i )
                {
                    if([emMinValue compare:models[em].Low] == cond)
                    {
                        emMinValue = models[em].Low;
                    }
                    em--;
                }
                models[j].NineClocksMinPrice = emMinValue;
            }
        }
            break;
        default:
            break;
    }
}

- (void) initWithArray:(NSArray *)arr;
{
    NSAssert(arr.count == 6, @"数组长度不足");
    
    if (self)
    {
        _Date = arr[0];
        _Open = @([arr[1] floatValue]);
        _High = @([arr[2] floatValue]);
        _Low = @([arr[3] floatValue]);
        _Close = @([arr[4] floatValue]);
        
        _Volume = [arr[5] floatValue];
        self.SumOfLastClose = @(_Close.floatValue + self.PreviousKlineModel.SumOfLastClose.floatValue);
        self.SumOfLastVolume = @(_Volume + self.PreviousKlineModel.SumOfLastVolume.floatValue);
        //        NSLog(@"%@======%@======%@------%@",_Close,self.MA7,self.MA30,_SumOfLastClose);
        
    }
}

- (void)initFirstModel
{
    //    _SumOfLastClose = _Close;
    //    _SumOfLastVolume = @(_Volume);
    _KDJ_K = @(55.27);
    _KDJ_D = @(55.27);
    _KDJ_J = @(55.27);
    //    _MA7 = _Close;
    //    _MA12 = _Close;
    //    _MA26 = _Close;
    //    _MA30 = _Close;
    _EMA7 = _Close;
    _EMA12 = _Close;
    _EMA26 = _Close;
    _EMA30 = _Close;
    _NineClocksMinPrice = _Low;
    _NineClocksMaxPrice = _High;
    [self DIF];
    [self DEA];
    [self MACD];
    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedDescending];
    [self RSV_9];
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
}

- (void)initData {
    [self MA7];
    [self MA12];
    [self MA26];
    [self MA30];
    [self EMA7];
    [self EMA12];
    [self EMA26];
    [self EMA30];
    
    [self DIF];
    [self DEA];
    [self MACD];
    [self NineClocksMaxPrice];
    [self NineClocksMinPrice];
    [self RSV_9];
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
    
}


@end
