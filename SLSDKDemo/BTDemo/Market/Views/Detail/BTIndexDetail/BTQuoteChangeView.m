//
//  BTQuoteChangeView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/1.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTQuoteChangeView.h"

@interface BTQuoteChangeView ()
@property (nonatomic, copy) NSString *headerStr;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *currentPrice;
@property (nonatomic, strong) UILabel *highLabel;
@property (nonatomic, strong) UILabel *lowLabel;
@property (nonatomic, strong) UIImageView *arowView;
@end

@implementation BTQuoteChangeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.headerStr = title;
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.backgroundColor = MAIN_COLOR;
    self.headerLabel = [self createLabelWithFont:14 color:GARY_BG_TEXT_COLOR];
    self.headerLabel.textAlignment = NSTextAlignmentLeft;
    self.headerLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN, SL_SCREEN_WIDTH * 0.5, SL_getWidth(20));
    self.headerLabel.text = self.headerStr;
    self.bottomView = [self createViewWithAlpha:0.1];
    self.middleView = [self createViewWithAlpha:0.5];
    self.topView = [self createViewWithAlpha:1];
    self.bottomView.frame = CGRectMake(SL_MARGIN, self.sl_height - SL_getWidth(40), SL_SCREEN_WIDTH - 2 * SL_MARGIN, SL_MARGIN);
    self.middleView.frame = CGRectMake(SL_MARGIN, self.sl_height - SL_getWidth(40), SL_SCREEN_WIDTH - 2 * SL_MARGIN, SL_MARGIN);
    self.topView.frame = CGRectMake(SL_MARGIN, self.sl_height - SL_getWidth(40), SL_SCREEN_WIDTH - 2 * SL_MARGIN, SL_MARGIN);
    
    self.currentPrice = [self createLabelWithFont:13 color:MAIN_GARY_TEXT_COLOR];
    self.highLabel = [self createLabelWithFont:13 color:MAIN_GARY_TEXT_COLOR];
    self.lowLabel = [self createLabelWithFont:13 color:MAIN_GARY_TEXT_COLOR];
}

- (void)loadDataWithHigh:(NSString *)high low:(NSString *)low open:(NSString *)open close:(NSString *)close currentPrice:(NSString *)currentPrice {
    NSString *length = [high bigSub:low];
    CGFloat closeX;
    CGFloat openX;
    CGFloat currentPriceX;
    closeX = [[[close bigSub:low] bigDiv:length] floatValue] * self.bottomView.sl_width;
    openX = [[[open bigSub:low] bigDiv:length] floatValue] * self.bottomView.sl_width;
    currentPriceX = [[[currentPrice bigSub:low] bigDiv:length] floatValue] * self.bottomView.sl_width;
    if ([open GreaterThan:close]) { // 收盘-----开盘
        self.middleView.frame = CGRectMake(self.bottomView.sl_x + closeX, self.bottomView.sl_y, openX - closeX, self.bottomView.sl_height);
        self.topView.frame = CGRectMake(self.bottomView.sl_x + closeX, self.bottomView.sl_y, currentPriceX - closeX, self.bottomView.sl_height);
    } else {
        self.middleView.frame = CGRectMake(self.bottomView.sl_x + openX, self.bottomView.sl_y, closeX - openX, self.bottomView.sl_height);
        self.topView.frame = CGRectMake(self.bottomView.sl_x + openX, self.bottomView.sl_y, currentPriceX - openX, self.bottomView.sl_height);
    }
    
    self.currentPrice.text = [NSString stringWithFormat:@"%@ %@", Launguage(@"str_last"), currentPrice];
    [self.currentPrice sizeToFit];
    self.currentPrice.sl_centerX = currentPriceX + self.bottomView.sl_x;
    self.currentPrice.sl_y = self.bottomView.sl_y - SL_getWidth(30);
    
    self.arowView.frame = CGRectMake(self.currentPrice.sl_centerX, CGRectGetMaxY(self.currentPrice.frame), SL_MARGIN, SL_MARGIN);
    self.arowView.sl_centerX = self.currentPrice.sl_centerX;
    
    if (self.currentPrice.sl_x < SL_MARGIN) {
        self.currentPrice.sl_x = SL_MARGIN;
    } else if (CGRectGetMaxY(self.currentPrice.frame) > (self.sl_width - SL_MARGIN)) {
        self.currentPrice.sl_x = self.sl_width - SL_MARGIN - self.currentPrice.sl_width;
    }
    
    self.lowLabel.text = [NSString stringWithFormat:@"%@ %@", Launguage(@"MK_SP_LO"), low];
    [self.lowLabel sizeToFit];
    self.lowLabel.sl_x = SL_MARGIN;
    self.lowLabel.sl_y = CGRectGetMaxY(self.bottomView.frame) + SL_MARGIN * 0.5;
    
    self.highLabel.text = [NSString stringWithFormat:@"%@ %@", Launguage(@"MK_SP_HI"), high];
    [self.highLabel sizeToFit];
    self.highLabel.sl_y = self.lowLabel.sl_y;
    self.highLabel.sl_x = SL_SCREEN_WIDTH - SL_MARGIN - self.highLabel.sl_width;

}

#pragma mark - lazy

- (UIImageView *)arowView {
    if (_arowView == nil) {
        _arowView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"3j"]];
        [self addSubview:_arowView];
    }
    return _arowView;
}

- (UILabel *)createLabelWithFont:(CGFloat)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    return label;
}

- (UIView *)createViewWithAlpha:(CGFloat)alpha {
    UIView *view = [[UIView alloc] init];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = MAIN_BTN_COLOR.CGColor;
    view.backgroundColor = [MAIN_BTN_COLOR colorWithAlphaComponent:alpha];
    [self addSubview:view];
    return view;
}

@end
