//
//  BTHorScreenView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/6/4.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTHorScreenView.h"
#import "KLineChartView.h"
#import "SLButton.h"
#import "BTDetailLabel.h"
#import "UIImage+SLGetImage.h"
#import "BTHorScreenListView.h"

@interface BTHorScreenView () <YKLineChartViewDelegate, KLineChartViewdelegate, SLMarketDetailChartSegmentDelegate, BTHorScreenListViewDelegate>
@property (nonatomic, strong) UIButton *removeBtn;

// header
@property (nonatomic, strong) SLButton *selectCoinBtn;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *exchangeLabel;
@property (nonatomic, strong) BTDetailLabel *highLabel;
@property (nonatomic, strong) BTDetailLabel *lowLabel;
@property (nonatomic, strong) BTDetailLabel *volumeLabel;

@property (nonatomic, assign) SLStockLineDataType currentDataType;
//@property (nonatomic, strong) BTKLineSegment *horScreenSegment;
@property (nonatomic, strong) SLMarketDetailChartSegment *horScreenSegment;
@property (nonatomic, strong) KLineChartView *kLineChartView;
@property (nonatomic, strong) BTHorScreenListView *horScreenListView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation BTHorScreenView

- (instancetype)initWithFrame:(CGRect)frame seletedDataType:(SLStockLineDataType)dataType {
    if (self = [super initWithFrame:frame]) {
        self.currentDataType = dataType;
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.backgroundColor = MAIN_COLOR;
    // 退出全屏按钮
    self.removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.sl_width - SL_getWidth(30) - SL_MARGIN, SL_MARGIN, SL_getWidth(30), SL_getWidth(30))];
    [self.removeBtn setImage:[UIImage imageWithName:@"icon-close2"] forState:UIControlStateNormal];
    [self.removeBtn addTarget:self action:@selector(removeHorView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.removeBtn];
    
    self.horScreenSegment = [[SLMarketDetailChartSegment alloc] initWithFrame:CGRectMake(SL_MARGIN, self.sl_height - SL_getWidth(45), self.sl_width - 2 * SL_MARGIN, SL_getWidth(40)) titles:@[
          @{Launguage(@"MK_SP_OD"): @(SLStockLineDataTypeTimely)},
          @{@"1分": @(SLStockLineDataTypeOneMinute)},
          @{@"5分": @(SLStockLineDataTypeFiveMinutes)},
          @{@"15分": @(SLStockLineDataTypeFifteenMinutes)},
          @{@"30分": @(SLStockLineDataTypeThirtyMinutes)},
          @{@"60分": @(SLStockLineDataTypeOneHour)},
          @{@"2时": @(SLStockLineDataTypeTwoHours)},
          @{@"4时": @(SLStockLineDataTypeFourHours)},
          @{@"6时": @(SLStockLineDataTypeSixHours)},
          @{@"12时": @(SLStockLineDataTypeTwelveHours)},
          @{@"1天": @(SLStockLineDataTypeOneDay)},
          @{@"1周": @(SLStockLineDataTypeOneWeek)}] selectedDataType:self.currentDataType];

    self.horScreenSegment.delegate = self;
    [self addSubview:self.horScreenSegment];
    
    self.selectCoinBtn = [[SLButton alloc]  initWithContentFrameType:BTTiTleLabelInFontType];
    self.selectCoinBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.selectCoinBtn];
    
    self.priceLabel = [self createLabelWithFont:[UIFont systemFontOfSize:15] textColor:UP_WARD_COLOR];
    
    self.rateLabel = [self createLabelWithFont:[UIFont systemFontOfSize:12] textColor:UP_WARD_COLOR];
    
    self.exchangeLabel = [self createLabelWithFont:[UIFont systemFontOfSize:12] textColor:GARY_BG_TEXT_COLOR];
    
    self.highLabel = [[BTDetailLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.exchangeLabel.frame) + SL_getWidth(70), 0,(self.removeBtn.sl_x - SL_MARGIN - CGRectGetMaxX(self.exchangeLabel.frame) - SL_getWidth(70)) / 3.0 - SL_MARGIN, SL_getWidth(50)) andType:1];
    self.lowLabel = [[BTDetailLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.highLabel.frame) + SL_MARGIN, self.highLabel.sl_y, self.highLabel.sl_width, self.highLabel.sl_height) andType:1];
    self.volumeLabel = [[BTDetailLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lowLabel.frame) + SL_MARGIN, self.lowLabel.sl_y, self.lowLabel.sl_width, self.lowLabel.sl_height) andType:1];
    self.highLabel.font = self.volumeLabel.font = self.lowLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.highLabel];
    [self addSubview:self.lowLabel];
    [self addSubview:self.volumeLabel];
    [self addSubview:self.horScreenListView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.selectCoinBtn sizeToFit];
    self.selectCoinBtn.sl_x = SL_MARGIN;
    self.selectCoinBtn.sl_y = SL_MARGIN;
    
    [self.priceLabel sizeToFit];
    self.priceLabel.sl_x = CGRectGetMaxX(self.selectCoinBtn.frame) + SL_MARGIN;
    self.priceLabel.sl_centerY = self.selectCoinBtn.sl_centerY;
    
    [self.exchangeLabel sizeToFit];
    self.exchangeLabel.sl_x = CGRectGetMaxX(self.priceLabel.frame) + SL_MARGIN;
    self.exchangeLabel.sl_y = CGRectGetMaxY(self.priceLabel.frame) - self.exchangeLabel.sl_height;
    
    [self.rateLabel sizeToFit];
    self.rateLabel.sl_x = CGRectGetMaxX(self.exchangeLabel.frame) + SL_MARGIN;
    self.rateLabel.sl_y = self.exchangeLabel.sl_y;
    
    self.highLabel.frame = CGRectMake(CGRectGetMaxX(self.rateLabel.frame) + SL_getWidth(40), 0,(self.removeBtn.sl_x - SL_MARGIN - CGRectGetMaxX(self.rateLabel.frame) - SL_getWidth(40)) / 3.0 - SL_MARGIN, SL_getWidth(40));
    self.highLabel.sl_centerY = self.selectCoinBtn.sl_centerY;
    self.lowLabel.frame = CGRectMake(CGRectGetMaxX(self.highLabel.frame) + SL_MARGIN, self.highLabel.sl_y, self.highLabel.sl_width, self.highLabel.sl_height);
    self.volumeLabel.frame = CGRectMake(CGRectGetMaxX(self.lowLabel.frame) + SL_MARGIN, self.lowLabel.sl_y, self.lowLabel.sl_width, self.lowLabel.sl_height);
    self.horScreenListView.frame = CGRectMake(SL_SCREEN_HEIGHT - SL_getWidth(70), SL_getWidth(56), SL_getWidth(70), SL_SCREEN_WIDTH - SL_getWidth(45) - SL_getWidth(57));
    [self addSubview:self.topLineView];
    [self addSubview:self.bottomLineView];
}

- (void)showHorScreenViewKLineDataDict:(NSDictionary *)lineDataDict {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.kLineChartView removeFromSuperview];
        self.kLineChartView = nil;
        if (self.currentDataType == SLStockLineDataTypeTimely) {
            [self initKineView];
            self.kLineChartView.isTimeLine = YES;
        } else {
            [self initKineView];
        }
        [self setMainkLineTypeWithType];
        [self setbottomLineTypeWithType];
        [self.kLineChartView drawChartWithData:lineDataDict];
        self.loadView.hidden = YES;
    });
}


#pragma mark - <SLMarketDetailChartSegmentDelegate>

- (void)chartSegment_segmentDidClick:(SLSegmentButton *)segmentButton {
    self.currentDataType = segmentButton.dataType;
    if ([self.delegate respondsToSelector:@selector(horScreenView_didCickSegmentWithDataType:)]) {
        self.loadView.hidden = NO;
        [self.delegate horScreenView_didCickSegmentWithDataType:segmentButton.dataType];
    }
}


#pragma mark - delegate

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
    [self.horScreenListView setMainTargetType:self.tlineType];
}

- (void)setbottomLineTypeWithType {
    switch (self.blineType) {
        case 0:
            self.kLineChartView.showMACDChart = YES;
            self.kLineChartView.showKDJChart = NO;
            self.kLineChartView.showRSIChart = NO;
            self.kLineChartView.showWRChart = NO;
            self.kLineChartView.showMTMChart = NO;
            self.kLineChartView.showCCIChart = NO;
            break;
        case 1:
            self.kLineChartView.showMACDChart = NO;
            self.kLineChartView.showKDJChart = YES;
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
    [self.horScreenListView setDupliTargetType:self.blineType];
}

- (void)horScreenListViewDidClickMainType:(NSInteger)type andIndex:(NSInteger)index {
    if (type == 0) {
        self.tlineType = index;
        [self tapToShowkLineType:1];
    } else {
        self.blineType = index;
        [self tapToShowkLineType:2];
    }
}

#pragma mark - action

- (void)removeHorView {
    if ([self.delegate respondsToSelector:@selector(horScreenViewDidClickCancelView:)]) {
        [self.delegate horScreenViewDidClickCancelView:self];
    }
}
#pragma mark ====== k线图 ===========
- (void)initKineView {
    if (!_kLineChartView) {
        CGFloat left = SL_SafeAreaTopHeight - 64 + SL_MARGIN;
        _kLineChartView = [[KLineChartView alloc] initWithFrame:CGRectMake(left, SL_getWidth(55), SL_SCREEN_HEIGHT - left - SL_MARGIN - SL_getWidth(70), self.horScreenSegment.sl_y - SL_getWidth(55) - SL_getWidth(20))];
    }
    _kLineChartView.backgroundColor = MAIN_COLOR;
    _kLineChartView.axisShadowColor = DARK_BARKGROUND_COLOR;
    _kLineChartView.xAxisTitleColor = GARY_BG_TEXT_COLOR;
    _kLineChartView.topMargin = 16.0f;
    _kLineChartView.leftMargin = 0;
    _kLineChartView.rightMargin = 0;
    _kLineChartView.bottomMargin = SL_getWidth(60);
    _kLineChartView.kLinePadding = 1;
    _kLineChartView.kLineWidth = self.sl_width / 72 - 1;
    _kLineChartView.supportGesture = YES;
    _kLineChartView.scrollEnable = YES;
    _kLineChartView.zoomEnable = YES;
    _kLineChartView.delegate = self;
    _kLineChartView.proxy = self;
    _kLineChartView.isHorScreen = YES;
    _kLineChartView.saveDecimalPlaces = self.decimals;
    [self addSubview:self.kLineChartView];
}

#pragma mark - Create View

- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    [self addSubview:label];
    return label;
}

- (UIView *)loadView {
    if (_loadView == nil) {
        _loadView = [[UIView alloc] initWithFrame:CGRectMake(0, SL_getWidth(50) ,SL_SCREEN_HEIGHT - SL_getWidth(80), SL_SCREEN_WIDTH - SL_getWidth(50) - SL_getWidth(45))];
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
        [loadBtn setImage:[UIImage imageWithSmallGIFData:imageData scale:1.f] forState:UIControlStateNormal];
        loadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [loadBtn setTitle:@"数据加载中..." forState:UIControlStateNormal];
    }
    return _loadView;
}

- (BOOL)notUpdateData {
    return self.kLineChartView.notUpdateKLineData;
}

- (void)setItemModel:(BTItemModel *)itemModel {
    if (itemModel.instrument_id > 0) {// 合约
        [self.selectCoinBtn setTitle:itemModel.name forState:UIControlStateNormal];
        self.priceLabel.text = [itemModel.last_px toSmallPriceWithContractID:itemModel.instrument_id];
        self.rateLabel.text = [NSString stringWithFormat:@"%.2f%%",[itemModel.change_rate doubleValue]];// rate
        NSString *value = [Common currentPriceWithCoin:[NSString stringWithFormat:@"%@/%@",itemModel.contractInfo.base_coin,itemModel.contractInfo.quote_coin] currentPrice:itemModel.last_px];
        self.exchangeLabel.text = [NSString stringWithFormat:@"≈ %@",value];
        
        [self.highLabel setName:Launguage(@"str_fair_price") andNumber:[itemModel.fair_px toSmallPriceWithContractID:itemModel.instrument_id]];
        [self.lowLabel setName:Launguage(@"BT_CA_INDEX_PRI") andNumber:[itemModel.index_px toSmallPriceWithContractID:itemModel.instrument_id]];
        [self.volumeLabel setName:Launguage(@"str_24Vol") andNumber:[BTFormat totalVolumeFromNumberStr:itemModel.qty_day]];
    } 
    if (itemModel.trend == BTPriceFluctuationUp) {
        self.priceLabel.textColor = self.rateLabel.textColor = UP_WARD_COLOR;
    } else {
        self.priceLabel.textColor = self.rateLabel.textColor = DOWN_COLOR;
    }
    [self layoutSubviews];
}

- (BTHorScreenListView *)horScreenListView {
    if (_horScreenListView == nil) {
        _horScreenListView = [[BTHorScreenListView alloc] initWithFrame:CGRectMake(SL_SCREEN_HEIGHT - SL_getWidth(70), SL_getWidth(56), SL_getWidth(70), SL_SCREEN_WIDTH - SL_getWidth(45) - SL_getWidth(57))];
        _horScreenListView.delegate = self;
        _horScreenListView.layer.borderWidth = 1;
        _horScreenListView.layer.borderColor = [UIColor colorWithHex:@"#2A2E3D"].CGColor;
        _horScreenListView.layer.cornerRadius = 2;
        _horScreenListView.layer.masksToBounds = YES;
    }
    return _horScreenListView;
}

- (UIView *)topLineView {
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, SL_getWidth(50), SL_SCREEN_HEIGHT, 5)];
        _topLineView.backgroundColor = DARK_BARKGROUND_COLOR;
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.horScreenSegment.sl_y, SL_SCREEN_HEIGHT, 1)];
        _bottomLineView.backgroundColor= DARK_BARKGROUND_COLOR;
    }
    return _bottomLineView;
}

@end
