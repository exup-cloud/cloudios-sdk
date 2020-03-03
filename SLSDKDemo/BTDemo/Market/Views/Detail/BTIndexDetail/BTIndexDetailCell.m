//
//  BTIndexDetailCell.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTIndexDetailCell.h"

@interface BTIndexDetailCell ()
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *fundRateLabel;

@property (nonatomic, strong) UILabel *timeInterval;

@end

@implementation BTIndexDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.backgroundColor = MAIN_COLOR;
    self.timeLabel = [self createLabel];
    self.fundRateLabel = [self createLabel];
    self.fundRateLabel.textAlignment = NSTextAlignmentRight;
    self.timeInterval = [self createLabel];
}

- (void)setModel:(BTIndexDetailModel *)model {
    _model = model;
    self.timeLabel.text = [BTFormat timeOnlyDateFromDateStr:model.timestamp.stringValue];
    if (self.type == 1) {
        self.fundRateLabel.text = [NSString stringWithFormat:@"%@ %@",model.vol,model.unit];
    } else {
        self.timeInterval.text = @"每八小时";
        self.fundRateLabel.text = [model.rate toPercentString:4];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.type == 1) {
        self.timeLabel.frame = CGRectMake(SL_MARGIN, 0, SL_SCREEN_WIDTH * 0.5 - SL_MARGIN, SL_getWidth(20));
        self.timeLabel.sl_centerY = self.sl_height * 0.5;
        self.fundRateLabel.frame = CGRectMake(SL_SCREEN_WIDTH * 0.5, 0, self.timeLabel.sl_width, SL_getWidth(20));
        self.fundRateLabel.sl_centerY = self.timeLabel.sl_centerY;
    } else {
        self.timeLabel.frame = CGRectMake(SL_MARGIN, 0, (SL_SCREEN_WIDTH - SL_MARGIN*2)* 0.45, SL_getWidth(20));
        self.timeInterval.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame), 0, (SL_SCREEN_WIDTH - SL_MARGIN * 2) *0.275, SL_getWidth(20));
        self.fundRateLabel.frame = CGRectMake(CGRectGetMaxX(self.timeInterval.frame), 0, (SL_SCREEN_WIDTH - SL_MARGIN * 2) *0.275, SL_getWidth(20));
        self.timeLabel.sl_centerY = self.timeInterval.sl_centerY = self.fundRateLabel.sl_centerY = self.sl_height * 0.5;
    }
    
}

#pragma mark - kongjian

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = MAIN_GARY_TEXT_COLOR;
    [self.contentView addSubview:label];
    return label;
}

@end
