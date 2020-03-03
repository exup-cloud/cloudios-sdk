//
//  SLKLineChartView.m
//  BTTest
//
//  Created by WWLy on 2019/9/11.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLKLineChartView.h"
#import "SLMarketDetailChartSegment.h"
#import "KLineChartView.h"
#import "KLineListTransformer.h"

#define SL_TIMELINE_DICT         @"SL_TIME_LINEDICT"
#define SL_ONEMINLINE_DICT       @"SL_ONEMINLINE_DICT"
#define SL_FIVELINE_DICT         @"SL_FIVE_LINEDICT"
#define SL_FIFTEENLINE_DICT      @"SL_FIFTEENLINE_DICT"
#define SL_THRITYLINE_DICT       @"SL_THRITY_LINEDICT"
#define SL_HOURLINE_DICT         @"SL_HOUR_LINEDICT"
#define SL_DAYLINE_DICT          @"SL_DAY_LINEDICT"
#define SL_WEEKLINE_DICT         @"SL_WEEK_LINEDICT"

#define SL_TWOHOURLINE_DICT      @"SL_TWOHOURLINE_DICT"
#define SL_FOURHOURLINE_DICT     @"SL_FOURHOURLINE_DICT"
#define SL_SIXHOURLINE_DICT      @"SL_SIXHOURLINE_DICT"
#define SL_TWELVEHOURLINE_DICT   @"SL_TWELVEHOURLINE_DICT"

@interface SLKLineChartView () <SLMarketDetailChartSegmentDelegate, KLineChartViewdelegate, YKLineChartViewDelegate>

@property (nonatomic, strong) SLMarketDetailChartSegment * chartSegment;
@property (nonatomic, strong) KLineChartView * kLineChartView;
@property (nonatomic, strong) KLineListTransformer *lineListTransformer;

@property (nonatomic, strong) UIView *loadView;

@property (nonatomic, strong) BTHorScreenView *horScreenView;

@property (nonatomic, assign) NSInteger tlineType;
@property (nonatomic, assign) NSInteger blineType;

@property (nonatomic, strong) NSMutableDictionary *lineDataDict;

@property (nonatomic, assign) SLStockLineDataType currentDataType;

@end

@implementation SLKLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.loadView.hidden = NO;
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    
    self.chartSegment = [[SLMarketDetailChartSegment alloc] initWithFrame:CGRectMake(0, 0, self.sl_width, 40)];
    self.chartSegment.delegate = self;
    [self addSubview:self.chartSegment];
    
    self.currentDataType = SLStockLineDataTypeFiveMinutes;
}

- (void)initKineView {
    if (!_kLineChartView) {
        _kLineChartView = [[KLineChartView alloc] initWithFrame:CGRectMake(0, self.chartSegment.sl_maxY, self.sl_width, self.sl_height - self.chartSegment.sl_maxY - 20)];
    }
    _kLineChartView.backgroundColor = MAIN_COLOR;
    _kLineChartView.axisShadowColor = DARK_BARKGROUND_COLOR;
    _kLineChartView.xAxisTitleColor = GARY_BG_TEXT_COLOR;
    _kLineChartView.topMargin = 20.0f;
    _kLineChartView.leftMargin = 0;
    _kLineChartView.rightMargin = 0;
    _kLineChartView.bottomMargin = self.sl_height * 0.22;
    _kLineChartView.kLinePadding = 1;
    _kLineChartView.kLineWidth = SL_SCREEN_WIDTH / 72 - 1;
    _kLineChartView.supportGesture = YES;
    _kLineChartView.scrollEnable = YES;
    _kLineChartView.zoomEnable = YES;
    _kLineChartView.delegate = self;
    _kLineChartView.proxy = self;
    NSInteger decimal = [NSString getPrice_unitWithContractID:self.itemModel.instrument_id];
    NSString *temp = [NSString stringWithFormat:@"%ld", decimal];
    int length = (int)(temp.length - 1);
    _kLineChartView.saveDecimalPlaces = length;
    [self addSubview:_kLineChartView];
}


#pragma mark - Public

- (void)changeDataType:(SLStockLineDataType)dataType {
    self.currentDataType = dataType;
    [self.chartSegment changeSelectedDataType:dataType];
}

#pragma mark 更新绘制线条数据

/// 更新分时数据
- (BOOL)updataTimeLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeTimely) {
        NSMutableDictionary *dict = self.lineDataDict[SL_TIMELINE_DICT];
        if (change || (nil == dict && data.count > 0)) {// 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if (nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_TIMELINE_DICT];
            }
        }
        if (nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新一分钟K线
- (BOOL)updataOneKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeOneMinute) {
        NSMutableDictionary *dict = self.lineDataDict[SL_ONEMINLINE_DICT];
        if (change || (nil == dict && data.count >0)) {// 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_ONEMINLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新五分钟数据
- (BOOL)updataFiveKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeFiveMinutes) {
        NSMutableDictionary *dict = self.lineDataDict[SL_FIVELINE_DICT];
        if (change || (nil == dict && data.count >0)) {// 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_FIVELINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新15分钟K线
- (BOOL)updataFifteenKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeFifteenMinutes) {
        NSMutableDictionary *dict = self.lineDataDict[SL_FIFTEENLINE_DICT];
        if (change || (nil == dict && data.count >0)) { // 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_FIFTEENLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新三十分钟数据
- (BOOL)updataThirtyKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeThirtyMinutes) {
        NSMutableDictionary *dict = self.lineDataDict[SL_THRITYLINE_DICT];
        if (change || (nil == dict && data.count >0)) {// 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_THRITYLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新六十分钟数据
- (BOOL)updataHourKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeOneHour) {
        NSMutableDictionary *dict = self.lineDataDict[SL_HOURLINE_DICT];
        if (change || (nil == dict && data.count >0)) {// 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_HOURLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新两个小时
- (BOOL)updataTwoHourKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeTwoHours) {
        NSMutableDictionary *dict = self.lineDataDict[SL_TWOHOURLINE_DICT];
        if (change || (nil == dict && data.count > 0)) { // 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_TWOHOURLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新4时K线
- (BOOL)updataFourHourKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeFourHours) {
        NSMutableDictionary *dict = self.lineDataDict[SL_FOURHOURLINE_DICT];
        if (change || (nil == dict && data.count > 0)) { // 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_FOURHOURLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新6时K线
- (BOOL)updataSixHourKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeSixHours) {
        NSMutableDictionary *dict = self.lineDataDict[SL_SIXHOURLINE_DICT];
        if (change || (nil == dict && data.count > 0)) { // 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_SIXHOURLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新12时K线
- (BOOL)updataTwelveHourKLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeTwelveHours) {
        NSMutableDictionary *dict = self.lineDataDict[SL_TWELVEHOURLINE_DICT];
        if (change || (nil == dict && data.count > 0)) { // 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_TWELVEHOURLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新日K数据
- (BOOL)updataKDayLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeOneDay) {
        NSMutableDictionary *dict = self.lineDataDict[SL_DAYLINE_DICT];
        if (change || (nil == dict && data.count >0)) {// 数据改变 或者 dict 为空
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_DAYLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}
/// 更新周K数据
- (BOOL)updataKWeekLine:(NSArray *)data hasChange:(BOOL)change {
    if (self.currentDataType == SLStockLineDataTypeOneWeek) {
        NSMutableDictionary *dict = self.lineDataDict[SL_WEEKLINE_DICT];
        if (change || (nil == dict && data.count >0)) { // 数据改变 或者 dict 为空
            // NSMutableArray *arr = [self getNewDataArr:data.mutableCopy num:0];
            dict = [[KLineListTransformer sharedInstance] managerTransformData:data];
            if ( nil != dict) {
                [self.lineDataDict setObject:dict forKey:SL_WEEKLINE_DICT];
            }
        }
        if ( nil != dict) {
            [self p_addDataWithKLineDataDict:dict];
            [self p_updataScreenDataWithData:dict];
            return YES;
        }
    }
    return NO;
}


/// 添加数据
- (void)p_addDataWithKLineDataDict:(NSDictionary *)lineDataDict {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.currentDataType == SLStockLineDataTypeTimely) {// 分时数据
            [self.kLineChartView removeFromSuperview];
            self.kLineChartView = nil;
            [self initKineView];
            self.kLineChartView.isTimeLine = YES;
            [self.kLineChartView drawChartWithData:lineDataDict];
        } else {
            [self.kLineChartView removeFromSuperview];
            self.kLineChartView = nil;
            [self initKineView];
            self.kLineChartView.isTimeLine = NO;
            [self.kLineChartView drawChartWithData:lineDataDict];
        }
        [self setMainkLineTypeWithType];    // 默认主绘制区MA
        [self setbottomLineTypeWithType];   // 默认副绘制区KDJ
        self.loadView.hidden = YES;
        self.kLineChartView.hidden = NO;
    });
}

- (void)p_updataScreenDataWithData:(NSDictionary *)dict {
    if (self.hasShowScreen) {// 显示全屏
        [self.horScreenView showHorScreenViewKLineDataDict:dict];
    }
}


#pragma mark - <SLMarketDetailChartSegmentDelegate>

- (void)chartSegment_segmentDidClick:(SLSegmentButton *)segmentButton {
    SLStockLineDataType dataType = segmentButton.dataType;
    
    if (self.currentDataType == dataType) {
        return;
    }
    
    self.currentDataType = dataType;

    if ([self.delegate respondsToSelector:@selector(lineChartView_didClickSegmentWithKLineDataType:)]) {
        self.loadView.hidden = NO;
        self.kLineChartView.hidden = YES;
        [self.delegate lineChartView_didClickSegmentWithKLineDataType:self.currentDataType];
    }
}

/// 显示全屏数据
- (void)chartSegment_fullScreenClick {
    self.horScreenView = [[BTHorScreenView alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_HEIGHT, SL_SCREEN_WIDTH) seletedDataType:self.currentDataType];
    self.horScreenView.delegate = self.delegate;
    NSInteger decimal = [NSString getPrice_unitWithContractID:self.itemModel.instrument_id];
    NSString *temp = [NSString stringWithFormat:@"%ld",decimal];
    int length = (int)(temp.length - 1);
    self.horScreenView.decimals = length;
    [[UIApplication sharedApplication].delegate.window addSubview:self.horScreenView];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (self.currentDataType) {
        case SLStockLineDataTypeTimely:
            dict = self.lineDataDict[SL_TIMELINE_DICT];
            break;
        case SLStockLineDataTypeOneMinute:
            dict = self.lineDataDict[SL_ONEMINLINE_DICT];
            break;
        case SLStockLineDataTypeFiveMinutes:
            dict = self.lineDataDict[SL_FIVELINE_DICT];
            break;
        case SLStockLineDataTypeFifteenMinutes:
            dict = self.lineDataDict[SL_FIFTEENLINE_DICT];
            break;
        case SLStockLineDataTypeThirtyMinutes:
            dict = self.lineDataDict[SL_THRITYLINE_DICT];
            break;
        case SLStockLineDataTypeOneHour:
            dict = self.lineDataDict[SL_HOURLINE_DICT];
            break;
        case SLStockLineDataTypeTwoHours:
            dict = self.lineDataDict[SL_TWOHOURLINE_DICT];
            break;
        case SLStockLineDataTypeFourHours:
            dict = self.lineDataDict[SL_FOURHOURLINE_DICT];
            break;
        case SLStockLineDataTypeSixHours:
            dict = self.lineDataDict[SL_SIXHOURLINE_DICT];
            break;
        case SLStockLineDataTypeTwelveHours:
            dict = self.lineDataDict[SL_TWELVEHOURLINE_DICT];
            break;
        case SLStockLineDataTypeOneDay:
            dict = self.lineDataDict[SL_DAYLINE_DICT];
            break;
        case SLStockLineDataTypeOneWeek:
            dict = self.lineDataDict[SL_WEEKLINE_DICT];
            break;
        default:
            break;
    }
    if (dict == nil) {
        [self.horScreenView removeFromSuperview];
        self.horScreenView = nil;
        return;
    }
    [self.horScreenView showHorScreenViewKLineDataDict:dict];
    self.horScreenView.itemModel = self.itemModel;
    
    // 横屏翻转
    self.horScreenView.center = [UIApplication sharedApplication].delegate.window.center;
    [UIView beginAnimations:nil context:nil];
    self.horScreenView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[UIApplication sharedApplication].delegate.window cache:NO];
    [UIView commitAnimations];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.hasShowScreen = YES;
    self.horScreenView.tlineType = self.tlineType;
    self.horScreenView.blineType = self.blineType;
}


#pragma mark - <KLineChartViewdelegate>

- (void)scrollVerticallyWithOffsetY:(CGFloat)offsetY isEnd:(BOOL)isEnd {
    if ([self.delegate respondsToSelector:@selector(lineChartView_scrollVerticallyWithOffsetY:isEnd:)]) {
        [self.delegate lineChartView_scrollVerticallyWithOffsetY:offsetY isEnd:isEnd];
    }
}

- (void)tapToShowkLineType:(NSInteger)lineType {
    if (lineType == 1) {
        if (self.tlineType >= 3) {
            self.tlineType = 0;
        } else {
            self.tlineType ++;
        }
        [self setMainkLineTypeWithType];
    } else if (lineType == 2) {
        if (self.blineType >= 5) {
            self.blineType = 0;
        } else {
            self.blineType ++;
        }
        [self setbottomLineTypeWithType];
    }
}

- (void)setMainkLineTypeWithType {
    switch (self.tlineType) {
        case 0:
            self.kLineChartView.showAvgLine = YES;
            self.kLineChartView.showEMALine = NO;
            self.kLineChartView.showBOLLLine = NO;
            self.kLineChartView.showSARLine = NO;
            break;
        case 1:
            self.kLineChartView.showAvgLine = NO;
            self.kLineChartView.showEMALine = YES;
            self.kLineChartView.showBOLLLine = NO;
            self.kLineChartView.showSARLine = NO;
            break;
        case 2:
            self.kLineChartView.showAvgLine = NO;
            self.kLineChartView.showEMALine = NO;
            self.kLineChartView.showBOLLLine = YES;
            self.kLineChartView.showSARLine = NO;
            break;
        case 3:
            self.kLineChartView.showAvgLine = NO;
            self.kLineChartView.showEMALine = NO;
            self.kLineChartView.showBOLLLine = NO;
            self.kLineChartView.showSARLine = YES;
            break;
        default:
            break;
    }
}

- (void)setbottomLineTypeWithType {
    switch (self.blineType) {
        case 0:
            self.kLineChartView.showKDJChart = YES;
            self.kLineChartView.showMACDChart = NO;
            self.kLineChartView.showRSIChart = NO;
            self.kLineChartView.showWRChart = NO;
            self.kLineChartView.showMTMChart = NO;
            self.kLineChartView.showCCIChart = NO;
            break;
        case 1:
            self.kLineChartView.showKDJChart = NO;
            self.kLineChartView.showMACDChart = YES;
            self.kLineChartView.showRSIChart = NO;
            self.kLineChartView.showWRChart = NO;
            self.kLineChartView.showMTMChart = NO;
            self.kLineChartView.showCCIChart = NO;
            break;
        case 2:
            self.kLineChartView.showKDJChart = NO;
            self.kLineChartView.showMACDChart = NO;
            self.kLineChartView.showRSIChart = YES;
            self.kLineChartView.showWRChart = NO;
            self.kLineChartView.showMTMChart = NO;
            self.kLineChartView.showCCIChart = NO;
            break;
        case 3:
            self.kLineChartView.showKDJChart = NO;
            self.kLineChartView.showMACDChart = NO;
            self.kLineChartView.showRSIChart = NO;
            self.kLineChartView.showWRChart = YES;
            self.kLineChartView.showMTMChart = NO;
            self.kLineChartView.showCCIChart = NO;
            break;
        case 4:
            self.kLineChartView.showKDJChart = NO;
            self.kLineChartView.showMACDChart = NO;
            self.kLineChartView.showRSIChart = NO;
            self.kLineChartView.showWRChart = NO;
            self.kLineChartView.showMTMChart = YES;
            self.kLineChartView.showCCIChart = NO;
            break;
        case 5:
            self.kLineChartView.showKDJChart = NO;
            self.kLineChartView.showMACDChart = NO;
            self.kLineChartView.showRSIChart = NO;
            self.kLineChartView.showWRChart = NO;
            self.kLineChartView.showMTMChart = NO;
            self.kLineChartView.showCCIChart = YES;
            break;
        default:
            break;
    }
}


#pragma mark - lazy load

- (NSMutableDictionary *)lineDataDict {
    if (_lineDataDict == nil) {
        _lineDataDict = [NSMutableDictionary dictionaryWithCapacity:6];
    }
    return _lineDataDict;
}

- (UIView *)loadView {
    if (_loadView == nil) {
        _loadView = [[UIView alloc] initWithFrame:CGRectMake(0, SL_getWidth(40), SL_SCREEN_WIDTH, self.sl_height - SL_getWidth(40))];
        [self addSubview:_loadView];
        _loadView.hidden = YES;
        _loadView.backgroundColor = [MAIN_COLOR colorWithAlphaComponent:1];
        UIButton *loadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _loadView.sl_height * 0.32, SL_getWidth(180), SL_getWidth(40))];
        loadBtn.sl_centerX = _loadView.sl_centerX;
        [_loadView addSubview:loadBtn];
        loadBtn.layer.cornerRadius = 2;
        loadBtn.layer.masksToBounds = YES;
        loadBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        loadBtn.layer.borderWidth = 0.3;
        [loadBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
        [loadBtn setBackgroundColor:[MAIN_BTN_COLOR colorWithAlphaComponent:0.05]];
        NSData *imageData = [UIImage GIFImageWithName:@"preloading"];
        [loadBtn setImage:[UIImage imageWithSmallGIFData:imageData scale:1.0] forState:UIControlStateNormal];
        loadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [loadBtn setTitle:@"数据加载中..." forState:UIControlStateNormal];
    }
    return _loadView;
}

@end
