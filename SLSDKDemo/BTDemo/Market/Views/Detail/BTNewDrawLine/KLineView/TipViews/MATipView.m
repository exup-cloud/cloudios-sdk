//
//  MATipView.m
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "MATipView.h"
#import "Masonry.h"

@interface MATipView ()
@property (nonatomic, strong) UILabel *minAvgPriceLbl;
@property (nonatomic, strong) UILabel *midAvgPriceLbl;
@property (nonatomic, strong) UILabel *maxAvgPriceLbl;

@property (nonatomic, strong) UILabel *avg_label;

@end

@implementation MATipView

- (instancetype)initWithFrame:(CGRect)frame Type:(NSInteger)type {
    if (self = [super initWithFrame:frame]) {
        if (type == 0) {
            [self setup];
            [self addPageSubviews];
            [self layoutPageSubviews];
        } else {
            [self setUpAvgPrice];
        }
    }
    return self;
}

- (void)setUpAvgPrice {
    [self addSubview:self.avg_label];
    self.avg_label.font = [UIFont systemFontOfSize:10.f];
    self.avg_label.frame = CGRectMake(SL_MARGIN, 0, self.sl_width - 2 * SL_MARGIN, self.sl_height);
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self addPageSubviews];
        [self layoutPageSubviews];
    }
    return self;
}

- (void)setup {
    self.font = [UIFont systemFontOfSize:9.0f];
    self.minAvgPriceColor = MAIN_BTN_COLOR;
    self.midAvgPriceColor = GARY_BG_TEXT_COLOR;
    self.maxAvgPriceColor = IMPORT_BTN_COLOR;
}

- (void)addPageSubviews {
    [self addSubview:self.minAvgPriceLbl];
    [self addSubview:self.midAvgPriceLbl];
    [self addSubview:self.maxAvgPriceLbl];
}

- (void)layoutPageSubviews {
//    [self.minAvgPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@5.0f);
//        make.sl_centerY.equalTo(self.mas_centerY);
//    }];
//
//    [self.midAvgPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.sl_centerX.equalTo(self.mas_centerX);
//        make.sl_centerY.equalTo(self.mas_centerY);
//    }];
//
//    [self.maxAvgPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.mas_trailing).with.offset(-5.0f);
//        make.sl_centerY.equalTo(self.mas_centerY);
//    }];
    self.minAvgPriceLbl.frame = CGRectMake(0, 0, self.sl_width/3.0, self.sl_height);
    self.midAvgPriceLbl.frame = CGRectMake(CGRectGetMaxX(self.minAvgPriceLbl.frame), 0, self.minAvgPriceLbl.sl_width, self.minAvgPriceLbl.sl_height);
    self.maxAvgPriceLbl.frame = CGRectMake(CGRectGetMaxX(self.midAvgPriceLbl.frame), 0, self.minAvgPriceLbl.sl_width, self.minAvgPriceLbl.sl_height);
}

#pragma mark - getters

- (UILabel *)minAvgPriceLbl {
    if (!_minAvgPriceLbl) {
        _minAvgPriceLbl = [UILabel new];
        _minAvgPriceLbl.font = self.font;
        _minAvgPriceLbl.textColor = self.minAvgPriceColor;
        _minAvgPriceLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _minAvgPriceLbl;
}

- (UILabel *)midAvgPriceLbl {
    if (!_midAvgPriceLbl) {
        _midAvgPriceLbl = [UILabel new];
        _midAvgPriceLbl.font = self.font;
        _midAvgPriceLbl.textColor = self.midAvgPriceColor;
        _midAvgPriceLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _midAvgPriceLbl;
}

- (UILabel *)maxAvgPriceLbl {
    if (!_maxAvgPriceLbl) {
        _maxAvgPriceLbl = [UILabel new];
        _maxAvgPriceLbl.font = self.font;
        _maxAvgPriceLbl.textColor = self.maxAvgPriceColor;
        _maxAvgPriceLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _maxAvgPriceLbl;
}

- (UILabel *)avg_label {
    if (_avg_label == nil) {
        _avg_label = [UILabel new];
        _avg_label.font = self.font;
        _avg_label.textColor = [UIColor orangeColor];
    }
    return _avg_label;
}

#pragma mark - setters

- (void)setMinAvgPrice:(NSString *)minAvgPrice {
    _minAvgPriceLbl.text = minAvgPrice == nil || minAvgPrice.length == 0 ? @"MA5：0.00" : minAvgPrice;
}

- (void)setMidAvgPrice:(NSString *)midAvgPrice {
    _midAvgPriceLbl.text = midAvgPrice == nil || midAvgPrice.length == 0 ? @"MA10：0.00" : midAvgPrice;
}

- (void)setMaxAvgPrice:(NSString *)maxAvgPrice {
    _maxAvgPriceLbl.text = maxAvgPrice == nil || maxAvgPrice.length == 0 ? @"MA20：0.00" : maxAvgPrice;
}

- (void)setavg_px:(NSString *)avg_px {
    _avg_label.text = avg_px == nil || avg_px.length == 0? @"AVG: 0.00" :  [NSString stringWithFormat:@"AVG:%@",avg_px];
}

@end
