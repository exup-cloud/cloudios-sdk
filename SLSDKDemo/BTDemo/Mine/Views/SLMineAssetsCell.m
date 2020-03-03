//
//  SLMineAssetsCell.m
//  BTTest
//
//  Created by WWLy on 2019/9/16.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMineAssetsCell.h"

@interface SLMineAssetsCell ()

@property (nonatomic, strong) UIView * topLineView;

/// 币种名称
@property (nonatomic, strong) UILabel * coinNameLabel;
/// 账户权益
@property (nonatomic, strong) UILabel * assetsTitleLabel;
/// 币种数量
@property (nonatomic, strong) UILabel * amountLabel;

@property (nonatomic, strong) UIView * marginLineView;

/// 钱包余额
@property (nonatomic, strong) UILabel * walletBalanceTitleLabel;
@property (nonatomic, strong) UILabel * walletBalanceLabel;
/// 保证金余额
@property (nonatomic, strong) UILabel * marginBalanceTitleLabel;
@property (nonatomic, strong) UILabel * marginBalanceLabel;
/// 未实现盈亏
@property (nonatomic, strong) UILabel * earnTitleLabel;
@property (nonatomic, strong) UILabel * earnLabel;
/// 仓位保证金
@property (nonatomic, strong) UILabel * positionMarginTitleLabel;
@property (nonatomic, strong) UILabel * positionMarginLabel;
/// 委托保证金
@property (nonatomic, strong) UILabel * orderMarginTitleLabel;
@property (nonatomic, strong) UILabel * orderMarginLabel;

@end

@implementation SLMineAssetsCell {
    CGFloat _horMargin;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    
    UIColor *titleColor = [SLConfig defaultConfig].lightGrayTextColor;
    UIColor *valueColor = [SLConfig defaultConfig].lightTextColor;
    
    _horMargin = SL_MARGIN;
    
    self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, 6)];
    self.topLineView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [self.contentView addSubview:self.topLineView];
    
    self.coinNameLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentLeft textColor:valueColor font:[UIFont systemFontOfSize:15] numberOfLines:1 frame:CGRectMake(_horMargin, self.topLineView.sl_maxY, 0, 40) superview:self.contentView];
    self.assetsTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_MO") textAlignment:NSTextAlignmentLeft textColor:titleColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.coinNameLabel.sl_maxX + _horMargin, self.coinNameLabel.sl_y, 100, self.coinNameLabel.sl_height) superview:self.contentView];
    self.amountLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentRight textColor:valueColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(_horMargin, self.coinNameLabel.sl_y, SL_SCREEN_WIDTH - _horMargin * 2, self.coinNameLabel.sl_height) superview:self.contentView];
    
    self.marginLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.coinNameLabel.sl_maxY, SL_SCREEN_WIDTH, 2)];
    self.marginLineView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [self.contentView addSubview:self.marginLineView];
    
    self.walletBalanceTitleLabel = [UILabel labelWithText:Launguage(@"str_wallet_balance") textAlignment:NSTextAlignmentLeft textColor:titleColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(_horMargin, self.marginLineView.sl_maxY + _horMargin, 100, 20) superview:self.contentView];
    self.walletBalanceLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentLeft textColor:valueColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.walletBalanceTitleLabel.sl_x, self.walletBalanceTitleLabel.sl_maxY, self.walletBalanceTitleLabel.sl_width, self.walletBalanceTitleLabel.sl_height) superview:self.contentView];
    
    self.marginBalanceTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_MB") textAlignment:NSTextAlignmentLeft textColor:titleColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.walletBalanceTitleLabel.sl_maxX, self.walletBalanceTitleLabel.sl_y, 150, self.walletBalanceTitleLabel.sl_height) superview:self.contentView];
    self.marginBalanceLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentLeft textColor:valueColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.marginBalanceTitleLabel.sl_x, self.marginBalanceTitleLabel.sl_maxY, self.marginBalanceTitleLabel.sl_width, self.marginBalanceTitleLabel.sl_height) superview:self.contentView];
    
    self.earnTitleLabel = [UILabel labelWithText:@"未实现盈亏" textAlignment:NSTextAlignmentRight textColor:titleColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(SL_SCREEN_WIDTH - 150 - _horMargin, self.marginBalanceTitleLabel.sl_y, 150, self.marginBalanceTitleLabel.sl_height) superview:self.contentView];
    self.earnLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentRight textColor:valueColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.earnTitleLabel.sl_x, self.earnTitleLabel.sl_maxY, self.earnTitleLabel.sl_width, self.earnTitleLabel.sl_height) superview:self.contentView];
    
    self.positionMarginTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_PM") textAlignment:NSTextAlignmentLeft textColor:titleColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.walletBalanceTitleLabel.sl_x, self.walletBalanceLabel.sl_maxY + _horMargin, self.walletBalanceTitleLabel.sl_width, self.walletBalanceTitleLabel.sl_height) superview:self.contentView];
    self.positionMarginLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentLeft textColor:valueColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.positionMarginTitleLabel.sl_x, self.positionMarginTitleLabel.sl_maxY, self.positionMarginTitleLabel.sl_width, self.positionMarginTitleLabel.sl_height) superview:self.contentView];
    
    self.orderMarginTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_OM") textAlignment:NSTextAlignmentLeft textColor:titleColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.positionMarginTitleLabel.sl_maxX, self.positionMarginTitleLabel.sl_y, self.marginBalanceTitleLabel.sl_width, self.positionMarginTitleLabel.sl_height) superview:self.contentView];
    self.orderMarginLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentLeft textColor:valueColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.orderMarginTitleLabel.sl_x, self.orderMarginTitleLabel.sl_maxY, self.orderMarginTitleLabel.sl_width, self.orderMarginTitleLabel.sl_height) superview:self.contentView];
}


- (void)updateViewWithPerprotyModel:(SLMinePerprotyModel *)perprotyModel {
    self.coinNameLabel.text = perprotyModel.coin_code;
    self.amountLabel.text = perprotyModel.total_amount;
    self.walletBalanceLabel.text = perprotyModel.walletBalance;
    self.marginBalanceLabel.text = perprotyModel.depositBalance;
    self.earnLabel.text = perprotyModel.profitOrLoss;
    self.positionMarginLabel.text = perprotyModel.holdDeposit;
    self.orderMarginLabel.text = perprotyModel.entrustDeposit;
    
    self.coinNameLabel.sl_width = [self.coinNameLabel textWidth];
    self.assetsTitleLabel.sl_x = self.coinNameLabel.sl_maxX + _horMargin;
}



@end
