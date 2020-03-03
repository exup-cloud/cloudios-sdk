//
//  SLContractCalculatorController.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/9/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "SLContractCalculatorController.h"
#import "BTSegment.h"
#import "BTSelectCoinButton.h"
#import "BTMainButton.h"
#import "BTTextFieldView.h"
#import "BTTextField.h"
#import "BTOrderViewInfoView.h"
#import "BTCreatedHeaderTipView.h"

@interface SLContractCalculatorController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) BTSegment *segment;

@property (nonatomic, assign) BTCalculatorType type;

@property (nonatomic, strong) BTSelectCoinButton *direction; // 方向
@property (nonatomic, strong) BTSelectCoinButton *calculatorType;// 计算类型
@property (nonatomic, strong) BTSelectCoinButton *leverage; // 杠杆

@property (nonatomic, weak) BTSelectCoinButton *currentSelectBtn;

@property (nonatomic, strong) BTTextFieldView *position; // 仓位
@property (nonatomic, strong) BTTextFieldView *openPrice;// 开仓价格
@property (nonatomic, strong) BTTextFieldView *closePrice;// 平仓价格
@property (nonatomic, strong) BTTextFieldView *targetProfit; // 目标收益额

@property (nonatomic, strong) BTMainButton *calculatorBtn;

@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) BTOrderViewInfoView *result1;
@property (nonatomic, strong) BTOrderViewInfoView *result2;
@property (nonatomic, strong) BTOrderViewInfoView *result3;
@property (nonatomic, strong) BTOrderViewInfoView *result4;

@property (nonatomic, strong) BTCreatedHeaderTipView *bottomTipsView;

@property (nonatomic, strong) UIPickerView *selectPickerView;
@property (nonatomic, strong) UITextField *pickTextField;
@property (nonatomic, strong) NSArray *pickItems;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, copy) NSString *currentPickItem;

@property (nonatomic, strong) BTContractsModel *contractInfo;

@end

@implementation SLContractCalculatorController

- (void)loadView {
    [super loadView];
    __weak typeof(self) weakSelf = self;
    // 默认高度是40
    self.segment = [[BTSegment alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, SL_SCREEN_WIDTH, SL_getWidth(40)) Titles:@[@"盈亏计算", @"强平计算", @"目标平仓价格:"] height:SL_getWidth(40) font:[UIFont systemFontOfSize:14] didClickAction:^(UIButton *button,NSInteger index) {
        [weakSelf setupChildViewsFrameWithType:button.tag];
    }];
    [self.view addSubview:self.segment];
    [self setupChildViews];
}

- (void)setupChildViews {
    self.direction = [self createSelectedBtnWithTips:@"方向" title:@"多"];
    [self.direction addTarget:self action:@selector(didClickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *leverageArr = _itemModel.contractInfo.leverageArr;
    self.leverage = [self createSelectedBtnWithTips:Launguage(@"BT_CA_SJ") title:[NSString stringWithFormat:@"%@X",leverageArr[0]]];
//    self.leverage = [self createSelectedBtnWithTips:Launguage(@"BT_CA_SJ") title:@"100X"];
    [self.leverage addTarget:self action:@selector(didClickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.calculatorType = [self createSelectedBtnWithTips:@"计算类型" title:@"目标收益额"];
    [self.calculatorType addTarget:self action:@selector(didClickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.position = [self createTextFieldViewWithTitle:@"持仓" placeholder:@"请输入您的数量" unit:@"张"];
    self.openPrice = [self createTextFieldViewWithTitle:@"开仓价格" placeholder:@"请输入您的价格" unit:self.contractInfo.quote_coin];
    self.closePrice = [self createTextFieldViewWithTitle:@"平仓价格" placeholder:@"请输入您的价格" unit:self.contractInfo.quote_coin];
    self.targetProfit = [self createTextFieldViewWithTitle:@"目标收益额" placeholder:@"请输入您的收益额" unit:self.contractInfo.margin_coin];
    
    self.result1 = [self createResultInfoView];
    self.result2 = [self createResultInfoView];
    self.result3 = [self createResultInfoView];
    self.result4 = [self createResultInfoView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DARK_BARKGROUND_COLOR;
    [self updateNavTitle:@"合约计算器"];
    self.segment.selectedIndex = 0;
    [self setupChildViewsFrameWithType:0];
}

- (void)setupChildViewsFrameWithType:(BTCalculatorType)type {
    self.type = type;
    self.direction.frame = CGRectMake(0, CGRectGetMaxY(self.segment.frame) + 0.5, SL_SCREEN_WIDTH, SL_getWidth(50));
    switch (type) {
        case BTCalculatorLoseGain:
            self.leverage.frame = CGRectMake(0, CGRectGetMaxY(self.direction.frame) + 0.5, SL_SCREEN_WIDTH, self.direction.sl_height);
            self.position.frame = CGRectMake(0, CGRectGetMaxY(self.leverage.frame) + SL_MARGIN, self.direction.sl_width, self.direction.sl_height);
            self.openPrice.frame = CGRectMake(0, CGRectGetMaxY(self.position.frame) + 0.5, self.direction.sl_width, self.direction.sl_height);
            self.closePrice.frame = CGRectMake(0, CGRectGetMaxY(self.openPrice.frame), self.openPrice.sl_width, self.openPrice.sl_height);
            self.calculatorBtn.frame = CGRectMake(SL_MARGIN,CGRectGetMaxY(self.closePrice.frame) + SL_MARGIN, SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(50));
            self.bottomBgView.frame = CGRectMake(0, CGRectGetMaxY(self.calculatorBtn.frame) + SL_MARGIN, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - CGRectGetMaxY(self.calculatorBtn.frame) - SL_MARGIN);
            self.resultLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN, SL_getWidth(150), SL_getWidth(20));
            self.line.frame = CGRectMake(0, SL_getWidth(40), SL_SCREEN_WIDTH, 0.5);
            self.result1.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.line.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.result2.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result1.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.result3.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result2.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.result4.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result3.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.bottomTipsView.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result4.frame) + SL_MARGIN, SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(100));
            self.calculatorType.hidden = YES;
            self.targetProfit.hidden = YES;
            self.closePrice.hidden = NO;
            self.result3.hidden = NO;
            self.result4.hidden = NO;
            [self.result1 loadInfoWithTitle:@"占用保证金:" mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            [self.result2 loadInfoWithTitle:Launguage(@"BT_CA_POSITION_VALUE") mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            [self.result3 loadInfoWithTitle:@"盈亏:" mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            [self.result4 loadInfoWithTitle:@"收益率:" mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            break;
        case BTCalculatorForceClose:
            self.leverage.frame = CGRectMake(0, CGRectGetMaxY(self.direction.frame) + 0.5, SL_SCREEN_WIDTH, self.direction.sl_height);
            self.position.frame = CGRectMake(0, CGRectGetMaxY(self.leverage.frame) + SL_MARGIN, self.direction.sl_width, self.direction.sl_height);
            self.openPrice.frame = CGRectMake(0, CGRectGetMaxY(self.position.frame) + 0.5, self.direction.sl_width, self.direction.sl_height);
            self.calculatorBtn.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.openPrice.frame) + SL_MARGIN, SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(50));
            self.bottomBgView.frame = CGRectMake(0, CGRectGetMaxY(self.calculatorBtn.frame) + SL_MARGIN, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - CGRectGetMaxY(self.calculatorBtn.frame) - SL_MARGIN);
            self.resultLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN, SL_getWidth(100), SL_getWidth(20));
            self.line.frame = CGRectMake(0, SL_getWidth(40), SL_SCREEN_WIDTH, 0.5);
            self.result1.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.line.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.result2.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result1.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.result3.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result2.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.result4.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result3.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.bottomTipsView.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result4.frame) + SL_MARGIN, SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(100));
            self.calculatorType.hidden = YES;
            self.targetProfit.hidden = YES;
            self.closePrice.hidden = YES;
            self.result3.hidden = NO;
            self.result4.hidden = NO;
            [self.result1 loadInfoWithTitle:[NSString stringWithFormat:@"%@:", Launguage(@"BT_CA_CLOSE_PRI")] mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            [self.result2 loadInfoWithTitle:[NSString stringWithFormat:@"%@:", Launguage(@"BT_CA_POSITION_VALUE")] mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            [self.result3 loadInfoWithTitle:@"实际起始保证金率:" mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            [self.result4 loadInfoWithTitle:@"实际维持保证金率:" mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            break;
        case BTCalculatorTargetPrice:
            self.leverage.frame = CGRectMake(0, CGRectGetMaxY(self.direction.frame) + 0.5, SL_SCREEN_WIDTH, self.direction.sl_height);
            self.calculatorType.frame = CGRectMake(0, CGRectGetMaxY(self.leverage.frame) + 0.5, SL_SCREEN_WIDTH, self.direction.sl_height);
            self.position.frame = CGRectMake(0, CGRectGetMaxY(self.calculatorType.frame) + SL_MARGIN, self.direction.sl_width, self.direction.sl_height);
            self.openPrice.frame = CGRectMake(0, CGRectGetMaxY(self.position.frame) + 0.5, SL_SCREEN_WIDTH, self.direction.sl_height);
            self.targetProfit.frame = CGRectMake(0, CGRectGetMaxY(self.openPrice.frame) + 0.5, SL_SCREEN_WIDTH, self.direction.sl_height);
            self.calculatorBtn.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.targetProfit.frame) + SL_MARGIN, SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(50));
            self.bottomBgView.frame = CGRectMake(0, CGRectGetMaxY(self.calculatorBtn.frame) + SL_MARGIN, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - CGRectGetMaxY(self.calculatorBtn.frame) - SL_MARGIN);
            self.resultLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN, SL_getWidth(100), SL_getWidth(20));
            self.line.frame = CGRectMake(0, SL_getWidth(40), SL_SCREEN_WIDTH, 0.5);
            self.result1.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.line.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.result2.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result1.frame), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(30));
            self.bottomTipsView.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.result2.frame) + SL_MARGIN, SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(100));
            self.calculatorType.hidden = NO;
            self.targetProfit.hidden = NO;
            self.closePrice.hidden = YES;
            self.result3.hidden = YES;
            self.result4.hidden = YES;
            [self.result1 loadInfoWithTitle:@"占用保证金:" mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            [self.result2 loadInfoWithTitle:@"目标平仓价格:" mainColor:MAIN_GARY_TEXT_COLOR number:@"--" numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
            break;
        default:
            break;
    }
    [self.bottomTipsView setupContent:@"计算结果仅供参考。实际操作中可能会因为手续费，资金费率导致操作结果存在偏差。" highStr:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPickViewDelegate and Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickItems.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
        pickerLabel.textColor = MAIN_GARY_TEXT_COLOR;
    }
    pickerLabel.text= [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row >= self.pickItems.count) {
        return nil;
    }
    NSString *item = [self.pickItems objectAtIndex:row];
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *item = [self.pickItems objectAtIndex:row];
    if (item) {
        self.currentPickItem = item;
    }
}


#pragma mark - action

- (void)didClickSelectedBtn:(UIButton *)sender {
    self.currentSelectBtn = (BTSelectCoinButton *)sender;
    if (sender == self.direction) {
        self.currentPickItem = self.direction.titleLabel.text;
        self.pickItems = @[@"多", @"空"];
    } else if (sender == self.calculatorType) {
        self.currentPickItem = self.calculatorType.titleLabel.text;
        self.pickItems = @[@"目标收益额", @"目标收益率"];
    } else if (sender == self.leverage) {
        self.currentPickItem = self.leverage.titleLabel.text;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
        for (NSString *leve in self.itemModel.contractInfo.leverageArr) {
            [arr addObject:[NSString stringWithFormat:@"%@X",leve]];
        }
        self.pickItems = arr.copy;
    }
    if (self.coverBtn.hidden == YES) {
        self.coverBtn.hidden = NO;
        [self.pickTextField becomeFirstResponder];
    } else {
        self.coverBtn.hidden = YES;
        [self.pickTextField resignFirstResponder];
    }
}

- (void)didClickCancelPickView:(UIButton *)sender {
    [self doneTouched:nil];
}

- (void)doneTouched:(UIButton *)sender {
    if (self.currentSelectBtn == self.direction) {
        [self.direction setTitle:self.currentPickItem forState:UIControlStateNormal];
    } else if (self.currentSelectBtn == self.calculatorType) {
        [self.calculatorType setTitle:self.currentPickItem forState:UIControlStateNormal];
        self.targetProfit.firstLabel.text = self.currentPickItem;
        if ([self.currentPickItem isEqualToString:@"目标收益率"]) {
            self.targetProfit.lastLabel.text = @"%";
        } else {
            self.targetProfit.lastLabel.text = self.contractInfo.margin_coin;
        }
    } else if (self.currentSelectBtn == self.leverage) {
        [self.leverage setTitle:self.currentPickItem forState:UIControlStateNormal];
    }
    self.coverBtn.hidden = YES;
    [self.pickTextField resignFirstResponder];
}

// 点击计算
- (void)didClickCalculatorBtn:(UIButton *)sender {
    [self.position.textField resignFirstResponder];
    [self.openPrice.textField resignFirstResponder];
    [self.closePrice.textField resignFirstResponder];
    [self.targetProfit.textField resignFirstResponder];
    BTContractsModel *contractInfo = self.itemModel.contractInfo;
    BTContractOrderModel *order = [[BTContractOrderModel alloc] init];
    order.position_type = BTPositionOpen_PursueType;
    order.qty = self.position.textField.text;
    order.px = self.openPrice.textField.text;
    order.leverage = [self.leverage.titleLabel.text substringWithRange:NSMakeRange(0, self.leverage.titleLabel.text.length - 1)];
    order.instrument_id = self.itemModel.instrument_id;
    if ([self.direction.titleLabel.text isEqualToString:@"多"]) {
        order.side = BTContractOrderWayBuy_OpenLong;
    } else {
        order.side = BTContractOrderWaySell_OpenShort;
    }
    BTContractsOpenModel *openModel = [[BTContractsOpenModel alloc] initWithOrderModel:order contractInfo:self.itemModel.contractInfo assets:nil];
    if (self.type == BTCalculatorLoseGain) { // 盈亏计算
        NSString *profit  = nil;
        if ([self.direction.titleLabel.text isEqualToString:@"多"]) {
            profit = [SLFormula calculateCloseLongProfitAmount:self.position.textField.text holdAvgPrice:self.openPrice.textField.text markPrice:self.closePrice.textField.text contractSize:contractInfo.face_value isReverse:contractInfo.is_reverse];
        } else {
            profit = [SLFormula calculateCloseShortProfitAmount:self.position.textField.text holdAvgPrice:self.openPrice.textField.text markPrice:self.closePrice.textField.text contractSize:contractInfo.face_value isReverse:contractInfo.is_reverse];
        }
        NSString *deposit = openModel.IM;
        if ([[DecimalOne bigDiv:order.leverage] GreaterThan:order.IMR]) {
            deposit = [openModel.orderAvai bigMul:[DecimalOne bigDiv:order.leverage]];
        }
        [self.result1 loadInfoWithTitle:@"占用保证金:" mainColor:MAIN_GARY_TEXT_COLOR number:[NSString stringWithFormat:@"%@",deposit] numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
        [self.result2 loadInfoWithTitle:[NSString stringWithFormat:@"%@:", Launguage(@"BT_CA_POSITION_VALUE")] mainColor:MAIN_GARY_TEXT_COLOR number:openModel.orderAvai numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
        [self.result3 loadInfoWithTitle:@"盈亏:" mainColor:MAIN_GARY_TEXT_COLOR number:profit numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
        [self.result4 loadInfoWithTitle:@"收益率:" mainColor:MAIN_GARY_TEXT_COLOR number:[[profit bigDiv:deposit] toPercentString:2] numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
        
    } else if (self.type == BTCalculatorForceClose) { // 强平计算
        [self.result1 loadInfoWithTitle:[NSString stringWithFormat:@"%@:", Launguage(@"BT_CA_CLOSE_PRI")] mainColor:MAIN_GARY_TEXT_COLOR number:openModel.liquidatePrice numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
        [self.result2 loadInfoWithTitle:[NSString stringWithFormat:@"%@:", Launguage(@"BT_CA_POSITION_VALUE")] mainColor:MAIN_GARY_TEXT_COLOR number:openModel.orderAvai numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
        [self.result3 loadInfoWithTitle:@"实际起始保证金率:" mainColor:MAIN_GARY_TEXT_COLOR number:[order.IMR toPercentString:2] numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
        [self.result4 loadInfoWithTitle:@"实际维持保证金率:" mainColor:MAIN_GARY_TEXT_COLOR number:[order.MMR toPercentString:2] numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
    } else if (self.type == BTCalculatorTargetPrice) { // 目标价计算
        NSString *deposit = openModel.IM;
        if ([[DecimalOne bigDiv:order.leverage] GreaterThan:order.IMR]) {
            deposit = [openModel.orderAvai bigMul:[DecimalOne bigDiv:order.leverage]];
        }
        NSString *value = openModel.orderAvai;
        if ([self.targetProfit.firstLabel.text isEqualToString:@"目标收益额"]) {
            if (!self.contractInfo.is_reverse) {
                if ([self.direction.titleLabel.text isEqualToString:@"多"]) {
                    value = [value bigAdd:self.targetProfit.textField.text];
                } else {
                    value = [value bigSub:self.targetProfit.textField.text];
                }
            } else {
                if ([self.direction.titleLabel.text isEqualToString:@"多"]) {
                    value = [value bigSub:self.targetProfit.textField.text];
                } else {
                    value = [value bigAdd:self.targetProfit.textField.text];
                }
            }
        } else {
            NSString *t = [[self.targetProfit.textField.text bigMul:openModel.IM] bigDiv:@"100"];
            if (!self.contractInfo.is_reverse) {
                if ([self.direction.titleLabel.text isEqualToString:@"多"]) {
                    value = [value bigAdd:t];
                } else {
                    value = [value bigSub:t];
                }
            }else {
                if ([self.direction.titleLabel.text isEqualToString:@"多"]) {
                    value = [value bigSub:t];
                } else {
                    value = [value bigAdd:t];
                }
            }
        }
        
        NSString *targetPrice = [SLFormula calculateQuotePriceWithValue:value vol:self.position.textField.text contract:self.contractInfo];
        
        [self.result1 loadInfoWithTitle:@"占用保证金:" mainColor:MAIN_GARY_TEXT_COLOR number:[NSString stringWithFormat:@"%@",deposit] numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
         [self.result2 loadInfoWithTitle:@"目标平仓价格:" mainColor:MAIN_GARY_TEXT_COLOR number:targetPrice numColor:MAIN_GARY_TEXT_COLOR endLabel:nil];
    }
}

#pragma mark - create UI
- (BTSelectCoinButton *)createSelectedBtnWithTips:(NSString *)tips title:(NSString *)title {
    BTSelectCoinButton *selectBtn = [[BTSelectCoinButton alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_getWidth(45))];
    selectBtn.tipsLabel.text = tips;
    [selectBtn setBackgroundColor:MAIN_COLOR];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    selectBtn.tipsLabel.textColor = MAIN_GARY_TEXT_COLOR;
    [selectBtn setTitleColor:MAIN_GARY_TEXT_COLOR forState:UIControlStateNormal];
    selectBtn.type = BTSelectCoinButtonCalculator;
    [selectBtn setTitle:title forState:UIControlStateNormal];
    [self.view addSubview:selectBtn];
    return selectBtn;
}

- (BTTextFieldView *)createTextFieldViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder unit:(NSString *)unit {
    BTTextFieldView *textFieldView = [[BTTextFieldView alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_getWidth(50))];
    textFieldView.type = BTTextFieldLastLabelType;
    textFieldView.backgroundColor = MAIN_COLOR;
    textFieldView.firstLabel.text = title;
    textFieldView.textField.placeholder = placeholder;
    textFieldView.lastLabel.text = unit;
    textFieldView.lastLabel.textColor = MAIN_GARY_TEXT_COLOR;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16]; // 设置font
    attrs[NSForegroundColorAttributeName] = GARY_BG_TEXT_COLOR; // 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:textFieldView.textField.placeholder attributes:attrs]; // 初始化富文本占位字符串
    textFieldView.textField.attributedPlaceholder = attStr;
    textFieldView.textField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:textFieldView];
    return textFieldView;
}

- (BTMainButton *)calculatorBtn {
    if (_calculatorBtn == nil) {
        _calculatorBtn = [BTMainButton blueBtnWithTitle:@"开始计算" target:self action:@selector(didClickCalculatorBtn:)];
        [self.view addSubview:_calculatorBtn];
    }
    return _calculatorBtn;
}

- (BTCreatedHeaderTipView *)bottomTipsView {
    if (_bottomTipsView == nil) {
        _bottomTipsView = [[BTCreatedHeaderTipView alloc] initWithFrame:CGRectMake(SL_MARGIN, 0, SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_SCREEN_HEIGHT - 3 * SL_MARGIN - SL_SafeAreaTopHeight)];
        [self.bottomBgView addSubview:_bottomTipsView];
    }
    return _bottomTipsView;
}

- (UIView *)bottomBgView {
    if (_bottomBgView == nil) {
        _bottomBgView = [[UIView alloc] init];
        _bottomBgView.backgroundColor = MAIN_COLOR;
        [self.view addSubview:_bottomBgView];
    }
    return _bottomBgView;
}

- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.textColor = GARY_BG_TEXT_COLOR;
        _resultLabel.font = [UIFont systemFontOfSize:15];
        _resultLabel.backgroundColor = MAIN_COLOR;
        _resultLabel.text = @"计算结果";
        [self.bottomBgView addSubview:_resultLabel];
    }
    return _resultLabel;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = DARK_BARKGROUND_COLOR;
        [self.bottomBgView addSubview:_line];
    }
    return _line;
}

- (BTOrderViewInfoView *)createResultInfoView {
    BTOrderViewInfoView *result = [[BTOrderViewInfoView alloc] initWithFrame: CGRectZero];
    result.backgroundColor = MAIN_COLOR;
    result.color = MAIN_COLOR;
    [self.bottomBgView addSubview:result];
    return result;
}

- (NSArray *)pickItems {
    if (_pickItems == nil) {
        _pickItems = [NSArray array];
    }
    return _pickItems;
}

- (UIPickerView *)selectPickerView {
    if (_selectPickerView == nil) {
        _selectPickerView = [[UIPickerView alloc] init];
        _selectPickerView.showsSelectionIndicator = YES;
        _selectPickerView.dataSource = self;
        _selectPickerView.delegate = self;
        _selectPickerView.backgroundColor = MAIN_COLOR;
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_getWidth(40))];
        toolBar.backgroundColor = MAIN_COLOR;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneTouched:)];
        [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
        _pickTextField.inputAccessoryView = toolBar;
    }
    return _selectPickerView;
}

- (UIButton *)coverBtn {
    if (_coverBtn == nil) {
        _coverBtn = [[UIButton alloc] init];
        [_coverBtn setBackgroundColor:[DARK_BARKGROUND_COLOR colorWithAlphaComponent:0.6]];
        _coverBtn.frame = CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - self.selectPickerView.sl_height);
        [[UIApplication sharedApplication].keyWindow addSubview:_coverBtn];
        [_coverBtn addTarget:self action:@selector(didClickCancelPickView:) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn.hidden = YES;
    }
    return _coverBtn;
}

- (UITextField *)pickTextField {
    if (_pickTextField == nil) {
        _pickTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_pickTextField];
        _pickTextField.inputView = self.selectPickerView;
    }
    return _pickTextField;
}

- (BTContractsModel *)contractInfo {
    if (_contractInfo == nil) {
        _contractInfo = self.itemModel.contractInfo;
    }
    return _contractInfo;
}

@end
