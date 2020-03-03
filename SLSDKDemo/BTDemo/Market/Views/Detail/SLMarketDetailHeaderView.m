//
//  SLMarketDetailHeaderView.m
//  BTTest
//
//  Created by wwly on 2019/9/10.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMarketDetailHeaderView.h"
#import "UILabel+CalculateSize.h"

@interface SLMarketDetailHeaderView ()

/// 当前价格
@property (nonatomic, strong) UILabel *priceLabel;
/// 转化为法币的价格
@property (nonatomic, strong) UILabel *legalTenderPriceLabel;
/// 当前涨跌幅
@property (nonatomic, strong) UILabel *currentGainsLabel;

/// 合理价格
@property (nonatomic, strong) UILabel * reasonablePriceTitleLabel;
@property (nonatomic, strong) UILabel * reasonablePriceLabel;

/// 资金费率
@property (nonatomic, strong) UILabel * rateTitleLabel;
@property (nonatomic, strong) UILabel * rateLabel;

/// 指数价格
@property (nonatomic, strong) UILabel * indexPriceTitleLabel;
@property (nonatomic, strong) UILabel * indexPriceLabel;

/// 24 小时交易量
@property (nonatomic, strong) UILabel * tradingVolumeTitleLabel;
@property (nonatomic, strong) UILabel * tradingVolumeLabel;

/// 右箭头
@property (nonatomic, strong) UIButton * rightArrowButton;

@end

@implementation SLMarketDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    CGFloat leftMargin = 12;
    CGFloat topMargin = 20;
    self.priceLabel = [UILabel labelWithText:@"0.0" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].redColorForSell font:[UIFont fontWithName:@"Helvetica-Bold" size:30] numberOfLines:1 frame:CGRectMake(leftMargin, topMargin, (self.sl_width - leftMargin * 2) / 2, 50) superview:self];
    self.legalTenderPriceLabel = [UILabel labelWithText:@"≈ 0.0" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.priceLabel.sl_x, self.priceLabel.sl_maxY, self.priceLabel.sl_width, 25) superview:self];
    self.currentGainsLabel = [UILabel labelWithText:@"- -" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].redColorForSell font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(self.priceLabel.sl_x, self.legalTenderPriceLabel.sl_maxY, self.legalTenderPriceLabel.sl_width, 30) superview:self];
    
    CGFloat rightArrowWidth = 20;
    CGFloat labelHeight = 30;
    CGFloat labelWidth = ((self.sl_width - leftMargin * 2) / 2 - rightArrowWidth) / 2;
    topMargin = (self.sl_height - labelHeight * 4) / 2;
    self.reasonablePriceTitleLabel = [UILabel labelWithText:Launguage(@"str_fair_price") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.priceLabel.sl_maxX, topMargin, labelWidth, labelHeight) superview:self];
    self.reasonablePriceLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.reasonablePriceTitleLabel.sl_x, self.reasonablePriceTitleLabel.sl_maxY, self.reasonablePriceTitleLabel.sl_width, labelHeight) superview:self];
    
    self.indexPriceTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_INDEX_PRI") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.reasonablePriceTitleLabel.sl_x, self.reasonablePriceLabel.sl_maxY, self.reasonablePriceTitleLabel.sl_width, labelHeight) superview:self];
    self.indexPriceLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.indexPriceTitleLabel.sl_x, self.indexPriceTitleLabel.sl_maxY, self.indexPriceTitleLabel.sl_width, labelHeight) superview:self];
    
    self.rateTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_ZJFL") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.reasonablePriceTitleLabel.sl_maxX, self.reasonablePriceTitleLabel.sl_y, labelWidth, labelHeight) superview:self];
    self.rateLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.rateTitleLabel.sl_x, self.rateTitleLabel.sl_maxY, self.rateTitleLabel.sl_width, labelHeight) superview:self];
    
    self.tradingVolumeTitleLabel = [UILabel labelWithText:Launguage(@"str_24Vol") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.rateTitleLabel.sl_x, self.rateLabel.sl_maxY, self.rateTitleLabel.sl_width, labelHeight) superview:self];
    self.tradingVolumeLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.tradingVolumeTitleLabel.sl_x, self.tradingVolumeTitleLabel.sl_maxY, self.tradingVolumeTitleLabel.sl_width, labelHeight) superview:self];
    
    self.rightArrowButton = [UIButton buttonExtensionWithTitle:nil TitleColor:nil Image:[UIImage imageWithName:@"btn-back-white"] font:nil target:self action:@selector(rightArrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.rightArrowButton.frame = CGRectMake(self.sl_width - leftMargin - rightArrowWidth, self.sl_height / 2 - rightArrowWidth / 2, rightArrowWidth, rightArrowWidth);
    self.rightArrowButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.rightArrowButton];
}


- (void)updateViewWithItemModel:(BTItemModel *)itemModel {
    NSString *price = [itemModel.last_px toSmallPriceWithContractID:itemModel.instrument_id];
    self.priceLabel.text = price ? price : @"--";
    
    UIColor *color = [SLConfig defaultConfig].redColorForSell;
    NSString *cha = @"+";
    if (itemModel.trend == BTPriceFluctuationDown) {
        color = [SLConfig defaultConfig].greenColorForBuy;;
        cha = @"-";
    }
    
    NSString *exchange = [Common currentPriceWithCoin:[NSString stringWithFormat:@"%@/%@",itemModel.contractInfo.base_coin,itemModel.contractInfo.quote_coin] currentPrice:itemModel.last_px];
    self.legalTenderPriceLabel.text = [NSString stringWithFormat:@"≈ %@", exchange];
    
    self.currentGainsLabel.text = [NSString stringWithFormat:@"%@  %@", [itemModel.change_rate toSmallPriceWithContractID:itemModel.instrument_id], [itemModel.change_rate toPercentString:3] ? [itemModel.change_rate toPercentString:2] : @"--"];
    self.currentGainsLabel.textColor = color;
    
    NSString *index = [itemModel.index_px toSmallPriceWithContractID:itemModel.instrument_id];
    index = index ? index : @"--";
    self.indexPriceLabel.text = index;
    
    NSString *fundRate = itemModel.funding_rate ? [itemModel.funding_rate toPercentString:4] : @"0";
    self.rateLabel.text = fundRate;
    
    NSString *fairPriceStr = [itemModel.fair_px toSmallPriceWithContractID:itemModel.instrument_id];
    fairPriceStr = fairPriceStr ? fairPriceStr : @"--";
    self.reasonablePriceLabel.text = fairPriceStr;
    
    NSString *dayNum = itemModel.qty_day ? [itemModel.qty_day toSmallValueWithContract:itemModel.instrument_id] : @"0";
    self.tradingVolumeLabel.text = [BTFormat totalVolumeFromNumberStr:dayNum];
}


#pragma mark - Actions

- (void)rightArrowButtonClick {
    if ([self.delegate respondsToSelector:@selector(headerView_rightArrowButtonClick)]) {
        [self.delegate headerView_rightArrowButtonClick];
    }
}


@end
