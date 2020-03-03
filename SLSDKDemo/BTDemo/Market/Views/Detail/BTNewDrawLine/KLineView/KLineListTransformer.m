//
//  KLineListTransformer.m
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "KLineListTransformer.h"

NSString *const kCandlerstickChartsContext = @"kCandlerstickChartsContext";
NSString *const kCandlerstickChartsDate    = @"kCandlerstickChartsDate";
NSString *const kCandlerstickChartsMaxHigh = @"kCandlerstickChartsMaxHigh";
NSString *const kCandlerstickChartsMinLow  = @"kCandlerstickChartsMinLow";
NSString *const kCandlerstickChartsMaxVol  = @"kCandlerstickChartsMaxVol";
NSString *const kCandlerstickChartsMinVol  = @"kCandlerstickChartsMinVol";
NSString *const kCandlerstickChartsRSI     = @"kCandlerstickChartsRSI";

@interface KLineListTransformer ()

@property (nonatomic, copy) NSString *kdj_k;
@property (nonatomic, copy) NSString *kdj_d;
@property (nonatomic, copy) NSString *ema_y12;
@property (nonatomic, copy) NSString *ema_y19;
@property (nonatomic, copy) NSString *ema_y26;
@property (nonatomic, copy) NSString *SAR_B;
@property (nonatomic, assign) BOOL lasttrend;
@end


@implementation KLineListTransformer{
    NSInteger _kCount;
    CGFloat   _EMA12;
    CGFloat   _EMA26;
    CGFloat   _DEA;
}


+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (id)managerTransformData:(NSArray*)data {
    _kCount = 150;
    self.kdj_k = @"50";
    self.kdj_d = @"50";
    self.SAR_B = BT_ZERO;
    self.lasttrend = false;
    
    // data = (NSMutableArray *)[[data reverseObjectEnumerator] allObjects];
    
    NSMutableArray *context = [NSMutableArray new];
    NSMutableArray *dates = [NSMutableArray new];
    float maxHigh = 0.0, minLow = 0.0, maxVol = 0.0, minVol = 0.0;
    for (int i = 0; i < (int)(data.count); i ++) { // 有崩的可能
        BTItemModel *dic = data[i] ;
        if (i == 10) {
            self.ema_y12 = dic.close;
        }
        if (i == 17) {
            self.ema_y19 = dic.close;
        }
        if (i == 24) {
            self.ema_y26 = dic.close;
        }
        NSString *currentTime = [BTFormat timeOnlyDateStr:[NSString stringWithFormat:@"%@",dic.timestamp]];
        NSString *time = [BTFormat timeOnlyDateStr:[NSString stringWithFormat:@"%@",dic.timestamp]];
        currentTime = [BTFormat timeOnlyHourAndSec:[NSString stringWithFormat:@"%@",dic.timestamp]];
        // 数据赋值并且计算
        NSArray *arr = @[currentTime,dic.open,dic.high,dic.low,dic.close,dic.last_qty?dic.last_qty: BT_ZERO];
        NSString *MA5 = BT_ZERO; NSString * MA10 = BT_ZERO; NSString * MA20 = BT_ZERO; NSString * MA25 = BT_ZERO;
        if (i >= 5) {
            MA5 = [self chartMAWithData:data inRange:NSMakeRange(i-5, 5)];
        }
        if (i >= 10) {
            MA10 = [self chartMAWithData:data inRange:NSMakeRange(i-10, 10)];
        }
        if (i >= 20) {
            MA20 = [self chartMAWithData:data inRange:NSMakeRange(i-20, 20)];
        }
        
        if (i >= 50 ) {
             MA25 = [self chartMAWithData:data inRange:NSMakeRange(i-50, 50)];
        }
        
//        avg = [self chartAvgWithData:data index:i];
        
        CGFloat RSI6 = [self chartRSIWithData:data inRange:NSMakeRange(i, 7)];
        CGFloat RSI12 = [self chartRSIWithData:data inRange:NSMakeRange(i, 13)];
        CGFloat RSI24 = [self chartRSIWithData:data inRange:NSMakeRange(i, 25)];
        NSArray *kdjArr = @[@"0",@"0",@"0"];
        if (i>=9) {
          kdjArr = [self chartKDJWithData:data inRange:NSMakeRange(i-9, 9)];
        }
        
        NSArray *macdArr = [self chartMACDWithData:data inRange:NSMakeRange(i, 1)];
        NSString * wr= @"0";
        if (i >= 14) {
            wr = [self chartWRWithData:data inRange:NSMakeRange(i-14, 14)];
        }
        NSString *mtm6 = @"0";
        if (i >= 6) {
            mtm6 = [self chartMTM6WithData:data inRange:NSMakeRange(i-6, 6)];
        }
        NSString *mtm12 = @"0";
        if (i>=12) {
            mtm12 = [self chartMTM6WithData:data inRange:NSMakeRange(i-12, 12)];
        }
        NSString *cci7 = BT_ZERO;
        if (i >= 7) {
            cci7 = [self chartCCIWithData:data inRange:NSMakeRange(i-7, 7)];
        }
        NSString *cci14 = BT_ZERO;
        if (i >= 14) {
            cci14 = [self chartCCIWithData:data inRange:NSMakeRange(i-14, 14)];
        }
        NSString *cci21 = BT_ZERO;
        if (i >= 21) {
            cci21 = [self chartCCIWithData:data inRange:NSMakeRange(i-21, 21)];
        }
        NSArray *cciArr = @[cci7,cci14,cci21];
        
        NSString *ema12 = BT_ZERO;
        if (i >= 12) {
            ema12 = [self chartEMA12WithData:data inRange:NSMakeRange(i-12, 12)];
        }
        NSString *ema19 = BT_ZERO;
        if (i >= 19) {
            ema19 = [self chartEMA19WithData:data inRange:NSMakeRange(i-19, 19)];
        }
        NSString *ema26= BT_ZERO;
        if (i >= 26) {
            ema26 = [self chartEMA26WithData:data inRange:NSMakeRange(i-26, 26)];
        }
        NSArray *emaArr = @[ema12,ema19,ema26];
        
        NSArray *bollArr = @[BT_ZERO,BT_ZERO,BT_ZERO];
        if (i >= 10) {
            bollArr = [self chartBOLLWithMA:MA10 WithData:data inRange:NSMakeRange(i-10, 10)];
        }
        NSString *sar = BT_ZERO;
        if (i >= 2 && i< data.count - 2) {
            sar = [self chartSARWithData:data step:@"0.02" maxStep:@"0.2" inRange:NSMakeRange(i-2, 3)];
        }
        
        /***************************************************/
        NSMutableArray *item = [[NSMutableArray alloc] initWithCapacity:30];
        item[0] = @([arr[1] doubleValue]);
        item[1] = @([arr[2] doubleValue]);
        item[2] = @([arr[3] doubleValue]);
        item[3] = @([arr[4] doubleValue]);
        item[4] = @([arr[5] doubleValue]);
        item[5] = MA5;
        item[6] = MA10;
        item[7] = MA20;
        item[8] = @(RSI6);
        item[9] = @(RSI12);
        item[10] = @(RSI24);
        item[11] = kdjArr;
        
        if (i <data.count-1) {
            BTItemModel *model = data[i+1];
            item[12] =  model.close;
        }else{
            item[12] =  @(0);
        }
        item[13] = macdArr;
        item[14] = time;
        item[15] = [NSString stringWithFormat:@"%.2f",[dic.change_rate doubleValue] * 100];
        item[16] = currentTime;
        item[17] = dic.last_px;
        item[18] = dic.avg_px;
        item[19] = @(0);
        item[20] = wr;
        item[21] = mtm6;
        item[22] = mtm12;
        item[23] = cciArr;
        item[24] = emaArr;
        item[25] = bollArr;
        item[26] = sar;
        
        if (maxHigh < [item[1] doubleValue]) {
            maxHigh = [item[1] doubleValue];
        }
        
        if (minLow > [item[2] doubleValue] || i == (data.count - 1)) {
            minLow = [item[2] doubleValue];
        }
        
        if (maxVol < [item[4] doubleValue]) {
            maxVol = [item[4] doubleValue];
        }
        
        if (minVol > [item[4] doubleValue] || i == (data.count - 1)) {
            minVol = [item[4] doubleValue];
        }
        [context addObject:item];
        [dates addObject:[arr[0] componentsSeparatedByString:@" "][0]];
    }
    return @{kCandlerstickChartsDate:dates,
             kCandlerstickChartsContext:context,
             kCandlerstickChartsMaxHigh:@(maxHigh),
             kCandlerstickChartsMinLow:@(minLow),
             kCandlerstickChartsMaxVol:@(maxVol),
             kCandlerstickChartsMinVol:@(minVol)
             };
}

- (NSMutableArray*)chartMACDWithData:(NSArray *)data inRange:(NSRange)range {
    NSMutableArray *arr = [[NSMutableArray alloc]init];;
    
    if (data.count - range.location > range.length) {
        CGFloat DIF = 0;
        CGFloat MACD = 0;

        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        BTItemModel *range_zero = rangeData[0];
        if (range.location == data.count-2) {
            _EMA12 = [range_zero.close doubleValue];
            _EMA26 = [range_zero.close doubleValue];
            _DEA = 0;
        } else {
            CGFloat close = [range_zero.close doubleValue];
            _EMA12 = _EMA12*11/13+close*2/13;
            _EMA26 = _EMA26*25/27+close*2/27;
             DIF = _EMA12-_EMA26;
            _DEA = _DEA*8/10+DIF*2/10;
             MACD = 2*(DIF-_DEA);
        }
        
        [arr addObject:@(DIF)];
        [arr addObject:@(_DEA)];
        [arr addObject:@(MACD)];
    } else {
        [arr addObject:@(0)];
        [arr addObject:@(0)];
        [arr addObject:@(0)];
    }
    return arr;
}

/*
 KDJ 值计算  取9日为周期
 C:  为第9日的收盘价
 L9: 为9日内的最低价
 H9: 为9日内的最高价
 RSV =（C－L9）÷（H9－L9）×100
 K值 = 2/3×第8日K值+1/3×第9日RSV
 D值 = 2/3×第8日D值+1/3×第9日K值
 J值 = 3*第9日K值-2*第9日D值
 若无前一日K值与D值，则可以分别用50代替
 */
- (NSMutableArray*)chartKDJWithData:(NSArray *)data inRange:(NSRange)range {
    NSString *k = @"0";
    NSString * d = @"0";
    NSString * j = @"0";
    NSMutableArray *kdjArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *highArr = [[NSMutableArray alloc]init];
    NSMutableArray *lowArr = [[NSMutableArray alloc]init];
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        for (BTItemModel  *item in rangeData) {
            [highArr addObject:item.high];
            [lowArr addObject:item.low];
        }
        NSString *maxClose = [NSString stringWithFormat:@"%@",[highArr valueForKeyPath:@"@max.floatValue"]];
        NSString *minClose = [NSString stringWithFormat:@"%@",[lowArr valueForKeyPath:@"@min.floatValue"]];
        BTItemModel *rang_zore = rangeData[8];
        NSString * RSV = [[[rang_zore.close bigSub:minClose] bigMul:@"100"] bigDiv:[maxClose bigSub:minClose]];
        k = [[[self.kdj_k bigDiv:@"3"] bigMul:@"2"] bigAdd:[RSV bigDiv:@"3.0"]];
        d = [[[self.kdj_d bigDiv:@"3"] bigMul:@"2"] bigAdd:[k bigDiv:@"3.0"]];
        j = [[@"3" bigMul:k] bigSub:[@"2"bigMul:d]];
        _kdj_d = d;
        _kdj_k = k;
        [kdjArr addObject:k];
        [kdjArr addObject:d];
        [kdjArr addObject:j];
    }else{
        [kdjArr addObject:@(0.0)];
        [kdjArr addObject:@(0.0)];
        [kdjArr addObject:@(0.0)];
    }
    
    
    return kdjArr;
}

/*
 
RSI值 计算
RSI(N)=A÷(A＋B)×100 
A: N日内收盘价的正数之和
B: N日内收盘价的负数之和乘以(—1)
*/

- (CGFloat)chartRSIWithData:(NSArray *)data inRange:(NSRange)range {
    CGFloat rsi = 0;
    CGFloat total = 0;
    CGFloat positive = 0;
    
    if (data.count - range.location > range.length) {
    NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        NSMutableArray *closePriceArr = [[NSMutableArray alloc]init];
        for (BTItemModel *item in rangeData) {
            
            [closePriceArr addObject:item.close];
        }
        for (int i = 0; i<closePriceArr.count; i++) {
            
            if (i== closePriceArr.count-1) {
                break ;
            }
            CGFloat index = [closePriceArr[i] doubleValue]-[closePriceArr[i+1] doubleValue];
            
            if (index>0) {
                
                positive+=index;
                total+=index;
            }else
            {
                total+=index*-1;
            }
        }
        rsi = [[NSString stringWithFormat:@"%.2f",positive*100/total] doubleValue];
    }else{
        rsi = 0;
    }

    return  rsi;
}

/*
 计算 MA5 MA10  MA20 数据
 周期内的收盘价平均值
*/
- (NSString *)chartMAWithData:(NSArray *)data inRange:(NSRange)range {
    NSString *md = BT_ZERO;
    if (data.count - range.length >= range.location) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        for (BTItemModel *item in rangeData) {
            md = [item.close bigAdd:md];
        }
        md = [md bigDiv:[NSString stringWithFormat:@"%lu",rangeData.count]];
    }
    return md;
}

/*
 计算 EMA12 EMA17 EMA26
 指数移动平均值
 EMAtoday=α * Pricetoday + ( 1 - α ) * EMAyesterday;
 α为平滑指数，一般取作2/(N+1)
 N一般选取12和26天
 */
- (NSString *)chartEMA12WithData:(NSArray *)data inRange:(NSRange)range {
    NSString *k = [@"2"bigDiv:[[NSString stringWithFormat:@"%lu",range.length] bigAdd:@"1"]];
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        BTItemModel *rang_now = rangeData[range.length - 1];
        NSString *EMA = [[k bigMul:rang_now.close] bigAdd:[[@"1" bigSub:k] bigMul:self.ema_y12]];
        self.ema_y12 = EMA;
        return EMA;
    }
    return BT_ZERO;
}

- (NSString *)chartEMA19WithData:(NSArray *)data inRange:(NSRange)range {
    NSString *k = [@"2"bigDiv:[[NSString stringWithFormat:@"%lu",range.length] bigAdd:@"1"]];
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        BTItemModel *rang_now = rangeData[range.length - 1];
        NSString *EMA = [[k bigMul:rang_now.close] bigAdd:[[@"1" bigSub:k] bigMul:self.ema_y19]];
        self.ema_y19 = EMA;
        return EMA;
    }
    return BT_ZERO;
}

- (NSString *)chartEMA26WithData:(NSArray *)data inRange:(NSRange)range {
    NSString *k = [@"2"bigDiv:[[NSString stringWithFormat:@"%lu",range.length] bigAdd:@"1"]];
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        BTItemModel *rang_now = rangeData[range.length - 1];
        NSString *EMA = [[k bigMul:rang_now.close] bigAdd:[[@"1" bigSub:k] bigMul:self.ema_y26]];
        self.ema_y26 = EMA;
        return EMA;
    }
    return BT_ZERO;
}

/*
 WR指标计算
 N 条数据为指标
 WR(N) = 100 * [ HIGH(N)- C ] / [ HIGH(N)-LOW(N) ]
 C：当日收盘价
 HIGH(N)：N日内的最高价
 LOW(n)：N日内的最低价
 */
- (NSString *)chartWRWithData:(NSArray *)data inRange:(NSRange)range {
    NSMutableArray *highArr = [[NSMutableArray alloc]init];
    NSMutableArray *lowArr = [[NSMutableArray alloc]init];
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        for (BTItemModel  *item in rangeData) {
            [highArr addObject:item.high];
            [lowArr addObject:item.low];
        }
        NSString * high = [NSString stringWithFormat:@"%@",[highArr valueForKeyPath:@"@max.floatValue"]];
        NSString *low = [NSString stringWithFormat:@"%@",[lowArr valueForKeyPath:@"@min.floatValue"]];
        BTItemModel *rang_now = rangeData[range.length - 1];
        NSString *wr = [[[high bigSub:rang_now.close] bigDiv:[high bigSub:low]] bigMul:@"100"];
        return wr;
    }
    return @"0";
}

/*
 MTM指标计算
 */
- (NSString *)chartMTM6WithData:(NSArray *)data inRange:(NSRange)range {
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        BTItemModel *rang_now = rangeData[range.length - 1];
        BTItemModel *rang_zero = rangeData[0];
        NSString *mtm = [rang_now.close bigSub:rang_zero.close];
        return mtm;
    }
    return @"0";
}

/*
 * CCI指标计算
 * 计算N日CCI指标
 * CCI(N) = (TP- MA) / MD / 0.015
 * TP = (最高价 + 最低价 + 收盘价) / 3
 * MA = (近N日收盘价之和) / N
 * MD = 近N日（MA - 收盘价）之和 / N
 * 0.015为计算系数
 */
- (NSString *)chartCCIWithData:(NSArray *)data inRange:(NSRange)range {
    NSMutableArray *highArr = [[NSMutableArray alloc]init];
    NSMutableArray *lowArr = [[NSMutableArray alloc]init];
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        NSString *MA = @"0";
        for (BTItemModel  *item in rangeData) {
            [highArr addObject:item.high];
            [lowArr addObject:item.low];
            MA = [MA bigAdd:item.close];
        }
        BTItemModel *rang_now = rangeData[range.length - 1];
        NSString * high = [NSString stringWithFormat:@"%@",[highArr valueForKeyPath:@"@max.floatValue"]];
        NSString *low = [NSString stringWithFormat:@"%@",[lowArr valueForKeyPath:@"@min.floatValue"]];
        NSString *TP = [[[high bigAdd:low] bigAdd:rang_now.close] bigDiv:@"3"];
        MA = [MA bigDiv:[NSString stringWithFormat:@"%lu",(unsigned long)range.length]];
        NSString *MD = @"0";
        for (BTItemModel *item in rangeData) {
            MD = [MD bigAdd:[MA bigSub:item.close]];
        }
        MD = [MD bigDiv:[NSString stringWithFormat:@"%lu",(unsigned long)range.length]];
        NSString *CCI = [[[TP bigSub:MA] bigDiv:MD] bigDiv:@"0.015"];
        return CCI;
    }
    return @"0";
}

/*
 * BOLL 线
 *
 */
- (NSArray *)chartBOLLWithMA:(NSString *)ma WithData:(NSArray *)data inRange:(NSRange)range {
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        NSString *MD = BT_ZERO;
        for (BTItemModel *item in rangeData) {
            NSString *value = [item.close bigSub:ma];
            MD = [MD bigAdd:[value bigMul:value]];
        }
        MD = [MD bigDiv:[NSString stringWithFormat:@"%lu",range.length]];
        MD = [NSString stringWithFormat:@"%f",sqrt(MD.doubleValue)];
        NSString *MB = [self chartMAWithData:rangeData inRange:NSMakeRange(1, rangeData.count - 1)];
        NSString *UP = [MB bigAdd:[@"2" bigMul:MD]];
        NSString *DN = [MB bigSub:[@"2" bigMul:MD]];
        NSArray *bollArr = @[UP,MB,DN];
        return bollArr;
    }
    return @[BT_ZERO,BT_ZERO,BT_ZERO];
}

/**
 * 获取SAR指标参数值
 *
 * 参数step 0.02
 * 参数max 0.2
 *
 */
- (NSString *)chartSARWithData:(NSArray *)data step:(NSString *)setp maxStep:(NSString *)maxStep inRange:(NSRange)range {
    //记录是否初始化过
    NSString *INIT_VALUE = @"-100";
    //加速因子
    NSString *af = BT_ZERO;
    //极值
    NSString *ep = INIT_VALUE;
    NSString *priorSAR = self.SAR_B;
    if (data.count - range.location > range.length) {
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        BTItemModel *model = rangeData[range.length - 2];
        BTItemModel *model_pri = rangeData[range.length - 3];
        BTItemModel *model_next = rangeData[range.length - 1];
        if (self.lasttrend) {
            if ([ep isEqualToString:INIT_VALUE] || [ep LessThan:model.high]) {
                ep = model.high;
                if ([[af bigAdd:setp] LessThan:maxStep]) {
                    af = [af bigAdd:setp];
                } else {
                    af = maxStep;
                }
            }
            self.SAR_B = [priorSAR bigAdd:[af bigMul:[ep bigSub:priorSAR]]];
            NSString *lowestPrior2Lows = model.low;
            if ([model.low GreaterThan:model_pri.low]) {
                lowestPrior2Lows = model_pri.low;
            }
            if ([self.SAR_B GreaterThan:model_next.low]) {
                self.SAR_B = ep;
                af = BT_ZERO;
                ep = INIT_VALUE;
                self.lasttrend = !self.lasttrend;
            } else if ([self.SAR_B GreaterThan:lowestPrior2Lows]) {
                self.SAR_B = lowestPrior2Lows;
            }
        } else {
            if ([ep isEqualToString:INIT_VALUE] || [ep GreaterThan:model.low]) {
                ep = model.low;
                if ([[af bigAdd:setp] LessThan:maxStep]) {
                    af = [af bigAdd:setp];
                } else {
                    af = maxStep;
                }
            }
            self.SAR_B = [priorSAR bigAdd:[af bigMul:[ep bigSub:priorSAR]]];
            NSString *lowestPrior2High = model.high;
            if ([model.high GreaterThan:model_pri.high]) {
                lowestPrior2High = model_pri.high;
            }
            if ([self.SAR_B GreaterThan:model_next.high]) {
                self.SAR_B = ep;
                af = BT_ZERO;
                ep = INIT_VALUE;
                self.lasttrend = !self.lasttrend;
            } else if ([self.SAR_B GreaterThan:lowestPrior2High]) {
                self.SAR_B = lowestPrior2High;
            }
        }
        return self.SAR_B;
    }
    return BT_ZERO;
}

/*
 计算 均线
 */
- (CGFloat)chartAvgWithData:(NSArray *)data index:(NSInteger)index {
    NSString *avg = @"0";
    if (data.count <= 0) {
        return 0;
    }
    if (index < data.count - 1) {
        for (int i = 0; i <= index; i++) {
            BTItemModel *item = data[i];
            avg = [item.avg_px  bigAdd:avg];
        }
        avg = [avg bigDiv:[NSString stringWithFormat:@"%ld",index + 1]];
    }
    return [avg toString:8].doubleValue;
}

@end
