//
//  SLCurrentPriceView.m
//  BTTest
//
//  Created by wwly on 2019/9/3.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLCurrentPriceView.h"

@interface SLCurrentPriceView ()

/// 当前价格
@property (nonatomic, strong) UILabel * currentPriceLabel;

/// 当前涨跌幅
@property (nonatomic, strong) UILabel * currentGainsLabel;

@end

@implementation SLCurrentPriceView

- (void)updateViewWithItemModel:(BTItemModel *)itemModel {
    self.currentPriceLabel.text = [itemModel.last_px toSmallPriceWithContractID:itemModel.instrument_id];
    NSString *rate = [itemModel.change_rate toPercentString:3];
    if (itemModel.trend == BTPriceFluctuationUp) {
        [self.currentGainsLabel setBackgroundColor:UP_WARD_COLOR];
        rate = [NSString stringWithFormat:@" +%@ ",rate];
        self.currentPriceLabel.textColor = UP_WARD_COLOR;
    } else {
        rate = [NSString stringWithFormat:@" %@ ", rate];
        [self.currentGainsLabel setBackgroundColor:DOWN_COLOR];
        self.currentPriceLabel.textColor = DOWN_COLOR;
    }
    self.currentGainsLabel.text = rate;
    
    self.currentGainsLabel.sl_width = [self.currentGainsLabel textWidth];
    self.currentGainsLabel.sl_maxX = self.sl_width;
}


#pragma mark - lazy load

- (UILabel *)currentPriceLabel {
    if (_currentPriceLabel == nil) {
        _currentPriceLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].redColorForSell font:[UIFont systemFontOfSize:16] numberOfLines:1 frame:CGRectMake(0, 0, self.sl_width / 2, 30) superview:self];
        _currentPriceLabel.sl_centerY = self.sl_height / 2;
    }
    return _currentPriceLabel;
}

- (UILabel *)currentGainsLabel {
    if (_currentGainsLabel == nil) {
        _currentGainsLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(self.currentPriceLabel.sl_maxX, self.currentPriceLabel.sl_y, self.sl_width / 2, 20) superview:self];
        _currentGainsLabel.sl_centerY = self.currentPriceLabel.sl_centerY;
        _currentGainsLabel.sl_centerY = self.sl_height / 2;
        _currentGainsLabel.backgroundColor = [SLConfig defaultConfig].redColorForSell;
        _currentGainsLabel.layer.cornerRadius = 2;
        _currentGainsLabel.layer.masksToBounds = YES;
    }
    return _currentGainsLabel;
}

@end
