//
//  BTSelectCoinButton.m
//  BTStore
//
//  Created by 健 王 on 2018/3/30.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTSelectCoinButton.h"

@interface BTSelectCoinButton ()
@property (nonatomic, strong) UIImageView *arrow;
@end

@implementation BTSelectCoinButton

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"btn-next01"]];
    [self addSubview:self.arrow];
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.textColor = MAIN_BTN_TITLE_COLOR;
    self.tipsLabel.font = [UIFont systemFontOfSize:15];
    self.tipsLabel.backgroundColor = MAIN_COLOR;
    [self addSubview:self.tipsLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupFrame];
}

- (void)setupFrame {
    if (self.type == BTSelectCoinButtonContract) {
        [self.tipsLabel sizeToFit];
        self.tipsLabel.sl_x = SL_MARGIN;
        self.tipsLabel.sl_centerY = self.sl_height * 0.5;
        self.arrow.frame = CGRectMake(self.sl_width - SL_getWidth(20) - SL_MARGIN, 0, SL_getWidth(20), SL_getWidth(20));
        self.arrow.sl_centerY = self.tipsLabel.sl_centerY;
        
        [self.titleLabel sizeToFit];
        self.titleLabel.sl_centerY = self.tipsLabel.sl_centerY;
        self.titleLabel.sl_x = self.sl_width * 0.3;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    } else if (self.type == BTSelectCoinButtonDefault) {
        [self.tipsLabel sizeToFit];
        self.tipsLabel.sl_x = SL_MARGIN;
        self.tipsLabel.sl_centerY = self.sl_height * 0.5;
        
        self.arrow.frame = CGRectMake(self.sl_width - SL_getWidth(20) - SL_MARGIN, 0, SL_getWidth(20), SL_getWidth(20));
        self.arrow.sl_centerY = self.tipsLabel.sl_centerY;
        [self.titleLabel sizeToFit];
        self.titleLabel.sl_centerY = self.tipsLabel.sl_centerY;
        self.titleLabel.sl_x = self.arrow.sl_x - self.titleLabel.sl_width - SL_MARGIN;
        
        self.imageView.frame = CGRectMake(self.titleLabel.sl_x - SL_MARGIN - SL_getWidth(26), 0, SL_getWidth(26), SL_getWidth(26));
        self.imageView.sl_centerY = self.sl_height * 0.5;
    } else if (self.type == BTSelectCoinButtonCalculator) {
        [self.tipsLabel sizeToFit];
        self.tipsLabel.sl_x = SL_MARGIN;
        self.tipsLabel.sl_centerY = self.sl_height * 0.5;
        self.arrow.frame = CGRectMake(self.sl_width - SL_getWidth(20) - SL_MARGIN, 0, SL_getWidth(20), SL_getWidth(20));
        self.arrow.sl_centerY = self.tipsLabel.sl_centerY;
        [self.titleLabel sizeToFit];
        self.titleLabel.sl_centerY = self.tipsLabel.sl_centerY;
        self.titleLabel.sl_x = self.arrow.sl_x - self.titleLabel.sl_width - SL_MARGIN;
    }
}

@end
