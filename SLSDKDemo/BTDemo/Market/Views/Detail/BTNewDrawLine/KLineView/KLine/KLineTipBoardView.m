//
//  KLineTipBoardView.m
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "KLineTipBoardView.h"

@interface KLineTipBoardView ()
@property (nonatomic, strong) UILabel *openLabel;
@property (nonatomic, strong) UILabel *closelabel;
@property (nonatomic, strong) UILabel *highLabel;
@property (nonatomic, strong) UILabel *lowLabel;
@property (nonatomic, strong) UILabel *chaLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation KLineTipBoardView

#pragma mark - life cycle

- (id)init {
    if (self = [super init]) {
//        [self _setup];
         [self initChildViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
//        [self _setup];
         [self initChildViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self _setup];
        [self initChildViews];
    }
    return self;
}

- (void)initChildViews {
    self.backgroundColor = MAIN_COLOR;
    self.openLabel = [self createdLabel];
    self.closelabel = [self createdLabel];
    self.highLabel = [self createdLabel];
    self.lowLabel = [self createdLabel];
    self.chaLabel = [self createdLabel];
    self.volumeLabel = [self createdLabel];
    self.dateLabel = [self createdLabel];
    self.timeLabel = [self createdLabel];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isScreen) {
        self.dateLabel.frame = CGRectMake(SL_MARGIN * 0.5, SL_MARGIN * 0.5, self.sl_width - SL_MARGIN, (self.sl_height - SL_getWidth(25))/8.0);
        self.timeLabel.frame = CGRectMake(self.dateLabel.sl_x, CGRectGetMaxY(self.dateLabel.frame), self.dateLabel.sl_width, self.dateLabel.sl_height);
        self.openLabel.frame = CGRectMake(self.timeLabel.sl_x, CGRectGetMaxY(self.timeLabel.frame) + SL_MARGIN * 0.5, self.timeLabel.sl_width, self.timeLabel.sl_height);
        self.closelabel.frame = CGRectMake(self.openLabel.sl_x, CGRectGetMaxY(self.openLabel.frame), self.openLabel.sl_width, self.openLabel.sl_height);
        self.highLabel.frame = CGRectMake(self.closelabel.sl_x, CGRectGetMaxY(self.closelabel.frame) + SL_MARGIN * 0.5, self.closelabel.sl_width, self.closelabel.sl_height);
        self.lowLabel.frame = CGRectMake(self.highLabel.sl_x, CGRectGetMaxY(self.highLabel.frame), self.highLabel.sl_width, self.highLabel.sl_height);
        self.chaLabel.frame = CGRectMake(self.lowLabel.sl_x, CGRectGetMaxY(self.lowLabel.frame) + SL_MARGIN * 0.5, self.lowLabel.sl_width, self.lowLabel.sl_height);
        self.volumeLabel.frame = CGRectMake(self.chaLabel.sl_x, CGRectGetMaxY(self.chaLabel.frame), self.chaLabel.sl_width, self.chaLabel.sl_height);
        
    } else {
        self.openLabel.frame = CGRectMake(0, 0, self.sl_width/4, self.sl_height/2);
        self.closelabel.frame = CGRectMake(0, self.sl_height/2, self.sl_width/4, self.sl_height/2);
        self.highLabel.frame = CGRectMake(self.sl_width/4, 0, self.sl_width/4, self.sl_height/2);
        self.lowLabel.frame = CGRectMake(self.sl_width/4, self.sl_height/2, self.sl_width/4, self.sl_height/2);
        self.chaLabel.frame = CGRectMake(self.sl_width/2, 0, self.sl_width/4, self.sl_height/2);
        self.volumeLabel.frame = CGRectMake(self.sl_width/2, self.sl_height/2, self.sl_width/4, self.sl_height/2);
        self.dateLabel.frame = CGRectMake((self.sl_width/4) *3, 0, self.sl_width/4, self.sl_height/2);
        self.timeLabel.frame = CGRectMake((self.sl_width/4) *3, self.sl_height/2, self.sl_width/4, self.sl_height/2);
    }
}


- (UILabel *)createdLabel {
    UILabel *label = [UILabel new];
    label.textColor = GARY_BG_TEXT_COLOR;
    label.backgroundColor = self.backgroundColor;
    label.font = [UIFont systemFontOfSize:10];
    [self addSubview:label];
//    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)setOpen:(NSString *)open {
    self.openLabel.text = open;
}

- (void)setClose:(NSString *)close {
    self.closelabel.text = close;
}

- (void)setHigh:(NSString *)high {
    self.highLabel.text = high;
}

- (void)setLow:(NSString *)low {
    self.lowLabel.text = low;
}

- (void)setChange:(NSString *)change {
    self.chaLabel.text = change;
}

- (void)setVolume:(NSString *)volume {
    self.volumeLabel.text =volume;
}

- (void)setTime:(NSString *)time {
    self.timeLabel.text = time;
}

- (void)setDate:(NSString *)date {
    self.dateLabel.text = date;
}

- (void)setTrendColor:(UIColor *)trendColor {
    self.chaLabel.textColor = self.volumeLabel.textColor = self.lowLabel.textColor = self.highLabel.textColor = self.closelabel.textColor = self.openLabel.textColor = trendColor;
}

@end
