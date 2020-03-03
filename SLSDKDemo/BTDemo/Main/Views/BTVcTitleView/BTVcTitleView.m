//
//  BTVcTitleView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/12/10.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTVcTitleView.h"
#import "UILabel+BTCreate.h"

@interface BTVcTitleView ()
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *subLabel;
@end

@implementation BTVcTitleView

- (void)setItemModel:(BTItemModel *)itemModel {
    _itemModel = itemModel;
    if (itemModel.instrument_id > 0) { // 合约
        self.mainLabel.text = itemModel.contractInfo.symbol;
        BTContractsModel *contract = itemModel.contractInfo;
        if (contract.area == CONTRACT_BLOCK_USDT) {
            self.subLabel.text = @" USDT ";
        }
    } else {
        self.mainLabel.text = itemModel.symbol;
    }
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.itemModel.instrument_id > 0) { // 合约
        [self.mainLabel sizeToFit];
        [self.subLabel sizeToFit];
        self.mainLabel.sl_x = (self.sl_width - self.mainLabel.sl_width - self.subLabel.sl_width) * 0.5;
        self.mainLabel.sl_centerY = self.sl_height * 0.5;
        self.subLabel.sl_x = CGRectGetMaxX(self.mainLabel.frame)+2;
        self.subLabel.sl_centerY = self.mainLabel.sl_centerY;
    } else {
        [self.mainLabel sizeToFit];
        self.mainLabel.sl_centerY = self.sl_height * 0.5;
        self.mainLabel.sl_centerX = self.sl_width * 0.5;
    }
}

- (UILabel *)mainLabel {
    if (_mainLabel == nil) {
        _mainLabel = [UILabel createLabelWithBackgroundColor:nil textColor:MAIN_GARY_TEXT_COLOR font:18 line:1];
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}

- (UILabel *)subLabel {
    if (_subLabel == nil) {
        _subLabel = [UILabel createLabelWithBackgroundColor:nil textColor:MAIN_BTN_COLOR font:10 line:1];
        _subLabel.layer.cornerRadius = 1;
        _subLabel.layer.masksToBounds = YES;
        _subLabel.layer.borderWidth = 0.8;
        _subLabel.layer.borderColor = MAIN_BTN_COLOR.CGColor;
        [self addSubview:_subLabel];
    }
    return _subLabel;
}

@end
