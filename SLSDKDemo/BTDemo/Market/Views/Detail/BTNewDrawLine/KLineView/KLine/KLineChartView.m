//
//  KlineChartView.m
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "KLineChartView.h"
#import "KLineListTransformer.h"
#import "UIBezierPath+curved.h"
#import "KLineTipBoardView.h"
#import "MATipView.h"
#import "Masonry.h"
#import "SDAutoLayout.h"

NSString *const KLineKeyStartUserInterfaceNotification = @"KLineKeyStartUserInterfaceNotification";
NSString *const KLineKeyEndOfUserInterfaceNotification = @"KLineKeyEndOfUserInterfaceNotification";

@interface KLineChartView ()

@property (nonatomic, assign) CGFloat yAxisHeight;

@property (nonatomic, assign) CGFloat xAxisWidth;

@property (nonatomic, strong) NSArray *contexts;

@property (nonatomic, strong) NSArray *dates;

@property (nonatomic, assign) NSInteger startDrawIndex;

@property (nonatomic, assign) NSInteger kLineDrawNum;

@property (nonatomic, assign) CGFloat maxHighValue;

@property (nonatomic, assign) CGFloat minLowValue;

@property (nonatomic, assign) CGFloat maxVolValue;

@property (nonatomic, assign) CGFloat minVolValue;

@property (nonatomic, assign) CGFloat maxKDJValue;

@property (nonatomic, assign) CGFloat maxMACDValue;

@property (nonatomic, assign) CGFloat maxMTMValue;

@property (nonatomic, assign) CGFloat maxCCIValue;

//手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;

@property (nonatomic, assign) CGFloat lastPanScale;

//坐标轴
@property (nonatomic, strong) NSMutableDictionary *xAxisContext;

//十字线
@property (nonatomic, strong) UIView *verticalCrossLine;     //垂直十字线
@property (nonatomic, strong) UIView *horizontalCrossLine;   //水平十字线

@property (nonatomic, strong) UIView *barVerticalLine;

@property (nonatomic, strong) KLineTipBoardView *tipBoard;

@property (nonatomic, strong) MATipView *maTipView;

//时间
@property (nonatomic, strong) UILabel *timeLbl;
//价格
@property (nonatomic, strong) UILabel *priceLbl;

//中间部分的 vol  kdj  macd  rsi值数组
@property (nonatomic, strong) NSMutableArray *contentArr;

@property (nonatomic, strong) UIView *contentView;

//实时数据提示按钮
@property (nonatomic, strong) UIButton *realDataTipBtn;

//交互中， 默认NO
@property (nonatomic, assign) BOOL interactive;
//更新临时存储
@property (nonatomic, strong) NSMutableArray *updateTempContexts;
@property (nonatomic, strong) NSMutableArray *updateTempDates;
@property (nonatomic, assign) CGFloat updateTempMaxHigh;
@property (nonatomic, assign) CGFloat updateTempMaxVol;

@end

@implementation KLineChartView {
    CGPoint _lastPanPoint;
    /// 是否是纵向滚动
    BOOL _isVerScroll;
}

#pragma mark - life cycle

- (id)init {
    if (self = [super init]) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.timeAxisHeight = 25.0;
    self.positiveLineColor = UP_WARD_COLOR;
    self.negativeLineColor = DOWN_COLOR;
    
    self.upperShadowColor = self.positiveLineColor;
    self.lowerShadowColor = self.negativeLineColor;
    
    self.movingAvgLineWidth = 0.8;
    
    self.minMALineColor = DOWN_COLOR;
    self.midMALineColor = MAIN_BTN_COLOR;
    self.maxMALineColor = UP_WARD_COLOR;
    self.positiveVolColor = self.positiveLineColor;
    self.negativeVolColor =  self.negativeLineColor;
    
    self.axisShadowColor = [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0];
    self.axisShadowWidth = 0.8;
    
    self.separatorColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0];
    self.separatorWidth = 0.5;
    
    self.yAxisTitleFont = [UIFont systemFontOfSize:8.0];
    self.yAxisTitleColor = GARY_BG_TEXT_COLOR;
    
    self.xAxisTitleFont = [UIFont systemFontOfSize:9.0];
    self.xAxisTitleColor = GARY_BG_TEXT_COLOR;
    
    self.crossLineColor = GARY_BG_TEXT_COLOR;
    self.needUpdata = YES;
    self.scrollEnable = YES;
    self.zoomEnable = YES;
//    self.showAvgLine = YES;
    self.showBarChart = YES;
    self.yAxisTitleIsChange = YES;
    
//    self.saveDecimalPlaces = 6;
    
    self.timeAndPriceTipsBackgroundColor = GARY_BG_TEXT_COLOR;
    self.timeAndPriceTextColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    
    self.supportGesture = YES;
    
    self.maxKLineWidth = 15;
    self.minKLineWidth = 4.0;
    
    self.kLineWidth = 4.0;
    self.kLinePadding = 1.0;
    
    self.lastPanScale = 1.0;
    
    self.xAxisContext = [NSMutableDictionary new];
    self.updateTempDates = [NSMutableArray new];
    self.updateTempContexts = [NSMutableArray new];
//    self.maTipView.hidden = NO;
    //添加手势
    [self addGestures];
    
    [self registerObserver];
}

/**
 *  添加手势
 */
- (void)addGestures {
    if (!self.supportGesture) {
        return;
    }
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.pinchGesture];
    [self addGestureRecognizer:self.longGesture];
}

/**
 *  通知
 */
- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTouchNotification:) name:KLineKeyStartUserInterfaceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfTouchNotification:) name:KLineKeyEndOfUserInterfaceNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.contexts || self.contexts.count == 0) {
        return;
    }
    
    if (self.kLineDrawNum != 0 && self.startDrawIndex + self.kLineDrawNum != self.contexts.count) {
        self.notUpdateKLineData = YES;
    } else {
        self.notUpdateKLineData = NO;
    }
    
    //x坐标轴长度
    self.xAxisWidth = rect.size.width - self.leftMargin - self.rightMargin;
    
    //y坐标轴高度
    self.yAxisHeight = rect.size.height - self.bottomMargin * 2 - self.topMargin;
    
    //坐标轴
    [self drawAxisInRect:rect];
    [self drawTimeAxis];
    if (self.isTimeLine) {
        // 分时
        [self drawTimeLine];
    } else {
        //k线
        [self drawKLine];
        // 均线
        if (self.showAvgLine) {
            [self drawAvgLine];
        } else if (self.showEMALine) {
            [self drawEMALine];
        } else if (self.showBOLLLine) {
            [self drawBOLLLine];
        } else if (self.showSARLine) {
            [self drawSARLine];
        }
    }
    
    [self drawVol];
    
    if (self.showMACDChart) {
        [self drawMACD];
    } else if (self.showRSIChart) {
        [self drawRSI];
    } else if (self.showKDJChart ) {
        [self drawKDJ];
    } else if (self.showWRChart) {
        [self drawWR];
    } else if (self.showMTMChart) {
        [self drawMTM];
    } else if (self.showCCIChart) {
        [self drawCCI];
    }
    
    NSArray *linediawArr =  [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];
    if (self.showAvgLine) {
        self.maTipView.minAvgPrice = [NSString stringWithFormat:@"MA5：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][5] doubleValue])]];
        self.maTipView.midAvgPrice = [NSString stringWithFormat:@"MA10：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][6] doubleValue])]];
        self.maTipView.maxAvgPrice = [NSString stringWithFormat:@"MA20：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][7] doubleValue])]];
    } else if (self.showEMALine) {
        self.maTipView.minAvgPrice = [NSString stringWithFormat:@"EMA12：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][24][0] doubleValue])]];
        self.maTipView.midAvgPrice = [NSString stringWithFormat:@"EMA19：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][24][1] doubleValue])]];
        self.maTipView.maxAvgPrice = [NSString stringWithFormat:@"EMA26：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][24][2] doubleValue])]];
    } else if (self.showBOLLLine) {
        self.maTipView.minAvgPrice = [NSString stringWithFormat:@"UP10：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][25][0] doubleValue])]];
        self.maTipView.midAvgPrice = [NSString stringWithFormat:@"MB10：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][25][1] doubleValue])]];
        self.maTipView.maxAvgPrice = [NSString stringWithFormat:@"DN10：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][25][2] doubleValue])]];
    }

    [self addContentView];
}

- (void)setShowSARLine:(BOOL)showSARLine {
    _showSARLine = showSARLine;
    if (_showSARLine == YES) {
        [self setNeedsDisplay];
    }
}
- (void)setShowBOLLLine:(BOOL)showBOLLLine {
    _showBOLLLine = showBOLLLine;
    if (_showBOLLLine == YES) {
        [self setNeedsDisplay];
    }
}
- (void)setShowAvgLine:(BOOL)showAvgLine {
    _showAvgLine = showAvgLine;
    if (_showAvgLine == YES) {
        [self setNeedsDisplay];
    }
}
- (void)setShowEMALine:(BOOL)showEMALine {
    _showEMALine = showEMALine;
    if (_showEMALine == YES) {
        [self setNeedsDisplay];
    }
}

- (void)setShowBarChart:(BOOL)showBarChart {
    _showBarChart = showBarChart;
    if (_showBarChart == YES) {
         [self setNeedsDisplay];
    }
}

- (void)setShowMACDChart:(BOOL)showMACDChart {
    _showMACDChart = showMACDChart;
    if (_showMACDChart == YES) {
        [self setNeedsDisplay];
    }
}

- (void)setShowKDJChart:(BOOL)showKDJChart {
    _showKDJChart = showKDJChart;
    if (_showKDJChart == YES) {
        [self setNeedsDisplay];
    }
}

- (void)setShowRSIChart:(BOOL)showRSIChart {
    
   _showRSIChart = showRSIChart;
    
    if (_showRSIChart == YES) {
        [self setNeedsDisplay];
    }
}

- (void)setShowWRChart:(BOOL)showWRChart {
    _showWRChart = showWRChart;
    if (_showWRChart == YES) {
        [self setNeedsDisplay];
    }
}

- (void)setShowMTMChart:(BOOL)showMTMChart {
    _showMTMChart = showMTMChart;
    if (_showMTMChart == YES) {
        [self setNeedsDisplay];
    }
}

- (void)setShowCCIChart:(BOOL)showCCIChart {
    _showCCIChart = showCCIChart;
    if (_showCCIChart == YES) {
        [self setNeedsDisplay];
    }
}

- (void)addContentView {
    NSArray<UIColor *> *colors = @[MAIN_GARY_TEXT_COLOR,GARY_BG_TEXT_COLOR, self.midMALineColor, IMPORT_BTN_COLOR];
    
    if (!self.contentView) {
        self.contentView = [[UIView alloc]init];
    }
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.contentView.frame = CGRectMake(self.leftMargin, self.frame.size.height - self.bottomMargin + SL_MARGIN, self.sl_width - self.leftMargin, 17);
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    self.contentArr = [[NSMutableArray alloc]initWithCapacity:4];
    
    NSArray *textArr = @[@"",@"",@"",@""];
    NSArray *linediawArr =  [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];

   //每次更新 纵坐标的最高值
   if (self.showRSIChart){
        textArr = @[@"RSI(6,12,24)",
                    [NSString stringWithFormat:@"RSI6:%.4f",[linediawArr[linediawArr.count-1][8] doubleValue]],
                    [NSString stringWithFormat:@"RSI12:%.4f",[linediawArr[linediawArr.count-1][9] doubleValue]],
                    [NSString stringWithFormat:@"RSI24:%.4f",[linediawArr[linediawArr.count-1][10] doubleValue]]];
    } else if (self.showKDJChart) {
        textArr = @[@"KDJ(9,3,3)",
                    [NSString stringWithFormat:@"K:%.4f",[linediawArr[linediawArr.count-1][11][0] doubleValue]],
                    [NSString stringWithFormat:@"D:%.4f",[linediawArr[linediawArr.count-1][11][1] doubleValue]],
                    [NSString stringWithFormat:@"J:%.4f",[linediawArr[linediawArr.count-1][11][2] doubleValue]]];
    } else if (self.showMACDChart)  {
        textArr = @[@"MACD",
                    [NSString stringWithFormat:@"DIF:%@",[self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][13][0] doubleValue])]],
                    [NSString stringWithFormat:@"DEA:%@",[self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][13][1] doubleValue])]],
                    [NSString stringWithFormat:@"MACD:%@",[self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][13][2] doubleValue])]]];
    } else if (self.showWRChart) {
        textArr = @[@"WR(9)",
                    [NSString stringWithFormat:@"wr:%.4f",[linediawArr[linediawArr.count-1][20] doubleValue]],
                    @"",
                    @""];
    } else if (self.showMTMChart) {
        textArr = @[@"MTM(6,12)",
                    [NSString stringWithFormat:@"MTM6:%.4f",[linediawArr[linediawArr.count-1][21] doubleValue]],
                    [NSString stringWithFormat:@"MTM12:%.4f",[linediawArr[linediawArr.count-1][22] doubleValue]],
                    @""];
    } else if (self.showCCIChart) {
        textArr = @[@"CCI(7,14,21)",
                    [NSString stringWithFormat:@"CCI7:%.4f",[linediawArr[linediawArr.count-1][23][0] doubleValue]],
                    [NSString stringWithFormat:@"CCI14:%.4f",[linediawArr[linediawArr.count-1][23][1] doubleValue]],
                    [NSString stringWithFormat:@"CCI21:%.4f",[linediawArr[linediawArr.count-1][23][2] doubleValue]]];
    }
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = colors[i];
        label.font = [UIFont systemFontOfSize:9];
        label.text = textArr[i];
        if (i != 0) {
            label.textAlignment = NSTextAlignmentCenter;
        }
        [_contentView addSubview:label];
        
        label.sd_layout.autoHeightRatio(0.2);
        [self.contentArr addObject:label];
    }
    
    [_contentView setupAutoWidthFlowItems:self.contentArr withPerRowItemsCount:4 verticalMargin:0 horizontalMargin:2 verticalEdgeInset:0 horizontalEdgeInset:0];
}

#pragma mark - render UI

- (void)drawChartWithData:(NSDictionary *)data {
    
    if (!self.needUpdata) {
        return;
    }
    self.contexts = data[kCandlerstickChartsContext];
    self.dates = data[kCandlerstickChartsDate];

    /**
     *  最高价,最低价
     */
    self.maxHighValue = [data[kCandlerstickChartsMaxHigh] floatValue];
    self.minLowValue = [data[kCandlerstickChartsMinLow] floatValue];
    
    /**
     *  成交量最大之，最小值
     */
    self.maxVolValue = [data[kCandlerstickChartsMaxVol] floatValue];
    self.minVolValue = [data[kCandlerstickChartsMinVol] floatValue];

    //更具宽度和间距确定要画多少个k线柱形图
    self.kLineDrawNum = floor(((self.frame.size.width - self.leftMargin - self.rightMargin - _kLinePadding) / (self.kLineWidth + self.kLinePadding)));
    
    // TODO这里会有问题 设置最小宽度能够显示所有数据
    
    if (self.contexts.count >self.sl_width / 15) {
        self.minKLineWidth = (self.sl_width - self.leftMargin - self.rightMargin - _kLinePadding) / self.contexts.count - _kLinePadding;
    }
    
    //确定从第几个开始画
    self.startDrawIndex = self.contexts.count > 0 ? self.contexts.count - self.kLineDrawNum : 0;
    
    [self resetMaxAndMin];
    
    [self setNeedsDisplay];
}

#pragma mark - event reponse

- (void)updateChartPressed:(UIButton *)button {
    self.startDrawIndex = self.contexts.count - self.kLineDrawNum;
    [self dynamicUpdateChart];
}

- (void)tapEvent:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self];
    NSInteger type = 0;
    if (touchPoint.y > self.topMargin && touchPoint.y < (self.topMargin + self.yAxisHeight)) {
        type = 1;
    } else if (touchPoint.y > (self.sl_height - _bottomMargin) && touchPoint.y < self.sl_height) {
        type = 2;
    }
    if ([self.delegate respondsToSelector:@selector(tapToShowkLineType:)]) {
        [self.delegate tapToShowkLineType:type];
    }
}

- (void)panEvent:(UIPanGestureRecognizer *)panGesture {
    CGPoint touchPoint = [panGesture translationInView:self];
    NSInteger offsetIndex = fabs(touchPoint.x*2/(self.kLineWidth > self.maxKLineWidth/2.0 ? 16.0f : 8.0));
    [self postNotificationWithGestureRecognizerStatus:panGesture.state];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [panGesture velocityInView:panGesture.view];
        if (fabs(velocity.x) < fabs(velocity.y)) {
            _isVerScroll = YES;
        } else {
            _isVerScroll = NO;
        }
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (_isVerScroll) {
            if ([self.proxy respondsToSelector:@selector(scrollVerticallyWithOffsetY:isEnd:)]) {
                if (_lastPanPoint.y != 0) {
                    CGPoint velocity = [panGesture velocityInView:panGesture.view];   //手指离开时x和y方向速度，单位是points/second
//                    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y)); //真实速度
                    CGFloat slideMult = fabs(velocity.y) / 500;  //自己试出来的比例,改动此处可修改灵敏度
                    float slideFactor = 0.1 * slideMult;
                    touchPoint = CGPointMake(touchPoint.x, touchPoint.y + velocity.y * slideFactor);
                    
                    [self.proxy scrollVerticallyWithOffsetY:touchPoint.y - _lastPanPoint.y isEnd:YES];
                }
                _lastPanPoint = touchPoint;
            }
            _lastPanPoint = CGPointZero;
            _isVerScroll = NO;
            return;
        }
    }
    
    if (_isVerScroll) {
        if ([self.proxy respondsToSelector:@selector(scrollVerticallyWithOffsetY:isEnd:)]) {
            if (_lastPanPoint.y != 0) {
                [self.proxy scrollVerticallyWithOffsetY:touchPoint.y - _lastPanPoint.y isEnd:NO];
            }
            _lastPanPoint = touchPoint;
        }
        return;
    }
    
    if (touchPoint.x > 0) {
        self.startDrawIndex = self.startDrawIndex - offsetIndex < 0 ? 0 : self.startDrawIndex - offsetIndex;
    } else {
        self.startDrawIndex = self.startDrawIndex + offsetIndex + self.kLineDrawNum > self.contexts.count ? self.contexts.count - self.kLineDrawNum : self.startDrawIndex + offsetIndex;
    }
    // 说明在滑动超过10个就不需要更新
    if (self.startDrawIndex < self.contexts.count - self.kLineDrawNum - 10) {
        self.needUpdata = NO;
    } else {
        self.needUpdata = YES;
    }
    
    [self resetMaxAndMin];
    
    [panGesture setTranslation:CGPointZero inView:self];
    _lastPanPoint = CGPointZero;
    [self setNeedsDisplay];
}

- (void)pinchEvent:(UIPinchGestureRecognizer *)pinchEvent {
    CGFloat scale = pinchEvent.scale - self.lastPanScale + 1;
    
    [self postNotificationWithGestureRecognizerStatus:pinchEvent.state];
    
    if (!self.zoomEnable || self.contexts.count == 0) {
        return;
    }
    
    self.kLineWidth = _kLineWidth*scale;
    
    CGFloat forwardDrawCount = self.kLineDrawNum;
    
    _kLineDrawNum = floor((self.frame.size.width - self.leftMargin - self.rightMargin) / (self.kLineWidth + self.kLinePadding));
    
    //容差处理
    CGFloat diffWidth = (self.frame.size.width - self.leftMargin - self.rightMargin) - (self.kLineWidth + self.kLinePadding)*_kLineDrawNum;
    if (diffWidth > 4*(self.kLineWidth + self.kLinePadding)/5.0) {
        _kLineDrawNum = _kLineDrawNum + 1;
    }
    
    _kLineDrawNum = self.contexts.count > 0 && _kLineDrawNum < self.contexts.count ? _kLineDrawNum : self.contexts.count;
    if (forwardDrawCount == self.kLineDrawNum && self.maxKLineWidth != self.kLineWidth) {
        return;
    }
    
    NSInteger diffCount = fabs(self.kLineDrawNum - forwardDrawCount);
    
    if (forwardDrawCount > self.startDrawIndex) {
        // 放大
        self.startDrawIndex += ceil(diffCount/2.0);
    } else {
        // 缩小
        self.startDrawIndex -= floor(diffCount/2.0);
        self.startDrawIndex = self.startDrawIndex < 0 ? 0 : self.startDrawIndex;
    }
    
    self.startDrawIndex = self.startDrawIndex + self.kLineDrawNum > self.contexts.count ? self.contexts.count - self.kLineDrawNum : self.startDrawIndex;
    
    [self resetMaxAndMin];
    
    pinchEvent.scale = scale;
    self.lastPanScale = pinchEvent.scale;
    
    [self setNeedsDisplay];
}

- (void)longPressEvent:(UILongPressGestureRecognizer *)longGesture {
    [self postNotificationWithGestureRecognizerStatus:longGesture.state];
    
    if (self.contexts.count == 0 || !self.contexts) {
        return;
    }
    
    if (longGesture.state == UIGestureRecognizerStateEnded) {
        self.needUpdata = YES;
        self.horizontalCrossLine.hidden = YES;
        self.verticalCrossLine.hidden = YES;
        self.barVerticalLine.hidden = YES;
        NSArray *linediawArr = [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];
        self.maTipView.minAvgPrice = [NSString stringWithFormat:@"MA5：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][5] doubleValue])]];
        self.maTipView.midAvgPrice = [NSString stringWithFormat:@"MA10：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][6] doubleValue])]];
        self.maTipView.maxAvgPrice = [NSString stringWithFormat:@"MA20：%@", [self dealDecimalWithNum:@([linediawArr[linediawArr.count-1][7] doubleValue])]];
        
        self.priceLbl.hidden = YES;
        self.timeLbl.hidden = YES;
        [self addContentView];
        self.tipBoard.hidden = YES;
        if ([self.proxy respondsToSelector:@selector(endToPointWithKLineChartView:lineArr:)]) {
            NSArray  *arr =  [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];
            [self.proxy endToPointWithKLineChartView:self lineArr:[arr lastObject]];
        }
    } else {
        self.needUpdata = NO;
        self.tipBoard.hidden = NO;
        self.maTipView.hidden = NO;
        CGPoint touchPoint = [longGesture locationInView:self];
        [self.xAxisContext enumerateKeysAndObjectsUsingBlock:^(NSNumber *xAxisKey, NSNumber *indexObject, BOOL *stop) {
            if (self->_kLinePadding + self->_kLineWidth >= ([xAxisKey floatValue] - touchPoint.x) && ([xAxisKey floatValue] - touchPoint.x) > 0) {
                NSInteger index = [indexObject integerValue];
                // 获取对应的k线数据
                NSArray *line = self->_contexts[index];
                CGFloat open = [line[0] floatValue];
                CGFloat close = [line[3] floatValue];
                CGFloat scale = (self.maxHighValue - self.minLowValue) / self.yAxisHeight;
                CGFloat xAxis = [xAxisKey floatValue] - self->_kLineWidth / 2.0 + self.leftMargin;
                CGFloat yAxis = 0;
                if (scale == 0) {
                    yAxis = self.yAxisHeight + self.topMargin;
                } else {
                    yAxis = self.yAxisHeight - (open - self.minLowValue)/scale + self.topMargin;
                }
                
                if ([line[1] floatValue] > [line[2] floatValue]) {
                    if (scale == 0) {
                        yAxis = self.yAxisHeight + self.topMargin;
                    } else {
                        yAxis = self.yAxisHeight - (close - self.minLowValue)/scale + self.topMargin;
                    }
                }
                
                [self configUIWithLine:line atPoint:CGPointMake(xAxis, yAxis)];
                *stop = YES;
            }
        }];
    }
}

- (void)configUIWithLine:(NSArray *)line atPoint:(CGPoint)point {
    if ([self.proxy respondsToSelector:@selector(moveToPointWithKLineChartView:lineArr:)]) {
        [self.proxy moveToPointWithKLineChartView:self lineArr:line];
    }
    
    //十字线
    self.verticalCrossLine.hidden = NO;
    CGRect frame = self.verticalCrossLine.frame;
    frame.origin.x = point.x;
    self.verticalCrossLine.frame = frame;
    
    self.horizontalCrossLine.hidden = NO;
    frame = self.horizontalCrossLine.frame;
    frame.origin.y = point.y;
    self.horizontalCrossLine.frame = frame;
    
    self.barVerticalLine.hidden = NO;
    frame = self.barVerticalLine.frame;
    frame.origin.x = point.x;
    self.barVerticalLine.frame = frame;
    
    //均值
    self.maTipView.hidden = NO;
    
    if (self.showAvgLine) {
        self.maTipView.minAvgPrice = [NSString stringWithFormat:@"MA5:%@", [self dealDecimalWithNum:@([line[5] doubleValue])]];
        self.maTipView.midAvgPrice = [NSString stringWithFormat:@"MA10:%@", [self dealDecimalWithNum:@([line[6] doubleValue])]];
        self.maTipView.maxAvgPrice = [NSString stringWithFormat:@"MA20:%@", [self dealDecimalWithNum:@([line[7] doubleValue])]];
    } else if (self.showEMALine) {
        self.maTipView.minAvgPrice = [NSString stringWithFormat:@"EMA12:%@", [self dealDecimalWithNum:@([line[24][0] doubleValue])]];
        self.maTipView.midAvgPrice = [NSString stringWithFormat:@"EMA19:%@", [self dealDecimalWithNum:@([line[24][1] doubleValue])]];
        self.maTipView.maxAvgPrice = [NSString stringWithFormat:@"EMA26:%@", [self dealDecimalWithNum:@([line[24][2] doubleValue])]];
    } else if (self.showBOLLLine) {
        self.maTipView.minAvgPrice = [NSString stringWithFormat:@"UP10:%@", [self dealDecimalWithNum:@([line[25][0] doubleValue])]];
        self.maTipView.midAvgPrice = [NSString stringWithFormat:@"MB10:%@", [self dealDecimalWithNum:@([line[25][1] doubleValue])]];
        self.maTipView.maxAvgPrice = [NSString stringWithFormat:@"DN10:%@", [self dealDecimalWithNum:@([line[25][2] doubleValue])]];
    }
    
    //提示版
    if (self.isHorScreen) {
        if (point.x >=self.sl_width * 0.5) {
            self.tipBoard.frame = CGRectMake(SL_MARGIN * 2, SL_getWidth(40), SL_getWidth(100), SL_getWidth(150));
        } else {
            self.tipBoard.frame = CGRectMake(self.sl_width -  SL_getWidth(120), SL_getWidth(40), SL_getWidth(100), SL_getWidth(150));
        }
    }
    
    self.tipBoard.open = [NSString stringWithFormat:@"%@ %@", @"O", [self dealDecimalWithNum:@([line[0] doubleValue])]];
    self.tipBoard.close = [NSString stringWithFormat:@"%@ %@", @"C", [self dealDecimalWithNum:@([line[3] doubleValue])]];
    self.tipBoard.high = [NSString stringWithFormat:@"%@ %@", @"H", [self dealDecimalWithNum:@([line[1] doubleValue])]];
    self.tipBoard.low = [NSString stringWithFormat:@"%@ %@", @"L", [self dealDecimalWithNum:@([line[2] floatValue])]];
    self.tipBoard.change = [NSString stringWithFormat:@"%@ %@%%", @"Cha", line[15]];
    self.tipBoard.volume = [NSString stringWithFormat:@"%@ %.2f", @"Vol", [line[4] floatValue]];
    self.tipBoard.date = [NSString stringWithFormat:@"%@", line[14]];
    self.tipBoard.time = [NSString stringWithFormat:@"%@", line[16]];
    
    if ([line[15] floatValue] > 0) {
        self.tipBoard.trendColor = UP_WARD_COLOR;
    } else {
        self.tipBoard.trendColor = DOWN_COLOR;
    }
    if (self.showRSIChart){
        for (int i = 0; i < 4; i++) {
            UILabel *label = self.contentArr[i];
            if (i == 0) {
                label.text = @"RSI(6,12,24)";
            } else if (i == 1) {
                label.text = [NSString stringWithFormat:@"RSI6:%.4F",[line[8] doubleValue]];
            } else if (i == 2) {
                label.text = [NSString stringWithFormat:@"RSI12:%.4F",[line[9] doubleValue]];
            } else if (i == 3) {
                label.text = [NSString stringWithFormat:@"RSI24:%.4F",[line[10] doubleValue]];
            }
        }
    } else if (self.showKDJChart){
        for (int i = 0; i < 4; i++) {
            UILabel *label = self.contentArr[i];
            if (i == 0) {
                label.text = @"KDJ(9,3,3)";
            } else if (i == 1) {
                label.text = [NSString stringWithFormat:@"K:%.4F",[line[11][0] doubleValue]];
            } else if (i == 2) {
                label.text = [NSString stringWithFormat:@"D:%.4F",[line[11][1] doubleValue]];
            } else if (i == 3) {
                label.text = [NSString stringWithFormat:@"J:%.4F",[line[11][2] doubleValue]];
            }
        }
    } else if (self.showMACDChart) {
        for (int i = 0; i < 4; i++) {
            UILabel *label = self.contentArr[i];
            if (i == 0) {
                label.text = @" MACD";
            } else if (i == 1) {
                label.text = [NSString stringWithFormat:@"DIF:%@",[self dealDecimalWithNum:@([line[13][0] doubleValue])]];
            } else if (i == 2) {
                label.text = [NSString stringWithFormat:@"DEA:%@",[self dealDecimalWithNum:@([line[13][1] doubleValue])]];
            } else if (i == 3) {
                label.text = [NSString stringWithFormat:@"MACD:%@",[self dealDecimalWithNum:@([line[13][2] doubleValue])]];
            }
        }
    } else if (self.showWRChart) {
        for (int i = 0; i < 4; i++) {
            UILabel *label = self.contentArr[i];
            if (i == 0) {
                label.text = @"WR(9)";
            } else if (i == 1) {
                label.text = [NSString stringWithFormat:@"wr:%@",[self dealDecimalWithNum:@([line[20] doubleValue])]];
            } else if (i == 2) {
                label.text = @"";
            } else if (i == 3) {
                label.text = @"";
            }
        }
    } else if (self.showMTMChart) {
        for (int i = 0; i < 4; i++) {
            UILabel *label = self.contentArr[i];
            if (i == 0) {
                label.text = @"MTM(6,12)";
            } else if (i == 1) {
                label.text = [NSString stringWithFormat:@"MTM6:%@",[self dealDecimalWithNum:@([line[21] doubleValue])]];
            } else if (i == 2) {
                label.text = [NSString stringWithFormat:@"MTM12:%@",[self dealDecimalWithNum:@([line[22] doubleValue])]];
            } else if (i == 3) {
                label.text = @"";
            }
        }
    } else if (self.showCCIChart) {
        for (int i = 0; i < 4; i++) {
            UILabel *label = self.contentArr[i];
            if (i == 0) {
                label.text = @"CCI(7,14,21)";
            } else if (i == 1) {
                label.text = [NSString stringWithFormat:@"CCI7:%@",[self dealDecimalWithNum:@([line[23][0] doubleValue])]];
            } else if (i == 2) {
                label.text = [NSString stringWithFormat:@"CCI14:%@",[self dealDecimalWithNum:@([line[23][1] doubleValue])]];
            } else if (i == 3) {
                label.text = [NSString stringWithFormat:@"CCI21:%@",[self dealDecimalWithNum:@([line[23][2] doubleValue])]];
            }
        }
    }

    if (!self.isHorScreen) {
        self.tipBoard.frame = CGRectMake(0,SL_getWidth(40) * -1, self.sl_width, SL_getWidth(40));
    }
    
    //时间，价额
    self.priceLbl.hidden = NO;
    self.priceLbl.text = [line[0] floatValue] > [line[3] floatValue] ? [self dealDecimalWithNum:@([line[0] floatValue])] :[self dealDecimalWithNum:@([line[3] floatValue])];
    [self.priceLbl sizeToFit];
    self.priceLbl.sl_x = self.leftMargin;
    self.priceLbl.sl_y = MIN(self.horizontalCrossLine.frame.origin.y - (self.timeAxisHeight - self.separatorWidth*2)/2.0, self.topMargin + self.yAxisHeight - self.timeAxisHeight);
    
    NSString *date = self.dates[[self.contexts indexOfObject:line]];
    self.timeLbl.text = date;
    self.timeLbl.hidden = date.length > 0 ? NO : YES;
    if (date.length > 0) {
        CGSize size = [date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.xAxisTitleFont} context:nil].size;
        CGFloat originX = MIN(MAX(self.leftMargin, point.x - size.width/2.0 - 2), self.frame.size.width - self.rightMargin - size.width - 4);
        [self.timeLbl sizeToFit];
        self.timeLbl.sl_x = originX;
        self.timeLbl.sl_y = self.topMargin + self.yAxisHeight + self.separatorWidth;
    }
}

- (void)postNotificationWithGestureRecognizerStatus:(UIGestureRecognizerState)state {
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            [[NSNotificationCenter defaultCenter] postNotificationName:KLineKeyStartUserInterfaceNotification object:nil];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [[NSNotificationCenter defaultCenter] postNotificationName:KLineKeyEndOfUserInterfaceNotification object:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - private methods

/**
 *  网格（坐标图）
 */
#pragma mark - （坐标图）
- (void)drawAxisInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //k线边框（上面的边框）
    CGRect strokeRect = CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, self.yAxisHeight);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, DARK_BARKGROUND_COLOR.CGColor);
    CGContextStrokeRect(context, strokeRect);
    
    //k线分割线
    CGFloat avgHeight = strokeRect.size.height/2.0;
    for (int i = 1; i < 4; i ++) {
        CGContextSetLineWidth(context, 1);
        CGFloat lengths[] = {5,5};
        CGContextSetStrokeColorWithColor(context, DARK_BARKGROUND_COLOR.CGColor);
        CGContextSetLineDash(context, 0, lengths, 2);  //画虚线

        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.leftMargin + 1.25, self.topMargin + avgHeight*i);    //开始画线
        CGContextAddLineToPoint(context, rect.size.width  - self.rightMargin - 0.8, self.topMargin + avgHeight*i);

        CGContextStrokePath(context);
    }

    //这必须把dash给初始化一次，不然会影响其他线条的绘制
    CGContextSetLineDash(context, 0, 0, 0);
    
    //k线y坐标
    CGFloat avgValue = (self.maxHighValue - self.minLowValue) / 5.0;
    for (int i = 0; i < 3; i ++) {
        float yAxisValue = i == 5 ? self.minLowValue : self.maxHighValue - avgValue*i;
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[self dealDecimalWithNum:@(yAxisValue)] attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:GARY_BG_TEXT_COLOR}];
        CGSize size = [attString boundingRectWithSize:CGSizeMake(self.leftMargin, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        [attString drawInRect:CGRectMake(self.leftMargin, self.topMargin + avgHeight*i - (i == 5 ? size.height - 1 : size.height/2.0), 80, size.height)];
    
    }
    if (self.showMACDChart) {
        [self drawBottomMACDLeftLabelrect:rect];
    }
    [self drawBottomLeftLabelrect:rect];
}

- (void)drawBottomMACDLeftLabelrect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect strokeRect = CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, self.yAxisHeight);
    
    //交易量边框
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, DARK_BARKGROUND_COLOR.CGColor);
    strokeRect = CGRectMake(self.leftMargin, self.yAxisHeight + self.topMargin + self.timeAxisHeight + _bottomMargin, self.xAxisWidth, (rect.size.height - self.yAxisHeight - self.topMargin - self.timeAxisHeight) * 0.5);
    CGContextStrokeRect(context, strokeRect);
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[self dealDecimalWithNum:@(self.maxMACDValue)] attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:self.yAxisTitleColor}];
    CGSize size = [attString boundingRectWithSize:CGSizeMake(self.leftMargin, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    [attString drawInRect:CGRectMake(self.leftMargin - size.width - 2.0f,self.sl_height - _bottomMargin, size.width, size.height)];
    
    attString = [[NSAttributedString alloc] initWithString:@"0.0"  attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:self.yAxisTitleColor}];
    size = [attString boundingRectWithSize:CGSizeMake(self.leftMargin, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    [attString drawInRect:CGRectMake(self.leftMargin - size.width - 2.0f, rect.size.height - size.height/2-(self.bottomMargin-self.timeAxisHeight)/2, size.width, size.height)];
    
    
    attString = [[NSAttributedString alloc] initWithString:[self dealDecimalWithNum:@(-self.maxMACDValue)]  attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:self.yAxisTitleColor}];
    size = [attString boundingRectWithSize:CGSizeMake(self.leftMargin, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    [attString drawInRect:CGRectMake(self.leftMargin - size.width - 2.0f, rect.size.height - size.height, size.width, size.height)];
    
}

- (void)drawBottomLeftLabelrect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect strokeRect = CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, self.yAxisHeight);
    CGFloat     tBottomyAxisTitle;
    NSString    *bBottomyAxisTitle;
    if (self.showBarChart) {
        if (self.maxVolValue<10000.0) {
            tBottomyAxisTitle  = self.maxVolValue;
            bBottomyAxisTitle = @"";
        }else{
            tBottomyAxisTitle  = self.maxVolValue ;//self.maxVolValue/10000;
            bBottomyAxisTitle = @"";
        }
    } else if(self.showRSIChart){
        tBottomyAxisTitle  = 100;
        bBottomyAxisTitle = @"0";
    } else {
        tBottomyAxisTitle  = self.maxKDJValue;
        bBottomyAxisTitle = @"0";
        
    }
    
    // 交易量边框
    CGContextSetLineWidth(context, self.axisShadowWidth);
    CGContextSetStrokeColorWithColor(context, self.axisShadowColor.CGColor);
    CGFloat length = 0;
//    if (self.isHorScreen) {
//        length = SL_getWidth(40);
//    }
    strokeRect = CGRectMake(self.leftMargin, self.yAxisHeight + self.topMargin + self.timeAxisHeight + length, self.xAxisWidth, rect.size.height - self.yAxisHeight - self.topMargin - self.timeAxisHeight);
    CGContextStrokeRect(context, strokeRect);
    
    //[self dealDecimalWithNum:@(tBottomyAxisTitle)]
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"VOL:%@",[BTFormat totalVolumeFromNumberStr:[NSString stringWithFormat:@"%.2f",tBottomyAxisTitle]]] attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:self.yAxisTitleColor}];
    CGSize size = [attString boundingRectWithSize:CGSizeMake(self.leftMargin, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    [attString drawInRect:CGRectMake(self.leftMargin, self.yAxisHeight + self.topMargin + self.timeAxisHeight - 2 + length, size.width, size.height)];
    
    attString = [[NSAttributedString alloc] initWithString:bBottomyAxisTitle attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:self.yAxisTitleColor}];
    size = [attString boundingRectWithSize:CGSizeMake(self.leftMargin, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

    [attString drawInRect:CGRectMake(self.leftMargin, rect.size.height - size.height, size.width, size.height)];
}

- (void)drawTimeAxis {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat quarteredWidth = self.xAxisWidth/4.0;
    NSInteger avgDrawCount = ceil(quarteredWidth/(_kLinePadding + _kLineWidth));
    
    CGFloat xAxis = 0;//self.leftMargin + _kLineWidth/2.0 + _kLinePadding;
    //画4条虚线
    for (int i = 0; i < 4; i ++) {
        if (xAxis > self.leftMargin + self.xAxisWidth) {
            break;
        }
        CGContextSetLineWidth(context, 1);
        CGFloat lengths[] = {5,5};
        CGContextSetStrokeColorWithColor(context, DARK_BARKGROUND_COLOR.CGColor);
        CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, xAxis, self.topMargin + 1.25);    //开始画线
        CGContextAddLineToPoint(context, xAxis, self.topMargin + self.yAxisHeight - 1.25);
        
        CGContextMoveToPoint(context, xAxis, self.topMargin +self.yAxisHeight+self.timeAxisHeight+1.25);    //开始画线
        CGContextAddLineToPoint(context, xAxis, self.frame.size.height-1.25);
        
        CGContextStrokePath(context);
        
        //x轴坐标
        NSInteger timeIndex = i*avgDrawCount + self.startDrawIndex;
        if (timeIndex > self.dates.count - 1) {
            xAxis += avgDrawCount*(_kLinePadding + _kLineWidth);
            continue;
        }
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.dates[timeIndex] attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGFloat originX = MIN(xAxis - size.width/2.0, self.frame.size.width - self.rightMargin - size.width);
        if (i != 0) { // 第一个不画
            [attString drawInRect:CGRectMake(originX, self.topMargin + self.yAxisHeight + 2.0, size.width, size.height)];
        }
        xAxis += avgDrawCount*(_kLinePadding + _kLineWidth);
    }
    CGContextSetLineDash(context, 0, 0, 0);
}

// 分时
- (void)drawTimeLine {
    NSArray<UIColor *> *colors = @[MAIN_BTN_COLOR, [UIColor blueColor],[UIColor orangeColor]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context, colors[0].CGColor);
    
    CGPathRef path = [self movingAvgGraphPathForContextAtIndex:(17)];
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    CGPathRef linearPath = [self linearGraphPathForContextAtIndex:(17)];
    
    [self drawLinearGradient:context path:linearPath alpha:0.5 startColor:[MAIN_BTN_COLOR colorWithAlphaComponent:0.2].CGColor endColor:[MAIN_BTN_COLOR colorWithAlphaComponent:0.2].CGColor];
}

- (CGPathRef)linearGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path;
    
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale = (self.maxHighValue - self.minLowValue) / self.yAxisHeight;
    
    if (scale != 0) {
        
        CGPoint startPoint = CGPointMake(xAxis, self.sl_height - self.bottomMargin * 2);
        
        NSArray *tempArray = [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];
        
        for (int i = 0; i < tempArray.count; ++i) {
            NSArray *line = tempArray[i];
            [self.xAxisContext setObject:@([_contexts indexOfObject:line]) forKey:@(xAxis + _kLineWidth)];
            // 取出第5个数值. 为什么?
            CGFloat maValue = [line[index] floatValue];
            CGFloat yAxis = self.yAxisHeight - (maValue - self.minLowValue)/scale + self.topMargin;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            if (yAxis < self.topMargin - 1 || yAxis > (self.frame.size.height - self.bottomMargin * 2) + 1) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:startPoint];
                [path addLineToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
            if (i == self.kLineDrawNum - 1) {
                CGPoint endPoint = CGPointMake(xAxis, self.sl_height - self.bottomMargin *2);
                [path addLineToPoint:endPoint];
//                SLLog(@"%@", NSStringFromCGPoint(endPoint));
            }
            
            xAxis += self.kLineWidth + self.kLinePadding;
        }
    } else {
        CGPoint startPoint = CGPointMake(xAxis, self.sl_height - self.bottomMargin * 2);
        
        NSArray *tempArray = [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];
        
        for (int i = 0; i < tempArray.count; ++i) {
            CGFloat yAxis = self.yAxisHeight* 0.5 + self.topMargin;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            if (yAxis < self.topMargin - 1 || yAxis > (self.frame.size.height - self.bottomMargin * 2) + 1) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:startPoint];
                [path addLineToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            if (i == self.kLineDrawNum-1) {
                CGPoint endPoint = CGPointMake(xAxis, self.frame.size.height - self.bottomMargin * 2);
                [path addLineToPoint:endPoint];
//                SLLog(@"%@", NSStringFromCGPoint(endPoint));
            }
            xAxis += self.kLineWidth + self.kLinePadding;
        }
    }
    
    //圆滑
    path = [path smoothedPathWithGranularity:15];
    
    return path.CGPath;
}


- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                     alpha:(CGFloat)alpha
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextSetAlpha(context, alpha);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


/**
 *  K线
 */
- (void)drawKLine {
    CGFloat scale = (self.maxHighValue - self.minLowValue) / self.yAxisHeight;
    if (scale == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    
    CGFloat xAxis = _kLinePadding;
    [self.xAxisContext removeAllObjects];
    
    BOOL drawLow = NO;
    BOOL drawHigh = NO;
    
    for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
        [self.xAxisContext setObject:@([_contexts indexOfObject:line]) forKey:@(xAxis + _kLineWidth)];
        //通过开盘价、收盘价判断颜色
        CGFloat open = [line[0] floatValue];
        CGFloat close = [line[3] floatValue];
        UIColor *fillColor = open > close ?  self.negativeLineColor : self.positiveLineColor;
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGFloat diffValue = fabs(open - close);
        CGFloat maxValue = MAX(open, close);
        CGFloat height = diffValue/scale == 0 ? 1 : diffValue/scale;
        CGFloat width = _kLineWidth;
        CGFloat yAxis = self.yAxisHeight - (maxValue - self.minLowValue)/scale + self.topMargin;
        
        CGRect rect = CGRectMake(xAxis + self.leftMargin, yAxis, width, height);
        CGContextAddRect(context, rect);
        CGContextFillPath(context);
        
        //上、下影线
        CGFloat highYAxis = self.yAxisHeight - ([line[1] floatValue] - self.minLowValue)/scale; // high - 最高价 (蜡烛图最上面的点)
        CGFloat lowYAxis = self.yAxisHeight - ([line[2] floatValue] - self.minLowValue)/scale;  // low - 最低价 (蜡烛图最下面的点)
        CGPoint highPoint = CGPointMake(xAxis + width/2.0 + self.leftMargin, highYAxis + self.topMargin);
        CGPoint lowPoint = CGPointMake(xAxis + width/2.0 + self.leftMargin, lowYAxis + self.topMargin);
        CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, highPoint.x, highPoint.y);  //起点坐标
        CGContextAddLineToPoint(context, lowPoint.x, lowPoint.y);   //终点坐标
        CGContextStrokePath(context);
        
        /*画最高最低值*/
        
        if ([line[1] floatValue] == self.maxHighValue) {
            if (drawHigh == NO) {
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[self dealDecimalWithNum:@(self.maxHighValue)] attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:GARY_BG_TEXT_COLOR}];
                CGSize size = [attString boundingRectWithSize:CGSizeMake(0, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                
                CGContextSetStrokeColorWithColor(context, GARY_BG_TEXT_COLOR.CGColor);
                CGContextMoveToPoint(context, highPoint.x, highPoint.y);  //起点坐标
                if (self.sl_width-highPoint.x-20<(10+size.width)) {
                    //终点坐标
                    CGContextAddLineToPoint(context, highPoint.x-10, highPoint.y);
                    CGContextStrokePath(context);
                    [attString drawInRect:CGRectMake( highPoint.x-10-size.width, highPoint.y, size.width, size.height)];
                }else{
                    CGContextAddLineToPoint(context, highPoint.x+10, highPoint.y);
                    CGContextStrokePath(context);
                    [attString drawInRect:CGRectMake( highPoint.x+10, highPoint.y, size.width, size.height)];
                }
                drawHigh = YES;
            }
            
        }
        
        if ([line[2] floatValue] == self.minLowValue) {
            if (drawLow == NO) {
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[self dealDecimalWithNum:@(self.minLowValue)] attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:GARY_BG_TEXT_COLOR}];
                CGSize size = [attString boundingRectWithSize:CGSizeMake( lowPoint.x+10, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesFontLeading context:nil].size;
                
                CGContextSetStrokeColorWithColor(context, GARY_BG_TEXT_COLOR.CGColor);
                CGContextMoveToPoint(context, lowPoint.x, lowPoint.y);  //起点坐标
                
                if (self.sl_width-lowPoint.x-20<(10+size.width)) {
                    //终点坐标
                    CGContextAddLineToPoint(context, lowPoint.x-10, lowPoint.y);
                    CGContextStrokePath(context);
                    
                    [attString drawInRect:CGRectMake( lowPoint.x-10-size.width, lowPoint.y-size.height, size.width, size.height)];
                }else{
                    CGContextAddLineToPoint(context, lowPoint.x+10, lowPoint.y);
                    CGContextStrokePath(context);
                    
                    [attString drawInRect:CGRectMake( lowPoint.x+10, lowPoint.y-size.height, size.width, size.height)];
                }
                drawLow = YES;
            }
        }
        
        xAxis += width + _kLinePadding;
    }
}

/**
 *  MACD
 */
- (void)drawMACD {
    NSArray<UIColor *> *colors = @[GARY_BG_TEXT_COLOR, MAIN_BTN_COLOR,IMPORT_BTN_COLOR];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    for (int i = 0; i < 2; i ++) {
        CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
        CGPathRef path = [self movingMACDGraphPathForContextAtIndex:13 macdIndex:i CGContextRef:context];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
    
}

- (CGPathRef)movingMACDGraphPathForContextAtIndex:(NSInteger)index macdIndex:(NSInteger)macdIndex CGContextRef:(CGContextRef)context {
    UIBezierPath *path;
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale =(self.bottomMargin-self.timeAxisHeight)/(self.maxMACDValue*2);
    
    if (scale !=0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            
            CGFloat indexY = self.frame.size.height - (self.bottomMargin-self.timeAxisHeight)/2;
            CGFloat yAxis = indexY - [line[index][macdIndex] doubleValue]*scale;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            
            
            //竖线
            CGContextSetStrokeColorWithColor(context, GARY_BG_TEXT_COLOR.CGColor);
            CGContextSetLineWidth(context, 0.5);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, xAxis,indexY );  //起点坐标
            CGContextAddLineToPoint(context, xAxis,indexY-[line[index][2] doubleValue]*scale);   //终点坐标
            CGContextStrokePath(context);
            
            CGContextSetStrokeColorWithColor(context, MAIN_BTN_COLOR.CGColor);
            if (yAxis < self.sl_height- self.bottomMargin || yAxis > self.frame.size.height) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
            xAxis += self.kLineWidth + self.kLinePadding;
        }
    }
    //圆滑
    path = [path smoothedPathWithGranularity:1];
    return path.CGPath;
}

/*
 * MTM
 */
- (void)drawMTM {
    NSArray<UIColor *> *colors = @[GARY_BG_TEXT_COLOR,MAIN_BTN_COLOR];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    for (int i = 0; i < 2; i++) {
        CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
        CGPathRef path = [self movingDrawMTMGraphPathForContextAtIndex:21+i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

- (CGPathRef)movingDrawMTMGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path;
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale =(self.bottomMargin-self.timeAxisHeight)/self.maxMTMValue;
    if (scale !=0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            CGFloat maVale = [line[index]floatValue];
            CGFloat yAxis = self.frame.size.height - maVale*scale;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            
            if (yAxis < self.frame.size.height- self.bottomMargin || yAxis > self.frame.size.height) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
            xAxis += self.kLineWidth + self.kLinePadding;
        }
    }
    //圆滑
    path = [path smoothedPathWithGranularity:1];
    return path.CGPath;
}

/*
 * WR
 */
- (void)drawWR {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    CGContextSetStrokeColorWithColor(context, IMPORT_BTN_COLOR.CGColor);
    CGPathRef path = [self movingDrawWRGraphPathForContextAtIndex:20];
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
}

- (CGPathRef)movingDrawWRGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path;
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale =(self.bottomMargin-self.timeAxisHeight)/100;
    
    if (scale !=0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            CGFloat maVale = [line[index]floatValue];
            CGFloat yAxis = self.frame.size.height - maVale*scale;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            
            if (yAxis < self.frame.size.height- self.bottomMargin || yAxis > self.frame.size.height) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
            xAxis += self.kLineWidth + self.kLinePadding;
        }
    }
    
    //圆滑
    path = [path smoothedPathWithGranularity:1];
    
    return path.CGPath;
}

/**
 *  CCI
 */
- (void)drawCCI {
    NSArray<UIColor *> *colors = @[MAIN_BTN_COLOR, GARY_BG_TEXT_COLOR,IMPORT_BTN_COLOR];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    for (int i = 0; i < 3; i ++) {
        CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
        CGPathRef path = [self movingCCIGraphPathForContextAtIndex:23 cciIndex:i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}
- (CGPathRef)movingCCIGraphPathForContextAtIndex:(NSInteger)index cciIndex:(NSInteger)cciIndex {
    UIBezierPath *path;
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale = (self.bottomMargin - self.timeAxisHeight)/self.maxCCIValue;
    
    if (scale !=0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            CGFloat maVale;
            if ([line[index] count]==0) {
                maVale = 0;
            }else{
                maVale = [line[index][cciIndex]floatValue];
                
            }
            CGFloat yAxis = self.sl_height - maVale*scale;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            
            if (yAxis < self.sl_height- self.bottomMargin || yAxis > self.frame.size.height) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
            xAxis += self.kLineWidth + self.kLinePadding;
        }
    }
    //圆滑
    path = [path smoothedPathWithGranularity:1];
    return path.CGPath;
}


/**
 *  KDJ
 */
- (void)drawKDJ {
    NSArray<UIColor *> *colors = @[MAIN_BTN_COLOR, GARY_BG_TEXT_COLOR,IMPORT_BTN_COLOR];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    for (int i = 0; i < 3; i ++) {
        CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
        CGPathRef path = [self movingKDJGraphPathForContextAtIndex:11 kdjIndex:i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
    
}

- (CGPathRef)movingKDJGraphPathForContextAtIndex:(NSInteger)index kdjIndex:(NSInteger)kdjIndex{
    UIBezierPath *path;
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale = (self.bottomMargin - self.timeAxisHeight)/self.maxKDJValue;
    
    if (scale !=0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            CGFloat maVale;
            if ([line[index] count]==0) {
             maVale = 0;
            }else{
             maVale = [line[index][kdjIndex]floatValue];

            }
            CGFloat yAxis = self.sl_height - maVale*scale;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            
            if (yAxis < self.sl_height- self.bottomMargin || yAxis > self.frame.size.height) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
            xAxis += self.kLineWidth + self.kLinePadding;
        }
    }
    
    //圆滑
    path = [path smoothedPathWithGranularity:1];
    
    return path.CGPath;

}

/**
 *  RSI
 */
- (void)drawRSI {
    if (!self.showRSIChart) {
        return;
    }
    NSArray<UIColor *> *colors = @[MAIN_BTN_COLOR, GARY_BG_TEXT_COLOR,IMPORT_BTN_COLOR];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    for (int i = 0; i < 3; i ++) {
    CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
    CGPathRef path = [self movingRSIGraphPathForContextAtIndex:(8+i)];
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    }
}
- (CGPathRef)movingRSIGraphPathForContextAtIndex:(NSInteger)index {
    
    UIBezierPath *path;
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale =(self.bottomMargin-self.timeAxisHeight)/100;
    
    if (scale !=0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            CGFloat maVale = [line[index]floatValue];
            CGFloat yAxis = self.frame.size.height - maVale*scale;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            
            if (yAxis < self.frame.size.height- self.bottomMargin || yAxis > self.frame.size.height) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }

            xAxis += self.kLineWidth + self.kLinePadding;
        }
    }
    
    //圆滑
    path = [path smoothedPathWithGranularity:1];
    
    return path.CGPath;;
}

#pragma mark - SAR

- (void)drawSARLine {
    if (!self.showSARLine) return;
    [self movingSARGraphPathForContextAtIndex:26];
}

- (void)movingSARGraphPathForContextAtIndex:(NSInteger)index {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale = (self.maxHighValue - self.minLowValue) / self.yAxisHeight;
    for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
        CGFloat maValue = [line[index] floatValue];
        CGFloat yAxis = self.yAxisHeight - (maValue - self.minLowValue)/scale + self.topMargin;
//        CGPoint maPoint = CGPointMake(xAxis, yAxis);
        if (yAxis < self.topMargin || yAxis > (self.sl_height - self.bottomMargin * 2)) {
            xAxis += self.kLineWidth + self.kLinePadding;
            continue;
        }
        xAxis += self.kLineWidth + self.kLinePadding;
        if (maValue == 0) {
            continue;
        }
        CGRect bigRect = CGRectMake(yAxis-1.5,
                                    yAxis-1.5,
                                    3,
                                    3);
        CGContextSetLineWidth(ctx, 1);
        //以矩形bigRect为依据画一个圆
        CGContextAddEllipseInRect(ctx, bigRect);
        [UP_WARD_COLOR set];
        
    }
    CGContextStrokePath(ctx);
}

#pragma mark - BOLL

- (void)drawBOLLLine {
    if (!self.showBOLLLine) return;
    NSArray<UIColor *> *colors = @[[UIColor orangeColor], GARY_BG_TEXT_COLOR,[UIColor purpleColor]];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    for (int i = 0; i < 3; i ++) {
        CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
        CGPathRef path = [self movingBOLLGraphPathForContextAtIndex:25 emaIndex:i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

- (CGPathRef)movingBOLLGraphPathForContextAtIndex:(NSInteger)index emaIndex:(NSInteger)emaIndex {
    UIBezierPath *path;
    
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale = (self.maxHighValue - self.minLowValue) / self.yAxisHeight;
    
    if (scale != 0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            CGFloat maValue = [line[index][emaIndex] floatValue];
            CGFloat yAxis = self.yAxisHeight - (maValue - self.minLowValue)/scale + self.topMargin;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            if (yAxis < self.topMargin || yAxis > (self.sl_height - self.bottomMargin * 2)) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            xAxis += self.kLineWidth + self.kLinePadding;
            // 4.21 change
            if (maValue == 0) {
                continue;
            }
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
        }
    }
    //圆滑
    path = [path smoothedPathWithGranularity:15];
    return path.CGPath;
}

#pragma mark - EMA12 EMA19 EMA 26

- (void)drawEMALine {
    if (!self.showEMALine) {
        return;
    }
    NSArray<UIColor *> *colors = @[MAIN_BTN_COLOR, GARY_BG_TEXT_COLOR,[UIColor orangeColor]];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    for (int i = 0; i < 3; i ++) {
        CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
        CGPathRef path = [self movingEMAGraphPathForContextAtIndex:24 emaIndex:i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

- (CGPathRef)movingEMAGraphPathForContextAtIndex:(NSInteger)index emaIndex:(NSInteger)emaIndex {
    UIBezierPath *path;
    
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale = (self.maxHighValue - self.minLowValue) / self.yAxisHeight;
    
    if (scale != 0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            CGFloat maValue = [line[index][emaIndex] floatValue];
            CGFloat yAxis = self.yAxisHeight - (maValue - self.minLowValue)/scale + self.topMargin;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            if (yAxis < self.topMargin || yAxis > (self.sl_height - self.bottomMargin * 2)) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            xAxis += self.kLineWidth + self.kLinePadding;
            // 4.21 change
            if (maValue == 0) {
                continue;
            }
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
        }
    }
    //圆滑
    path = [path smoothedPathWithGranularity:15];
    return path.CGPath;
}

#pragma mark - MA5 MA10 MA20

- (void)drawAvgLine {
    if (!self.showAvgLine) {
        return;
    }
    NSArray<UIColor *> *colors = @[MAIN_BTN_COLOR, GARY_BG_TEXT_COLOR,[UIColor orangeColor]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.movingAvgLineWidth);
    
    for (int i = 0; i < 3; i ++) {
        CGContextSetStrokeColorWithColor(context, colors[i].CGColor);
        CGPathRef path = [self movingAvgGraphPathForContextAtIndex:(i + 5)];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}
/**
 *  均线path
 */
- (CGPathRef)movingAvgGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path;
    
    CGFloat xAxis = self.leftMargin + 1/2.0*_kLineWidth + _kLinePadding;
    CGFloat scale = (self.maxHighValue - self.minLowValue) / self.yAxisHeight;
    
    if (scale != 0) {
        for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
            CGFloat maValue = [line[index] floatValue];
            CGFloat yAxis = self.yAxisHeight - (maValue - self.minLowValue)/scale + self.topMargin;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            if (yAxis < self.topMargin || yAxis > (self.sl_height - self.bottomMargin * 2)) {
                xAxis += self.kLineWidth + self.kLinePadding;
                continue;
            }
            xAxis += self.kLineWidth + self.kLinePadding;
            // 4.21 change
            if (maValue == 0) {
                continue;
            }
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
        }
    }
    
    //圆滑
    path = [path smoothedPathWithGranularity:15];
    
    return path.CGPath;
}

/**
 *  交易量
 */
- (void)drawVol {
    if (!self.negativeLineColor) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.kLineWidth);
    
    CGRect rect = self.bounds;
    
    CGFloat xAxis = _kLinePadding + _leftMargin;
    
    CGFloat boxYOrigin = self.topMargin + self.yAxisHeight + self.timeAxisHeight;
    CGFloat boxHeight = (rect.size.height - boxYOrigin) * 0.5;
    CGFloat scale = self.maxVolValue / boxHeight* 1.2;
    
    for (NSArray *line in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)]) {
        CGFloat open = [line[0] floatValue];
        CGFloat close = [line[3] floatValue];
        UIColor *fillColor = open >= close ? self.negativeVolColor: self.positiveVolColor;
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGFloat height = [line[4] floatValue]/scale == 0 ? 1.0 : [line[4] floatValue]/scale;
        CGRect pathRect = CGRectMake(xAxis, boxYOrigin + boxHeight - height, self.kLineWidth, height);
        CGContextAddRect(context, pathRect);
        CGContextFillPath(context);
        
        xAxis += _kLineWidth + _kLinePadding;
    }
}

- (void)dynamicUpdateChart {
    if (self.updateTempContexts.count == 0) {
        return;
    }
    
    if ((!self.interactive && (self.startDrawIndex + self.kLineDrawNum) == self.contexts.count) || self.dynamicUpdateIsNew) {
        self.contexts = [self.contexts arrayByAddingObjectsFromArray:self.updateTempContexts];
        self.dates = [self.dates arrayByAddingObjectsFromArray:self.updateTempDates];
        self.maxVolValue = self.maxVolValue > self.updateTempMaxVol ? self.maxVolValue : self.updateTempMaxVol;
        self.maxHighValue = self.maxHighValue > self.updateTempMaxHigh ? self.maxHighValue : self.updateTempMaxHigh;
        
        [self resetLeftMargin];
        
        //更具宽度和间距确定要画多少个k线柱形图
        self.kLineDrawNum = floor(((self.frame.size.width - self.leftMargin - self.rightMargin - _kLinePadding) / (self.kLineWidth + self.kLinePadding)));
        
        //确定从第几个开始画
        self.startDrawIndex = self.contexts.count > 0 ? self.contexts.count - self.kLineDrawNum : 0;
        
        [self resetMaxAndMin];
        
        [self setNeedsDisplay];
        self.realDataTipBtn.hidden = YES;
        [self.realDataTipBtn.layer removeAllAnimations];
        [self.updateTempDates removeAllObjects];
        [self.updateTempContexts removeAllObjects];
        self.updateTempMaxHigh = 0.0;
        self.updateTempMaxVol = 0.0;
    } else {
        //提示有新数据
        SLLog(@"has new data!");
        if (self.realDataTipBtn.hidden) {
            self.realDataTipBtn.hidden = NO;
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.duration = 2.5;
            animation.repeatCount = 99999;
            
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.65, 0.65, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.65, 0.65, 1.0)]];
            animation.values = values;
            [self.realDataTipBtn.layer addAnimation:animation forKey:nil];
        }
    }
}

- (void)resetLeftMargin {
    CGFloat maxValue = self.showBarChart ? (self.maxVolValue > self.maxHighValue ? self.maxVolValue : self.maxHighValue) : self.maxHighValue;
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[self dealDecimalWithNum:@(maxValue)] attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:self.yAxisTitleColor}];
    CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.leftMargin = size.width + 4.0f;
}

- (void)resetMaxAndMin {
    NSArray *drawContext = self.contexts;
    if (self.yAxisTitleIsChange) {
        drawContext = [self.contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNum)];
    }
     NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < drawContext.count; i++) {
        NSArray<NSString *> *item = drawContext[i];
        if (i == 0) {
            self.minVolValue = [item[4] floatValue];
            self.maxVolValue = [item[4] floatValue];
            self.minLowValue = [item[2] floatValue];
            self.maxHighValue = [item[1] floatValue];
            self.maxKDJValue = [[item[11] valueForKeyPath:@"@max.floatValue"]floatValue];
            self.maxMTMValue = [item[21] floatValue];
            if ([item[22] GreaterThan:item[21]]) {
                self.maxMTMValue = [item[22] floatValue];
            }
           
            self.maxCCIValue = [[item[23] valueForKeyPath:@"@max.floatValue"]floatValue];
            
            for (NSNumber *num in (NSArray*)item[13]) {
                
                [arr addObject:[NSNumber numberWithFloat:fabsf([num floatValue])]];
            }
            self.maxMACDValue = [[arr valueForKeyPath:@"@max.floatValue"]floatValue];
            
            
        } else {
            if (self.maxHighValue < [item[1] floatValue]) {
                self.maxHighValue = [item[1] floatValue];
            }
            
            if (self.minLowValue > [item[2] floatValue]) {
                self.minLowValue = [item[2] floatValue];
            }
            
            if (self.maxVolValue < [item[4] floatValue]) {
                self.maxVolValue = [item[4] floatValue];
            }
            
            if (self.minVolValue > [item[4] floatValue]) {
                self.minVolValue = [item[4] floatValue];
            }
            if (self.maxKDJValue<[[item[11] valueForKeyPath:@"@max.floatValue"]floatValue]) {
                self.maxKDJValue = [[item[11] valueForKeyPath:@"@max.floatValue"]floatValue];
            }
            
            if (self.maxMTMValue < [item[21] floatValue]) {
                 self.maxMTMValue = [item[21] floatValue];
            }
            
            if (self.maxMTMValue < [item[22] floatValue]) {
                self.maxMTMValue = [item[22] floatValue];
            }
            
            if (self.maxCCIValue<[[item[23] valueForKeyPath:@"@max.floatValue"]floatValue]) {
                self.maxCCIValue = [[item[23] valueForKeyPath:@"@max.floatValue"]floatValue];
            }
            
             [arr removeAllObjects];
            for (NSNumber *num in (NSArray*)item[13]) {
                
                [arr addObject:[NSNumber numberWithFloat:fabsf([num floatValue])]];
            }
            CGFloat maxMACDValues = [[arr valueForKeyPath:@"@max.floatValue"]floatValue];
            
            if (self.maxMACDValue < maxMACDValues) {
                self.maxMACDValue = maxMACDValues;
            }
        }
    }
}

- (NSString *)dealDecimalWithNum:(NSNumber *)num {
    NSString *dealString;
    NSString *format = [NSString stringWithFormat:@"%%.%ldf%%",self.saveDecimalPlaces];
    dealString = [NSString stringWithFormat:format, num.doubleValue];
    return dealString;
}

#pragma mark -  public methods

- (void)updateChartWithData:(NSDictionary *)data {
    if (data.count == 0 || !data) {
        return;
    }
    
    [self.updateTempDates addObjectsFromArray:data[kCandlerstickChartsDate]];
    [self.updateTempContexts addObjectsFromArray:data[kCandlerstickChartsContext]];
    
    if ([data[kCandlerstickChartsMaxVol] floatValue] > self.updateTempMaxVol) {
        self.updateTempMaxVol = [data[kCandlerstickChartsMaxVol] floatValue];
    }
    
    if ([data[kCandlerstickChartsMaxHigh] floatValue] > self.updateTempMaxHigh) {
        self.updateTempMaxHigh = [data[kCandlerstickChartsMaxHigh] floatValue];
    }
    
    [self dynamicUpdateChart];
}

- (void)clear {
    self.contexts = nil;
    self.dates = nil;
    [self setNeedsDisplay];
}

#pragma mark - notificaiton events

- (void)startTouchNotification:(NSNotification *)notification {
    self.interactive = YES;
}

- (void)endOfTouchNotification:(NSNotification *)notification {
    self.interactive = NO;
    [self dynamicUpdateChart];
}

- (void)deviceOrientationDidChangeNotification:(NSNotification *)notificaiton {
    
}

#pragma mark - getters

- (UIView *)verticalCrossLine {
    if (!_verticalCrossLine) {
        _verticalCrossLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin, self.topMargin, 0.5, self.yAxisHeight)];
        _verticalCrossLine.backgroundColor = self.crossLineColor;
        [self addSubview:_verticalCrossLine];
    }
    return _verticalCrossLine;
}

- (UIView *)horizontalCrossLine {
    if (!_horizontalCrossLine) {
        _horizontalCrossLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, 0.5)];
        _horizontalCrossLine.backgroundColor = self.crossLineColor;
        [self addSubview:_horizontalCrossLine];
    }
    return _horizontalCrossLine;
}

- (UIView *)barVerticalLine {
    if (!_barVerticalLine) {
        _barVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin, self.topMargin + self.yAxisHeight + self.timeAxisHeight, 0.5, self.frame.size.height - (self.topMargin + self.yAxisHeight + self.timeAxisHeight))];
        _barVerticalLine.backgroundColor = self.crossLineColor;
        [self addSubview:_barVerticalLine];
    }
    return _barVerticalLine;
}

- (KLineTipBoardView *)tipBoard {
    if (!_tipBoard) {
        _tipBoard = [[KLineTipBoardView alloc] initWithFrame:CGRectMake(0, 0, self.sl_width, SL_getWidth(40))];
        _tipBoard.hidden = YES;
        _tipBoard.backgroundColor = MAIN_COLOR;
        if (self.isHorScreen) {
            _tipBoard.isScreen = YES;
            _tipBoard.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
            _tipBoard.layer.borderWidth = 1;
        }
        [self addSubview:_tipBoard];
    }
    return _tipBoard;
}

- (MATipView *)maTipView {
    if (!_maTipView) {
        _maTipView = [[MATipView alloc] initWithFrame:CGRectMake(SL_MARGIN, 2, self.sl_width - SL_MARGIN * 2, 18.0f) Type:0];
        _maTipView.backgroundColor = [UIColor clearColor];
        [self addSubview:_maTipView];
    }
    return _maTipView;
}

- (UIButton *)realDataTipBtn {
    if (!_realDataTipBtn) {
        _realDataTipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_realDataTipBtn setTitle:@"New Data" forState:UIControlStateNormal];
        [_realDataTipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _realDataTipBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _realDataTipBtn.frame = CGRectMake(self.frame.size.width - self.rightMargin - 60.0f, self.topMargin + 10.0f, 60.0f, 25.0f);
        [_realDataTipBtn addTarget:self action:@selector(updateChartPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_realDataTipBtn];
        _realDataTipBtn.layer.borderWidth = 1.0;
        _realDataTipBtn.layer.borderColor = MAIN_BTN_COLOR.CGColor;
        _realDataTipBtn.hidden = YES;
    }
    return _realDataTipBtn;
}

- (UILabel *)timeLbl {
    if (!_timeLbl) {
        _timeLbl = [UILabel new];
        _timeLbl.backgroundColor = self.timeAndPriceTipsBackgroundColor;
        _timeLbl.textAlignment = NSTextAlignmentCenter;
        _timeLbl.font = self.yAxisTitleFont;
        _timeLbl.textColor = self.timeAndPriceTextColor;
        [self addSubview:_timeLbl];
    }
    return _timeLbl;
}

- (UILabel *)priceLbl {
    if (!_priceLbl) {
        _priceLbl = [UILabel new];
        _priceLbl.backgroundColor = self.timeAndPriceTipsBackgroundColor;
        _priceLbl.textAlignment = NSTextAlignmentCenter;
        _priceLbl.font = self.xAxisTitleFont;
        _priceLbl.textColor = self.timeAndPriceTextColor;
        [self addSubview:_priceLbl];
    }
    return _priceLbl;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    }
    return _tapGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    }
    return _panGesture;
}

- (UIPinchGestureRecognizer *)pinchGesture {
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEvent:)];
    }
    return _pinchGesture;
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    }
    return _longGesture;
}

#pragma mark - setters 

- (void)setKLineDrawNum:(NSInteger)kLineDrawNum {
    if (kLineDrawNum  < 0) {
        _kLineDrawNum = 0;
    }
    
    _kLineDrawNum = self.contexts.count > 0 && kLineDrawNum < self.contexts.count ? kLineDrawNum : self.contexts.count;
    
    if (_kLineDrawNum != 0) {
        self.kLineWidth = (self.sl_width - self.leftMargin - self.rightMargin - _kLinePadding)/_kLineDrawNum - _kLinePadding;
    }
}

- (void)setKLineWidth:(CGFloat)kLineWidth {
    if (kLineWidth < self.minKLineWidth) {
        kLineWidth = self.minKLineWidth;
    }
    
    if (kLineWidth > self.maxKLineWidth) {
        kLineWidth = self.maxKLineWidth;
    }
    
    _kLineWidth = kLineWidth;
}

- (void)setMaxKLineWidth:(CGFloat)maxKLineWidth {
    if (maxKLineWidth < _minKLineWidth) {
        maxKLineWidth = _minKLineWidth;
    }
    
    CGFloat realAxisWidth = (self.frame.size.width - self.leftMargin - self.rightMargin - _kLinePadding);
    NSInteger maxKLineCount = floor(realAxisWidth)/(maxKLineWidth + _kLinePadding);
    maxKLineWidth = realAxisWidth/maxKLineCount - _kLinePadding;
    
    _maxKLineWidth = maxKLineWidth;
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    self.maxKLineWidth = _maxKLineWidth;
}

- (void)setSupportGesture:(BOOL)supportGesture {
    _supportGesture = supportGesture;
    
    if (!supportGesture) {
        self.gestureRecognizers = nil;
    }
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin < _timeAxisHeight ? _timeAxisHeight : bottomMargin;
}

@end
