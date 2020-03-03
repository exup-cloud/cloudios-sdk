//
//  SLContractListCell.m
//  BTTest
//
//  Created by wwly on 2019/9/7.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractListCell.h"

@interface SLContractListCell ()

/// 多 / 空 类型
@property (nonatomic, strong) UILabel * contractOrderTypeLabel;
/// 交易币种
@property (nonatomic, strong) UILabel * coinLabel;
/// 撤单
@property (nonatomic, strong) UIButton * cancelButton;
/// 委托时间
@property (nonatomic, strong) UILabel * timeLabel;
/// 分隔线
@property (nonatomic, strong) UIView * marginLineView;
/// 委托量
@property (nonatomic, strong) UILabel * contractAmountTitleLabel;
@property (nonatomic, strong) UILabel * contractAmountLabel;
/// 成交量
@property (nonatomic, strong) UILabel * finishAmountTitleLabel;
@property (nonatomic, strong) UILabel * finishAmountLabel;
/// 委托价格
@property (nonatomic, strong) UILabel * contractPriceTitleLabel;
@property (nonatomic, strong) UILabel * contractPriceLabel;
/// 委托价值
@property (nonatomic, strong) UILabel * contractWorthTitleLabel;
@property (nonatomic, strong) UILabel * contractWorthLabel;
/// 底部分隔线
@property (nonatomic, strong) UIView * bottomLineView;

/// 历史委托 - 订单状态
@property (nonatomic, strong) UILabel * historyOrderStatusLabel;
/// 历史委托 - 成交均价
@property (nonatomic, strong) UILabel * historyFinishPriceTitleLabel;
@property (nonatomic, strong) UILabel * historyFinishPriceLabel;

/// 计划委托 - 触发价格
@property (nonatomic, strong) UILabel * planTriggerPriceTitleLabel;
@property (nonatomic, strong) UILabel * planTriggerPriceLabel;
/// 计划委托 - 执行价格
@property (nonatomic, strong) UILabel * planPerformPriceTitleLabel;
@property (nonatomic, strong) UILabel * planPerformPriceLabel;
/// 计划委托 - 执行数量
@property (nonatomic, strong) UILabel * planPerformAmountTitleLabel;
@property (nonatomic, strong) UILabel * planPerformAmountLabel;
/// 计划委托 - 到期时间
@property (nonatomic, strong) UILabel * planExpireTimeTitleLabel;
@property (nonatomic, strong) UILabel * planExpireTimeLabel;

@property (nonatomic, strong) BTContractOrderModel * contractMdoel;

@end

@implementation SLContractListCell {
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
    CGFloat leftMargin = _horMargin;
    CGFloat topMargin = 10;
    
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.contractOrderTypeLabel = [UILabel labelWithText:Launguage(@"BT_CA_KKMC") textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].redColorForSell font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(leftMargin, topMargin, 60, 20) superview:self.contentView];
    self.contractOrderTypeLabel.layer.cornerRadius = 1;
    self.contractOrderTypeLabel.layer.borderWidth = 0.5;
    self.contractOrderTypeLabel.layer.borderColor = [SLConfig defaultConfig].redColorForSell.CGColor;
    self.contractOrderTypeLabel.layer.masksToBounds = YES;
    
    self.coinLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(self.contractOrderTypeLabel.sl_maxX + leftMargin, self.contractOrderTypeLabel.sl_y, 200, self.contractOrderTypeLabel.sl_height) superview:self.contentView];
    
    self.cancelButton = [UIButton buttonExtensionWithTitle:Launguage(@"str_revoke") TitleColor:[SLConfig defaultConfig].blueTextColor Image:nil font:nil target:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.cancelButton.layer.cornerRadius = 2;
    self.cancelButton.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
    self.cancelButton.layer.borderWidth = 0.5;
    CGFloat cancelButtonX = SL_SCREEN_WIDTH - leftMargin - 60;
    self.cancelButton.frame = CGRectMake(cancelButtonX, 0, 60, 20);
    self.cancelButton.sl_centerY = self.coinLabel.sl_centerY;
    [self.contentView addSubview:self.cancelButton];
    
    self.timeLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(self.contractOrderTypeLabel.sl_x, self.contractOrderTypeLabel.sl_maxY, 200, 25) superview:self.contentView];
    
    self.marginLineView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, self.timeLabel.sl_maxY, SL_SCREEN_WIDTH - leftMargin * 2, 1)];
    self.marginLineView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [self.contentView addSubview:self.marginLineView];
    
    self.contractAmountTitleLabel = [UILabel labelWithText:@"委托量" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(leftMargin, self.marginLineView.sl_maxY + 3, 200, 30) superview:self.contentView];
    self.contractAmountLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(SL_SCREEN_WIDTH - 200 - leftMargin, self.contractAmountTitleLabel.sl_y, 200, self.contractAmountTitleLabel.sl_height) superview:self.contentView];
    
    self.finishAmountTitleLabel = [UILabel labelWithText:Launguage(@"BT_MAR_CJL") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.contractAmountTitleLabel.sl_x, self.contractAmountTitleLabel.sl_maxY, self.contractAmountTitleLabel.sl_width, self.contractAmountTitleLabel.sl_height) superview:self.contentView];
    self.finishAmountLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.contractAmountLabel.sl_x, self.finishAmountTitleLabel.sl_y, self.contractAmountLabel.sl_width, self.finishAmountTitleLabel.sl_height) superview:self.contentView];
    
    self.contractPriceTitleLabel = [UILabel labelWithText:Launguage(@"str_entrust_price") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.contractAmountTitleLabel.sl_x, self.finishAmountTitleLabel.sl_maxY, self.contractAmountTitleLabel.sl_width, self.contractAmountTitleLabel.sl_height) superview:self.contentView];
    self.contractPriceLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.contractAmountLabel.sl_x, self.contractPriceTitleLabel.sl_y, self.contractAmountLabel.sl_width, self.contractPriceTitleLabel.sl_height) superview:self.contentView];
    
    self.contractWorthTitleLabel = [UILabel labelWithText:Launguage(@"BT_CA_ORDER_VAL") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.contractAmountTitleLabel.sl_x, self.contractPriceTitleLabel.sl_maxY, self.contractAmountTitleLabel.sl_width, self.contractAmountTitleLabel.sl_height) superview:self.contentView];
    self.contractWorthLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.contractAmountLabel.sl_x, self.contractWorthTitleLabel.sl_y, self.contractAmountLabel.sl_width, self.contractWorthTitleLabel.sl_height) superview:self.contentView];
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contractWorthLabel.sl_maxY, SL_SCREEN_WIDTH, 8)];
    self.bottomLineView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [self.contentView addSubview:self.bottomLineView];
}


#pragma mark - Public

- (void)updateViewWithContractOrderModel:(BTContractOrderModel *)contractOrderModel {
    self.contractMdoel = contractOrderModel;
    
    self.coinLabel.text = contractOrderModel.name;
    
    if (contractOrderModel.side == BTContractOrderWayBuy_OpenLong) {
        self.contractOrderTypeLabel.textColor = UP_WARD_COLOR;
        self.contractOrderTypeLabel.text = [NSString stringWithFormat:@" %@ ", Launguage(@"BT_CA_KDMR")];
        self.contractOrderTypeLabel.layer.borderColor = UP_WARD_COLOR.CGColor;
    } else if (contractOrderModel.side == BTContractOrderWaySell_OpenShort) {
        self.contractOrderTypeLabel.textColor = DOWN_COLOR;
        self.contractOrderTypeLabel.text = [NSString stringWithFormat:@" %@ ", Launguage(@"BT_CA_KKMC")];
        self.contractOrderTypeLabel.layer.borderColor = DOWN_COLOR.CGColor;
    } else if (contractOrderModel.side == BTContractOrderWayBuy_CloseShort) {
        self.contractOrderTypeLabel.textColor = UP_WARD_COLOR;
        self.contractOrderTypeLabel.text = [NSString stringWithFormat:@" %@ ", @"买入平空"];
        self.contractOrderTypeLabel.layer.borderColor = UP_WARD_COLOR.CGColor;
    } else if (contractOrderModel.side == BTContractOrderWaySell_CloseLong) {
        self.contractOrderTypeLabel.textColor = DOWN_COLOR;
        self.contractOrderTypeLabel.text = [NSString stringWithFormat:@" %@ ", @"卖出平多"];
        self.contractOrderTypeLabel.layer.borderColor = DOWN_COLOR.CGColor;
    }
    
    // 时间
    self.timeLabel.text = [BTFormat date2localTimeStr:[BTFormat dateFromUTCString:contractOrderModel.created_at] format:DATE_FORMAT_YMDHm];
    if (contractOrderModel.status == BTContractOrderStatusFinished) {
        self.timeLabel.text = [BTFormat date2localTimeStr:[BTFormat dateFromUTCString:contractOrderModel.finished_at] format:DATE_FORMAT_YMDHm];
    }
    
    // 委托数量
    NSString *contractAmount = [contractOrderModel.qty toSmallVolumeWithContractID:contractOrderModel.instrument_id];
    self.contractAmountLabel.text = [NSString stringWithFormat:@"%@ %@", contractAmount,@"张"];
    
    // 成交数量
    NSString *finishAmount = contractOrderModel.cum_qty;
    finishAmount = [finishAmount toSmallVolumeWithContractID:contractOrderModel.instrument_id];
    self.finishAmountLabel.text = [NSString stringWithFormat:@"%@ %@", finishAmount,@"张"];
    
    // 委托价格
    self.contractPriceLabel.text = [NSString stringWithFormat:@"%@%@", [contractOrderModel.px toSmallPriceWithContractID:contractOrderModel.instrument_id], contractOrderModel.contractInfo.quote_coin];
    if ((self.contractListType == SLContractListTypeHistory) && contractOrderModel.category == BTContractOrderCategoryMarket) {
        self.contractPriceLabel.text = Launguage(@"TD_MA_OR");
    }
    
    // 委托价值
    self.contractWorthLabel.text = [NSString stringWithFormat:@"%@%@", [contractOrderModel.avai toSmallValueWithContract:contractOrderModel.instrument_id], contractOrderModel.contractInfo.margin_coin];
    
    // 成交均价
    self.historyFinishPriceLabel.text = [contractOrderModel.avg_px toSmallPriceWithContractID:contractOrderModel.instrument_id];
    
    // 计划委托-触发价格
    NSString *priceType = nil;
    if (contractOrderModel.trigger_type == BTContractOrderTradePriceType) {
        priceType = Launguage(@"str_new_price");
    } else if (contractOrderModel.trigger_type == BTContractOrderMarkPriceType) {
        priceType = @"合理价";
    } else if (contractOrderModel.trigger_type == BTContractOrderIndexPriceType) {
        priceType = @"指数价";
    }
    NSString *triggerPrice = [NSString stringWithFormat:@"%@ %@ %@", priceType, contractOrderModel.px, contractOrderModel.contractInfo.quote_coin];
    self.planTriggerPriceLabel.text = triggerPrice;
    // 计划委托-执行价格
    if ((self.contractListType == SLContractListTypePlanCurrent || self.contractListType == SLContractListTypePlanHistory) && contractOrderModel.category == BTContractOrderCategoryMarket) {
        self.planPerformPriceLabel.text = Launguage(@"TD_MA_OR");
    } else {
        self.planPerformPriceLabel.text = [NSString stringWithFormat:@"%@ %@", contractOrderModel.exec_px, contractOrderModel.contractInfo.quote_coin];
    }
    // 计划委托-执行数量
    self.planPerformAmountLabel.text = [NSString stringWithFormat:@"%@ %@", contractOrderModel.qty,@"张"];
    // 计划委托-到期时间
    self.planExpireTimeLabel.text = [BTFormat datelocalTimeStr:[BTFormat dateFromUTCString:contractOrderModel.created_at] format:DATE_FORMAT_YMDHm addDate:60 * 60 * contractOrderModel.cycle.doubleValue];
    
    // 订单状态
    switch (contractOrderModel.status) {
        case BTContractOrderStatusApproval: // 申报中
            self.cancelButton.userInteractionEnabled = YES;
            [self.cancelButton setTitle:Launguage(@"str_revoke") forState:UIControlStateNormal];
            self.cancelButton.layer.borderColor = IMPORT_BTN_COLOR.CGColor;
            [self.cancelButton setTitleColor:IMPORT_BTN_COLOR forState:UIControlStateNormal];
            break;
        case BTContractOrderStatusWait: // 委托中
            self.cancelButton.userInteractionEnabled = YES;
            [self.cancelButton setTitle:Launguage(@"str_revoke") forState:UIControlStateNormal];
            self.cancelButton.layer.borderColor = IMPORT_BTN_COLOR.CGColor;
            [self.cancelButton setTitleColor:IMPORT_BTN_COLOR forState:UIControlStateNormal];
            break;
        case BTContractOrderStatusFinished: { // 结束
            NSString *tips = @"订单完成";
            UIColor *color = MAIN_BTN_COLOR;
            if (self.contractListType == SLContractListTypePlanHistory) { // 历史计划委托
//                [self.detailBtn setImage:[UIImage imageWithName:@"icon-Q_white-s"] forState:UIControlStateNormal];
                switch (contractOrderModel.errorno) {
                    case BTContractOrderErrNONoErr:
                        tips = @"触发成功";
                        color = UP_WARD_COLOR;
                        break;
                    case BTContractOrderErrCancel:
                        tips = @"用户撤销";
                        color = GARY_BG_TEXT_COLOR;
                        break;
                    case BTContractOrderErrTimeout:
                        tips = @"订单过期";
                        color = IMPORT_BTN_COLOR;
                        break;
                    default:
                        tips = @"触发失败";
                        color = DOWN_COLOR;
                        break;
                }
                self.historyOrderStatusLabel.text = tips;
                self.historyOrderStatusLabel.textColor = color;
            } else {
                if (self.contractListType == SLContractListTypeHistory) {
                    if (contractOrderModel.errorno > 1) {
//                        self.historyInfoBtn.hidden = NO;
//                        [self.historyInfoBtn setImage:[UIImage imageWithName:@"icon-Q_white-s"] forState:UIControlStateNormal];
                    } else {
//                        self.historyInfoBtn.hidden = YES;
                    }
                }
                if (contractOrderModel.errorno != BTContractOrderErrNONoErr && contractOrderModel.errorno < 4 && [contractOrderModel.cum_qty GreaterThan:BT_ZERO]) {
                    tips = @"部分成交";
                    color = IMPORT_BTN_COLOR;
                } else {
                    switch (contractOrderModel.errorno) {
                        case BTContractOrderErrCancel:
                            tips = @"用户撤销";
                            color = DOWN_COLOR;
                            break;
                        case BTContractOrderErrTimeout:
                            tips = @"系统撤销";
                            color = IMPORT_BTN_COLOR;
                            break;
                        case BTContractOrderErrASSETS:
                            tips = @"系统撤销";
                            color = DOWN_COLOR;
                            break;
                        case BTContractOrderErrUNDO:
                            tips = @"系统撤销";
                            color = DOWN_COLOR;
                            break;
                        case BTContractOrderErrCLOSE:
                            tips = @"系统撤销";
                            color = DOWN_COLOR;
                            break;
                        case BTContractOrderErrReduce:
                            tips = @"系统撤销";
                            color = DOWN_COLOR;
                            break;
                        case BTContractOrderErrCompensate:
                            tips = @"系统撤销";
                            color = DOWN_COLOR;
                            break;
                        default:
                            break;
                    }
                }
            }
            [self.cancelButton setTitle:tips forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:color forState:UIControlStateNormal];
            self.historyOrderStatusLabel.text = tips;
            self.historyOrderStatusLabel.textColor = color;
            break;
        }
        default:
            break;
    }
}

- (void)setContractListType:(SLContractListType)contractListType {
    if (_contractListType == contractListType) {
        return;
    }
    _contractListType = contractListType;
    switch (contractListType) {
        case SLContractListTypeCurrent:
            self.cancelButton.hidden = NO;
            self.contractAmountTitleLabel.hidden = NO;
            self.contractAmountLabel.hidden = NO;
            self.finishAmountTitleLabel.hidden = NO;
            self.finishAmountLabel.hidden = NO;
            self.contractPriceTitleLabel.hidden = NO;
            self.contractPriceLabel.hidden = NO;
            self.contractWorthTitleLabel.hidden = NO;
            self.contractWorthLabel.hidden = NO;
            self.historyOrderStatusLabel.hidden = YES;
            self.historyFinishPriceTitleLabel.hidden = YES;
            self.historyFinishPriceLabel.hidden = YES;
            self.planTriggerPriceTitleLabel.hidden = YES;
            self.planTriggerPriceLabel.hidden = YES;
            self.planPerformPriceTitleLabel.hidden = YES;
            self.planPerformPriceLabel.hidden = YES;
            self.planPerformAmountTitleLabel.hidden = YES;
            self.planPerformAmountLabel.hidden = YES;
            self.planExpireTimeTitleLabel.hidden = YES;
            self.planExpireTimeLabel.hidden = YES;
            break;
        case SLContractListTypeHistory:
            self.cancelButton.hidden = YES;
            self.contractAmountTitleLabel.hidden = NO;
            self.contractAmountLabel.hidden = NO;
            self.finishAmountTitleLabel.hidden = NO;
            self.finishAmountLabel.hidden = NO;
            self.contractPriceTitleLabel.hidden = NO;
            self.contractPriceLabel.hidden = NO;
            self.contractWorthTitleLabel.hidden = YES;
            self.contractWorthLabel.hidden = YES;
            self.historyOrderStatusLabel.hidden = NO;
            self.historyFinishPriceTitleLabel.hidden = NO;
            self.historyFinishPriceLabel.hidden = NO;
            self.planTriggerPriceTitleLabel.hidden = YES;
            self.planTriggerPriceLabel.hidden = YES;
            self.planPerformPriceTitleLabel.hidden = YES;
            self.planPerformPriceLabel.hidden = YES;
            self.planPerformAmountTitleLabel.hidden = YES;
            self.planPerformAmountLabel.hidden = YES;
            self.planExpireTimeTitleLabel.hidden = YES;
            self.planExpireTimeLabel.hidden = YES;
            break;
        case SLContractListTypePlanCurrent:
            self.cancelButton.hidden = NO;
            self.contractAmountTitleLabel.hidden = YES;
            self.contractAmountLabel.hidden = YES;
            self.finishAmountTitleLabel.hidden = YES;
            self.finishAmountLabel.hidden = YES;
            self.contractPriceTitleLabel.hidden = YES;
            self.contractPriceLabel.hidden = YES;
            self.contractWorthTitleLabel.hidden = YES;
            self.contractWorthLabel.hidden = YES;
            self.historyOrderStatusLabel.hidden = YES;
            self.historyFinishPriceTitleLabel.hidden = YES;
            self.historyFinishPriceLabel.hidden = YES;
            self.planTriggerPriceTitleLabel.hidden = NO;
            self.planTriggerPriceLabel.hidden = NO;
            self.planPerformPriceTitleLabel.hidden = NO;
            self.planPerformPriceLabel.hidden = NO;
            self.planPerformAmountTitleLabel.hidden = NO;
            self.planPerformAmountLabel.hidden = NO;
            self.planExpireTimeTitleLabel.hidden = NO;
            self.planExpireTimeLabel.hidden = NO;
            break;
        case SLContractListTypePlanHistory:
            self.cancelButton.hidden = YES;
            self.contractAmountTitleLabel.hidden = YES;
            self.contractAmountLabel.hidden = YES;
            self.finishAmountTitleLabel.hidden = YES;
            self.finishAmountLabel.hidden = YES;
            self.contractPriceTitleLabel.hidden = YES;
            self.contractPriceLabel.hidden = YES;
            self.contractWorthTitleLabel.hidden = YES;
            self.contractWorthLabel.hidden = YES;
            self.historyOrderStatusLabel.hidden = NO;
            self.historyFinishPriceTitleLabel.hidden = YES;
            self.historyFinishPriceLabel.hidden = YES;
            self.planTriggerPriceTitleLabel.hidden = NO;
            self.planTriggerPriceLabel.hidden = NO;
            self.planPerformPriceTitleLabel.hidden = NO;
            self.planPerformPriceLabel.hidden = NO;
            self.planPerformAmountTitleLabel.hidden = NO;
            self.planPerformAmountLabel.hidden = NO;
            self.planExpireTimeTitleLabel.hidden = NO;
            self.planExpireTimeLabel.hidden = NO;
            break;
        default:
            break;
    }
}


#pragma mark - Click Events

/// 点击撤单
- (void)cancelButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contractListCell_cancelButtonClickWithOrderModel:)]) {
        [self.delegate contractListCell_cancelButtonClickWithOrderModel:self.contractMdoel];
    }
}


#pragma mark - lazy load

#pragma mark 历史委托

- (UILabel *)historyOrderStatusLabel {
    if (_historyOrderStatusLabel == nil) {
        _historyOrderStatusLabel = [UILabel labelWithText:@"订单完成" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].blueTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(SL_SCREEN_WIDTH - 80 - _horMargin, 0, 80, self.timeLabel.sl_maxY) superview:self.contentView];
        _historyOrderStatusLabel.hidden = YES;
    }
    return _historyOrderStatusLabel;
}

- (UILabel *)historyFinishPriceTitleLabel {
    if (_historyFinishPriceTitleLabel == nil) {
        _historyFinishPriceTitleLabel = [UILabel labelWithText:Launguage(@"str_deal_price") textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self.contractWorthTitleLabel.frame superview:self.contentView];
        _historyFinishPriceTitleLabel.hidden = YES;
    }
    return _historyFinishPriceTitleLabel;
}

- (UILabel *)historyFinishPriceLabel {
    if (_historyFinishPriceLabel == nil) {
        _historyFinishPriceLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self.contractWorthLabel.frame superview:self.contentView];
        _historyFinishPriceLabel.hidden = YES;
    }
    return _historyFinishPriceLabel;
}


#pragma mark 计划委托

- (UILabel *)planTriggerPriceTitleLabel {
    if (_planTriggerPriceTitleLabel == nil) {
        _planTriggerPriceTitleLabel = [UILabel labelWithText:@"触发价格" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self.contractAmountTitleLabel.frame superview:self.contentView];
        _planTriggerPriceTitleLabel.hidden = YES;
    }
    return _planTriggerPriceTitleLabel;
}

- (UILabel *)planTriggerPriceLabel {
    if (_planTriggerPriceLabel == nil) {
        _planTriggerPriceLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self.contractAmountLabel.frame superview:self.contentView];
        _planTriggerPriceLabel.hidden = YES;
    }
    return _planTriggerPriceLabel;
}

- (UILabel *)planPerformPriceTitleLabel {
    if (_planPerformPriceTitleLabel == nil) {
        _planPerformPriceTitleLabel = [UILabel labelWithText:@"执行价格" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self. finishAmountTitleLabel.frame superview:self.contentView];
        _planPerformPriceTitleLabel.hidden = YES;
    }
    return _planPerformPriceTitleLabel;
}

- (UILabel *)planPerformPriceLabel {
    if (_planPerformPriceLabel == nil) {
        _planPerformPriceLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self.finishAmountLabel.frame superview:self.contentView];
        _planPerformPriceLabel.hidden = YES;
    }
    return _planPerformPriceLabel;
}

- (UILabel *)planPerformAmountTitleLabel {
    if (_planPerformAmountTitleLabel == nil) {
        _planPerformAmountTitleLabel = [UILabel labelWithText:@"执行数量" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self. contractPriceTitleLabel.frame superview:self.contentView];
        _planPerformAmountTitleLabel.hidden = YES;
    }
    return _planPerformAmountTitleLabel;
}

- (UILabel *)planPerformAmountLabel {
    if (_planPerformAmountLabel == nil) {
        _planPerformAmountLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self.contractPriceLabel.frame superview:self.contentView];
        _planPerformAmountLabel.hidden = YES;
    }
    return _planPerformAmountLabel;
}

- (UILabel *)planExpireTimeTitleLabel {
    if (_planExpireTimeTitleLabel == nil) {
        _planExpireTimeTitleLabel = [UILabel labelWithText:@"到期时间" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self.contractWorthTitleLabel.frame superview:self.contentView];
        _planExpireTimeTitleLabel.hidden = YES;
    }
    return _planExpireTimeTitleLabel;
}

- (UILabel *)planExpireTimeLabel {
    if (_planExpireTimeLabel == nil) {
        _planExpireTimeLabel = [UILabel labelWithText:@"-" textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:self.contractWorthLabel.frame superview:self.contentView];
        _planExpireTimeLabel.hidden = YES;
    }
    return _planExpireTimeLabel;
}


@end
