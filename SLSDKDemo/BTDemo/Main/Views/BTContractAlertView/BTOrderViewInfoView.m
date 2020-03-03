//
//  BTOrderViewInfoView.m
//  BTStore
//
//  Created by 健 王 on 2018/5/8.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTOrderViewInfoView.h"

@interface BTOrderViewInfoView ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *num;
@property (nonatomic, strong) UILabel *coin;
@property (nonatomic, strong) UIView *line;
@end

@implementation BTOrderViewInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.backgroundColor = [UIColor whiteColor];
    self.title = [self createLabel];
    self.coin = [self createLabel];
    self.num = [self createLabel];
}

- (void)loadInfoWithTitle:(NSString *)title mainColor:(UIColor *)Color number:(NSString *)number numColor:(UIColor *)numColor endLabel:(NSString *)endText {
    self.title.text = title;
    self.title.textColor = Color;
    self.coin.text = endText;
    self.coin.textColor = Color;
    self.num.text = number;
    self.num.textColor = numColor;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isOTC) {
        self.title.frame = CGRectMake(0, SL_MARGIN, self.sl_width * 0.5 - SL_MARGIN, self.sl_height);
        self.title.sl_centerY = self.sl_height * 0.5;
        [self.coin sizeToFit];
        self.coin.sl_centerY = self.title.sl_centerY;
        self.coin.sl_x = self.sl_width - self.coin.sl_width - SL_MARGIN;
        if (self.coin.sl_width == 0) {
            self.num.frame = CGRectMake(CGRectGetMaxX(self.title.frame), 0, self.sl_width - CGRectGetMaxX(self.title.frame), SL_getWidth(20));
        } else {
            self.num.frame = CGRectMake(CGRectGetMaxX(self.title.frame), 0, self.coin.sl_x - CGRectGetMaxX(self.title.frame) - SL_MARGIN, SL_getWidth(20));
        }
        self.num.sl_centerY = self.coin.sl_centerY;
        self.num.textAlignment = NSTextAlignmentRight;
    } else {
        self.title.frame = CGRectMake(0, 0, self.sl_width * 0.5, self.sl_height);
        self.title.sl_centerY = self.sl_height * 0.5;
        [self.coin sizeToFit];
        self.coin.sl_centerY = self.title.sl_centerY;
        self.coin.sl_x = self.sl_width - self.coin.sl_width;
        if (self.coin.sl_width == 0) {
            self.num.frame = CGRectMake(CGRectGetMaxX(self.title.frame), 0, self.sl_width - CGRectGetMaxX(self.title.frame), SL_getWidth(20));
            
        } else {
            self.num.frame = CGRectMake(CGRectGetMaxX(self.title.frame), 0, self.coin.sl_x - CGRectGetMaxX(self.title.frame), SL_getWidth(20));
        }
        self.num.sl_centerY = self.coin.sl_centerY;
        self.num.textAlignment = NSTextAlignmentRight;
    }
    if (self.color) {
        self.line.frame = CGRectMake(0, 0, self.sl_width, 1);
        self.line.backgroundColor = self.color;
    } else {
        self.line.frame = CGRectMake(0, self.sl_height - 1, self.sl_width, 1);
    }
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    return label;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GARY_BG_TEXT_COLOR colorWithAlphaComponent:0.3];
        [self addSubview:_line];
    }
    return _line;
}

@end
