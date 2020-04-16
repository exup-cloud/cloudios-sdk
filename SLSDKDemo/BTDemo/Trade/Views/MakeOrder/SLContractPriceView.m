//
//  SLContractPriceView.m
//  BTTest
//
//  Created by wwly on 2019/8/28.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractPriceView.h"
#import "SLTradePriceTableView.h"
#import "SLGuidePriceView.h"
#import "SLDropLineView.h"

@interface SLContractPriceView () <SLTradePriceTableViewDelegate>

/// 价格
@property (nonatomic, strong) UILabel * priceTitleLabel;
/// 数量
@property (nonatomic, strong) UILabel * countTitleLabel;

/// 买
@property (nonatomic, strong) SLTradePriceTableView * buyTableView;

/// 中间line
@property (nonatomic, strong) SLDropLineView *midLine;
/// 底部line
@property (nonatomic, strong) SLDropLineView *bottomLine;

/// 卖
@property (nonatomic, strong) SLTradePriceTableView * sellTableView;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) SLGuidePriceView * guidePriceView;

@property (nonatomic, strong) BTItemModel * currentItemModel;

@end

@implementation SLContractPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    
    [self countTitleLabel];
    [self guidePriceView];
}


/// 更新整个列表数据
- (void)updateViewWithDepthModel:(BTDepthModel *)depthModel itemModel:(nonnull BTItemModel *)itemModel {
    self.currentItemModel = itemModel;
    // 更新深度列表视图
    BTDepthPriceDecimalType decimalType = [NSString getPrice_unitWithContractID:itemModel.instrument_id] / 10;
    [self.buyTableView updateViewWithModelArray:depthModel.buys decimalType:decimalType];
    [self.sellTableView updateViewWithModelArray:depthModel.sells decimalType:decimalType];
    // 更新指导价格
    [self.guidePriceView updateViewWithItmeModel:itemModel];
    
    NSString *buyPrice = [NSString stringWithFormat:@"%@", [depthModel.buys valueForKeyPath:@"px.@max.doubleValue"]];
    NSString *sellPrice = [NSString stringWithFormat:@"%@", [depthModel.sells valueForKeyPath:@"px.@min.doubleValue"]];
    
    if ([self.delegate respondsToSelector:@selector(priceView_updateBuyPrice:sellPrice:)]) {
        [self.delegate priceView_updateBuyPrice:buyPrice sellPrice:sellPrice];
    }
    self.priceTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",Launguage(@"BT_MAIN_P"),itemModel.contractInfo.quote_coin];
}

/// 更新部分数据
- (void)updateViewWithBuysArray:(NSArray <BTContractOrderModel *> *)buys sellsArray:(NSArray <BTContractOrderModel *> *)sells {
    
    NSString *buyPrice = nil;
    NSString *sellPrice = nil;
    
    BTDepthPriceDecimalType decimalType = [NSString getPrice_unitWithContractID:self.currentItemModel.instrument_id] / 10;
    if (buys.count > 0) {
        [self.buyTableView updateViewWithModelArray:buys decimalType:decimalType];
        buyPrice = [NSString stringWithFormat:@"%@", [buys valueForKeyPath:@"px.@max.doubleValue"]];
    }
    if (sells.count > 0) {
        [self.sellTableView updateViewWithModelArray:sells decimalType:decimalType];
        sellPrice = [NSString stringWithFormat:@"%@", [sells valueForKeyPath:@"px.@min.doubleValue"]];
    }
   
    if ([self.delegate respondsToSelector:@selector(priceView_updateBuyPrice:sellPrice:)]) {
        [self.delegate priceView_updateBuyPrice:buyPrice sellPrice:sellPrice];
    }
}


#pragma mark - <SLTradePriceTableViewDelegate>

- (void)tableView_didSelectCellWithModel:(BTContractOrderModel *)orderModel {
    if ([self.delegate respondsToSelector:@selector(priceView_didSelectPrice:)]) {
        [self.delegate priceView_didSelectPrice:orderModel.px];
    }
}


#pragma mark - lazy load

- (UILabel *)priceTitleLabel {
    if (_priceTitleLabel == nil) {
        _priceTitleLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@(USDT)",Launguage(@"BT_MAIN_P")] textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:11] numberOfLines:1 frame:CGRectMake(0, 15, self.sl_width, 20) superview:self];
    }
    return _priceTitleLabel;
}

- (UILabel *)countTitleLabel {
    if (_countTitleLabel == nil) {
        _countTitleLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@(%@)",Launguage(@"BT_MAIN_V"),@"张"] textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:11] numberOfLines:1 frame:CGRectMake(0, self.priceTitleLabel.sl_y, self.sl_width, self.priceTitleLabel.sl_height) superview:self];
    }
    return _countTitleLabel;
}

- (SLTradePriceTableView *)sellTableView {
    if (_sellTableView == nil) {
        _sellTableView = [[SLTradePriceTableView alloc] initWithFrame:CGRectMake(0, self.priceTitleLabel.sl_maxY, self.sl_width, (self.sl_height - 60 - 35  - SL_MARGIN * 4) * 0.5)];
        _sellTableView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
        _sellTableView.orderWay = BTOrderWaySell;
        _sellTableView.cus_delegate = self;
        [self addSubview:_sellTableView];
    }
    return _sellTableView;
}

- (SLDropLineView *)midLine {
    if (_midLine == nil) {
        _midLine = [[SLDropLineView alloc] initWithFrame:CGRectMake(self.sellTableView.sl_x, CGRectGetMaxY(self.sellTableView.frame), self.sellTableView.sl_width, 2 + SL_MARGIN)];
        [self addSubview:_midLine];
    }
    return _midLine;
}

- (SLTradePriceTableView *)buyTableView {
    if (_buyTableView == nil) {
        _buyTableView = [[SLTradePriceTableView alloc] initWithFrame:CGRectMake(self.sellTableView.sl_x, self.midLine.sl_maxY, self.sellTableView.sl_width, self.sellTableView.sl_height)];
        _buyTableView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
        _buyTableView.orderWay = BTOrderWayBuy;
        _buyTableView.cus_delegate = self;
        [self addSubview:_buyTableView];
    }
    return _buyTableView;
}

- (SLDropLineView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[SLDropLineView alloc] initWithFrame:CGRectMake(self.buyTableView.sl_x, CGRectGetMaxY(self.buyTableView.frame), self.sellTableView.sl_width, 2 + SL_MARGIN)];
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (SLGuidePriceView *)guidePriceView {
    if (_guidePriceView == nil) {
        _guidePriceView = [[SLGuidePriceView alloc] initWithFrame:CGRectMake(0, self.bottomLine.sl_maxY, self.sl_width, 60)];
        _guidePriceView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
        [self addSubview:_guidePriceView];
    }
    return _guidePriceView;
}

@end
