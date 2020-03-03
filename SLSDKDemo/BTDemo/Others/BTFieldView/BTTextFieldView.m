//
//  BTTextFieldView.m
//  BTStore
//
//  Created by 健 王 on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTTextFieldView.h"
#import "BTTextField.h"
#import "UIButton+Extension.h"
#import "SLButton.h"

@interface BTTextFieldView ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation BTTextFieldView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = MAIN_COLOR;
    }
    return self;
}

- (void)setupframe {
    if (self.type == BTTextFieldDefaultType) {
        self.firstLabel.frame = CGRectMake(SL_MARGIN, 0, self.sl_width * 0.25, self.sl_height);
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), 0, self.sl_width* 0.75 - SL_MARGIN, self.sl_height);
    } else if (self.type == BTTextFieldLastLabelType) {
        self.firstLabel.frame = CGRectMake(SL_MARGIN, 0, self.sl_width * 0.25, self.sl_height);

        [self.lastLabel sizeToFit];
        self.lastLabel.sl_x = self.sl_width - SL_MARGIN - self.lastLabel.sl_width;
        self.lastLabel.sl_centerY = self.sl_height * 0.5;
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), 0, self.lastLabel.sl_x - CGRectGetMaxX(self.firstLabel.frame), self.sl_height);
    } else if (self.type == BTTextFieldButtonType) {
        self.firstLabel.frame = CGRectMake(SL_MARGIN, 0, self.sl_width * 0.25, self.sl_height);

        self.commiTip.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame) - SL_MARGIN * 2, (self.sl_height - SL_getWidth(30)) * 0.5, SL_getWidth(30), SL_getWidth(30));
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), 0, self.sl_width - CGRectGetMaxX(self.commiTip.frame) - SL_MARGIN, self.sl_height);
    } else if (self.type == BTTextFieldTableSelectType) {
        [self.firstLabel sizeToFit];
        self.firstLabel.sl_x = SL_MARGIN;
        self.firstLabel.sl_centerY = self.sl_height * 0.5;
        self.commiTip.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame) + SL_MARGIN * 0.3, 0, SL_getWidth(15), SL_getWidth(15));
        self.commiTip.sl_centerY = self.sl_height * 0.5;
        [self.lastLabel sizeToFit];
        self.lastLabel.sl_x = self.sl_width - SL_MARGIN - self.lastLabel.sl_width;
        self.lastLabel.sl_centerY = self.sl_height * 0.5;
        self.textField.frame = CGRectMake(self.sl_width * 0.25 + SL_MARGIN, 0, self.lastLabel.sl_x - CGRectGetMaxX(self.firstLabel.frame), self.sl_height);
    } else if (self.type == BTTextFieldLastButtonType) {
        self.firstLabel.frame = CGRectMake(SL_MARGIN, 0, self.sl_width * 0.25, self.sl_height);
        self.lastButton2.frame = CGRectMake(self.sl_width - SL_getWidth(25) - SL_MARGIN, 0, SL_getWidth(25), SL_getWidth(25));
        self.lastButton2.sl_centerY = self.sl_height * 0.5;
        self.lineView.frame = CGRectMake(self.lastButton2.sl_x - SL_MARGIN, 0, 1, SL_getWidth(20));
        self.lineView.sl_centerY = self.sl_height * 0.5;
        self.lastButton1.frame = CGRectMake(self.lineView.sl_x - SL_getWidth(25) - SL_MARGIN, 0, SL_getWidth(25), SL_getWidth(25));
        self.lastButton1.sl_centerY = self.sl_height * 0.5;
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), 0, self.lastButton1.sl_x - CGRectGetMaxX(self.firstLabel.frame) - SL_MARGIN, self.sl_height);
    } else if (self.type == BTTextFieldLastOneButtonType) {
        self.firstLabel.frame = CGRectMake(SL_MARGIN, 0, self.sl_width * 0.25, self.sl_height);
        self.lastButton1.frame = CGRectMake(self.sl_width - SL_getWidth(25) - SL_MARGIN, 0, SL_getWidth(25), SL_getWidth(25));
         self.lastButton1.sl_centerY = self.sl_height * 0.5;
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), 0, self.lastButton1.sl_x - CGRectGetMaxX(self.firstLabel.frame) - SL_MARGIN, self.sl_height);
    } else if (self.type == BTTextFieldOTCTextType) {
        self.firstLabel.frame = CGRectMake(SL_MARGIN, 0, self.sl_width * 0.2, self.sl_height);
        
        [self.lastLabel sizeToFit];
        self.lastLabel.sl_x = self.sl_width - SL_MARGIN - self.lastLabel.sl_width;
        self.lastLabel.sl_centerY = self.sl_height * 0.5;
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), 0, self.lastLabel.sl_x - CGRectGetMaxX(self.firstLabel.frame), self.sl_height);
    } else if (self.type == BTTextFieldDepositType) {
        // 设计的真他妈丑
        self.firstLabel.frame = CGRectMake(SL_MARGIN, 0, self.sl_width * 0.7-SL_MARGIN, self.sl_height);
        self.lastLabel.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), 0, self.sl_width - CGRectGetMaxX(self.firstLabel.frame) , self.sl_height);
        self.backgroundColor = [[UIColor colorWithHex:@"#4E5674"] colorWithAlphaComponent:0.6];
        self.lastLabel.backgroundColor = MAIN_BTN_COLOR;
        self.lastLabel.textColor = MAIN_BTN_TITLE_COLOR;
    } else if (self.type == BTTextFieldNoLabelType) {
        self.textField.frame = CGRectMake(SL_MARGIN, 0, self.sl_width - SL_MARGIN * 2, self.sl_height);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupframe];
}

#pragma mark - action

- (void)didClickTipInfo {
    SLLog(@"click commiTip");
}

#pragma mark - lazy
- (BTTextField *)textField {
    if (_textField == nil) {
        _textField = [[BTTextField alloc] init];
        _textField.backgroundColor = MAIN_COLOR;
        _textField.textColor = MAIN_BTN_TITLE_COLOR;
        [self addSubview:_textField];
    }
    return _textField;
}

- (UILabel *)firstLabel {
    if (_firstLabel == nil) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.textColor = MAIN_BTN_TITLE_COLOR;
        _firstLabel.font = [UIFont systemFontOfSize:14];
//        _firstLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_firstLabel];
    }
    return _firstLabel;
}

- (UILabel *)lastLabel {
    if (_lastLabel == nil) {
        _lastLabel = [[UILabel alloc] init];
        _lastLabel.font = [UIFont systemFontOfSize:15];
        _lastLabel.textAlignment = NSTextAlignmentCenter;
        _lastLabel.textColor = MAIN_BTN_COLOR;
        [self addSubview:_lastLabel];
    }
    return _lastLabel;
}

- (UIButton *)commiTip {
    if (_commiTip == nil) {
        _commiTip = [UIButton buttonIExtensionWithTitle:nil TitleColor:nil Image:[UIImage imageWithName:@""] highLightedImage:nil target:nil  action:nil forControlEvents:UIControlEventTouchUpInside];
//        [_commiTip setBackgroundColor:MAIN_TEXT_COLOR];
        [_commiTip setImage:[UIImage imageWithName:@"3j"] forState:UIControlStateNormal];
        [self addSubview:_commiTip];
        _commiTip.hidden = YES;
    }
    return _commiTip;
}

- (UIButton *)lastButton1 {
    if (_lastButton1 == nil) {
        _lastButton1 = [self createBtnWithImage:@"icon-scan"];
    }
    return _lastButton1;
}

- (UIButton *)lastButton2 {
    if (_lastButton2 == nil) {
        _lastButton2 = [self createBtnWithImage:@"icon-address"];
    }
    return _lastButton2;
}

- (UIButton *)createBtnWithImage:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = GARY_BG_TEXT_COLOR;
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
