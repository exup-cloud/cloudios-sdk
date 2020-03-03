//
//  BTDetailBidAskCell.m
//  BTStore
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTDetailBidAskCell.h"
#import "BTBidAskCellModel.h"

@interface BTDetailBidAskCell ()
@property (nonatomic, strong) UILabel *bid;
@property (nonatomic, strong) UILabel *bidPrice;
@property (nonatomic, strong) UILabel *bidNum;
@property (nonatomic, strong) UIView *bidBg;

@property (nonatomic, strong) UILabel *ask;
@property (nonatomic, strong) UILabel *askPrice;
@property (nonatomic, strong) UILabel *askNum;
@property (nonatomic, strong) UIView *askBg;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation BTDetailBidAskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = MAIN_COLOR;
    self.bid = [self createLabelWithColor:GARY_BG_TEXT_COLOR textAlignment:NSTextAlignmentLeft];
    self.bidPrice = [self createLabelWithColor:UP_WARD_COLOR textAlignment:NSTextAlignmentRight];
    self.bidNum = [self createLabelWithColor:GARY_BG_TEXT_COLOR textAlignment:NSTextAlignmentLeft];
    self.askPrice = [self createLabelWithColor:DOWN_COLOR textAlignment:NSTextAlignmentLeft];
    self.askNum = [self createLabelWithColor:GARY_BG_TEXT_COLOR textAlignment:NSTextAlignmentRight];
    self.ask = [self createLabelWithColor:GARY_BG_TEXT_COLOR textAlignment:NSTextAlignmentRight];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bid.frame = CGRectMake(SL_MARGIN, 0, 20, self.contentView.sl_height);
    self.bidNum.frame = CGRectMake(CGRectGetMaxX(self.bid.frame), 0, (self.contentView.sl_width - 4 * SL_MARGIN - 40)/4.f, self.contentView.sl_height);
    self.bidPrice.frame = CGRectMake(CGRectGetMaxX(self.bidNum.frame), 0, self.bidNum.sl_width, self.contentView.sl_height);
    self.askPrice.frame = CGRectMake(CGRectGetMaxX(self.bidPrice.frame) + SL_MARGIN * 2, 0, self.bidPrice.sl_width, self.bidPrice.sl_height);
    self.askNum.frame = CGRectMake(CGRectGetMaxX(self.askPrice.frame), 0, self.bidNum.sl_width, self.bidNum.sl_height);
    self.ask.frame = CGRectMake(self.sl_width - 30, 0, 20, self.bidNum.sl_height);
    self.lineView.frame = CGRectMake(0, self.contentView.sl_height - 0.5, self.contentView.sl_width, 0.5);
    self.bidBg.frame = CGRectMake((self.contentView.sl_width * 0.5 -SL_MARGIN) * (1-self.cellModel.bidLength) + SL_MARGIN, 1, (self.contentView.sl_width * 0.5 - SL_MARGIN) * self.cellModel.bidLength, self.contentView.sl_height - 1.5);
    self.askBg.frame = CGRectMake(self.contentView.sl_width * 0.5, 1, (self.contentView.sl_width * 0.5 - SL_MARGIN) * self.cellModel.askLength, self.contentView.sl_height - 1.5);
}

- (void)setCellModel:(BTBidAskCellModel *)cellModel {
    _cellModel = cellModel;
    self.bid.text = [NSString stringWithFormat:@"%lu",cellModel.index];
    self.ask.text = [NSString stringWithFormat:@"%lu",cellModel.index];
    self.bidPrice.text = cellModel.bidPrice;
    self.bidNum.text = cellModel.bidNum;
    self.askPrice.text = cellModel.askPrice;
    self.askNum.text = cellModel.askNum;
    [self layoutIfNeeded];
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DARK_BARKGROUND_COLOR;
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)createLabelWithColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = textAlignment;
    [self.contentView addSubview:label];
    return label;
}

- (UIView *)bidBg {
    if (_bidBg == nil) {
        _bidBg = [[UIView alloc] init];
        _bidBg.backgroundColor = [UP_WARD_COLOR colorWithAlphaComponent:0.3];
        [self.contentView addSubview:_bidBg];
    }
    return _bidBg;
}

- (UIView *)askBg {
    if (_askBg == nil) {
        _askBg = [[UIView alloc] init];
        _askBg.backgroundColor = [DOWN_COLOR colorWithAlphaComponent:0.3];
        [self.contentView addSubview:_askBg];
    }
    return _askBg;
}

@end
