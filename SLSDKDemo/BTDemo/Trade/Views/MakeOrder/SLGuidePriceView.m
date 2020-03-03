//
//  SLGuidePriceView.m
//  BTTest
//
//  Created by wwly on 2019/9/3.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLGuidePriceView.h"

@interface SLGuidePriceView ()

/// 指数价格
@property (nonatomic, strong) UILabel * indexPriceTitleLabel;
@property (nonatomic, strong) UILabel * indexPriceLabel;
/// 合理价格
@property (nonatomic, strong) UILabel * reasonablePriceTitleLabel;
@property (nonatomic, strong) UILabel * reasonablePriceLabel;
/// 资金费率
@property (nonatomic, strong) UILabel * rateTitleLabel;
@property (nonatomic, strong) UILabel * rateLabel;

@end

@implementation SLGuidePriceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    UIColor *titleColor = [UIColor blackColor];//[SLConfig defaultConfig].lightGrayTextColor;
    UIColor *valueColor = [UIColor grayColor];//[SLConfig defaultConfig].lightTextColor;
    
    UIFont *titleFont = [UIFont systemFontOfSize:12];
    
    self.indexPriceTitleLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@:",Launguage(@"BT_CA_INDEX_PRI")] textAlignment:NSTextAlignmentLeft textColor:titleColor font:titleFont numberOfLines:1 frame:CGRectMake(0, 0, 0, 20) superview:self];
    CGFloat titleWidth = [self.indexPriceTitleLabel textWidth];
    self.indexPriceTitleLabel.sl_width = titleWidth;
    self.indexPriceLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:valueColor font:titleFont numberOfLines:1 frame:CGRectMake(self.indexPriceTitleLabel.sl_maxX + 2, self.indexPriceTitleLabel.sl_y, self.sl_width - self.indexPriceTitleLabel.sl_maxY, self.indexPriceTitleLabel.sl_height) superview:self];
    
    self.reasonablePriceTitleLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@:",Launguage(@"str_fair_price")] textAlignment:NSTextAlignmentLeft textColor:titleColor font:titleFont numberOfLines:1 frame:CGRectMake(self.indexPriceTitleLabel.sl_x, self.indexPriceTitleLabel.sl_maxY, self.indexPriceTitleLabel.sl_width,  self.indexPriceTitleLabel.sl_height) superview:self];
    self.reasonablePriceLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:valueColor font:titleFont numberOfLines:1 frame:CGRectMake(self.indexPriceLabel.sl_x, self.reasonablePriceTitleLabel.sl_y, self.indexPriceLabel.sl_width, self.reasonablePriceTitleLabel.sl_height) superview:self];
    
    self.rateTitleLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@:",Launguage(@"BT_CA_ZJFL")] textAlignment:NSTextAlignmentLeft textColor:titleColor font:titleFont numberOfLines:1 frame:CGRectMake(self.indexPriceTitleLabel.sl_x, self.reasonablePriceTitleLabel.sl_maxY, self.reasonablePriceTitleLabel.sl_width, self.indexPriceTitleLabel.sl_height) superview:self];
    self.rateLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:valueColor font:titleFont numberOfLines:1 frame:CGRectMake(self.indexPriceLabel.sl_x, self.rateTitleLabel.sl_y, self.indexPriceLabel.sl_width, self.rateTitleLabel.sl_height) superview:self];
}


- (void)updateViewWithItmeModel:(BTItemModel *)itemModel {
    NSString *index = [itemModel.index_px toSmallPriceWithContractID:itemModel.instrument_id];
    index = index ? index : @"--";
    self.indexPriceLabel.text = index;
    
    NSString *fundRate = [itemModel.funding_rate toPercentString:4];
    fundRate = fundRate ? fundRate : @"--";
    self.rateLabel.text = fundRate;
    
    NSString *fairPriceStr = [itemModel.fair_px toSmallPriceWithContractID:itemModel.instrument_id];
    fairPriceStr = fairPriceStr ? fairPriceStr : @"--";
    self.reasonablePriceLabel.text = fairPriceStr;
}


@end
