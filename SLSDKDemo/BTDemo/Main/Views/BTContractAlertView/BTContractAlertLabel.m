//
//  BTContractAlertLabel.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/17.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTContractAlertLabel.h"

@interface BTContractAlertLabel ()
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation BTContractAlertLabel

- (void)setContStr:(NSString *)contStr {
    _contStr = contStr;
    self.detailLabel.text = contStr;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.detailLabel.font = font;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.numLabel.frame = CGRectMake(0, SL_MARGIN * 0.3, SL_getWidth(18), SL_getWidth(18));
    self.numLabel.layer.cornerRadius = 9;
    self.numLabel.layer.masksToBounds = YES;
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.numLabel.frame) + SL_MARGIN * 0.5, 0, self.sl_width -CGRectGetMaxX(self.numLabel.frame) - SL_MARGIN * 0.5, SL_getWidth(20));
    if (self.titleLabel.text.length <= 0) {
        self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.numLabel.frame) + SL_MARGIN * 0.5, 0 , self.sl_width -CGRectGetMaxX(self.numLabel.frame) - SL_MARGIN * 0.5, self.sl_height);
    } else {
        self.titleLabel.sl_centerY = self.numLabel.sl_centerY;
        self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.numLabel.frame) + SL_MARGIN * 0.5, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 0.5,  self.sl_width -CGRectGetMaxX(self.numLabel.frame) - SL_MARGIN * 0.5, self.sl_height - (CGRectGetMaxY( self.titleLabel.frame) + SL_MARGIN * 0.5));
    }
}

- (UILabel *)numLabel {
    if (_numLabel == nil) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:15];
        _numLabel.textColor = MAIN_BTN_TITLE_COLOR;
        _numLabel.backgroundColor = [UIColor colorWithHex:@"#97b0d6"];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numLabel];
    }
    return _numLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = DARK_BARKGROUND_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = GARY_BG_TEXT_COLOR;
        _detailLabel.numberOfLines = 0;
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

@end
