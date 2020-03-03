//
//  BTContractTextView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTContractTextView.h"
#import "BTTextField.h"

@interface BTContractTextView ()
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *marketPrice;
@property (nonatomic, strong) UIButton *martekPriceBtn;
@end

@implementation BTContractTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.backgroundColor = [MAIN_BTN_COLOR colorWithAlphaComponent:0.1];
    self.layer.borderColor = [MAIN_BTN_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.unitLabel.frame = CGRectMake(self.sl_width - SL_getWidth(60) - SL_MARGIN, SL_MARGIN, SL_getWidth(60), self.sl_height - 2 * SL_MARGIN);
    self.defineView.frame = CGRectMake(0, SL_MARGIN, self.sl_width - SL_MARGIN - SL_getWidth(60), self.sl_height - SL_MARGIN * 2);
    self.marketPrice.frame = CGRectMake(SL_MARGIN, SL_MARGIN, self.sl_width - SL_MARGIN * 2 - SL_getWidth(70), self.sl_height - 2 * SL_MARGIN);
}

- (void)setType:(BTContractTextFieldType)type {
    _type = type;
    if (_type == BTContractTextMarketPrice) {
        self.defineView.hidden = YES;
//        self.unitLabel.hidden = YES;
        self.marketPrice.hidden = NO;
        self.marketPrice.text = Launguage(@"str_market");
    } else if (_type == BTContractTextLimitPrice) {
        self.defineView.hidden = NO;
        self.placeholder = Launguage(@"BT_MAIN_P");
        self.unitLabel.hidden = NO;
        self.marketPrice.hidden = YES;
    } else if (_type == BTContractTextVolume) {
        self.defineView.hidden = NO;
        self.placeholder = Launguage(@"BT_MAIN_V");
        self.unitLabel.hidden = NO;
        self.marketPrice.hidden = YES;
    } else if (_type == BTContractTextTrigger) {
        self.defineView.hidden = NO;
        self.unitLabel.hidden = NO;
        self.marketPrice.hidden = YES;
    } else if (_type == BTContractTextPerform) {
        self.defineView.hidden = NO;
        self.placeholder = @"执行价格";
        self.unitLabel.hidden = NO;
        self.marketPrice.hidden = YES;
        [self.martekPriceBtn sizeToFit];
        self.martekPriceBtn.sl_width = self.martekPriceBtn.sl_width + SL_MARGIN;
        self.martekPriceBtn.sl_height = SL_getWidth(20);
        self.martekPriceBtn.sl_centerY = self.sl_height * 0.5;
        self.martekPriceBtn.sl_x = self.sl_width - SL_MARGIN - self.martekPriceBtn.sl_width;
        self.unitLabel.frame = CGRectMake(self.martekPriceBtn.sl_x - SL_getWidth(50) - SL_MARGIN, SL_MARGIN, SL_getWidth(50), self.sl_height - 2 * SL_MARGIN);
        self.defineView.frame = CGRectMake(0, SL_MARGIN, self.martekPriceBtn.sl_x - SL_getWidth(50), self.sl_height - SL_MARGIN * 2);
        self.martekPriceBtn.layer.borderColor = MAIN_GARY_TEXT_COLOR.CGColor;
        self.martekPriceBtn.selected = NO;
    } else if (_type == BTContractTextBuyOnePrice) {
        self.defineView.hidden = YES;
//        self.unitLabel.hidden = YES;
        self.marketPrice.hidden = NO;
        self.marketPrice.text = Launguage(@"str_buyOne");
    } else if (_type == BTContractTextSellOnePrice) {
        self.defineView.hidden = YES;
//        self.unitLabel.hidden = YES;
        self.marketPrice.hidden = NO;
        self.marketPrice.text = Launguage(@"str_sellOne");
    } else if (_type == BTContractTextMarketPerform) {
        self.defineView.hidden = YES;
        self.placeholder = @"执行价格";
        self.unitLabel.hidden = NO;
        self.marketPrice.hidden = NO;
        [self.martekPriceBtn sizeToFit];
        self.martekPriceBtn.sl_width = self.martekPriceBtn.sl_width + SL_MARGIN;
        self.martekPriceBtn.sl_height = SL_getWidth(20);
        self.martekPriceBtn.sl_centerY = self.sl_height * 0.5;
        self.martekPriceBtn.sl_x = self.sl_width - SL_MARGIN - self.martekPriceBtn.sl_width;
        self.unitLabel.frame = CGRectMake(self.martekPriceBtn.sl_x - SL_getWidth(50) - SL_MARGIN, SL_MARGIN, SL_getWidth(50), self.sl_height - 2 * SL_MARGIN);
        self.defineView.frame = CGRectMake(0, SL_MARGIN, self.martekPriceBtn.sl_x - SL_getWidth(50), self.sl_height - SL_MARGIN * 2);
        self.martekPriceBtn.layer.borderColor = MAIN_BTN_COLOR.CGColor;
        self.martekPriceBtn.selected = YES;
    }
}

- (NSString *)currentValue {
    return self.defineView.text;
}

- (void)setUnitStr:(NSString *)unitStr {
    _unitStr = unitStr;
    self.unitLabel.text = unitStr;
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    attrs[NSForegroundColorAttributeName] = GARY_BG_TEXT_COLOR;
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:placeholder attributes:attrs];
    self.defineView.attributedPlaceholder = attStr;
}

#pragma mark - action

- (void)didClickMarketPriceBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(contractTextViewDidClickMarketPriceBtn:)]) {
        [self.delegate contractTextViewDidClickMarketPriceBtn:sender];
    }
}

- (void)textFieldChanged {
    SLLog(@"%@",self.defineView.text);
    if ([self.delegate respondsToSelector:@selector(contractTextViewValuehasChange:)]) {
        [self.delegate contractTextViewValuehasChange:self];
    }
}

#pragma mark - lazy

- (BTTextField *)defineView {
    if (_defineView == nil) {
        _defineView = [[BTTextField alloc] init];
        _defineView.font = [UIFont systemFontOfSize:15];
        _defineView.textColor = MAIN_BTN_TITLE_COLOR;
        _defineView.backgroundColor = [UIColor clearColor];
        _defineView.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_defineView];
        [_defineView addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _defineView;
}

- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = [UIFont systemFontOfSize:14];
        _unitLabel.textColor = GARY_BG_TEXT_COLOR;
        _unitLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_unitLabel];
    }
    return _unitLabel;
}

- (UILabel *)marketPrice {
    if (_marketPrice == nil) {
        _marketPrice = [[UILabel alloc] init];
        _marketPrice.font = [UIFont systemFontOfSize:15];
        _marketPrice.textColor = MAIN_GARY_TEXT_COLOR;
        _marketPrice.text = Launguage(@"str_market");
//        _marketPrice.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_marketPrice];
    }
    return _marketPrice;
}

- (UIButton *)martekPriceBtn {
    if (_martekPriceBtn == nil) {
        _martekPriceBtn = [[UIButton alloc] init];
        [_martekPriceBtn setTitle:Launguage(@"str_market") forState:UIControlStateNormal];
        _martekPriceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_martekPriceBtn setTitleColor:MAIN_GARY_TEXT_COLOR forState:UIControlStateNormal];
        [_martekPriceBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
        _martekPriceBtn.layer.borderColor = MAIN_GARY_TEXT_COLOR.CGColor;
        _martekPriceBtn.layer.borderWidth = 1;
        _martekPriceBtn.layer.cornerRadius = 1;
        _martekPriceBtn.layer.masksToBounds = YES;
        [_martekPriceBtn addTarget:self action:@selector(didClickMarketPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_martekPriceBtn];
    }
    return _martekPriceBtn;
}

@end
