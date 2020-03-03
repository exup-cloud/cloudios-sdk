//
//  SLContractMakeOrderView.m
//  BTTest
//
//  Created by wwly on 2019/9/3.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractMakeOrderView.h"
#import "SLContractOrderTypeView.h"
#import "SLContractTextField.h"
#import "SLButton.h"
#import "SLContractTableViewController.h"

@interface SLContractMakeOrderView () <SLContractOrderTypeViewDelegate>
/// 委托类型 (限价委托，市价委托，计划委托)
@property (nonatomic, assign) BTContractOrderCategory defineContractType;
/// 委托类型
@property (nonatomic, strong) UIButton * orderTypeButton;
/// 选择委托类型
@property (nonatomic, strong) SLContractOrderTypeView * orderTypeView;
/// 杠杆倍数
@property (nonatomic, strong) SLButton * leverageButton;

/// 计划委托_触发价格
@property (nonatomic, strong) SLContractTextField * planTriggerPriceTextField;
/// 触发价格转换成法币的价格
@property (nonatomic, strong) UILabel * planTriggerPriceLabel;
/// 计划委托_执行价格
@property (nonatomic, strong) SLContractTextField * planPerformPriceTextField;
/// 计划委托市价
@property (nonatomic, strong) UIButton * planPerformMarketPriceButton;
/// 执行价格转换成法币的价格
@property (nonatomic, strong) UILabel * planPerformPriceLabel;

/// 价格
@property (nonatomic, strong) SLContractTextField * priceTextField;
/// 转换成法币的价格
@property (nonatomic, strong) UILabel * legalTenderPriceLabel;
/// 市价
@property (nonatomic, strong) UIButton * marketPriceButton;
/// 买一价
@property (nonatomic, strong) UIButton * buyPriceButton;
/// 卖一价
@property (nonatomic, strong) UIButton * sellPriceButton;
/// 数量
@property (nonatomic, strong) SLContractTextField * amountTextField;
/// 委托数量对应的价格
@property (nonatomic, strong) UILabel * amountPriceLabel;
/// 买入开多
@property (nonatomic, strong) UIButton * buyButton;
/// 可开多少张多
@property (nonatomic, strong) UILabel * canBuyLongLabel;
/// 卖出开空
@property (nonatomic, strong) UIButton * sellButton;
/// 可开多少张空
@property (nonatomic, strong) UILabel * canSellShortLabel;

/// 可平多少张空
@property (nonatomic, strong) UILabel * canBuyShortLabel;
/// 持仓 空单
@property (nonatomic, strong) UILabel * haveShortLabel;
/// 可平多少张多
@property (nonatomic, strong) UILabel * canSellLongLabel;
/// 持仓 多单
@property (nonatomic, strong) UILabel * haveLongLabel;

/// 可用
@property (nonatomic, strong) UILabel * canUseLabel;

/// 支持杠杆数组
@property (nonatomic, strong) NSArray * leverageArr;
/// 当前杠杆
@property (nonatomic, strong) NSString *leverage;
/// 当前开仓类型
@property (nonatomic, assign) BTPositionOpenType position_type;
/// 价格单位
@property (nonatomic, copy) NSString *priceUnit;
/// 成本单位
@property (nonatomic, copy) NSString *costUnit;
/// 对应合约已存在多仓位
@property (nonatomic, strong) BTPositionModel *buyPosition;
/// 对应合约已存在空仓位
@property (nonatomic, strong) BTPositionModel *sellPosition;
/// 资金划转按钮
@property (nonatomic, strong) SLButton *fundTransferBtn;
/// 合约信息
@property (nonatomic, strong) BTContractsModel *contractModel;
/// 当前合约收取币种的资产
@property (nonatomic, strong) BTItemCoinModel *asset;

/// 开仓 平仓
@property (nonatomic, assign) BTContractOrderType currentOrderType;

/// 开多模型
@property (nonatomic, strong) BTContractOrderModel *orderLongModel;
/// 开空模型
@property (nonatomic, strong) BTContractOrderModel *orderShortModel;
/// 平仓模型
@property (nonatomic, strong) BTContractOrderModel *closeModel;

@property (nonatomic, strong) BTContractOrderModel * currentOrderModel;

@end

@implementation SLContractMakeOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.currentOrderType = BTDefineContractOpen;
    self.defineContractType = BTContractOrderCategoryNormal;
    self.orderTypeButton = [[SLButton alloc] initWithContentFrameType:(BTTiTleLabelInFontType)];
    [self.orderTypeButton setTitle:Launguage(@"str_normalOrder") forState:UIControlStateNormal];
    [self.orderTypeButton setTitleColor:[SLConfig defaultConfig].lightTextColor forState:UIControlStateNormal];
    self.orderTypeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.orderTypeButton addTarget:self action:@selector(orderTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderTypeButton setImage:[UIImage imageWithName:@"3j"] forState:UIControlStateNormal];
    self.orderTypeButton.frame = CGRectMake(0, 0, 100, 50);
    [self.orderTypeButton sizeToFit];
    self.orderTypeButton.sl_x = 0;
    self.orderTypeButton.sl_y = 0;
    self.orderTypeButton.sl_height = SL_getWidth(50);
    [self addSubview:self.orderTypeButton];
    
    self.leverageButton = [[SLButton alloc] initWithContentFrameType:(BTTiTleLabelInFontType)];
    NSString *lever = [BTStoreData storeObjectForKey:SL_LEVERAGE];
    if (lever) {
        [self.leverageButton setTitle:lever forState:UIControlStateNormal];
    } else {
        [self.leverageButton setTitle:@"杠杆倍数" forState:UIControlStateNormal];
    }
    [self.leverageButton setTitleColor:[SLConfig defaultConfig].lightTextColor forState:UIControlStateNormal];
    self.leverageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.leverageButton addTarget:self action:@selector(leverageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leverageButton setImage:[UIImage imageWithName:@"3j"] forState:UIControlStateNormal];
    CGFloat w = 100;
    [self.leverageButton sizeToFit];
    self.leverageButton.sl_centerY = self.orderTypeButton.sl_centerY;
    self.leverageButton.sl_x = self.sl_width - self.leverageButton.sl_width;
    
    [self addSubview:self.leverageButton];
    
    self.priceTextField = [[SLContractTextField alloc] initWithFrame:CGRectMake(self.orderTypeButton.sl_x, self.orderTypeButton.sl_maxY, self.sl_width, 45)];
    [self.priceTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.priceTextField.placeholder = Launguage(@"BT_MAIN_P");
    self.priceTextField.rightView = [UILabel labelWithText:@"USDT" textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(0, 0, 50, 45) superview:nil];
    self.priceTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.priceTextField];
    
    self.legalTenderPriceLabel = [UILabel labelWithText:@"≈ 0￥" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(0, self.priceTextField.sl_maxY, self.sl_width, 25) superview:self];
    
    self.marketPriceButton = [UIButton buttonExtensionWithTitle:Launguage(@"str_market") TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:12] target:self action:@selector(priceTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.marketPriceButton setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
    w = (self.sl_width - 10 * 2) / 3;
    self.marketPriceButton.frame = CGRectMake(0, self.legalTenderPriceLabel.sl_maxY, w, 25);
    self.marketPriceButton.layer.cornerRadius = 2;
    self.marketPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    self.marketPriceButton.layer.borderWidth = 1;
    [self addSubview:self.marketPriceButton];
    
    self.buyPriceButton = [UIButton buttonExtensionWithTitle:Launguage(@"str_buyOne") TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:12] target:self action:@selector(priceTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyPriceButton setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
    self.buyPriceButton.frame = CGRectMake(self.marketPriceButton.sl_maxX + 10, self.marketPriceButton.sl_y, w, self.marketPriceButton.sl_height);
    self.buyPriceButton.layer.cornerRadius = 2;
    self.buyPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    self.buyPriceButton.layer.borderWidth = 1;
    [self addSubview:self.buyPriceButton];
    
    self.sellPriceButton = [UIButton buttonExtensionWithTitle:Launguage(@"str_sellOne") TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:12] target:self action:@selector(priceTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sellPriceButton setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
    self.sellPriceButton.frame = CGRectMake(self.buyPriceButton.sl_maxX + 10, self.buyPriceButton.sl_y, w, self.marketPriceButton.sl_height);
    self.sellPriceButton.layer.cornerRadius = 2;
    self.sellPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    self.sellPriceButton.layer.borderWidth = 1;
    [self addSubview:self.sellPriceButton];
    
    self.amountTextField = [[SLContractTextField alloc] initWithFrame:CGRectMake(0, self.marketPriceButton.sl_maxY + 10, self.sl_width, 45)];
    [self.amountTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.amountTextField.rightView = [UILabel labelWithText:@"张" textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(0, 0, 35, 45) superview:nil];
    self.amountTextField.rightViewMode = UITextFieldViewModeAlways;
    self.amountTextField.placeholder = Launguage(@"BT_MAIN_V");
    [self addSubview:self.amountTextField];
    
    self.amountPriceLabel = [UILabel labelWithText:@"≈ 0" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(0, self.amountTextField.sl_maxY, self.sl_width, 25) superview:self];
    BOOL isCoin = [BTStoreData storeBoolForKey:SL_UNIT_VOL];
    NSString *vol = self.amountTextField.text;
    NSString *amount = BT_ZERO;
    if (isCoin) {
        vol = [SLFormula coinToTicket:vol price:self.priceTextField.text contract:_itemModel.contractInfo];
        amount = vol;
        self.amountPriceLabel.text = [NSString stringWithFormat:@"≈ %@ %@",amount,@"张"];
    } else {
        amount = [SLFormula calculateContractBasicValueWithPrice:self.priceTextField.text vol:vol contract:self.itemModel.contractInfo];
        self.amountPriceLabel.text = [NSString stringWithFormat:@"≈ %@ %@",amount,self.itemModel.contractInfo.base_coin];
    }
    
    self.buyButton = [UIButton buttonExtensionWithTitle:@"买入开多 (看多)" TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:15] target:self action:@selector(buyOrSellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buyButton.frame = CGRectMake(0, self.amountPriceLabel.sl_maxY, self.sl_width, 40);
    self.buyButton.layer.cornerRadius = 3;
    self.buyButton.backgroundColor = [SLConfig defaultConfig].greenColorForBuy;
    [self addSubview:self.buyButton];
    
    self.canBuyLongLabel = [UILabel labelWithText:@"可开多: " textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.buyButton.sl_x, self.buyButton.sl_maxY, self.buyButton.sl_width, 25) superview:self];
    
    self.sellButton = [UIButton buttonExtensionWithTitle:@"卖出开空 (看空)" TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:15] target:self action:@selector(buyOrSellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sellButton.frame = CGRectMake(self.buyButton.sl_x, self.canBuyLongLabel.sl_maxY, self.buyButton.sl_width, self.buyButton.sl_height);
    self.sellButton.layer.cornerRadius = 3;
    self.sellButton.backgroundColor = [SLConfig defaultConfig].redColorForSell;
    [self addSubview:self.sellButton];
    
    self.canSellShortLabel = [UILabel labelWithText:@"可开空: " textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.sellButton.sl_x, self.sellButton.sl_maxY, self.sellButton.sl_width, 25) superview:self];
    
    self.canBuyShortLabel = [UILabel labelWithText:[NSString stringWithFormat:@"可平：-%@",@"张"] textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.buyButton.sl_x, self.buyButton.sl_maxY, self.buyButton.sl_width, 25) superview:self];
    self.canBuyShortLabel.hidden = YES;
    
    self.haveShortLabel = [UILabel labelWithText:[NSString stringWithFormat:@"持仓：-%@",@"张"] textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.buyButton.sl_x, self.canBuyShortLabel.sl_y, self.buyButton.sl_width, self.canBuyShortLabel.sl_height) superview:self];
    self.haveShortLabel.hidden = YES;
    
    self.canSellLongLabel = [UILabel labelWithText:[NSString stringWithFormat:@"可平：-%@",@"张"] textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.sellButton.sl_x, self.sellButton.sl_maxY, self.sellButton.sl_width, 25) superview:self];
    self.canSellLongLabel.hidden = YES;
    
    self.haveLongLabel = [UILabel labelWithText:[NSString stringWithFormat:@"持仓：-%@",@"张"] textAlignment:NSTextAlignmentRight textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.sellButton.sl_x, self.canSellLongLabel.sl_y, self.sellButton.sl_width, self.canBuyShortLabel.sl_height) superview:self];
    self.haveLongLabel.hidden = YES;
    
    self.canUseLabel = [UILabel labelWithText:@"可用余额: " textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:13] numberOfLines:1 frame:CGRectMake(self.canSellShortLabel.sl_x, self.canSellShortLabel.sl_maxY, self.canSellShortLabel.sl_width, self.canSellShortLabel.sl_height) superview:self];
    
    [self addSubview:self.fundTransferBtn];
}

- (void)updateUI {
    if (![SLPlatformSDK sharedInstance].activeAccount) {
        [self.buyButton setTitle:Launguage(@"LOGIN_LI") forState:UIControlStateNormal];
        [self.sellButton setTitle:Launguage(@"LOGIN_LI") forState:UIControlStateNormal];
    } else if (self.currentOrderType == BTDefineContractOpen) { // 开仓
        self.leverageButton.hidden = NO;
        [self.buyButton setTitle:Launguage(@"BT_CA_KDMR") forState:UIControlStateNormal];
        [self.sellButton setTitle:Launguage(@"BT_CA_KKMC") forState:UIControlStateNormal];
    } else if (_currentOrderType == BTDefineContractClose) { // 平仓
        self.leverageButton.hidden = YES;
        [self.buyButton setTitle:@"买入平空" forState:UIControlStateNormal];
        [self.sellButton setTitle:@"卖出开多" forState:UIControlStateNormal];
        // 判断是否有此合约ID的仓位
        self.buyPosition = [SLFormula getUserPositionWithItemModel:_itemModel contractWay:BTContractOrderWayBuy_OpenLong];
        self.sellPosition = [SLFormula getUserPositionWithItemModel:_itemModel contractWay:BTContractOrderWaySell_OpenShort];;
    }
    if (!self.asset) {
        self.canUseLabel.text = [NSString stringWithFormat:@"%@: -- ",Launguage(@"BT_CA_KYYE")];
    } else {
        NSString *balanceCode = self.contractModel.margin_coin;
        NSString *balance = [NSString stringWithFormat:@"--%@",balanceCode];
        if ([self.asset.coin_code isEqualToString:balanceCode]) {
            balance = [NSString stringWithFormat:@"%@%@",self.asset.contract_avail?[self.asset.contract_avail toSmallValueWithContract:_itemModel.instrument_id]:@"--",self.asset.coin_code];
        }
        self.canUseLabel.text = [NSString stringWithFormat:@"%@: %@",Launguage(@"BT_CA_KYYE"),balance];
    }
    
    if (self.currentOrderType == BTDefineContractOpen) {
        [self loadOpenOrderPropertyUI];
    } else if (self.currentOrderType == BTDefineContractClose) {
        [self loadCloseOrderPropertyUI];
    }
    
    [self.leverageButton sizeToFit];
    self.leverageButton.sl_x = self.sl_width - self.leverageButton.sl_width;
}

/// 设置开仓UI
- (void)loadOpenOrderPropertyUI {
    self.buyButton.enabled = YES;
    self.sellButton.enabled = YES;
    self.priceUnit = self.contractModel.quote_coin;
    self.costUnit = self.contractModel.margin_coin;
    NSString *unit = @"张";
    BOOL isCoin = [BTStoreData storeBoolForKey:SL_UNIT_VOL];
    if (isCoin) {
        unit = self.contractModel.base_coin;
    }
    [self.priceTextField updateRightViewText:self.priceUnit];
    [self.amountTextField updateRightViewText:unit];
    BTContractOrderModel *order_long = [[BTContractOrderModel alloc] init];
    BTContractOrderModel *order_short = [[BTContractOrderModel alloc] init];
    
    self.orderLongModel = [self caculatePropertyUIWithWay:BTContractOrderWayBuy_OpenLong contract:self.contractModel unit:unit order:order_long isCoin:isCoin];
    self.orderShortModel = [self caculatePropertyUIWithWay:BTContractOrderWaySell_OpenShort contract:self.contractModel unit:unit order:order_short isCoin:isCoin];
}

/// 设置平仓UI
- (void)loadCloseOrderPropertyUI {
    NSString *unit = @"张";
    BTContractsModel *contract = _itemModel.contractInfo;
    BOOL isCoin = [BTStoreData storeBoolForKey:SL_UNIT_VOL];
    if (isCoin) {
        unit = contract.base_coin;
    }
    [self.amountTextField updateRightViewText:unit];
    self.priceUnit = contract.quote_coin;
    BTContractOrderModel *order = [[BTContractOrderModel alloc] init];
    order.takeFeeRatio = self.contractModel.taker_fee_ratio;
    order.instrument_id = _itemModel.instrument_id;
    order.category = self.defineContractType;
    order.leverage = self.leverage;
    order.index_px = _itemModel.index_px;
    order.position_type = self.position_type;
    order.qty = self.amountTextField.text;
    if (self.defineContractType == BTContractOrderCategoryNormal) {
        [self.priceTextField updateRightViewText:self.priceUnit];
        if (self.marketPriceButton.selected) {
            order.category = BTContractOrderCategoryMarket;
            order.px = _itemModel.last_px;
        } else if (self.buyPriceButton.selected) {
            order.category = BTContractOrderCategoryNormal;
            order.px = self.buyOnePrice;
        } else if (self.sellPriceButton.selected) {
            order.category = BTContractOrderCategoryNormal;
            order.px = self.sellOnePrice;
        } else {
            if ([self.priceTextField.text LessThanOrEqual:BT_ZERO]) {
                order.px = _itemModel.fair_px;
            } else {
                order.px = self.priceTextField.text;
            }
        }
        order.category = BTContractOrderCategoryNormal;
    } else if (self.defineContractType == BTContractOrderCategoryPlan) {
        if (self.planPerformMarketPriceButton.selected) {
            order.category = BTContractOrderCategoryMarket;
            order.exec_px = _itemModel.last_px;
        } else {
            order.category = BTContractOrderCategoryNormal;
            order.exec_px = self.planPerformPriceTextField.text;
        }
        order.px = self.planTriggerPriceTextField.text;
        // 价方向
        if ([order.px LessThan:_itemModel.last_px]) { // 计划价格低于当前价格
            order.trend = BTContractOrderPriceWayDown;
        } else if ([order.px GreaterThan:_itemModel.last_px]) {
            order.trend = BTContractOrderPriceWayUp;
        } else {
            order.trend = BTContractOrderPriceWayUp;
        }
        
        // 价类型
        if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"1"]) {
            order.trigger_type = BTContractOrderTradePriceType;
            self.planTriggerPriceTextField.placeholder = [NSString stringWithFormat:@"触发价格(%@)",Launguage(@"str_new_price")];
            
            // 价方向
            if ([order.px LessThan:_itemModel.last_px]) { // 计划价格低于当前价格
                order.trend = BTContractOrderPriceWayDown;
            } else if ([order.px GreaterThan:_itemModel.last_px]) {
                order.trend = BTContractOrderPriceWayUp;
            } else {
                order.trend = BTContractOrderPriceWayUp;
            }
            
        } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
            order.trigger_type = BTContractOrderMarkPriceType;
            self.planTriggerPriceTextField.placeholder = @"触发价格(合理价)";
            // 价方向
            if ([order.px LessThan:_itemModel.fair_px]) { // 计划价格低于当前价格
                order.trend = BTContractOrderPriceWayDown;
            } else if ([order.px GreaterThan:_itemModel.fair_px]) {
                order.trend = BTContractOrderPriceWayUp;
            } else {
                order.trend = BTContractOrderPriceWayUp;
            }
        } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"3"]) {
            order.trigger_type = BTContractOrderIndexPriceType;
            self.planTriggerPriceTextField.placeholder = @"触发价格(指数价)";
            if ([order.px LessThan:_itemModel.index_px]) { // 计划价格低于当前价格
                order.trend = BTContractOrderPriceWayDown;
            } else if ([order.px GreaterThan:_itemModel.index_px]) {
                order.trend = BTContractOrderPriceWayUp;
            } else {
                order.trend = BTContractOrderPriceWayUp;
            }
        }
        
        // 价周期
        if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"7"]) { // 周期7天
            order.cycle = @(7 * 24);
        } else if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"24"]) { // 周期24小时
            order.cycle = @(24);
        }
    }
    if (isCoin) {
        NSString *volume = [SLFormula coinToTicket:order.qty price:order.px contract:contract];
        int len = (int)[NSString getVolume_unitWithContractID:order.instrument_id];
        order.qty = [volume toString:len-1 cut:YES];
    }
    
    if ([SLPlatformSDK sharedInstance].activeAccount) {
        self.buyButton.enabled = NO;
        self.sellButton.enabled = NO;
    } else {
        self.buyButton.enabled = YES;
        self.sellButton.enabled = YES;
    }
    
    if (self.buyPosition) {
        NSString *canClose = [self.buyPosition.cur_qty bigSub:self.buyPosition.freeze_qty];
        
        NSString *holdStr = self.buyPosition.cur_qty;
        if (isCoin) {
            holdStr = [SLFormula ticketToCoin:holdStr price:self.buyPosition.markPrice contract:contract];
        }
        
        if (isCoin) {
            canClose = [SLFormula ticketToCoin:canClose price:self.buyPosition.markPrice contract:contract];
        }
        if ([canClose GreaterThan:BT_ZERO]) { // 如果可平仓量大于0
            self.sellButton.enabled = YES;
        }
        self.canBuyShortLabel.text = [NSString stringWithFormat:@"%@：%@%@",@"可平",canClose,unit];
        self.haveShortLabel.text = [NSString stringWithFormat:@"%@：%@%@",@"持仓",holdStr,unit];
    } else {
        self.canBuyShortLabel.text = [NSString stringWithFormat:@"%@：0%@",@"可平",unit];
        self.haveShortLabel.text = [NSString stringWithFormat:@"%@：0%@",@"持仓",unit];
    }
    
    if (self.sellPosition) {
        NSString *canClose = [self.sellPosition.cur_qty bigSub:self.sellPosition.freeze_qty];
        NSString *holdStr = self.sellPosition.cur_qty;
        
        if (isCoin) {
            canClose = [SLFormula ticketToCoin:canClose price:self.buyPosition.markPrice contract:contract];
        }
        if (isCoin) {
            holdStr = [SLFormula ticketToCoin:holdStr price:self.buyPosition.markPrice contract:contract];
        }
        if ([canClose GreaterThan:BT_ZERO]) { // 如果可平仓量大于0
            self.buyButton.enabled = YES;
        }
        
        self.canBuyLongLabel.text = [NSString stringWithFormat:@"%@：%@%@",@"可平",canClose,unit];
        self.haveLongLabel.text = [NSString stringWithFormat:@"%@：%@%@",@"持仓",holdStr,unit];
        
    } else {
        self.canBuyLongLabel.text = [NSString stringWithFormat:@"%@：0%@",@"可平",unit];
        self.haveLongLabel.text = [NSString stringWithFormat:@"%@：0%@",@"持仓",unit];
    }
    
    self.closeModel = order;
}

- (BTContractOrderModel *)caculatePropertyUIWithWay:(BTContractOrderWay)way contract:(BTContractsModel *)contract unit:(NSString *)unit order:(BTContractOrderModel *)order isCoin:(BOOL)isCoin {
    BTContractsOpenModel *openModel = nil;
    order.takeFeeRatio = self.contractModel.taker_fee_ratio;
    order.instrument_id = _itemModel.instrument_id;
    order.leverage = self.leverage;
    order.index_px = _itemModel.index_px;
    order.position_type = self.position_type;
    order.qty = self.amountTextField.text;
    order.side = way;
    // 默认是限价单
    order.category = BTContractOrderCategoryNormal;
    if (self.defineContractType == BTContractOrderCategoryNormal) { // 普通委托
        if (self.marketPriceButton.selected) {
            order.category = BTContractOrderCategoryMarket;
            order.px = _itemModel.last_px;
        } else if (self.buyPriceButton.selected) {
            order.category = BTContractOrderCategoryNormal;
            order.px = self.buyOnePrice;
        } else if (self.sellPriceButton.selected) {
            order.category = BTContractOrderCategoryNormal;
            order.px = self.sellOnePrice;
        } else {
            if ([self.priceTextField.text LessThanOrEqual:BT_ZERO]) {
                order.px = _itemModel.fair_px;
            } else {
                order.px = self.priceTextField.text;
            }
        }
        if (isCoin) {
            NSString *volume = [SLFormula coinToTicket:order.qty price:order.px contract:self.contractModel];
            int len = (int)[NSString getVolume_unitWithContractID:order.instrument_id];
            order.qty = [volume toString:len-1 cut:YES];
        }
        
        openModel = [[BTContractsOpenModel alloc] initWithOrderModel:order contractInfo:self.contractModel assets:self.asset];
    } else if (self.defineContractType == BTContractOrderCategoryPlan) { // 计划委托
        if (self.planPerformMarketPriceButton.selected) {
            order.category = BTContractOrderCategoryMarket;
            order.exec_px = _itemModel.last_px;
        } else {
            order.category = BTContractOrderCategoryNormal;
            order.exec_px = self.planPerformPriceTextField.text;
        }
        order.px = self.planTriggerPriceTextField.text;
        
        // 价类型
        if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"1"]) {
            order.trigger_type = BTContractOrderTradePriceType;
            self.planTriggerPriceTextField.placeholder = [NSString stringWithFormat:@"触发价格(%@)",Launguage(@"str_new_price")];
            
            // 价方向
            if ([order.px LessThan:_itemModel.last_px]) { // 计划价格低于当前价格
                order.trend = BTContractOrderPriceWayDown;
            } else if ([order.px GreaterThan:_itemModel.last_px]) {
                order.trend = BTContractOrderPriceWayUp;
            } else {
                order.trend = BTContractOrderPriceWayUp;
            }
            
        } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
            order.trigger_type = BTContractOrderMarkPriceType;
            self.planTriggerPriceTextField.placeholder = @"触发价格(合理价)";
            // 价方向
            if ([order.px LessThan:_itemModel.fair_px]) { // 计划价格低于当前价格
                order.trend = BTContractOrderPriceWayDown;
            } else if ([order.px GreaterThan:_itemModel.fair_px]) {
                order.trend = BTContractOrderPriceWayUp;
            } else {
                order.trend = BTContractOrderPriceWayUp;
            }
        } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"3"]) {
            order.trigger_type = BTContractOrderIndexPriceType;
            self.planTriggerPriceTextField.placeholder = @"触发价格(指数价)";
            if ([order.px LessThan:_itemModel.index_px]) { // 计划价格低于当前价格
                order.trend = BTContractOrderPriceWayDown;
            } else if ([order.px GreaterThan:_itemModel.index_px]) {
                order.trend = BTContractOrderPriceWayUp;
            } else {
                order.trend = BTContractOrderPriceWayUp;
            }
        }
        
        // 价周期
        if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"7"]) { // 周期7天
            order.cycle = @(7 * 24);
        } else if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"24"]) { // 周期24小时
            order.cycle = @(24);
        }
    }
    
    if (openModel != nil) {
        if (way == BTContractOrderWayBuy_OpenLong) {
            NSString *longNum = openModel.maxOpenLong;
            if (isCoin) {
                if (longNum) {
                    if ([self.priceTextField.text GreaterThan:BT_ZERO]) {
                        longNum = [SLFormula ticketToCoin:longNum price:self.priceTextField.text contract:contract];
                    } else {
                        longNum = [SLFormula ticketToCoin:longNum price:_itemModel.fair_px contract:contract];
                    }
                }
                longNum = [longNum toSmallValueWithContract:_itemModel.instrument_id];
            } else {
                longNum = [longNum toSmallVolumeWithContractID:_itemModel.instrument_id];
            }
            self.canBuyLongLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"可开多",longNum?longNum:@"--",unit];
        } else if (way == BTContractOrderWaySell_OpenShort) {
            NSString *shortNum = openModel.maxOpenShort;
            if (isCoin) {
                if (shortNum) {
                    if ([self.priceTextField.text GreaterThan:BT_ZERO]) {
                        shortNum = [SLFormula ticketToCoin:shortNum price:self.priceTextField.text contract:contract];
                    } else {
                        shortNum = [SLFormula ticketToCoin:shortNum price:_itemModel.fair_px contract:contract];
                    }
                }
                shortNum = [shortNum toSmallValueWithContract:_itemModel.instrument_id];
            } else {
                shortNum = [shortNum toSmallVolumeWithContractID:_itemModel.instrument_id];
            }
            self.canSellShortLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"可开空",shortNum?shortNum:@"--",unit];
        }
    }
    order.avai = openModel.orderAvai;
    order.freezAssets = openModel.freezAssets;
    order.balanceAssets = self.asset.contract_avail;
    return order;
}

- (void)setSelectedPrice:(NSString *)selectedPrice {
    self.priceTextField.text = selectedPrice;
    self.priceTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.priceTextField.userInteractionEnabled = YES;
    self.marketPriceButton.selected = NO;
    self.buyPriceButton.selected = NO;
    self.sellPriceButton.selected = NO;
    self.marketPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    self.buyPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    self.sellPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    [self updateUI];
}

- (void)setItemModel:(BTItemModel *)itemModel {
    if (self.defineContractType == BTContractOrderCategoryNormal && itemModel.instrument_id != _itemModel.instrument_id) {
        self.priceTextField.text = itemModel.last_px;
    }
    _itemModel = itemModel;
    self.contractModel = _itemModel.contractInfo;
    
    if ([SLPlatformSDK sharedInstance].activeAccount) {
        // 获得对应币种的资产
        for (BTItemCoinModel *coinModel in [BTMineAccountTool shareMineAccountTool].contractAccountArr) {
            if ([coinModel.coin_code isEqualToString:self.contractModel.margin_coin]) {
                self.asset = coinModel;
            }
        }
    } else {
        self.asset = nil;
    }
    self.leverageArr = self.contractModel.leverageArr;
    NSDictionary *dict = [BTStoreData storeObjectForKey:[NSString stringWithFormat:@"%@_%lld",SL_LEVERAGE_NUM,itemModel.instrument_id]];
    if (dict) {
        self.position_type = [dict[@"position_type"] integerValue];
        self.leverage = dict[@"leverage"];
        if (self.position_type == BTPositionOpen_PursueType) {
            [self.leverageButton setTitle:[NSString stringWithFormat:@"%@ %@X",Launguage(@"BT_CA_GRADE"),self.leverage] forState:UIControlStateNormal];
        } else {
            [self.leverageButton setTitle:[NSString stringWithFormat:@"%@ %@X",Launguage(@"BT_CA_CROSS"),self.leverage] forState:UIControlStateNormal];
        }
    } else {
        if (self.leverageArr.count > 0) {
            [self.leverageButton setTitle:[NSString stringWithFormat:@"%@ %@X",Launguage(@"BT_CA_GRADE"),self.leverageArr.lastObject] forState:UIControlStateNormal];
            self.leverage = self.leverageArr.lastObject;
            self.position_type = BTPositionOpen_PursueType;
            [BTStoreData setStoreObjectAndKey:dict Key:[NSString stringWithFormat:@"%@_%lld",SL_LEVERAGE_NUM,itemModel.instrument_id]];
        }
    }
    [self textFieldChanged:self.priceTextField];
}

- (void)updateViewWithContractOrderType:(BTContractOrderType)orderType {
    self.currentOrderType = orderType;
    /// 开仓
    if (orderType == BTDefineContractOpen) {
        self.canBuyShortLabel.hidden = YES;
        self.haveShortLabel.hidden = YES;
        self.canSellLongLabel.hidden = YES;
        self.haveLongLabel.hidden = YES;
        self.canBuyLongLabel.hidden = NO;
        self.canSellShortLabel.hidden = NO;
        [self.buyButton setTitle:Launguage(@"BT_CA_MRKD") forState:UIControlStateNormal];
        [self.sellButton setTitle:Launguage(@"BT_CA_MCKK") forState:UIControlStateNormal];
    } else if (orderType == BTDefineContractClose) {
        self.canBuyShortLabel.hidden = NO;
        self.haveShortLabel.hidden = NO;
        self.canSellLongLabel.hidden = NO;
        self.haveLongLabel.hidden = NO;
        self.canBuyLongLabel.hidden = YES;
        self.canSellShortLabel.hidden = YES;
        [self.buyButton setTitle:@"买入平空" forState:UIControlStateNormal];
        [self.sellButton setTitle:@"卖出开多" forState:UIControlStateNormal];
    }
    self.canBuyShortLabel.sl_y = self.buyButton.sl_maxY;
    self.haveShortLabel.sl_y = self.canBuyShortLabel.sl_y;
    self.canSellLongLabel.sl_y = self.sellButton.sl_maxY;
    self.haveLongLabel.sl_y = self.sellButton.sl_maxY;
}


#pragma mark - Click Events

/// 输入框数字变化
- (void)textFieldChanged:(UITextField *)textField {
    BOOL isCoin = [BTStoreData storeBoolForKey:SL_UNIT_VOL];
    if (textField == self.priceTextField || textField == self.planTriggerPriceTextField || textField == self.planPerformPriceTextField) { // 价格发生变化
        NSString *newPri = [textField.text stringForDecimals:[self.contractModel.px_unit bigMul:@"10"]]; // 价格精度少一位
        textField.text = newPri;
        
        NSString *exchangePrice = [Common carculateCNY:textField.text];
        if (textField == self.priceTextField) {
            self.legalTenderPriceLabel.text = [NSString stringWithFormat:@"≈ %@", exchangePrice];
        } else if (textField == self.planTriggerPriceTextField) {
            self.planTriggerPriceLabel.text = [NSString stringWithFormat:@"≈ %@", exchangePrice];
        } else if (textField == self.planPerformPriceTextField) {
            self.planPerformPriceLabel.text = [NSString stringWithFormat:@"≈ %@", exchangePrice];
        }
    } else if (textField == self.amountTextField) { // 数量发生变化
        NSString *newVol = nil;
        if (isCoin) {
            newVol = [textField.text  stringForDecimals:@"0.00000001"]; // 价格精度少一位
        } else {
            newVol = [textField.text stringForDecimals:self.contractModel.qty_unit];
        }
        self.amountTextField.text = newVol;
    }
    
    NSString *vol = self.amountTextField.text;
    NSString *amount = BT_ZERO;
    if (isCoin) {
        vol = [SLFormula coinToTicket:vol price:self.priceTextField.text contract:self.contractModel];
        amount = vol;
        self.amountPriceLabel.text = [NSString stringWithFormat:@"≈ %@ %@",amount,@"张"];
    } else {
        amount = [SLFormula calculateContractBasicValueWithPrice:self.priceTextField.text vol:vol contract:self.contractModel];
        self.amountPriceLabel.text = [NSString stringWithFormat:@"≈ %@ %@", amount, self.contractModel.base_coin];
    }
    [self updateUI];
}

/// 点击资金划转
- (void)didClickFundTransferBtn:(UIButton *)sender {
    
}

/// 更改委托类型
- (void)orderTypeButtonClick:(UIButton *)sender {
    if (self.orderTypeView.hidden == YES) {
        [self p_showOrderTypeView];
    } else {
        [self p_hiddenOrderTypeView];
    }
}

/// 更改杠杆倍数
- (void)leverageButtonClick:(UIButton *)sender {
    NSMutableArray *itemM = [NSMutableArray arrayWithCapacity:self.leverageArr.count + 1];
    if (self.leverageArr.count <= 0) {
        return;
    }
    [itemM addObject:[NSString stringWithFormat:@"%@ %@X",Launguage(@"BT_CA_CROSS"),self.leverageArr[0]]];
    for (NSString *item in self.leverageArr) {
        [itemM addObject:[NSString stringWithFormat:@"%@ %@X",Launguage(@"BT_CA_GRADE"),item]];
    }
    
    __weak typeof(self) weakSelf = self;
    if ([self.delegate respondsToSelector:@selector(contractMakeOrdersViewDidClickWithLeverArr:leverage:handle:)]) {
        [self.delegate contractMakeOrdersViewDidClickWithLeverArr:itemM leverage:sender.titleLabel.text handle:^(UITableViewCell *cell) {
            [BTStoreData setStoreObjectAndKey:cell.textLabel.text Key:SL_LEVERAGE];
            [sender setTitle:cell.textLabel.text forState:UIControlStateNormal];
            if (cell.tag == 0) {
                weakSelf.leverage = weakSelf.leverageArr[0];
                weakSelf.position_type = BTPositionOpen_AllType;
            } else {
                weakSelf.leverage = weakSelf.leverageArr[cell.tag - 1];
                weakSelf.position_type = BTPositionOpen_PursueType;
            }
            [weakSelf.leverageButton sizeToFit];
            weakSelf.leverageButton.sl_centerY = weakSelf.orderTypeButton.sl_centerY;
            weakSelf.leverageButton.sl_x = weakSelf.sl_width - weakSelf.leverageButton.sl_width;
            NSDictionary *dict = @{@"position_type":@(weakSelf.position_type),@"leverage":weakSelf.leverage};
            [BTStoreData setStoreObjectAndKey:dict Key:[NSString stringWithFormat:@"%@_%lld",SL_LEVERAGE_NUM,weakSelf.itemModel.instrument_id]];
        }];
    }
}

/// 选择价格
- (void)priceTypeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        sender.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
    } else {
        sender.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        self.priceTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.priceTextField.sl_height)];
        self.priceTextField.userInteractionEnabled = YES;
    }
    
    if (sender == self.marketPriceButton) {
        self.buyPriceButton.selected = NO;
        self.sellPriceButton.selected = NO;
        self.buyPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        self.sellPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        if (sender.isSelected) {
            self.priceTextField.leftView = [UILabel labelWithText:[NSString stringWithFormat:@"  %@",Launguage(@"str_market")] textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightTextColor font:self.priceTextField.font numberOfLines:1 frame:CGRectMake(0, 0, 50, self.priceTextField.sl_height) superview:nil];
            self.priceTextField.userInteractionEnabled = NO;
            self.priceTextField.text = nil;
            self.priceTextField.placeholder = nil;
        } else {
            self.priceTextField.placeholder = Launguage(@"BT_MAIN_P");
        }
    } else if (sender == self.buyPriceButton) {
        self.marketPriceButton.selected = NO;
        self.sellPriceButton.selected = NO;
        self.marketPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        self.sellPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        if (sender.isSelected) {
            self.priceTextField.leftView = [UILabel labelWithText:[NSString stringWithFormat:@"  %@",Launguage(@"str_buyOne")] textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightTextColor font:self.priceTextField.font numberOfLines:1 frame:CGRectMake(0, 0, 65, self.priceTextField.sl_height) superview:nil];
            self.priceTextField.text = nil;
            self.priceTextField.userInteractionEnabled = NO;
            self.priceTextField.placeholder = nil;
        } else {
            self.priceTextField.placeholder = Launguage(@"BT_MAIN_P");
        }
    } else if (sender == self.sellPriceButton) {
        self.marketPriceButton.selected = NO;
        self.buyPriceButton.selected = NO;
        self.marketPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        self.buyPriceButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        if (sender.isSelected) {
            self.priceTextField.leftView = [UILabel labelWithText:[NSString stringWithFormat:@"  %@",Launguage(@"str_sellOne")] textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightTextColor font:self.priceTextField.font numberOfLines:1 frame:CGRectMake(0, 0, 65, self.priceTextField.sl_height) superview:nil];
            self.priceTextField.userInteractionEnabled = NO;
            self.priceTextField.text = nil;
            self.priceTextField.placeholder = nil;
        } else {
            self.priceTextField.placeholder = Launguage(@"BT_MAIN_P");
        }
    }
    [self updateUI];
}

/// 计划委托-点击市价
- (void)planPerformMarketPriceButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        sender.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
        self.planPerformPriceTextField.leftView = [UILabel labelWithText:[NSString stringWithFormat:@"  %@",Launguage(@"str_market")] textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightTextColor font:self.planPerformPriceTextField.font numberOfLines:1 frame:CGRectMake(0, 0, 50, self.planTriggerPriceTextField.sl_height) superview:nil];
        self.planPerformPriceTextField.enabled = NO;
        self.planPerformPriceTextField.text = nil;
        self.planPerformPriceTextField.placeholder = nil;
    } else {
        sender.layer.borderColor = [SLConfig defaultConfig].lightTextColor.CGColor;
        self.planPerformPriceTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        self.planPerformPriceTextField.enabled = YES;
        self.planPerformPriceTextField.placeholder = @"执行价格";
    }
}


/// 买入或者卖出
- (void)buyOrSellButtonClick:(UIButton *)sender {
    [self.priceTextField endEditing:YES];
    [self.planPerformPriceTextField endEditing:YES];
    [self.amountTextField endEditing:YES];
    
    if (self.marketPriceButton.selected || self.buyPriceButton.selected || self.sellPriceButton.selected) {
        if (self.amountTextField.text.length <= 0) {
            return;
        }
    } else if (self.defineContractType == BTContractOrderCategoryNormal) { // 限价
        if (self.amountTextField.text.length <= 0 || self.priceTextField.text.length <= 0) {
            return;
        }
    } else {
        if (self.amountTextField.text.length <= 0 || self.priceTextField.text.length <=0) {
            return;
        }
    }
    if (!self.leverage) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(defineContractViewDidClickBuyOrSellWithContractOrderType:order:)]) {
        BTContractOrderModel *model = [[BTContractOrderModel alloc] init];
        if (sender == self.buyButton) {
            if (self.currentOrderType == BTDefineContractOpen) {// 开仓
                model = self.orderLongModel;
            } else if (self.currentOrderType == BTDefineContractClose) { // 平仓
                self.closeModel.side = BTContractOrderWayBuy_CloseShort;
                self.closeModel.pid = self.sellPosition.pid;
                model = self.closeModel;
            }
            if (model.category == BTContractOrderCategoryMarket) { // 市价单计算预计开仓均价
                model.open_avg_px = [SLFormula carculateOpenAveragePriceWithOrder:model];
            }
            
        } else if (sender == self.sellButton) {
            if (self.currentOrderType == BTDefineContractOpen) {
                model = self.orderShortModel;
            } else if (self.currentOrderType == BTDefineContractClose) {
                self.closeModel.side = BTContractOrderWaySell_CloseLong;
                self.closeModel.pid = self.buyPosition.pid;
                model = self.closeModel;
            }
            if (model.category == BTContractOrderCategoryMarket) { // 市价单计算预计开仓均价
                model.open_avg_px = [SLFormula carculateOpenAveragePriceWithOrder:model];
            }
        }
        model.currentPrice = self.itemModel.last_px;
        
        self.currentOrderModel = model;
        [self.delegate defineContractViewDidClickBuyOrSellWithContractOrderType:self.currentOrderType order:model];
    }
}


#pragma mark - <SLContractOrderTypeViewDelegate>

/// 委托类型改变
- (void)orderTypeView_orderTypeChanged:(BTContractOrderCategory)orderType {
    [self p_hiddenOrderTypeView];
    self.defineContractType = orderType;
    switch (orderType) {
        case BTContractOrderCategoryNormal:
            [self.orderTypeButton setTitle:Launguage(@"str_normalOrder") forState:UIControlStateNormal];
            self.priceTextField.hidden = NO;
            self.legalTenderPriceLabel.hidden = NO;
            self.marketPriceButton.hidden = NO;
            self.buyPriceButton.hidden = NO;
            self.sellPriceButton.hidden = NO;
            self.planTriggerPriceTextField.hidden = YES;
            self.planTriggerPriceLabel.hidden = YES;
            self.planPerformPriceTextField.hidden = YES;
            self.planPerformMarketPriceButton.hidden = YES;
            self.planPerformPriceLabel.hidden = YES;
            self.amountTextField.sl_y = self.marketPriceButton.sl_maxY + 10;
            break;
        case BTContractOrderCategoryPlan:
            [self.orderTypeButton setTitle:Launguage(@"str_planOrder") forState:UIControlStateNormal];
            self.priceTextField.hidden = YES;
            self.legalTenderPriceLabel.hidden = YES;
            self.marketPriceButton.hidden = YES;
            self.buyPriceButton.hidden = YES;
            self.sellPriceButton.hidden = YES;
            self.planTriggerPriceTextField.hidden = NO;
            self.planTriggerPriceLabel.hidden = NO;
            self.planPerformPriceTextField.hidden = NO;
            self.planPerformMarketPriceButton.hidden = NO;
            self.planPerformPriceLabel.hidden = NO;
            self.amountTextField.sl_y = self.planPerformPriceLabel.sl_maxY;
            break;
        default:
            break;
    }
    [self p_updateLayoutWhenChangedOrderType];
}


#pragma mark - Private

/// 更改委托类型后更新布局
- (void)p_updateLayoutWhenChangedOrderType {
    self.amountPriceLabel.sl_y = self.amountTextField.sl_maxY;
    self.buyButton.sl_y = self.amountPriceLabel.sl_maxY;
    self.canBuyLongLabel.sl_y = self.buyButton.sl_maxY;
    self.sellButton.sl_y = self.canBuyLongLabel.sl_maxY;
    self.canSellShortLabel.sl_y = self.sellButton.sl_maxY;
    self.canUseLabel.sl_y = self.canSellShortLabel.sl_maxY;
    self.fundTransferBtn.sl_y = self.canUseLabel.sl_maxY;
    self.canBuyShortLabel.sl_y = self.buyButton.sl_maxY;
    self.haveShortLabel.sl_y = self.canBuyShortLabel.sl_y;
    self.canSellLongLabel.sl_y = self.sellButton.sl_maxY;
    self.haveLongLabel.sl_y = self.sellButton.sl_maxY;
}

- (void)p_showOrderTypeView {
    self.orderTypeView.hidden = NO;
    self.orderTypeView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.orderTypeView.alpha = 1;
    }];
}

- (void)p_hiddenOrderTypeView {
    [UIView animateWithDuration:0.2 animations:^{
        self.orderTypeView.alpha = 0;
    } completion:^(BOOL finished) {
        self.orderTypeView.hidden = YES;
    }];
}


#pragma mark - lazy load

- (SLContractOrderTypeView *)orderTypeView {
    if (_orderTypeView == nil) {
        _orderTypeView = [[SLContractOrderTypeView alloc] initWithFrame:CGRectMake(self.orderTypeButton.sl_x, self.orderTypeButton.sl_maxY - 10, self.orderTypeButton.sl_width, 0)];
        _orderTypeView.layer.borderWidth = 1;
        _orderTypeView.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        _orderTypeView.layer.cornerRadius = 1;
        _orderTypeView.delegate = self;
        _orderTypeView.hidden = YES;
        [self addSubview:_orderTypeView];
    }
    return _orderTypeView;
}

- (SLContractTextField *)planTriggerPriceTextField {
    if (_planTriggerPriceTextField == nil) {
        _planTriggerPriceTextField = [[SLContractTextField alloc] initWithFrame:CGRectMake(0, self.orderTypeButton.sl_maxY, self.sl_width, 45)];
        // 价类型
        if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"1"]) {
            _planTriggerPriceTextField.placeholder = [NSString stringWithFormat:@"触发价格(%@)",Launguage(@"str_new_price")];
        } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
            _planTriggerPriceTextField.placeholder = @"触发价格(合理价)";
        } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"3"]) {
            _planTriggerPriceTextField.placeholder = @"触发价格(指数价)";
        }
        _planTriggerPriceTextField.hidden = YES;
        _planTriggerPriceTextField.rightView = [UILabel labelWithText:@"USDT" textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(0, 0, 50, 45) superview:nil];
        _planTriggerPriceTextField.rightViewMode = UITextFieldViewModeAlways;
        [_planTriggerPriceTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self insertSubview:_planTriggerPriceTextField belowSubview:self.orderTypeView];
    }
    return _planTriggerPriceTextField;
}

- (UILabel *)planTriggerPriceLabel {
    if (_planTriggerPriceLabel == nil) {
        _planTriggerPriceLabel = [UILabel labelWithText:@"≈ 0" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(0, self.planTriggerPriceTextField.sl_maxY, self.sl_width, 25) superview:self];
        _planTriggerPriceLabel.hidden = YES;
        [self bringSubviewToFront:self.orderTypeView];
    }
    return _planTriggerPriceLabel;
}

- (SLContractTextField *)planPerformPriceTextField {
    if (_planPerformPriceTextField == nil) {
        _planPerformPriceTextField = [[SLContractTextField alloc] initWithFrame:CGRectMake(0, self.planTriggerPriceLabel.sl_maxY, self.sl_width, 45)];
        _planPerformPriceTextField.placeholder = @"执行价格";
        _planPerformPriceTextField.hidden = YES;
        [_planPerformPriceTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self insertSubview:_planPerformPriceTextField belowSubview:self.orderTypeView];
    }
    return _planPerformPriceTextField;
}

- (UIButton *)planPerformMarketPriceButton {
    if (_planPerformMarketPriceButton == nil) {
        UIButton *rightViewButton = [UIButton buttonExtensionWithTitle:@"市价" TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:13] target:self action:@selector(planPerformMarketPriceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightViewButton setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
        rightViewButton.layer.cornerRadius = 1;
        rightViewButton.layer.borderWidth = 1;
        rightViewButton.layer.borderColor = [SLConfig defaultConfig].lightTextColor.CGColor;
        rightViewButton.frame = CGRectMake(self.planPerformPriceTextField.sl_maxX - 60, self.planPerformPriceTextField.sl_y + 10, 50, _planPerformPriceTextField.sl_height - 20);
        rightViewButton.hidden = YES;
        [self addSubview:rightViewButton];
        _planPerformMarketPriceButton = rightViewButton;
    }
    return _planPerformMarketPriceButton;
}

- (UILabel *)planPerformPriceLabel {
    if (_planPerformPriceLabel == nil) {
        _planPerformPriceLabel = [UILabel labelWithText:@"≈ 0" textAlignment:NSTextAlignmentLeft textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:12] numberOfLines:1 frame:CGRectMake(0, self.planPerformPriceTextField.sl_maxY, self.sl_width, 25) superview:self];
        [self bringSubviewToFront:self.orderTypeView];
        _planPerformPriceLabel.hidden = YES;
    }
    return _planPerformPriceLabel;
}

- (NSArray *)leverageArr {
    if (_leverageArr == nil) {
        _leverageArr = [NSArray array];
    }
    return _leverageArr;
}

- (SLButton *)fundTransferBtn {
    if (_fundTransferBtn == nil) {
        _fundTransferBtn = [[SLButton alloc] initWithContentFrameType:BTTiTleLabelInFontType];
        [_fundTransferBtn setImage:nil forState:UIControlStateNormal];
        [_fundTransferBtn setBackgroundColor:MAIN_COLOR];
        [_fundTransferBtn setTitle:Launguage(@"BT_FUND_TRAN") forState:UIControlStateNormal];
        _fundTransferBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_fundTransferBtn sizeToFit];
        _fundTransferBtn.sl_x = self.canUseLabel.sl_x;
        _fundTransferBtn.sl_y = self.canUseLabel.sl_maxY;
        [_fundTransferBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateNormal];
        [self addSubview:_fundTransferBtn];
        [_fundTransferBtn addTarget:self action:@selector(didClickFundTransferBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fundTransferBtn;
}

@end
