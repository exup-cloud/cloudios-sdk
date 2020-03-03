//
//  BTMarketFuturesCell.m
//  SLContractSDK
//
//  Created by WWLy on 2019/8/14.
//  Copyright © 2019 Karl. All rights reserved.
//

#import "BTMarketFuturesCell.h"

@interface BTMarketFuturesCell ()

@property (nonatomic, strong) UIButton * collectionButton;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * USDTLabel;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UILabel * dollarPriceLabel;
@property (nonatomic, strong) UILabel * RMBPriceLabel;
/// 涨跌幅
@property (nonatomic, strong) UILabel * gainLabel;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) BTItemModel * itemModel;

@end

@implementation BTMarketFuturesCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self initLayout];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self initLayout];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
}

- (void)initLayout {
    CGFloat margin =  15;
//    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView).mas_offset(margin);
//        make.width.height.mas_equalTo(25);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(margin);
        make.top.mas_equalTo(self.contentView).mas_offset(10);
        make.height.mas_equalTo(25);
    }];
//    [self.USDTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.nameLabel.mas_right);
//        make.bottom.mas_equalTo(self.nameLabel);
//        make.height.mas_equalTo(20);
//    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(16);
    }];
    [self.dollarPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(SL_SCREEN_WIDTH * 0.4);
        make.height.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel);
    }];
    [self.RMBPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dollarPriceLabel);
        make.top.mas_equalTo(self.countLabel);
        make.height.mas_equalTo(self.countLabel);
    }];
    [self.gainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-margin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(90);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(0.5);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)updateViewWithModel:(BTItemModel *)itemModel {
    _itemModel = itemModel;
    if (itemModel.hasCollect) {
        self.collectionButton.hidden = NO;
    } else {
        self.collectionButton.hidden = YES;
    }
    self.nameLabel.text = itemModel.contractInfo.symbol;
    NSString *totalVolume = [BTFormat totalVolumeFromNumberStr:itemModel.qty_day];
    self.countLabel.text = [NSString stringWithFormat:@"%@ %@", Launguage(@"BT_MA_DE_CJL"), totalVolume];
    self.RMBPriceLabel.text = [Common currentPriceWithCoin:[NSString stringWithFormat:@"%@/%@",itemModel.contractInfo.base_coin,itemModel.contractInfo.quote_coin] currentPrice:itemModel.last_px];
    self.dollarPriceLabel.text = [NSString stringWithFormat:@"$%@",[itemModel.last_px toSmallPriceWithContractID:itemModel.instrument_id]];
    
    if (itemModel.trend  == BTPriceFluctuationUp) {
        self.gainLabel.backgroundColor = UP_WARD_COLOR;
        self.gainLabel.text = [NSString stringWithFormat:@"﹢%@",[itemModel.change_rate toPercentString:2]];
    } else if (itemModel.trend  == BTPriceFluctuationDown) {
        self.gainLabel.backgroundColor = DOWN_COLOR;
        self.gainLabel.text = [NSString stringWithFormat:@"%@", [itemModel.change_rate toPercentString:2]];
    }
}


#pragma mark - click events

- (void)collectionButtonClick:(UIButton *)sender {
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - lazy load

//- (UIButton *)collectionButton {
//    if (_collectionButton == nil) {
//        _collectionButton = [UIButton buttonExtensionWithTitle:nil TitleColor:nil Image:[UIImage imageWithName:@"icon-sorting"] font:nil target:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_collectionButton];
//    }
//    return _collectionButton;
//}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] numberOfLines:1 frame:CGRectZero superview:self.contentView];
    }
    return _nameLabel;
}

//- (UILabel *)USDTLabel {
//    if (_USDTLabel == nil) {
//        _USDTLabel = [UILabel labelWithText:@"/USDT" textAlignment:NSTextAlignmentLeft textColor:DARK_BARKGROUND_COLOR font:[UIFont systemFontOfSize:15] numberOfLines:1 frame:CGRectZero superview:self.contentView];
//    }
//    return _USDTLabel;
//}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectZero superview:self.contentView];
    }
    return _countLabel;
}

- (UILabel *)dollarPriceLabel {
    if (_dollarPriceLabel == nil) {
        _dollarPriceLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor  font:[UIFont systemFontOfSize:15] numberOfLines:1 frame:CGRectZero superview:self.contentView];
    }
    return _dollarPriceLabel;
}

- (UILabel *)RMBPriceLabel {
    if (_RMBPriceLabel == nil) {
        _RMBPriceLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectZero superview:self.contentView];
    }
    return _RMBPriceLabel;
}

- (UILabel *)gainLabel {
    if (_gainLabel == nil) {
        _gainLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] numberOfLines:1 frame:CGRectZero superview:self.contentView];
        _gainLabel.backgroundColor = [UIColor whiteColor];
        _gainLabel.layer.cornerRadius = 2;
    }
    return _gainLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}


@end
