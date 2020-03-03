//
//  SLContractSettingController.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2019/3/1.
//  Copyright © 2019年 Karl. All rights reserved.
//

#import "SLContractSettingController.h"
#import "BTMainButton.h"

@interface SLContractSettingController ()
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *tradeUnitLabel;  // 交易单位
@property (nonatomic, strong) UILabel *unRealizeLabel;  // 未实现盈亏计算
@property (nonatomic, strong) UILabel *planEntrustLabel;// 计划委托

@property (nonatomic, strong) UILabel *dateLabel;  // 有效期
@property (nonatomic, strong) UILabel *triggerLabel; // 触发价格

@property (nonatomic, strong) BTMainButton *unitBtn;
@property (nonatomic, strong) BTMainButton *coinBtn;

@property (nonatomic, strong) BTMainButton *fairPriceBtn;
@property (nonatomic, strong) BTMainButton *lastPriceBtn;

@property (nonatomic, strong) BTMainButton *sevenBtn;
@property (nonatomic, strong) BTMainButton *thirtyBtn;

@property (nonatomic, strong) BTMainButton *lastPrice;
@property (nonatomic, strong) BTMainButton *fairPrice;
@property (nonatomic, strong) BTMainButton *indexPrice;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) UITextView *bottomView;
@end

@implementation SLContractSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    
    [self updateNavTitle:@"合约设置"];
    
    [self addChildViews];
    [self loadDataConfig];
}

- (void)addChildViews {
    self.bgView = [self createViewWithBackground:MAIN_COLOR];
    self.bgView.frame = CGRectMake(0, SL_SafeAreaTopHeight, SL_SCREEN_WIDTH, SL_getWidth(300));
    [self.view addSubview:self.bgView];
    self.bottomView.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.bgView.frame) + SL_MARGIN, SL_SCREEN_WIDTH - 2 * SL_MARGIN, SL_getWidth(80));
    
    self.tradeUnitLabel = [self createLabelWithFont:15 text:@"交易单位"];
    self.tradeUnitLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN, SL_getWidth(100), SL_getWidth(20));
    
    self.unitBtn = [self createBtnWithTitle:@"张" action:@selector(didClickTradeUnitBtn:)];
    self.coinBtn = [self createBtnWithTitle:@"币" action:@selector(didClickTradeUnitBtn:)];
    self.unitBtn.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.tradeUnitLabel.frame) + SL_MARGIN * 0.8, SL_getWidth(80), SL_getWidth(35));
    self.coinBtn.frame = CGRectMake(CGRectGetMaxX(self.unitBtn.frame) + SL_MARGIN, self.unitBtn.sl_y, self.unitBtn.sl_width, self.unitBtn.sl_height);
    
    self.line1 = [self createViewWithBackground:DARK_BARKGROUND_COLOR];
    [self.bgView addSubview:self.line1];
    self.line1.frame = CGRectMake(0, CGRectGetMaxY(self.unitBtn.frame) + SL_MARGIN, SL_SCREEN_WIDTH, 1);
    
    self.unRealizeLabel = [self createLabelWithFont:15 text:@"未实现盈亏计算"];
    self.unRealizeLabel.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.line1.frame) + SL_MARGIN, SL_getWidth(200), SL_getWidth(20));
    
    self.fairPriceBtn = [self createBtnWithTitle:Launguage(@"str_fair_price") action:@selector(didClickUnRealityCarculaterBtn:)];
    self.lastPriceBtn = [self createBtnWithTitle:Launguage(@"str_new_price") action:@selector(didClickUnRealityCarculaterBtn:)];
    self.fairPriceBtn.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.unRealizeLabel.frame) + SL_MARGIN, self.unitBtn.sl_width, self.unitBtn.sl_height);
    self.lastPriceBtn.frame = CGRectMake(CGRectGetMaxX(self.fairPriceBtn.frame) + SL_MARGIN, CGRectGetMaxY(self.unRealizeLabel.frame) + SL_MARGIN, self.unitBtn.sl_width, self.unitBtn.sl_height);
    
    self.line2 = [self createViewWithBackground:DARK_BARKGROUND_COLOR];
    [self.bgView addSubview:self.line2];
    self.line2.frame = CGRectMake(0, CGRectGetMaxY(self.fairPriceBtn.frame) + SL_MARGIN, SL_SCREEN_WIDTH, 1);
    
    self.planEntrustLabel = [self createLabelWithFont:15 text:@"计划委托"];
    self.planEntrustLabel.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.line2.frame) + SL_MARGIN, SL_getWidth(150), SL_getWidth(20));
    
    self.sevenBtn = [self createBtnWithTitle:@"7天" action:@selector(didClickDateBtn:)];
    self.thirtyBtn = [self createBtnWithTitle:@"24小时" action:@selector(didClickDateBtn:)];
    self.sevenBtn.frame = CGRectMake(SL_getWidth(80), CGRectGetMaxY(self.planEntrustLabel.frame) + SL_MARGIN, self.unitBtn.sl_width, self.unitBtn.sl_height);
    self.thirtyBtn.frame = CGRectMake(CGRectGetMaxX(self.sevenBtn.frame) + SL_MARGIN, self.sevenBtn.sl_y, self.sevenBtn.sl_width, self.sevenBtn.sl_height);
    self.dateLabel = [self createLabelWithFont:13 text:@"有效期"];
    [self.dateLabel sizeToFit];
    self.dateLabel.sl_x = SL_MARGIN;
    self.dateLabel.sl_centerY = self.sevenBtn.sl_centerY;
    
    self.lastPrice = [self createBtnWithTitle:Launguage(@"str_new_price") action:@selector(didClickTriggerPriceBtn:)];
    self.fairPrice = [self createBtnWithTitle:@"合理价" action:@selector(didClickTriggerPriceBtn:)];
    self.indexPrice = [self createBtnWithTitle:@"指数价" action:@selector(didClickTriggerPriceBtn:)];
    self.triggerLabel = [self createLabelWithFont:13 text:@"触发价格"];
    self.lastPrice.frame = CGRectMake(self.sevenBtn.sl_x, CGRectGetMaxY(self.sevenBtn.frame) + SL_MARGIN, self.sevenBtn.sl_width, self.sevenBtn.sl_height);
    self.fairPrice.frame = CGRectMake(CGRectGetMaxX(self.sevenBtn.frame) + SL_MARGIN, self.lastPrice.sl_y, self.lastPrice.sl_width, self.lastPrice.sl_height);
    self.indexPrice.frame = CGRectMake(CGRectGetMaxX(self.fairPrice.frame) + SL_MARGIN, self.lastPrice.sl_y, self.lastPrice.sl_width, self.lastPrice.sl_height);
    [self.triggerLabel sizeToFit];
    self.triggerLabel.sl_x = SL_MARGIN;
    self.triggerLabel.sl_centerY = self.lastPrice.sl_centerY;
}

- (void)loadDataConfig {
    if ([BTStoreData storeBoolForKey:SL_UNIT_VOL]) {
        [self didClickTradeUnitBtn:self.coinBtn];
    } else {
        [self didClickTradeUnitBtn:self.unitBtn];
    }
    
    NSString *str = [BTStoreData storeObjectForKey:ST_UNREA_CARCUL];
    if ([str isEqualToString:@"1"]) {
        [self didClickUnRealityCarculaterBtn:self.fairPriceBtn];
    } else if ([str isEqualToString:@"2"]) {
        [self didClickUnRealityCarculaterBtn:self.lastPriceBtn];
    }
    
    NSString *str1 = [BTStoreData storeObjectForKey:ST_DATE_CYCLE];
    if ([str1 isEqualToString:@"7"]) {
        [self didClickDateBtn:self.sevenBtn];
    } else if ([str1 isEqualToString:@"24"]) {
        [self didClickDateBtn:self.thirtyBtn];
    }
    
    NSString *str2 = [BTStoreData storeObjectForKey:ST_TIGGER_PRICE];
    if ([str2 isEqualToString:@"1"]) {
        [self didClickTriggerPriceBtn:self.lastPrice];
    } else if ([str2 isEqualToString:@"2"]) {
        [self didClickTriggerPriceBtn:self.fairPrice];
    } else if ([str2 isEqualToString:@"3"]) {
        [self didClickTriggerPriceBtn:self.indexPrice];
    }
}

#pragma mark - action

// 交易单位
- (void)didClickTradeUnitBtn:(UIButton *)sender {
    sender.selected = YES;
    sender.layer.borderColor = MAIN_BTN_COLOR.CGColor;
    if (sender == self.unitBtn) {
        [BTStoreData setStoreBoolAndKey:0 Key:SL_UNIT_VOL];
        self.coinBtn.selected = NO;
        self.coinBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
    } else if (sender == self.coinBtn) {
        self.unitBtn.selected = NO;
        self.unitBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        [BTStoreData setStoreBoolAndKey:1 Key:SL_UNIT_VOL];
    }
}

// 未实现盈亏计算
- (void)didClickUnRealityCarculaterBtn:(UIButton *)sender {
    sender.selected = YES;
    sender.layer.borderColor = MAIN_BTN_COLOR.CGColor;
    if (sender == self.fairPriceBtn) {
        self.lastPriceBtn.selected = NO;
        self.lastPriceBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        [BTStoreData setStoreObjectAndKey:@"1" Key:ST_UNREA_CARCUL];
    } else if (sender == self.lastPriceBtn) {
        self.fairPriceBtn.selected = NO;
        self.fairPriceBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        [BTStoreData setStoreObjectAndKey:@"2" Key:ST_UNREA_CARCUL];
    }
}

// 有效期
- (void)didClickDateBtn:(UIButton *)sender {
    sender.selected = YES;
    sender.layer.borderColor = MAIN_BTN_COLOR.CGColor;
    if (sender == self.sevenBtn) {
        self.thirtyBtn.selected = NO;
        self.thirtyBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        [BTStoreData setStoreObjectAndKey:@"7"  Key:ST_DATE_CYCLE];
    } else if (sender == self.thirtyBtn) {
        self.sevenBtn.selected = NO;
        self.sevenBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        [BTStoreData setStoreObjectAndKey:@"24" Key:ST_DATE_CYCLE];
    }
}

// 触发价格
- (void)didClickTriggerPriceBtn:(UIButton *)sender {
    sender.selected = YES;
    sender.layer.borderColor = MAIN_BTN_COLOR.CGColor;
    if (sender == self.lastPrice) {
        self.fairPrice.selected = NO;
        self.indexPrice.selected = NO;
        self.fairPrice.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        self.indexPrice.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        [BTStoreData setStoreObjectAndKey:@"1"  Key:ST_TIGGER_PRICE];
    } else if (sender == self.fairPrice) {
        self.lastPrice.selected = NO;
        self.indexPrice.selected = NO;
        self.lastPrice.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        self.indexPrice.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        [BTStoreData setStoreObjectAndKey:@"2" Key:ST_TIGGER_PRICE];
    } else if (sender == self.indexPrice) {
        self.lastPrice.selected = NO;
        self.fairPrice.selected = NO;
        self.lastPrice.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        self.fairPrice.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        [BTStoreData setStoreObjectAndKey:@"3" Key:ST_TIGGER_PRICE];
    }
}

#pragma mark - create

- (UIView *)createViewWithBackground:(UIColor *)color {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = color;
    return v;
}

- (UILabel *)createLabelWithFont:(CGFloat)font text:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = MAIN_GARY_TEXT_COLOR;
    label.text = text;
    [self.bgView addSubview:label];
    return label;
}

- (BTMainButton *)createBtnWithTitle:(NSString *)title action:(SEL)action {
    BTMainButton *btn = [BTMainButton closeBtnWithTitle:title target:self action:action];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView addSubview:btn];
    return btn;
}

- (UITextView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UITextView alloc] init];
        [self.view addSubview:_bottomView];
        _bottomView.userInteractionEnabled = NO;
        _bottomView.text = @"⚠️注意\n修改后的计划委托仅对以后提交的计划委托生效，不会影响之前的计划委托";
        _bottomView.font = [UIFont systemFontOfSize:13];
        _bottomView.backgroundColor = DARK_BARKGROUND_COLOR;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        // 设置行间距
        paragraphStyle.lineSpacing = 2;
        paragraphStyle.paragraphSpacing = SL_MARGIN * 0.5;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:13],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _bottomView.attributedText = [[NSAttributedString alloc] initWithString:_bottomView.text attributes:attributes];
        _bottomView.textColor = GARY_BG_TEXT_COLOR;
    }
    return _bottomView;
}

@end
