//
//  BTDealBackCell.m
//  BTStore
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTDealBackCell.h"
#import "BTDealBackCellModel.h"

@interface BTDealBackCell ()
@property (nonatomic, strong) UILabel *dealTime;
@property (nonatomic, strong) UILabel *dealPrice;
@property (nonatomic, strong) UILabel *dealVolume;
@property (nonatomic, strong) UILabel *wayLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation BTDealBackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = MAIN_COLOR;
    
    self.dealTime = [[UILabel alloc] init];
    self.dealTime.textColor = GARY_BG_TEXT_COLOR;
    self.dealTime.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.dealTime];
    
    self.dealPrice = [[UILabel alloc] init];
    self.dealPrice.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.dealPrice];
//    self.dealPrice.textAlignment = NSTextAlignmentCenter;
    
    self.dealVolume = [[UILabel alloc] init];
    self.dealVolume.textColor = GARY_BG_TEXT_COLOR;
    self.dealVolume.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.dealVolume];
//    self.dealVolume.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.type == 0) {
        self.dealTime.frame = CGRectMake(SL_MARGIN, 0, (SL_SCREEN_WIDTH - SL_MARGIN * 2) *0.25, self.contentView.sl_height);
        self.wayLabel.frame = CGRectMake(CGRectGetMaxX(self.dealTime.frame), 0, self.dealTime.sl_width, self.contentView.sl_height);
        self.dealPrice.frame = CGRectMake(CGRectGetMaxX(self.wayLabel.frame), 0, self.dealTime.sl_width, self.contentView.sl_height);
        self.dealPrice.textAlignment = NSTextAlignmentCenter;
        self.dealVolume.frame = CGRectMake(CGRectGetMaxX(self.dealPrice.frame), 0, (SL_SCREEN_WIDTH - SL_MARGIN * 2) *0.25, self.contentView.sl_height);
        self.dealVolume.textAlignment = NSTextAlignmentRight;
    } else if (self.type == 1) {
        self.dealTime.frame = CGRectMake(SL_MARGIN, 0, (SL_SCREEN_WIDTH - SL_MARGIN *2) *0.25, self.contentView.sl_height);
        self.dealPrice.frame = CGRectMake(CGRectGetMaxX(self.dealTime.frame), 0, self.dealTime.sl_width, self.contentView.sl_height);
        self.dealPrice.textAlignment = NSTextAlignmentRight;
        self.dealVolume.frame = CGRectMake(CGRectGetMaxX(self.dealPrice.frame), 0, self.dealPrice.sl_width, self.contentView.sl_height);
        self.dealVolume.textAlignment = NSTextAlignmentRight;
        self.wayLabel.frame = CGRectMake(CGRectGetMaxX(self.dealVolume.frame), 0, self.dealVolume.sl_width, self.contentView.sl_height);
        self.wayLabel.textAlignment = NSTextAlignmentRight;
        self.bottomLine.frame = CGRectMake(0, self.contentView.sl_height - 1, self.contentView.sl_width, 1);
    }
}

- (void)setModel:(BTDealBackCellModel *)model {
    _model = model;
    if (self.type == 0) {
        if (model.type == BTTradeWayBuy) {
            self.dealPrice.textColor = UP_WARD_COLOR;
            self.dealTime.text = model.time;
            self.dealPrice.text = model.price;
            self.dealVolume.text = [NSString cutOffEndZero:model.volume lessThan:2];
            self.wayLabel.text = @"买入";
            self.wayLabel.textColor = UP_WARD_COLOR;
        } else if (model.type == BTTradeWaySell) {
            self.dealPrice.textColor = DOWN_COLOR;
            self.dealTime.text = model.time;
            self.dealPrice.text = model.price;
            self.dealVolume.text = [NSString cutOffEndZero:model.volume lessThan:2];
            self.wayLabel.text = @"卖出";
            self.wayLabel.textColor = DOWN_COLOR;
        }
    } else if (self.type == 1) {
        if (model.recordWay <= 4 ) {
            self.dealPrice.textColor = UP_WARD_COLOR;
        } else {
            self.dealPrice.textColor = DOWN_COLOR;
        }
        switch (model.recordWay) {
            case CONTRACT_TRADE_WAY_BUY_OLOS_1:
                self.wayLabel.text = Launguage(@"str_duo_kai");
                break;
            case CONTRACT_TRADE_WAY_BUY_OLCL_2:
                self.wayLabel.text = Launguage(@"str_duo_kai");
                break;
            case CONTRACT_TRADE_WAY_BUY_CSOS_3:
                self.wayLabel.text = Launguage(@"str_duo_ping");
                break;
            case CONTRACT_TRADE_WAY_BUY_CSCL_4:
                self.wayLabel.text = Launguage(@"str_duo_ping");
                break;
            case CONTRACT_TRADE_WAY_SELL_OSOL_5:
                self.wayLabel.text = Launguage(@"str_duo_kai");
                break;
            case CONTRACT_TRADE_WAY_SELL_OSCS_6:
                self.wayLabel.text = Launguage(@"str_duo_kai");
                break;
            case CONTRACT_TRADE_WAY_SELL_CLOL_7:
                self.wayLabel.text = Launguage(@"str_duo_ping");
                break;
            case CONTRACT_TRADE_WAY_SELL_CLCS_8:
                self.wayLabel.text = Launguage(@"str_duo_ping");
                break;
            default:
                break;
        }
        self.dealTime.text = model.time;
        self.dealPrice.text = [model.price toSmallPriceWithContractID:model.contract_id];
        self.dealVolume.text = [model.volume toSmallVolumeWithContractID:model.contract_id];
    }
    [self layoutIfNeeded];
}

- (UILabel *)wayLabel {
    if (_wayLabel == nil) {
        _wayLabel = [[UILabel alloc] init];
        _wayLabel.textColor = GARY_BG_TEXT_COLOR;
         _wayLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview: _wayLabel];
    }
    return _wayLabel;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = DARK_BARKGROUND_COLOR;
        [self.contentView addSubview: _bottomLine];
    }
    return _bottomLine;
}

@end
