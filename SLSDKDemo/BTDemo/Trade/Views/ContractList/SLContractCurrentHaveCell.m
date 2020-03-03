//
//  SLContractCurrentHaveCell.m
//  BTTest
//
//  Created by wwly on 2019/9/8.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractCurrentHaveCell.h"

@interface SLContractCurrentHaveCell ()

/// 多 / 空 类型
@property (nonatomic, strong) UILabel * contractOrderTypeLabel;
/// 交易币种
@property (nonatomic, strong) UILabel * coinLabel;
/// 分隔线
@property (nonatomic, strong) UIView * marginLineView;

/// 开仓均价
@property (nonatomic, strong) UILabel * orderPriceTitleLabel;
@property (nonatomic, strong) UILabel * orderPriceLabel;
/// 回报率
@property (nonatomic, strong) UILabel * earnGainsTitleLabel;
@property (nonatomic, strong) UILabel * earnGainsLabel;
/// 未实现盈亏
@property (nonatomic, strong) UILabel * earnTitleLabel;
@property (nonatomic, strong) UILabel * earnLabel;
/// 实际杠杆
@property (nonatomic, strong) UILabel * leverageTitleLabel;
@property (nonatomic, strong) UILabel * leverageLabel;
/// 持仓量
@property (nonatomic, strong) UILabel * haveAmountTitleLabel;
@property (nonatomic, strong) UILabel * haveAmountLabel;
/// 可平仓量
@property (nonatomic, strong) UILabel * canSellTitleLabel;
@property (nonatomic, strong) UILabel * canSellLabel;
/// 仓位价值
@property (nonatomic, strong) UILabel * worthTitleLabel;
@property (nonatomic, strong) UILabel * worthLabel;
/// 强平价格
@property (nonatomic, strong) UILabel * forcePriceTitleLabel;
@property (nonatomic, strong) UILabel * forcePriceLabel;
/// 保证金
@property (nonatomic, strong) UILabel * marginTitleLabel;
@property (nonatomic, strong) UILabel * marginLabel;
/// 已实现盈亏
@property (nonatomic, strong) UILabel * finishEarnTitleLabel;
@property (nonatomic, strong) UILabel * finishEarnLabel;

/// 调整保证金
@property (nonatomic, strong) UIButton * adjustMarginButton;
/// 平仓
@property (nonatomic, strong) UIButton * sellAllButton;

@property (nonatomic, strong) BTPositionModel * positionModel;

@end

@implementation SLContractCurrentHaveCell {
    CGFloat _horMargin;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor blackColor];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
        });
    }
}

- (void)initUI {
    _horMargin = 15;
    CGFloat topMargin = 10;
    
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat margin = 5;
    
    self.contractOrderTypeLabel = [UILabel labelWithText:Launguage(@"BT_CA_KKMC") textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].redColorForSell font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(_horMargin, topMargin, 60, 20) superview:self.contentView];
    self.contractOrderTypeLabel.layer.cornerRadius = 1;
    self.contractOrderTypeLabel.layer.borderWidth = 0.5;
    self.contractOrderTypeLabel.layer.borderColor = [SLConfig defaultConfig].redColorForSell.CGColor;
    self.contractOrderTypeLabel.layer.masksToBounds = YES;
    
    self.coinLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(self.contractOrderTypeLabel.sl_maxX + _horMargin, self.contractOrderTypeLabel.sl_y, 200, self.contractOrderTypeLabel.sl_height) superview:self.contentView];
    
    UIView *marginLineView = [self createMarginLineViewWithY:self.coinLabel.sl_maxY + topMargin];
    
    UIFont *titleFont = [UIFont systemFontOfSize:13];
    UIFont *valueFont = [UIFont systemFontOfSize:13];
    CGFloat titleHeight = 30;
    
    self.orderPriceTitleLabel = [UILabel labelWithText:Launguage(@"str_open_price") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, (SL_SCREEN_WIDTH - _horMargin * 2) / 2, titleHeight) superview:self.contentView];
    self.orderPriceLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.orderPriceTitleLabel.sl_x, self.orderPriceTitleLabel.sl_maxY, self.orderPriceTitleLabel.sl_width, titleHeight) superview:self.contentView];
    
    self.earnGainsTitleLabel = [UILabel labelWithText:@"回报率" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(self.orderPriceTitleLabel.sl_maxX, self.orderPriceTitleLabel.sl_y, self.orderPriceTitleLabel.sl_width, titleHeight) superview:self.contentView];
    self.earnGainsLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.earnGainsTitleLabel.sl_x, self.earnGainsTitleLabel.sl_maxY, self.earnGainsTitleLabel.sl_width, titleHeight) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.orderPriceLabel.sl_maxY + margin];
    
    self.earnTitleLabel = [UILabel labelWithText:@"未实现盈亏" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, (SL_SCREEN_WIDTH - _horMargin * 2) / 2, titleHeight) superview:self.contentView];
    self.earnLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(SL_SCREEN_WIDTH - _horMargin * 2 - self.earnTitleLabel.sl_width, self.earnTitleLabel.sl_y, self.earnTitleLabel.sl_width, titleHeight) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.earnTitleLabel.sl_maxY + margin];
    
    self.leverageTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_SJ") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, self.earnTitleLabel.sl_width, titleHeight) superview:self.contentView];
    self.leverageLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.earnLabel.sl_x, self.leverageTitleLabel.sl_y, self.earnLabel.sl_width, self.earnLabel.sl_height) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.leverageTitleLabel.sl_maxY + margin];
    
    self.haveAmountTitleLabel = [UILabel labelWithText:Launguage(@"str_holdings") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, self.leverageTitleLabel.sl_width, titleHeight) superview:self.contentView];
    self.haveAmountLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.earnLabel.sl_x, self.haveAmountTitleLabel.sl_y, self.earnLabel.sl_width, self.earnLabel.sl_height) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.haveAmountTitleLabel.sl_maxY + margin];
    
    self.canSellTitleLabel = [UILabel labelWithText:Launguage(@"str_amount_can_be_liquidated") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, self.leverageTitleLabel.sl_width, titleHeight) superview:self.contentView];
    self.canSellLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.earnLabel.sl_x, self.canSellTitleLabel.sl_y, self.earnLabel.sl_width, self.earnLabel.sl_height) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.canSellTitleLabel.sl_maxY + margin];
    
    self.worthTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_POSITION_VALUE") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, self.leverageTitleLabel.sl_width, titleHeight) superview:self.contentView];
    self.worthLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.earnLabel.sl_x, self.worthTitleLabel.sl_y, self.earnLabel.sl_width, self.earnLabel.sl_height) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.worthTitleLabel.sl_maxY + margin];
    
    self.forcePriceTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_CLOSE_PRI") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, self.leverageTitleLabel.sl_width, titleHeight) superview:self.contentView];
    self.forcePriceLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.earnLabel.sl_x, self.forcePriceTitleLabel.sl_y, self.earnLabel.sl_width, self.earnLabel.sl_height) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.forcePriceTitleLabel.sl_maxY + margin];
    
    self.marginTitleLabel = [UILabel labelWithText:Launguage(@"str_margins") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, self.leverageTitleLabel.sl_width, titleHeight) superview:self.contentView];
    self.marginLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.earnLabel.sl_x, self.marginTitleLabel.sl_y, self.earnLabel.sl_width, self.earnLabel.sl_height) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.marginTitleLabel.sl_maxY + margin];
    
    self.finishEarnTitleLabel = [UILabel labelWithText:Launguage(@"str_gains") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:titleFont numberOfLines:1 frame:CGRectMake(_horMargin, marginLineView.sl_maxY + margin, self.leverageTitleLabel.sl_width, titleHeight) superview:self.contentView];
    self.finishEarnLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:valueFont numberOfLines:1 frame:CGRectMake(self.earnLabel.sl_x, self.finishEarnTitleLabel.sl_y, self.earnLabel.sl_width, self.earnLabel.sl_height) superview:self.contentView];
    
    marginLineView = [self createMarginLineViewWithY:self.finishEarnTitleLabel.sl_maxY + margin];
    
    self.adjustMarginButton = [UIButton buttonExtensionWithTitle:Launguage(@"str_adjust_margins") TitleColor:[SLConfig defaultConfig].blueTextColor Image:nil font:titleFont target:self action:@selector(adjustMarginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.adjustMarginButton.frame = CGRectMake(_horMargin, marginLineView.sl_maxY + margin, self.finishEarnLabel.sl_width, titleHeight);
    self.adjustMarginButton.titleLabel.font = titleFont;
    [self.contentView addSubview:self.adjustMarginButton];
    
    self.sellAllButton = [UIButton buttonExtensionWithTitle:Launguage(@"BT_CA_CP") TitleColor:[SLConfig defaultConfig].blueTextColor Image:nil font:titleFont target:self action:@selector(sellAllButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.sellAllButton.frame = CGRectMake(self.adjustMarginButton.sl_maxX, self.adjustMarginButton.sl_y, self.adjustMarginButton.sl_width, self.adjustMarginButton.sl_height);
    self.sellAllButton.titleLabel.font = titleFont;
    [self.contentView addSubview:self.sellAllButton];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.adjustMarginButton.sl_maxY + margin, SL_SCREEN_WIDTH, 8)];
    bottomLineView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [self.contentView addSubview:bottomLineView];
}


#pragma mark - Update Data

- (void)updateViewWithPositionModel:(BTPositionModel *)positionModel {
    self.positionModel = positionModel;
    if (positionModel.position_type == BTPositionType_OpenMore) {
        self.contractOrderTypeLabel.text = [NSString stringWithFormat:@" %@ ", Launguage(@"BT_CA_KDMR")];
        self.contractOrderTypeLabel.textColor = UP_WARD_COLOR;
        self.contractOrderTypeLabel.layer.borderColor = UP_WARD_COLOR.CGColor;
    } else if (positionModel.position_type == BTPositionType_OpenEmpty) {
        self.contractOrderTypeLabel.text = [NSString stringWithFormat:@" %@ ", Launguage(@"BT_CA_KKMC")];
        self.contractOrderTypeLabel.textColor = DOWN_COLOR;
        self.contractOrderTypeLabel.layer.borderColor = DOWN_COLOR.CGColor;
    }
    self.coinLabel.text = positionModel.name;
    
    NSString *price = [positionModel.avg_cost_px toSmallPriceWithContractID:positionModel.instrument_id];
    NSString *marginCode = positionModel.contractInfo.margin_coin;
    self.orderPriceLabel.text = [NSString stringWithFormat:@"%@ %@", price, marginCode];

    // 未实现盈亏
    NSString *profitOrLess = positionModel.markPrice;
    if ([[BTStoreData storeObjectForKey:ST_UNREA_CARCUL] isEqualToString:@"1"]) {
        profitOrLess = positionModel.markPrice;
    } else if ([[BTStoreData storeObjectForKey:ST_UNREA_CARCUL] isEqualToString:@"2"]) {
        profitOrLess = positionModel.lastPrice;
    }

    if (positionModel.position_type == BTPositionType_OpenMore) {
        profitOrLess = [SLFormula calculateCloseLongProfitAmount:positionModel.cur_qty holdAvgPrice:positionModel.avg_cost_px markPrice:profitOrLess contractSize:positionModel.contractInfo.face_value isReverse:positionModel.contractInfo.is_reverse];
    } else if (positionModel.position_type == BTPositionType_OpenEmpty) {
        profitOrLess = [SLFormula calculateCloseShortProfitAmount:positionModel.cur_qty holdAvgPrice:positionModel.avg_cost_px markPrice:profitOrLess contractSize:positionModel.contractInfo.face_value isReverse:positionModel.contractInfo.is_reverse];
    }
    // 回报率
    NSString *profitOrLessRate = [profitOrLess bigDiv:[positionModel.im bigAdd:[positionModel.tax bigMul:[positionModel.cur_qty bigDiv:[positionModel.cur_qty bigAdd:positionModel.freeze_qty]]]]];
    self.earnGainsLabel.text = [profitOrLessRate toPercentString:2];
    if ([profitOrLessRate LessThan:BT_ZERO]) {
        self.earnGainsLabel.textColor = DOWN_COLOR;
    } else {
        self.earnGainsLabel.textColor = UP_WARD_COLOR;
    }
    // 未实现盈亏
    profitOrLess = [profitOrLess toSmallValueWithContract:positionModel.instrument_id];
    self.earnLabel.text = profitOrLess;
    // 实际杠杆
    self.leverageLabel.text = positionModel.realityLeverage;
    // 持仓量
    self.haveAmountLabel.text = [positionModel.cur_qty toSmallVolumeWithContractID:positionModel.instrument_id];
    // 可平仓量
    self.canSellLabel.text = [[positionModel.cur_qty bigSub:positionModel.freeze_qty] toSmallVolumeWithContractID:positionModel.instrument_id];
    // 仓位价值
    NSString *position_value = [SLFormula calculateContractValueWithVol:positionModel.cur_qty price:positionModel.avg_cost_px contract:positionModel.contractInfo];
    position_value = [NSString stringWithFormat:@"%@ %@",[position_value toSmallValueWithContract:positionModel.instrument_id],positionModel.contractInfo.margin_coin];
    self.worthLabel.text = position_value;
    // 强平价格
    self.forcePriceLabel.text = [positionModel.liquidate_price toSmallPriceWithContractID:positionModel.instrument_id];
    // 保证金
    self.marginLabel.text = [positionModel.im toSmallValueWithContract:positionModel.instrument_id];
    // 已实现盈亏
    self.finishEarnLabel.text = [positionModel.earnings toSmallValueWithContract:positionModel.instrument_id];
}


#pragma mark - Events

/// 调整保证金
- (void)adjustMarginButtonClick {
    if ([self.delegate respondsToSelector:@selector(currentHaveCell_adjustMarginWithPositionModel:)]) {
        [self.delegate currentHaveCell_adjustMarginWithPositionModel:self.positionModel];
    }
}

/// 平仓
- (void)sellAllButtonClick {
    if ([self.delegate respondsToSelector:@selector(currentHaveCell_sellAllWithPositionModel:)]) {
        [self.delegate currentHaveCell_sellAllWithPositionModel:self.positionModel];
    }
}


- (UIView *)createMarginLineViewWithY:(CGFloat)y {
    UIView *marginLineView = [[UIView alloc] initWithFrame:CGRectMake(_horMargin, y, SL_SCREEN_WIDTH - _horMargin * 2, 1)];
    marginLineView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [self.contentView addSubview:marginLineView];
    return marginLineView;
}

@end
