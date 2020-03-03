//
//  BTIndexDetailHeaderView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTIndexDetailHeaderView.h"

@interface BTIndexDetailHeaderView ()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timeinVLabel;
@property (nonatomic, strong) UILabel *fundRateLabel;
@end

@implementation BTIndexDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.backgroundColor = DARK_BARKGROUND_COLOR;
    self.dateLabel = [self createLabel];
    self.timeinVLabel = [self createLabel];
    self.fundRateLabel = [self createLabel];
    self.fundRateLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setStr1:(NSString *)str1 {
    _str1 = str1;
    self.dateLabel.text = str1;
}

- (void)setStr2:(NSString *)str2 {
    _str2 = str2;
    self.timeinVLabel.text = str2;
}

- (void)setStr3:(NSString *)str3 {
    _str3 = str3;
    self.fundRateLabel.text = str3;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.frame = CGRectMake(SL_MARGIN, 0, (SL_SCREEN_WIDTH - SL_MARGIN*2)* 0.45, SL_getWidth(20));
    self.timeinVLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame), 0, (SL_SCREEN_WIDTH - SL_MARGIN*2) * 0.275, SL_getWidth(20));
    self.fundRateLabel.frame = CGRectMake(CGRectGetMaxX(self.timeinVLabel.frame), 0, (SL_SCREEN_WIDTH - SL_MARGIN*2) * 0.275, SL_getWidth(20));
    self.dateLabel.sl_centerY = self.timeinVLabel.sl_centerY = self.fundRateLabel.sl_centerY = self.sl_height * 0.5;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = GARY_BG_TEXT_COLOR;
    [self addSubview:label];
    return label;
}

@end
