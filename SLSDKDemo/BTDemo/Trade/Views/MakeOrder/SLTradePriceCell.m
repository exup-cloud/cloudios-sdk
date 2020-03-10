//
//  SLTradePriceCell.m
//  BTTest
//
//  Created by wwly on 2019/8/28.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLTradePriceCell.h"

@interface SLTradePriceCell ()

@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UIView * countBackgroundView;

@end

@implementation SLTradePriceCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
        [self initLayout];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView);
    }];
    [self.countBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(1);
        make.bottom.mas_equalTo(-1);
        make.width.mas_equalTo(0);
    }];
}


#pragma mark - 视图更新

- (void)updateViewWithModel:(BTContractOrderModel *)model {
    if (model.side == BTContractOrderWayBuy_OpenLong) {
        self.priceLabel.textColor = [SLConfig defaultConfig].greenColorForBuy;
        self.countBackgroundView.backgroundColor = [[SLConfig defaultConfig].greenColorForBuy colorWithAlphaComponent:0.1];
    } else if (model.side  == BTContractOrderWaySell_OpenShort) {
        self.priceLabel.textColor = [SLConfig defaultConfig].redColorForSell;
        self.countBackgroundView.backgroundColor = [[SLConfig defaultConfig].redColorForSell colorWithAlphaComponent:0.1];
    }
    
    NSString *priceString = model.px;;
    
    if ([priceString isEqualToString:@"0"]) {
        priceString = @"--";
    } else {
        switch (model.decimalPointum) {
            case BTDepthPriceDecimal_1:
                priceString = [NSString stringWithFormat:@"%.1lf", model.px.doubleValue];
                break;
            case BTDepthPriceDecimal_2:
                priceString = [NSString stringWithFormat:@"%.2lf", model.px.doubleValue];
                break;
            case BTDepthPriceDecimal_3:
                priceString = [NSString stringWithFormat:@"%.3lf", model.px.doubleValue];
                break;
            case BTDepthPriceDecimal_4:
                priceString = [NSString stringWithFormat:@"%.4lf", model.px.doubleValue];
                break;
            case BTDepthPriceDecimal_5:
                priceString = [NSString stringWithFormat:@"%.5lf", model.px.doubleValue];
                break;
            case BTDepthPriceDecimal_6:
                priceString = [NSString stringWithFormat:@"%.6lf", model.px.doubleValue];
                break;
            case BTDepthPriceDecimal_7:
                priceString = [NSString stringWithFormat:@"%.7lf", model.px.doubleValue];
                break;
            case BTDepthPriceDecimal_8:
                priceString = [NSString stringWithFormat:@"%.8lf", model.px.doubleValue];
                break;
            default:
                priceString = model.px;
                break;
        }
    }
    self.priceLabel.text = priceString;
    
    if ([model.qty isEqualToString:@"0"]) {
        self.countLabel.text = @"--";
    } else {
        self.countLabel.text = model.qty;
    }
    
    if (model.sumVolNum != 0 ) {
        CGFloat w = (model.qty.doubleValue / model.sumVolNum.doubleValue) * self.contentView.sl_width;
        [self.countBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w);
        }];
    } else {
        [self.countBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}


#pragma mark - lazy load

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].redColorForSell font:[UIFont systemFontOfSize:11] numberOfLines:1 frame:CGRectZero superview:self.contentView];
    }
    return _priceLabel;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:11] numberOfLines:1 frame:CGRectZero superview:self.contentView];
    }
    return _countLabel;
}

- (UIView *)countBackgroundView {
    if (_countBackgroundView == nil) {
        _countBackgroundView = [[UIView alloc] init];
        [self.contentView addSubview:_countBackgroundView];
    }
    return _countBackgroundView;
}

@end
