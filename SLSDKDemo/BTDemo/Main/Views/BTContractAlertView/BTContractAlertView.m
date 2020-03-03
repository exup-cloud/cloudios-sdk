//
//  BTContractAlertView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/17.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTContractAlertView.h"
#import "BTMainButton.h"
#import "BTContractLabel.h"
#import "BTContractAlertLabel.h"
#import "BTContractTextView.h"
#import "BTOrderViewInfoView.h"
#import "BTTextField.h"
#import "BTDetailLabel.h"
#import "BTSlider.h"

@interface BTContractAlertView ()<BTContractTextViewDelegate>
@property (nonatomic, assign) BTContractAlertViewType alertViewType;
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *crossBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) BTMainButton *comfirmBtn;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) BTContractLabel *entrustLabel;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *contractType;

@property (nonatomic, strong) BTContractAlertLabel *label1;
@property (nonatomic, strong) BTContractAlertLabel *label2;
@property (nonatomic, strong) BTContractAlertLabel *label3;

@property (nonatomic, strong) BTContractTextView *priceTextField;
@property (nonatomic, strong) BTContractTextView *volumeField;
@property (nonatomic, strong) UIButton *marketClose;

@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) BTContractLabel *avaibalance;


// 下单详情
@property (nonatomic, strong) UILabel *leverLabel; // 杠杆倍数
@property (nonatomic, strong) BTOrderViewInfoView *entrustValue;
@property (nonatomic, strong) BTOrderViewInfoView *costLabel;
@property (nonatomic, strong) BTOrderViewInfoView *balanceLabel;
@property (nonatomic, strong) BTOrderViewInfoView *holdSize;
@property (nonatomic, strong) BTOrderViewInfoView *markPrice;
@property (nonatomic, strong) BTOrderViewInfoView *closePrice;
@property (nonatomic, strong) BTOrderViewInfoView *difference;
@property (nonatomic, strong) UIButton *circleBtn;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) BTMainButton *supporDepositBtn;
@property (nonatomic, strong) BTMainButton *reduceDepositBtn;
@property (nonatomic, strong) BTPositionModel *position;

@property (nonatomic, strong) BTItemCoinModel *asset;

@property (nonatomic, strong) BTContractLipRecordModel *lipRecordModel;

@property (nonatomic, strong) BTDetailLabel *priceDetail;
@property (nonatomic, strong) BTDetailLabel *volumeDetail;
@property (nonatomic, strong) BTDetailLabel *leverageDetail;

@property (nonatomic, strong) BTSlider *tradeSlider;
@property (nonatomic, copy) NSString *currentSliderValue;

@property (nonatomic, strong) BTContractOrderModel *orderModel;

@end

@implementation BTContractAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [DARK_BARKGROUND_COLOR colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)loadDataWithData:(id)data {
    switch (self.alertViewType) {
        case BTContractAlertViewMarketPriceClose1:{
            NSString *name = data[@"name"];
            self.titleLabel.text = @"市价全平";
            NSString *str =  [@"您确认对%1$s仓位进行市价全平吗？" stringByReplacingOccurrencesOfString:@"%1$s" withString:name];
            self.contentLabel.text = str;
            self.contentLabel.textColor = DARK_BARKGROUND_COLOR;
            break;}
        case BTContractAlertViewMarketPriceClose2:{
            self.titleLabel.text = @"市价全平";
            self.contentLabel.text = @"市价全平前，您需要先撤销该仓位的未成交状态的平仓委托单";
            [self.comfirmBtn setTitle:@"全部撤单" forState:UIControlStateNormal];
            if ([data[@"type"] integerValue] == 1) { // 则卖出平多
                self.contractType.text = [NSString stringWithFormat:@" %@ ", @"卖出平多"];
                self.contractType.layer.borderColor = DOWN_COLOR.CGColor;
                self.contractType.textColor = DOWN_COLOR;
            } else {
                self.contractType.text = [NSString stringWithFormat:@" %@ ", @"买入平空"];
                self.contractType.layer.borderColor = UP_WARD_COLOR.CGColor;
                self.contractType.textColor = UP_WARD_COLOR;
            }
            NSString *name = data[@"name"];
            NSString *vol = data[@"vol"];
            self.coinLabel.text = name?name:@"--";
            self.entrustLabel.text = [NSString stringWithFormat:@"%@ %@ %@", @"委托量", vol ? vol : @"--",@"张"];
            [self.entrustLabel layoutStringArr:@[vol]];
    }
            break;
        case BTContractAlertViewMarketPriceClose3:
            {
            NSData *imageData = [UIImage GIFImageWithName:@"preloading"];
            self.imageView.image = [UIImage imageWithSmallGIFData:imageData scale:1.0];
            self.titleLabel.text = @"撤单中，请耐心等待";
            self.contentLabel.text = @"撤单成功后，您才可以进行市价全平操作";
            self.contentLabel.textColor = GARY_BG_TEXT_COLOR;
            [self.comfirmBtn setTitle:@"市价全平" forState:UIControlStateNormal];
            self.comfirmBtn.enabled = NO;
            self.cancelBtn.enabled = NO;
            self.cancelBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
                [self.cancelBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
            break;
            }
        case BTContractAlertViewMarketPriceClose4:
            self.imageView.image = [UIImage imageWithName:@"icon-finish;"];
            self.contentLabel.text = @"撤单成功，您可以继续进行市价全平操作";
            [self.comfirmBtn setTitle:@"市价全平" forState:UIControlStateNormal];
            break;
        case BTContractAlertViewPriceExplain:
            {
                self.titleLabel.text = @"名词解释";
                self.label1.titleLabel.text = @"最新交易价格";
                self.label1.numLabel.text = @"1";
                self.label2.titleLabel.text = Launguage(@"BT_CA_INDEX_PRI");
                self.label2.numLabel.text = @"2";
                self.label3.titleLabel.text = @"标记价格";
                self.label3.numLabel.text = @"3";
            }
            break;
        case BTContractAlertViewPriceExplain2:
            self.titleLabel.text = @"名词解释";
            self.label1.titleLabel.text = @"最新交易价格";
            self.label1.numLabel.text = @"1";
            self.label2.titleLabel.text = @"标记价格";
            self.label2.numLabel.text = @"2";
            break;
        case BTContractAlertViewContractTerm:
            {
            self.titleLabel.text = @"合约名词";
            self.label1.titleLabel.text = @"未实现盈亏";
            self.label1.numLabel.text = @"1";
            self.label2.titleLabel.text = @"仓位保证金";
            self.label2.numLabel.text = @"2";
            self.label3.titleLabel.text = @"委托保证金";
            self.label3.numLabel.text = @"3";
            }
            break;
        case BTContractAlertViewContractBreakHold:{
            self.lipRecordModel = [BTContractLipRecordModel mj_objectWithKeyValues:data];
            self.titleLabel.text = @"爆仓明细 ";
            self.label1.numLabel.text = @"1";
            self.label2.numLabel.text = @"2";
            break;
        }
        case BTContractAlertViewContractReduceDetail:{
            self.lipRecordModel = [BTContractLipRecordModel mj_objectWithKeyValues:data];
            self.titleLabel.text = @"减仓明细 ";
            self.label1.numLabel.text = @"1";
            break;
        }
        case BTContractAlertViewContractCloseHold:{
            BTPositionModel *position = [BTPositionModel mj_objectWithKeyValues:data];
            self.position = position;
            self.titleLabel.text = @"确认平仓";
            BTPositionModel *model = [BTPositionModel mj_objectWithKeyValues:data];
            NSString *price = [BTMaskFutureTool marketPriceWithContractID:model.instrument_id];
            self.priceTextField.defineView.text = price;
            NSString *max = [[position.cur_qty bigSub:position.freeze_qty] toSmallVolumeWithContractID:position.instrument_id];
            self.tradeSlider.value = .5f;
            self.volumeField.defineView.text = [[self.currentSliderValue bigMul:max] toString:0];
            self.tipsLabel.text = [NSString stringWithFormat:@"最大可平：%@", max];
            [self.comfirmBtn setTitle:Launguage(@"BT_CA_CP") forState:UIControlStateNormal];
            break;
        }
        case BTContractAlertViewContractSupplementDeposit:{
            BTPositionModel *position = [BTPositionModel mj_objectWithKeyValues:data];
            NSString *hol = position.cur_qty;
            NSString *unit = @"张";
            self.position = position;
            self.titleLabel.text = Launguage(@"str_adjust_margins");
            [self.entrustValue loadInfoWithTitle:@"持仓" mainColor:GARY_BG_TEXT_COLOR number:hol numColor:DARK_BARKGROUND_COLOR endLabel:unit];
            [self.costLabel loadInfoWithTitle:Launguage(@"str_margins") mainColor:GARY_BG_TEXT_COLOR number:[position.im toSmallValueWithContract:position.instrument_id] numColor:DARK_BARKGROUND_COLOR endLabel:position.contractInfo.margin_coin];
            
            BTItemCoinModel *asset = [BTMineAccountTool getCoinAssetsWithCoinCode:position.contractInfo.margin_coin];
            
            self.asset = asset;
            [self.balanceLabel loadInfoWithTitle:@"可用保证金" mainColor:GARY_BG_TEXT_COLOR number:asset.contract_avail numColor:DARK_BARKGROUND_COLOR endLabel:position.contractInfo.margin_coin];
            self.tipsLabel.text = [NSString stringWithFormat:@"最大可增加：%@ %@",[asset.contract_avail toSmallValueWithContract:position.instrument_id],position.contractInfo.margin_coin];
            
            if (position.position_type == BTPositionOpen_PursueType) {
                asset = nil;
            }
            NSString *closePrice = [SLFormula calculatePositionLiquidatePrice:position assets:asset contractInfo:position.contractInfo];
            self.position.liquidate_price = closePrice;
            [self.holdSize loadInfoWithTitle:Launguage(@"BT_CA_CLOSE_PRI") mainColor:GARY_BG_TEXT_COLOR number:closePrice numColor:DARK_BARKGROUND_COLOR endLabel:nil];
            [self.comfirmBtn setTitle:Launguage(@"str_adjust_margins") forState:UIControlStateNormal];
            self.avaibalance.text = [NSString stringWithFormat:@"%@ --",@"调整后预计强平价格"];
            [self.avaibalance layoutStringArr:@[@"--"]];
            [self didClickSupporDepositBtn:self.supporDepositBtn];
            break;
        }
        case BTContractAlertViewContractFuturesOrder:
            {
                BTContractOrderModel *order = [BTContractOrderModel mj_objectWithKeyValues:data];
                self.orderModel = order;
                NSString *str1 = @"--";
                NSString *str2 = @"--";
                NSString *cost = @"--";
                NSString *lever = @"--";
                if (order.category == BTContractOrderCategoryNormal) {
                    str1 = @"限价";
                } else if (order.category == BTContractOrderCategoryMarket) {
                    str1 = Launguage(@"str_market");
                }
                if (order.side == BTContractOrderWayBuy_OpenLong || order.side == BTContractOrderWayBuy_CloseShort) {
                    str2 = @"买入";
                    self.titleLabel.textColor = UP_WARD_COLOR;
                } else if (order.side == BTContractOrderWaySell_CloseLong || order.side == BTContractOrderWaySell_OpenShort) {
                    str2 = @"卖出";
                    self.titleLabel.textColor = DOWN_COLOR;
                }
                
                if (order.position_type == BTPositionOpen_PursueType) {
                    lever = Launguage(@"BT_CA_GRADE");
                } else if (order.position_type == BTPositionOpen_AllType) {
                    lever = Launguage(@"BT_CA_CROSS");
                }
                cost = [order.freezAssets toSmallValueWithContract:order.instrument_id];
                self.titleLabel.text = [NSString stringWithFormat:@"%@%@",str1,str2];
                self.contentLabel.text = [NSString stringWithFormat:@"%@合约",order.name];
                
                BTPositionModel *position = [SLFormula getUserPositionWithCoinCode:order.contractInfo.margin_coin contractID:order.instrument_id contractWay:order.side];
//                BTContractsOpenModel
                NSString *holdVol = order.qty;
                if (position) {
                    holdVol = [holdVol bigAdd:position.cur_qty];
                }
                
                if (order.exec_px) {
                    NSString *ex_price = [order.exec_px toSmallPriceWithContractID:order.instrument_id];
                    if (order.category == BTContractOrderCategoryMarket) {
                        ex_price = Launguage(@"str_market");
                    }
                    
                    self.titleLabel.text = [NSString stringWithFormat:@"%@计划",self.titleLabel.text];
                    [self.priceDetail setName:@"触发价格" andNumber:[order.px toSmallPriceWithContractID:order.instrument_id]];
                    [self.volumeDetail setName:@"执行价格" andNumber:ex_price];
                    [self.leverageDetail setName:[NSString stringWithFormat:@"%@(%@)", Launguage(@"BT_MAIN_V"), @"张"] andNumber:[order.qty toSmallVolumeWithContractID:order.instrument_id]];
                    
                    [self.entrustValue loadInfoWithTitle:@"杠杆" mainColor:GARY_BG_TEXT_COLOR number:[NSString stringWithFormat:@"%@%@X",lever,order.leverage] numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                    
                    NSString *typeStr = nil;
                    if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"1"]) {
                        typeStr = Launguage(@"str_new_price");
                    } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
                        typeStr = @"合理价";
                    } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
                        typeStr = @"指数价";
                    }
                    
                    NSString *dateStr = nil;
                    if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"7"]) {
                        dateStr = @"7天";
                    } else if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"24"]) {
                        dateStr = @"24小时";
                    }
                    
                    [self.costLabel loadInfoWithTitle:@"触发类型" mainColor:GARY_BG_TEXT_COLOR number:typeStr numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                    [self.balanceLabel loadInfoWithTitle:@"有效期" mainColor:GARY_BG_TEXT_COLOR number:dateStr numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                    [self.holdSize loadInfoWithTitle:@"成交后仓位大小" mainColor:GARY_BG_TEXT_COLOR number:holdVol numColor:DARK_BARKGROUND_COLOR endLabel:nil];

                } else {
                    
                    NSString *price = [order.px toSmallPriceWithContractID:order.instrument_id];
                    if (order.category == BTContractOrderCategoryMarket) {
                        price = Launguage(@"str_market");
                    }
                    
                    [self.priceDetail setName:[NSString stringWithFormat:@"%@(%@)", Launguage(@"BT_MAIN_P"), order.contractInfo.quote_coin] andNumber:price];
                    [self.volumeDetail setName:[NSString stringWithFormat:@"%@(%@)", Launguage(@"BT_MAIN_V"), @"张"] andNumber:[order.qty toSmallVolumeWithContractID:order.instrument_id]];
                    [self.leverageDetail setName:@"杠杆" andNumber:[NSString stringWithFormat:@"%@%@X",lever,order.leverage]];
                    [self.entrustValue loadInfoWithTitle:Launguage(@"BT_CA_ORDER_VAL") mainColor:GARY_BG_TEXT_COLOR number:[order.avai toSmallValueWithContract:order.instrument_id] numColor:DARK_BARKGROUND_COLOR endLabel:order.contractInfo.margin_coin];
                    [self.costLabel loadInfoWithTitle:[NSString stringWithFormat:@"%@@%@X", @"成本", order.leverage] mainColor:GARY_BG_TEXT_COLOR number:cost numColor:DARK_BARKGROUND_COLOR endLabel:order.contractInfo.margin_coin];
                    [self.balanceLabel loadInfoWithTitle:Launguage(@"BT_CA_KYYE") mainColor:GARY_BG_TEXT_COLOR number:[order.balanceAssets toSmallValueWithContract:order.instrument_id] numColor:DARK_BARKGROUND_COLOR endLabel:order.contractInfo.margin_coin];
                    [self.holdSize loadInfoWithTitle:@"成交后仓位大小" mainColor:GARY_BG_TEXT_COLOR number:holdVol numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                }
            break;
            }
        case BTContractAlertViewSendCloseOrder:{
            BTContractOrderModel *order = [BTContractOrderModel mj_objectWithKeyValues:data];
            self.orderModel = order;
            NSString *str1 = @"--";
            NSString *str2 = @"--";
            if (order.category == BTContractOrderCategoryNormal) {
                str1 = @"限价";
            } else if (order.category == BTContractOrderCategoryMarket) {
                str1 = Launguage(@"str_market");
            } else if (order.category == BTContractOrderCategoryPlan) {
                str1 = @"计划";
            }
            if (order.side == BTContractOrderWayBuy_CloseShort) {
                str2 = @"买入";
                self.titleLabel.textColor = UP_WARD_COLOR;
            } else if (order.side == BTContractOrderWaySell_CloseLong) {
                str2 = @"卖出";
                self.titleLabel.textColor = DOWN_COLOR;
            }
            self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@", str1, str2, Launguage(@"BT_CA_CP")];
            if (order.exec_px) { // 计划委托
                NSString *lever = @"";
                if (order.position_type == BTPositionOpen_PursueType) {
                    lever = Launguage(@"BT_CA_GRADE");
                } else if (order.position_type == BTPositionOpen_AllType) {
                    lever = Launguage(@"BT_CA_CROSS");
                }
                NSString *ex_price = [order.exec_px toSmallPriceWithContractID:order.instrument_id];
                if (order.category == BTContractOrderCategoryMarket) {
                    ex_price = Launguage(@"str_market");
                }
                
                self.titleLabel.text = [NSString stringWithFormat:@"%@计划",self.titleLabel.text];
                [self.priceDetail setName:@"触发价格" andNumber:[order.px toSmallPriceWithContractID:order.instrument_id]];
                [self.volumeDetail setName:@"执行价格" andNumber:ex_price];
                [self.leverageDetail setName:[NSString stringWithFormat:@"%@(%@)", Launguage(@"BT_MAIN_V"), @"张"] andNumber:[order.qty toSmallVolumeWithContractID:order.instrument_id]];
//                [self.entrustValue loadInfoWithTitle:@"杠杆倍数" mainColor:GARY_BG_TEXT_COLOR number:[NSString stringWithFormat:@"%@%@X",lever,order.leverage] numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                NSString *typeStr = nil;
                if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"1"]) {
                    typeStr = Launguage(@"str_new_price");
                } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
                    typeStr = @"合理价";
                } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
                    typeStr = @"指数价";
                }
                
                NSString *dateStr = nil;
                if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"7"]) {
                    dateStr = @"7天";
                } else if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"24"]) {
                    dateStr = @"24小时";
                }
                
                [self.costLabel loadInfoWithTitle:@"触发类型" mainColor:GARY_BG_TEXT_COLOR number:typeStr numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                [self.balanceLabel loadInfoWithTitle:@"有效期" mainColor:GARY_BG_TEXT_COLOR number:dateStr numColor:DARK_BARKGROUND_COLOR endLabel:nil];
            } else {
                NSString *price = order.px;
                if (order.category == BTContractOrderCategoryMarket) {
                    price = Launguage(@"str_market");
                }
                self.contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@%@ %@",str2,price, Launguage(@"BT_MAIN_P"),order.qty, @"张",order.name];
            }
            break;
        }
        case BTContractAlertViewContractOpenAccount:{ // 开通合约账户
            NSString *name = data[@"name"];
            self.titleLabel.text = [NSString stringWithFormat:@"开通%@合约账户",name];
            [self.comfirmBtn setTitle:@"我已知晓风险，继续开通合约账户" forState:UIControlStateNormal];
            break;
        }
        case BTContractAlertViewContractBonus:
            self.titleLabel.text = @"BBX永续合约赠金永不停";
            self.titleLabel.textColor = IMPORT_BTN_COLOR;
            self.contentLabel.text = @"您有 10,000 BUSD 待领取";
            self.contentLabel.textColor = MAIN_BTN_TITLE_COLOR;
            break;
        case BTContractAlertViewContractFairPrice:{
            self.titleLabel.text = Launguage(@"str_fair_price");
            NSString *str = @"合理价格等于标的指数价格加上随时间递减的资金费用基差，主要是为了避免高杠杆发生不必要平仓\n\r合理价格影响强平，即当合理价格达到爆仓价格时系统将执行强制平仓操作";
            [self.comfirmBtn setTitle:@"我知道了" forState:UIControlStateNormal];
            NSArray *arr = [str componentsSeparatedByString:@"\n\r"];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
            [text addAttribute:NSForegroundColorAttributeName value:DARK_BARKGROUND_COLOR range:[str rangeOfString:arr[0]]];
            [text addAttribute:NSForegroundColorAttributeName value:MAIN_BTN_COLOR range:[str rangeOfString:arr[1]]];
            self.contentLabel.attributedText = text;
        }
            break;
        case BTContractAlertViewContractLeverage:
            self.label1.numLabel.text = @"1";
            self.label2.numLabel.text = @"2";
            break;
        case BTContractAlertViewContractPlanEntrust: {
            [self.cancelBtn setTitle:@"我知道了" forState:UIControlStateNormal];
            [self.comfirmBtn setTitle:@"去设置" forState:UIControlStateNormal];
            NSString *typeStr = nil;
            if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"1"]) {
                typeStr = Launguage(@"str_new_price");
            } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
                typeStr = @"合理价";
            } else if ([[BTStoreData storeObjectForKey:ST_TIGGER_PRICE] isEqualToString:@"2"]) {
                typeStr = @"指数价";
            }
            NSString *dateStr = nil;
            if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"7"]) {
                dateStr = @"7天";
            } else if ([[BTStoreData storeObjectForKey:ST_DATE_CYCLE] isEqualToString:@"24"]) {
                dateStr = @"24小时";
            }
            NSString *str = [NSString stringWithFormat:@"当市场最新价/合理价格/指数价格达到触发价格时，按预先设置的执行价格跟数量自动下开仓单或平仓单。\n\r计划委托当前有效期期限为%@，当前触发价格为%@,可到合约设置中去修改",dateStr,typeStr];
            NSArray *arr = [str componentsSeparatedByString:@"\n\r"];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
            [text addAttribute:NSForegroundColorAttributeName value:DARK_BARKGROUND_COLOR range:[str rangeOfString:arr[0]]];
            [text addAttribute:NSForegroundColorAttributeName value:MAIN_BTN_COLOR range:[str rangeOfString:arr[1]]];
            self.contentLabel.attributedText = text;
        }
            break;
        case BTContractAlertViewContractFundRate:
            if ([data isKindOfClass:[NSArray class]]) {
                BTIndexDetailModel *model = data[0];
                BTIndexDetailModel *model1 = data[1];
                BTIndexDetailModel *model2 = data[2];
                BTIndexDetailModel *model3 = data[3];
                self.contentLabel.text = @"资金费率为正数时,看多用户需要支付给看空用户资金费用，负数则相反。";
                [self.entrustValue loadInfoWithTitle:[BTFormat timeOnlyDateHourStr:model.timestamp.stringValue] mainColor:GARY_BG_TEXT_COLOR number:[model.rate toPercentString:4] numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                [self.costLabel loadInfoWithTitle:[BTFormat timeOnlyDateHourStr:model1.timestamp.stringValue] mainColor:GARY_BG_TEXT_COLOR number:[model1.rate toPercentString:4] numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                [self.balanceLabel loadInfoWithTitle:[BTFormat timeOnlyDateHourStr:model2.timestamp.stringValue] mainColor:GARY_BG_TEXT_COLOR number:[model2.rate toPercentString:4] numColor:DARK_BARKGROUND_COLOR endLabel:nil];
                [self.holdSize loadInfoWithTitle:[BTFormat timeOnlyDateHourStr:model3.timestamp.stringValue] mainColor:GARY_BG_TEXT_COLOR number:[model3.rate toPercentString:4] numColor:DARK_BARKGROUND_COLOR endLabel:nil];
            }
            break;
        case BTContractAlertViewDepositTips:
        {
            NSString *title = data[@"title"];
            self.contentLabel.text = [NSString stringWithFormat:@"充值%@同时需要一个充值地址和%@ memo，请务必正确填写，若未按照规则填写，资产将不可找回",title,title];
        }
            break;
        case BTContractAlertViewPlanOrderTips:{
            
            NSString *title = data[@"title"];
            self.contentLabel.text = title;
        }
            break;
        case BTContractAlertViewInsufficient:
        {
            NSString *title = data[@"title"];
            self.contentLabel.text = [NSString stringWithFormat:@"您的合约账户%@余额不足，需要进行资金划转，方可进行合约交易。",title];
        }
            break;
        case BTContractAlertViewOTCBuyCoin:
            self.contentLabel.text = @"您的账户中没有任何资产，可以直接充值或者进行法币交易购买";
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.alertViewType) {
        case BTContractAlertViewMarketPriceClose1:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(175));
            self.titleLabel.frame = CGRectMake(SL_getWidth(20), SL_MARGIN * 2, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(20));
            self.contentLabel.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.titleLabel.sl_width, SL_getWidth(50));
            self.cancelBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN, (self.mainView.sl_width - SL_getWidth(50)) * 0.5, SL_getWidth(45));
            self.comfirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + SL_MARGIN, self.cancelBtn.sl_y, self.cancelBtn.sl_width, self.cancelBtn.sl_height);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewMarketPriceClose2:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(245));
            self.titleLabel.frame = CGRectMake(SL_getWidth(20), SL_MARGIN* 2, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(20));
            self.contentLabel.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.titleLabel.sl_width, SL_getWidth(50));
            self.coverView.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN, self.contentLabel.sl_width, SL_getWidth(50));
            
            [self.contractType sizeToFit];
            self.contractType.sl_x = SL_MARGIN;
            self.contractType.sl_y = SL_getWidth(15);
            self.contractType.sl_height = SL_getWidth(20);
            
            [self.coinLabel sizeToFit];
            self.coinLabel.sl_x = CGRectGetMaxX(self.contractType.frame) + SL_MARGIN * 0.5;
            self.coinLabel.sl_centerY =  self.contractType.sl_centerY;
            
            [self.entrustLabel sizeToFit];
            self.entrustLabel.sl_x = self.coverView.sl_width - SL_MARGIN - self.entrustLabel.sl_width;
            self.entrustLabel.sl_centerY = self.contractType.sl_centerY;
            
            self.cancelBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.coverView.frame) + SL_MARGIN * 2, (self.mainView.sl_width - SL_getWidth(50)) * 0.5, SL_getWidth(45));
            self.comfirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + SL_MARGIN, self.cancelBtn.sl_y, self.cancelBtn.sl_width, self.cancelBtn.sl_height);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewMarketPriceClose3:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(235));
            self.imageView.frame = CGRectMake((self.mainView.sl_width -SL_getWidth(40)) * 0.5, SL_getWidth(20), SL_getWidth(40), SL_getWidth(40));
            self.titleLabel.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.imageView.frame), self.mainView.sl_width - SL_getWidth(40), SL_getWidth(40));
            self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.sl_width, SL_getWidth(50));
            self.cancelBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN * 2, (self.mainView.sl_width - SL_getWidth(50)) * 0.5, SL_getWidth(45));
            self.comfirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + SL_MARGIN, self.cancelBtn.sl_y, self.cancelBtn.sl_width, self.cancelBtn.sl_height);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewMarketPriceClose4:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(215));
            self.imageView.frame = CGRectMake((self.mainView.sl_width -SL_getWidth(40)) * 0.5, SL_getWidth(20), SL_getWidth(40), SL_getWidth(40));
            self.contentLabel.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.imageView.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(60));
            self.cancelBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.contentLabel.frame) + 2 * SL_MARGIN, (self.mainView.sl_width - SL_getWidth(50)) * 0.5, SL_getWidth(45));
            self.comfirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + SL_MARGIN, self.cancelBtn.sl_y, self.cancelBtn.sl_width, self.cancelBtn.sl_height);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewPriceExplain:
            {
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(350));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
            self.imageView.frame = CGRectMake(SL_getWidth(35), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(70), SL_getWidth(60));
                self.imageView.image = [UIImage imageWithName:@"jiage"];
            NSDictionary *dict1 = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
            NSString *contentStr1 = @"指标的资产最新交易价格";
            self.label1.contStr = contentStr1;
            CGSize size1 = [contentStr1 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
            self.label1.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.imageView.frame) + SL_MARGIN * 2, self.mainView.sl_width - SL_getWidth(40), size1.height + SL_getWidth(25));
            NSDictionary *dict2 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *contentStr2 = @"标的资产的价格，BTC指数跟踪比特币的价格，频率为每5分钟。该指数是综合指数，意味着价格取自多个交易所。如果某交易所停止服务，并且超过15分钟没有发布任何交易，那么BBX会自动从指数中移除该交易所，直至其交易恢复";
            CGSize size2 = [contentStr2 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict2 context:nil].size;
            self.label2.contStr = contentStr2;
            self.label2.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.label1.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), size2.height + SL_getWidth(30));
                
            NSDictionary *dict3 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
                NSString *contentStr3 = @"标记价格是合约用来计算未实现盈亏和强制平仓的。\n在BBX Swap上，标记价格=（1+资金费率基差率）*指数价格，反映了当前最合理的市场成交价。";
            CGSize size3 = [contentStr3 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict3 context:nil].size;
            self.label3.contStr = contentStr3;
            self.label3.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.label2.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), size3.height + SL_getWidth(30));
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY( self.label3.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
            }
        case BTContractAlertViewPriceExplain2:{
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(350));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
            self.imageView.frame = CGRectMake(SL_getWidth(35), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(70), SL_getWidth(60));
            self.imageView.image = [UIImage imageWithName:@"jiage-2"];
            NSDictionary *dict1 = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
            NSString *contentStr1 = @"指标的资产最新交易价格";
            self.label1.contStr = contentStr1;
            CGSize size1 = [contentStr1 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
            self.label1.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.imageView.frame) + SL_MARGIN * 2, self.mainView.sl_width - SL_getWidth(40), size1.height + SL_getWidth(25));
            NSDictionary *dict2 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *contentStr2 = @"标记价格是合约用来计算未实现盈亏和强制平仓的。\n在BBX Swap上，标记价格=（1+资金费率基差率）*指数价格，反映了当前最合理的市场成交价。";
            CGSize size2 = [contentStr2 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict2 context:nil].size;
            self.label2.contStr = contentStr2;
            self.label2.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.label1.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), size2.height + SL_getWidth(30));
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY(self.label2.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        }
        case BTContractAlertViewContractTerm:
        {
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(360));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
            NSDictionary *dict1 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *contentStr1 = @"未平仓位目前的盈亏";
            self.label1.contStr = contentStr1;
            CGSize size1 = [contentStr1 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
            self.label1.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 3, self.mainView.sl_width - SL_getWidth(40), size1.height + SL_getWidth(30));
            NSDictionary *dict2 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *contentStr2 = @"保证金中分配给未平仓仓位作为起始保证金要求的部分。 这是您持有的所有合约的买入价值除以选定的杠杆，加上未实现的盈亏。";
            CGSize size2 = [contentStr2 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict2 context:nil].size;
            self.label2.contStr = contentStr2;
            self.label2.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.label1.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), size2.height + SL_getWidth(30));
            NSDictionary *dict3 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *contentStr3 = @"保证金中分配给未成交委托作为起始保证金要求的部分。";
            CGSize size3 = [contentStr3 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict3 context:nil].size;
            self.label3.contStr = contentStr3;
            self.label3.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.label2.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), size3.height + SL_getWidth(30));
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), CGRectGetMaxY(self.label3.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
        }
            break;
        case BTContractAlertViewContractBreakHold:
        {
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(350));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
            NSDictionary *dict1 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *time = [BTFormat date2localTimeStr:[BTFormat dateFromUTCString:self.lipRecordModel.created_at] format:DATE_FORMAT_YMDHm];
            NSString *contentStr1 = @"在%1$s，%2$s合约的标记价格%3$s时，您的仓位%4$s-保证金率小于%5$s的维持保证金率，因此触发强平";
            contentStr1 = [contentStr1 stringByReplacingOccurrencesOfString:@"%1$s" withString:time];
            contentStr1 = [contentStr1 stringByReplacingOccurrencesOfString:@"%2$s" withString:self.lipRecordModel.coinCode];
            contentStr1 = [contentStr1 stringByReplacingOccurrencesOfString:@"%3$s" withString:[NSString stringWithFormat:@"%@ %@",self.lipRecordModel.trigger_px,self.lipRecordModel.marginCoin]];
            contentStr1 = [contentStr1 stringByReplacingOccurrencesOfString:@"%4$s" withString:self.lipRecordModel.coinCode];
            contentStr1 = [contentStr1 stringByReplacingOccurrencesOfString:@"%5$s" withString:[self.lipRecordModel.mmr toPercentString:2]];
            
            self.label1.contStr = contentStr1;
            CGSize size1 = [contentStr1 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
            self.label1.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 2, self.mainView.sl_width - SL_getWidth(40), size1.height + SL_getWidth(10));
            NSDictionary *dict2 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *contentStr2 = @"根据保险基金和维持保证金余量，按照价格为%1$s委托入市场，并按照该委托价格结算仓位的收益，但仓位平仓的实际成交价格可能不等于委托价格";
            
            contentStr2 = [contentStr2 stringByReplacingOccurrencesOfString:@"%1$s" withString:[NSString stringWithFormat:@"%@ %@",self.lipRecordModel.order_px,self.lipRecordModel.marginCoin]];
            
            CGSize size2 = [contentStr2 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict2 context:nil].size;
            self.label2.contStr = contentStr2;
            self.label2.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.label1.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), size2.height + SL_getWidth(5));
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.label2.frame) + SL_getWidth(20), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(45));
            [self.comfirmBtn setTitle:@"了解强平机制" forState:UIControlStateNormal];
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), CGRectGetMaxY(self.comfirmBtn.frame) + SL_MARGIN * 2);
            self.mainView.center = self.center;
        }
            break;
        case BTContractAlertViewContractReduceDetail:{
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(350));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
            NSDictionary *dict1 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *time = [BTFormat date2localTimeStr:[BTFormat dateFromUTCString:self.lipRecordModel.created_at] format:DATE_FORMAT_YMDHm];
            NSString *contentStr1 = @"在%1$s，标记价格在%2$s，由于系统保险基金不足，根据盈利排名PnL将你与对手盘在价格%3$s自动减仓";
            contentStr1 = [contentStr1 stringByReplacingOccurrencesOfString:@"%1$s" withString:time];
            contentStr1 = [contentStr1 stringByReplacingOccurrencesOfString:@"%2$s" withString:[NSString stringWithFormat:@"%@ %@",self.lipRecordModel.forcePrice,self.lipRecordModel.marginCoin]];
            contentStr1 = [contentStr1 stringByReplacingOccurrencesOfString:@"%3$s" withString:[NSString stringWithFormat:@"%@ %@",self.lipRecordModel.order_px,self.lipRecordModel.marginCoin]];
            CGSize size1 = [contentStr1 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
            self.label1.contStr = contentStr1;
            self.label1.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), size1.height + SL_getWidth(10));
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.label1.frame) + SL_getWidth(20), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(45));
            [self.comfirmBtn setTitle:@"了解自动减仓机制" forState:UIControlStateNormal];
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), CGRectGetMaxY(self.comfirmBtn.frame) + SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        }
        case BTContractAlertViewContractCloseHold:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(255));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
            self.priceTextField.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 2, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            self.volumeField.frame = CGRectMake(self.priceTextField.sl_x, CGRectGetMaxY(self.priceTextField.frame) + SL_MARGIN * 1.5, self.priceTextField.sl_width, self.priceTextField.sl_height);
            self.tradeSlider.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.volumeField.frame), self.mainView.sl_width - SL_getWidth(40), SL_getWidth(50));
            self.tipsLabel.frame = CGRectMake(self.priceTextField.sl_x, CGRectGetMaxY(self.tradeSlider.frame) + SL_MARGIN, self.priceTextField.sl_width, SL_getWidth(20));
            self.marketClose.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.tipsLabel.frame) + SL_MARGIN, (self.mainView.sl_width - SL_getWidth(50)) * 0.5, SL_getWidth(45));
            self.marketClose.titleLabel.numberOfLines = 0;
            self.comfirmBtn.frame = CGRectMake(CGRectGetMaxX(self.marketClose.frame) + SL_MARGIN, self.marketClose.sl_y, self.marketClose.sl_width, self.marketClose.sl_height);
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), CGRectGetMaxY(self.comfirmBtn.frame) + SL_MARGIN * 2);
            self.mainView.sl_centerY = self.sl_height * 0.4;
            break;
        case BTContractAlertViewContractSupplementDeposit:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(375));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
            
            self.supporDepositBtn.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.mainView.sl_width * 0.5 - SL_getWidth(35), SL_getWidth(35));
            self.reduceDepositBtn.frame = CGRectMake(CGRectGetMaxX(self.supporDepositBtn.frame) + SL_MARGIN, self.supporDepositBtn.sl_y, self.supporDepositBtn.sl_width, self.supporDepositBtn.sl_height);
            
            self.entrustValue.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.supporDepositBtn.frame) + SL_getWidth(10) , self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
            self.costLabel.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.entrustValue.frame), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
//            self.balanceLabel.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.costLabel.frame), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
            self.holdSize.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.costLabel.frame), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
            self.priceTextField.placeholder = @"请输入追加保证金数量";
            self.priceTextField.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.holdSize.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            
            self.tipsLabel.frame = CGRectMake(self.priceTextField.sl_x, CGRectGetMaxY(self.priceTextField.frame) + SL_MARGIN * 0.4, self.sl_width - SL_getWidth(50) - SL_getWidth(40), SL_getWidth(20));
            self.tipsLabel.font = [UIFont systemFontOfSize:13];
            [self.allBtn sizeToFit];
            self.allBtn.sl_x = self.mainView.sl_width - SL_getWidth(20) - self.allBtn.sl_width;
            self.allBtn.sl_height = SL_getWidth(20);
            self.allBtn.sl_centerY = self.tipsLabel.sl_centerY;
            
            self.avaibalance.frame = CGRectMake(self.priceTextField.sl_x, CGRectGetMaxY(self.tipsLabel.frame) + 2, self.priceTextField.sl_width, SL_getWidth(35));
            self.avaibalance.numberOfLines = 2;
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.avaibalance.frame) + SL_MARGIN * 0.5, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            self.mainView.center = CGPointMake(self.sl_centerX, self.sl_height * 0.4);
            break;
        case BTContractAlertViewContractFuturesOrder:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(360));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(25));
            self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
//            self.leverLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.sl_width, SL_getWidth(20));
            self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.sl_width, self.titleLabel.sl_height);
            self.priceDetail.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN * 0.5, (self.mainView.sl_width - SL_getWidth(70))/3.0, SL_getWidth(50));
            self.priceDetail.nameColor = GARY_BG_TEXT_COLOR;
            self.priceDetail.numberColor = DARK_BARKGROUND_COLOR;
            
            self.volumeDetail.frame = CGRectMake(CGRectGetMaxX(self.priceDetail.frame) + SL_MARGIN, self.priceDetail.sl_y, self.priceDetail.sl_width, self.priceDetail.sl_height);
            self.volumeDetail.nameColor = GARY_BG_TEXT_COLOR;
            self.volumeDetail.numberColor = DARK_BARKGROUND_COLOR;
            
            self.leverageDetail.frame = CGRectMake(CGRectGetMaxX(self.volumeDetail.frame) + SL_MARGIN, self.priceDetail.sl_y, self.priceDetail.sl_width, self.priceDetail.sl_height);
            self.leverageDetail.nameColor = GARY_BG_TEXT_COLOR;
            self.leverageDetail.numberColor = DARK_BARKGROUND_COLOR;
            
            if (self.orderModel.forceTips) {
                self.leverLabel.frame = CGRectMake(self.priceDetail.sl_x, CGRectGetMaxY(self.priceDetail.frame) + SL_MARGIN * 0.5, self.mainView.sl_width - SL_getWidth(50), SL_getWidth(35));
                self.entrustValue.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.leverLabel.frame) + SL_MARGIN * 0.5, self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
                self.leverLabel.textColor = [UIColor redColor];
                self.leverLabel.font = [UIFont systemFontOfSize:13];
                self.leverLabel.textAlignment = NSTextAlignmentLeft;
                self.leverLabel.numberOfLines = 0;
                self.leverLabel.text = self.orderModel.forceTips;
            } else {
                self.entrustValue.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.priceDetail.frame) + SL_MARGIN , self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
            }
            self.costLabel.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.entrustValue.frame) + SL_MARGIN , self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
            self.balanceLabel.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.costLabel.frame) + SL_MARGIN , self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
            self.holdSize.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.balanceLabel.frame) + SL_MARGIN , self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
            self.circleBtn.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.holdSize.frame) + SL_MARGIN, SL_getWidth(20), SL_getWidth(20));
            self.tipsLabel.frame = CGRectMake(CGRectGetMaxX(self.circleBtn.frame), self.circleBtn.sl_y, self.mainView.sl_width - SL_getWidth(20 - CGRectGetMaxX(self.circleBtn.frame)),  SL_getWidth(20));
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.circleBtn.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(50), SL_getWidth(45));
            self.tipsLabel.text = @"下次不再提醒";
            self.tipsLabel.sl_centerY =  self.circleBtn.sl_centerY;
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), CGRectGetMaxY(self.comfirmBtn.frame) + SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewSendCloseOrder:
            if (self.orderModel.exec_px) {
                self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(360));
                self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(25));
                self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
                //            self.leverLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.sl_width, SL_getWidth(20));
//                self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.sl_width, self.titleLabel.sl_height);
                self.priceDetail.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 0.5, (self.mainView.sl_width - SL_getWidth(70))/3.0, SL_getWidth(50));
                self.priceDetail.nameColor = GARY_BG_TEXT_COLOR;
                self.priceDetail.numberColor = DARK_BARKGROUND_COLOR;
                
                self.volumeDetail.frame = CGRectMake(CGRectGetMaxX(self.priceDetail.frame) + SL_MARGIN, self.priceDetail.sl_y, self.priceDetail.sl_width, self.priceDetail.sl_height);
                self.volumeDetail.nameColor = GARY_BG_TEXT_COLOR;
                self.volumeDetail.numberColor = DARK_BARKGROUND_COLOR;
                
                self.leverageDetail.frame = CGRectMake(CGRectGetMaxX(self.volumeDetail.frame) + SL_MARGIN, self.priceDetail.sl_y, self.priceDetail.sl_width, self.priceDetail.sl_height);
                self.leverageDetail.nameColor = GARY_BG_TEXT_COLOR;
                self.leverageDetail.numberColor = DARK_BARKGROUND_COLOR;
                
//                self.entrustValue.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.priceDetail.frame) + SL_MARGIN , self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
                self.costLabel.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.self.priceDetail.frame) + SL_MARGIN , self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
                self.balanceLabel.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.costLabel.frame) + SL_MARGIN , self.mainView.sl_width - SL_getWidth(50), SL_getWidth(30));
                self.circleBtn.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.balanceLabel.frame) + SL_MARGIN, SL_getWidth(20), SL_getWidth(20));
                self.tipsLabel.frame = CGRectMake(CGRectGetMaxX(self.circleBtn.frame), self.circleBtn.sl_y, self.mainView.sl_width - SL_getWidth(20 - CGRectGetMaxX(self.circleBtn.frame)),  SL_getWidth(20));
                self.comfirmBtn.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.circleBtn.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(50), SL_getWidth(45));
                self.tipsLabel.text = @"下次不再提醒";
                self.tipsLabel.sl_centerY =  self.circleBtn.sl_centerY;
                self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), CGRectGetMaxY(self.comfirmBtn.frame) + SL_MARGIN * 1.5);
                self.mainView.center = self.center;
            } else {
                self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(210));
                self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
                self.crossBtn.frame = CGRectMake(self.mainView.sl_width - SL_getWidth(40), SL_getWidth(10), SL_getWidth(30),  SL_getWidth(30));
                if (self.orderModel.forceTips) {
                    self.leverLabel.frame = CGRectMake(self.priceDetail.sl_x, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(50), SL_getWidth(35));
                    self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.leverLabel.frame) + SL_MARGIN * 0.5, self.titleLabel.sl_width, SL_getWidth(40));
                    self.leverLabel.textColor = [UIColor redColor];
                    self.leverLabel.font = [UIFont systemFontOfSize:13];
                    self.leverLabel.textAlignment = NSTextAlignmentLeft;
                    self.leverLabel.numberOfLines = 0;
                    self.leverLabel.text = self.orderModel.forceTips;
                } else {
                    self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.titleLabel.sl_width, SL_getWidth(40));
                }
                
                self.contentLabel.numberOfLines = 0;
                self.contentLabel.textAlignment = NSTextAlignmentCenter;
                self.circleBtn.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN, SL_getWidth(20), SL_getWidth(20));
                self.tipsLabel.frame = CGRectMake(CGRectGetMaxX(self.circleBtn.frame), self.circleBtn.sl_y, self.mainView.sl_width - SL_getWidth(20 - CGRectGetMaxX(self.circleBtn.frame)),  SL_getWidth(20));
                self.comfirmBtn.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.circleBtn.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(50), SL_getWidth(45));
                self.tipsLabel.text = @"下次不再提醒";
                self.tipsLabel.sl_centerY =  self.circleBtn.sl_centerY;
                self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), CGRectGetMaxY(self.comfirmBtn.frame) + SL_MARGIN * 1.5);
                self.mainView.center = self.center;
            }
            break;
        case BTContractAlertViewContractOpenAccount:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(450));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN , self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.lineView.frame = CGRectMake(SL_MARGIN * 2, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.mainView.sl_width - 4 * SL_MARGIN, 1);
            self.contentTextView.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.lineView.frame) + SL_MARGIN,  self.mainView.sl_width - SL_getWidth(40), SL_getWidth(350));
            self.contentTextView.text = @"内容：\n风险披露告知通知：\n一、您在合约市场进行交易，假如市场走势对您不利导致您的仓位保证金不足时，BBX Swap会按照系统约定的对您的仓位进行强平委托并披露强平明细。\n\n二、您必须认真阅读并遵守BBX Swap的业务规则，了解合约的机制和运行原理，了解市场的各种风险。\n\n三、在某些极端的市场情况下，您可能会难以或无法将持有的未平仓合约平仓。例如，当你的盈利在整个合约市场中有效杠杆PnL中排位第一，且对手盘在保险基金不足以垫付其穿仓损失的情况下。\n\n四、由于马耳他法律、法规、政策的变化、合约交易所交易规则的修改、紧急措施的出台等原因，BBX会提前披露声明，您持有的未平仓合约可能无法继续持有，但保证金和盈利的结余仍会兑现。\n\n五、由于非BBX所能控制的原因，例如：地震、水灾、火灾等不可抗力因素或者计算机系统、通讯系统故障等，可能造成您的指令无法成交或者无法全部成交，您可能会承担由此导致的损失。\n\n六、“套期保值”交易同投机交易一样，同样面临价格波动引起的风险。\n\n七、如果您没有进行KYC2（实名认证）或者未绑定Google验证，或者将账号借给非本人操作，将可能会影响您的合约保证金的安全性。";
            self.contentTextView.scrollEnabled = YES;
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.contentTextView.frame) + SL_MARGIN * 1.5, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            self.comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), CGRectGetMaxY(self.comfirmBtn.frame) + SL_MARGIN * 1.5);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewContractBonus:
            self.mainView.frame = CGRectMake(SL_getWidth(40), 0, self.sl_width - SL_getWidth(80), SL_getWidth(450));
            self.mainView.backgroundColor = [UIColor clearColor];
            self.imageView.frame = CGRectMake(0, 0, self.mainView.sl_width, self.mainView.sl_height * 0.8);
            self.imageView.image = [UIImage imageWithName:@"bg-tankuang"];
            self.titleLabel.frame = CGRectMake(SL_MARGIN , SL_getWidth(60), self.mainView.sl_width - SL_MARGIN * 2, SL_getWidth(30));
            self.titleLabel.font = [UIFont systemFontOfSize:16];
            self.contentLabel.frame = CGRectMake(SL_MARGIN, self.mainView.sl_height * 0.52, self.mainView.sl_width - SL_MARGIN * 2, SL_getWidth(40));
            self.contentLabel.numberOfLines = 0;
            self.contentLabel.font = [UIFont systemFontOfSize:20];
            self.crossBtn.frame = CGRectMake(SL_getWidth(40), self.imageView.sl_height + SL_getWidth(40), SL_getWidth(30),  SL_getWidth(30));
            self.crossBtn.sl_centerX = self.mainView.sl_width * 0.5;
            [self.crossBtn setImage:[UIImage imageWithName:@"icon-close3"] forState:UIControlStateNormal];
            self.comfirmBtn = [BTMainButton orangeBtnWithTitle:@"去领取10,000 BUSD" target:self action:@selector(contractAlertViewDidClickComfirm:)];
            [self.mainView addSubview:self.comfirmBtn];
            self.comfirmBtn.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame) + SL_getWidth(15), SL_getWidth(180), SL_getWidth(40));
            self.comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.comfirmBtn setTitleColor:DARK_BARKGROUND_COLOR forState:UIControlStateNormal];
            self.comfirmBtn.sl_centerX = self.mainView.sl_width * 0.5;
            self.mainView.center = CGPointMake(SL_SCREEN_WIDTH * 0.5, SL_SCREEN_HEIGHT * 0.5);
            [self.mainView sendSubviewToBack:self.imageView];
            break;
        case BTContractAlertViewContractFairPrice:
            self.mainView.frame = CGRectMake(SL_getWidth(25), 0, self.sl_width - SL_getWidth(50), SL_getWidth(275));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 1.5, self.titleLabel.sl_width, SL_getWidth(130));
            self.contentLabel.textAlignment = NSTextAlignmentLeft;
            self.contentLabel.font = [UIFont systemFontOfSize:15];
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN * 1, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            self.comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewContractLeverage:{
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(350));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.titleLabel.text = @"全仓和逐仓";
            NSDictionary *dict1 = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
            NSString *contentStr1 = @"全仓：是指将账户所有可用余额作为保证金来避免强制平仓。任何其他仓位已实现盈利都可以帮助在亏损仓位上增加保证金。";
            self.label1.contStr = contentStr1;
            CGSize size1 = [contentStr1 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
            self.label1.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 2, self.mainView.sl_width - SL_getWidth(40), size1.height + SL_getWidth(25));
            self.label1.font = [UIFont systemFontOfSize:15];
            NSDictionary *dict2 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
            NSString *contentStr2 = @"逐仓：用户的最大损失仅限于所使用的起始保证金，在某仓位被强制平仓时，你的任何可用余额都不会用于增加次仓位的保证金";
            CGSize size2 = [contentStr2 boundingRectWithSize:CGSizeMake(self.sl_width - SL_getWidth(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict2 context:nil].size;
            self.label2.contStr = contentStr2;
            self.label2.font = [UIFont systemFontOfSize:15];
            self.label2.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.label1.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), size2.height + SL_getWidth(20));
            
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.label2.frame) + SL_MARGIN * 1.5, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            [self.comfirmBtn setTitle:@"我知道了" forState:UIControlStateNormal];
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY(self.comfirmBtn.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
        }
            break;
        case BTContractAlertViewContractPlanEntrust:
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(350));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(25));
            self.titleLabel.text = Launguage(@"str_planOrder");
            self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 1, self.titleLabel.sl_width, SL_getWidth(160));
            self.contentLabel.font = [UIFont systemFontOfSize:16];
            self.contentLabel.textAlignment = NSTextAlignmentLeft;
            self.cancelBtn.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.contentLabel.frame), (self.mainView.sl_width - SL_getWidth(50)) * 0.5, SL_getWidth(45));
            self.comfirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame)+ SL_MARGIN, self.cancelBtn.sl_y, self.cancelBtn.sl_width, self.cancelBtn.sl_height);
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY(self.comfirmBtn.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewContractFundRate:
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(350));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(30));
            self.titleLabel.text = Launguage(@"BT_CA_ZJFL");
            self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.titleLabel.sl_width, SL_getWidth(50));
            self.entrustValue.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.contentLabel.frame), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(40));
            self.costLabel.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.entrustValue.frame), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(40));
            self.balanceLabel.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.costLabel.frame), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(40));
            self.holdSize.frame = CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.balanceLabel.frame), self.mainView.sl_width - SL_getWidth(50), SL_getWidth(40));
            [self.allBtn setTitle:@"了解更多" forState:UIControlStateNormal];
            [self.allBtn sizeToFit];
            self.allBtn.sl_y = CGRectGetMaxY(self.holdSize.frame)+ SL_MARGIN;
            self.allBtn.sl_x = self.mainView.sl_width - SL_getWidth(20) - self.allBtn.sl_width;
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.allBtn.frame) + SL_MARGIN * 1, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            [self.comfirmBtn setTitle:@"我知道了" forState:UIControlStateNormal];
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY(self.comfirmBtn.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewDepositTips:
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(300));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(25));
            self.titleLabel.text = @"⚠️ 注意";
            self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.titleLabel.sl_width, SL_getWidth(90));
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            [self.comfirmBtn setTitle:@"我已知晓" forState:UIControlStateNormal];
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY(self.comfirmBtn.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewPlanOrderTips:
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(300));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(25));
            self.titleLabel.text = @"失败原因";
            self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN, self.titleLabel.sl_width, SL_getWidth(90));
            self.comfirmBtn.frame = CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(45));
            [self.comfirmBtn setTitle:@"我知道了" forState:UIControlStateNormal];
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY(self.comfirmBtn.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewInsufficient:
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(350));
            self.titleLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(25));
            self.titleLabel.text = @"合约账户余额不足";
            self.contentLabel.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 1, self.titleLabel.sl_width, SL_getWidth(80));
            self.contentLabel.font = [UIFont systemFontOfSize:16];
            self.contentLabel.textAlignment = NSTextAlignmentLeft;
            self.cancelBtn.frame = CGRectMake(self.titleLabel.sl_x, CGRectGetMaxY(self.contentLabel.frame), (self.mainView.sl_width - SL_getWidth(50)) * 0.5, SL_getWidth(45));
            self.comfirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame)+ SL_MARGIN, self.cancelBtn.sl_y, self.cancelBtn.sl_width, self.cancelBtn.sl_height);
            [self.comfirmBtn setTitle:@"划转" forState:UIControlStateNormal];
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY(self.comfirmBtn.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        case BTContractAlertViewOTCBuyCoin:
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), SL_getWidth(350));
            self.contentLabel.frame = CGRectMake(SL_MARGIN * 2, SL_MARGIN * 3, self.mainView.sl_width - SL_MARGIN * 4, SL_getWidth(70));
            self.contentLabel.font = [UIFont systemFontOfSize:16];
            self.contentLabel.textAlignment = NSTextAlignmentLeft;
            self.cancelBtn.frame = CGRectMake(self.contentLabel.sl_x, CGRectGetMaxY(self.contentLabel.frame), (self.mainView.sl_width - SL_getWidth(50)) * 0.5, SL_getWidth(45));
            self.comfirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame)+ SL_MARGIN, self.cancelBtn.sl_y, self.cancelBtn.sl_width, self.cancelBtn.sl_height);
            [self.comfirmBtn setTitle:@"一键买币" forState:UIControlStateNormal];
            self.mainView.frame = CGRectMake(SL_getWidth(20), 0, self.sl_width - SL_getWidth(40), CGRectGetMaxY(self.comfirmBtn.frame)+ SL_MARGIN * 2);
            self.mainView.center = self.center;
            break;
        default:
            break;
    }
}

#pragma mark - delegate

- (void)contractTextViewValuehasChange:(BTContractTextView *)contractTextView {
    if (self.alertViewType == BTContractAlertViewContractSupplementDeposit) {
        BTPositionModel *positionModel = [BTPositionModel mj_objectWithKeyValues:[self.position mj_keyValues]];
        if (self.reduceDepositBtn.selected) { // 减少保证金
            if (self.position.position_type == BTPositionOpen_AllType) {
                NSString *closePrice = self.position.liquidate_price;
                self.avaibalance.text = [NSString stringWithFormat:@"%@:\n %@(%@) %@",@"调整后预计强平价格",closePrice,[closePrice bigSub:self.position.liquidate_price],self.position.contractInfo.margin_coin];
                [self.avaibalance layoutStringArr:@[closePrice]];
                if ([contractTextView.currentValue GreaterThan:self.position.reduceDeposit_Max]) {
                    self.tipsLabel.text = @"超过最大可减少保证金";
                    self.tipsLabel.textColor = DOWN_COLOR;
                } else {
                    self.tipsLabel.textColor = GARY_BG_TEXT_COLOR;
                    self.tipsLabel.text = [NSString stringWithFormat:@"最大可减少：%@ %@",[self.position.reduceDeposit_Max toSmallValueWithContract:self.position.instrument_id],self.position.contractInfo.margin_coin];
                }
            } else {
                if (contractTextView.currentValue.length > 0) {
                    NSString *im = [self.position.im bigSub:contractTextView.currentValue];
                    if ([im GreaterThanOrEqual:BT_ZERO]) {
                        positionModel.im = im;
                        NSString *closePrice = [SLFormula calculatePositionLiquidatePrice:positionModel assets:self.asset contractInfo:self.position.contractInfo];
                        self.avaibalance.text = [NSString stringWithFormat:@"%@:\n %@(%@) %@",@"调整后预计强平价格",closePrice,[closePrice bigSub:self.position.liquidate_price],self.position.contractInfo.margin_coin];
                        [self.avaibalance layoutStringArr:@[closePrice]];
                    } else {
                        self.avaibalance.text = [NSString stringWithFormat:@"%@ %@",@"调整后预计强平价格",@"--"];
                        [self.avaibalance layoutStringArr:@[@"--"]];
                    }
                } else {
                    self.avaibalance.text = [NSString stringWithFormat:@"%@ %@",@"调整后预计强平价格",@"--"];
                    [self.avaibalance layoutStringArr:@[@"--"]];
                }
                
                if ([contractTextView.currentValue GreaterThan:self.position.reduceDeposit_Max]) {
                    self.tipsLabel.text = @"超过最大可减少保证金";
                    self.tipsLabel.textColor = DOWN_COLOR;
                } else {
                    self.tipsLabel.textColor = GARY_BG_TEXT_COLOR;
                    self.tipsLabel.text = [NSString stringWithFormat:@"最大可减少：%@ %@",[self.position.reduceDeposit_Max toSmallValueWithContract:self.position.instrument_id],self.position.contractInfo.margin_coin];
                }
            }
        } else { // 追加保证金
            if (self.position.position_type == BTPositionOpen_AllType) {
                NSString *closePrice = self.position.liquidate_price;
                self.avaibalance.text = [NSString stringWithFormat:@"%@:\n %@(%@) %@",@"调整后预计强平价格",closePrice,[closePrice bigSub:self.position.liquidate_price],self.position.contractInfo.margin_coin];
                [self.avaibalance layoutStringArr:@[closePrice]];
                if ([contractTextView.currentValue GreaterThan:self.asset.contract_avail]) {
                    self.tipsLabel.text = @"超过最大可增加保证金";
                    self.tipsLabel.textColor = DOWN_COLOR;
                } else {
                    self.tipsLabel.textColor = GARY_BG_TEXT_COLOR;
                    self.tipsLabel.text = [NSString stringWithFormat:@"最大可增加：%@ %@",[self.asset.contract_avail toSmallValueWithContract:self.position.instrument_id],self.position.contractInfo.margin_coin];
                }
            } else {
                if (contractTextView.currentValue.length > 0) {
                    NSString *im = [self.position.im bigAdd:contractTextView.currentValue];
                    if ([im GreaterThanOrEqual:BT_ZERO]) {
                        positionModel.im = im;
                    }
                    NSString *closePrice = positionModel.liquidate_price;//[BTContractsOpenModel calculatePositionLiquidatePrice:positionModel assets:self.asset contractInfo:self.position.contractInfo];
                    self.avaibalance.text = [NSString stringWithFormat:@"%@:\n %@(%@) %@",@"调整后预计强平价格",closePrice,[closePrice bigSub:self.position.liquidate_price],self.position.contractInfo.margin_coin];
                    [self.avaibalance layoutStringArr:@[closePrice]];
                } else {
                    self.avaibalance.text = [NSString stringWithFormat:@"%@ %@",@"调整后预计强平价格",@"--"];
                    [self.avaibalance layoutStringArr:@[@"--"]];
                }
                if ([contractTextView.currentValue GreaterThan:self.asset.contract_avail]) {
                    self.tipsLabel.text = @"超过最大可增加保证金";
                    self.tipsLabel.textColor = DOWN_COLOR;
                } else {
                    self.tipsLabel.textColor = GARY_BG_TEXT_COLOR;
                    self.tipsLabel.text = [NSString stringWithFormat:@"最大可增加：%@ %@",[self.asset.contract_avail toSmallValueWithContract:self.position.instrument_id],self.position.contractInfo.margin_coin];
                }
            }
        }
    }
}

#pragma mark - action
- (void)contractAlertViewDidClickCancel:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contractAlertViewDidClickCancelWithType:)]) {
        [self.delegate contractAlertViewDidClickCancelWithType:self.alertViewType];
    }
}

- (void)contractAlertViewDidClickComfirm:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contractAlertViewDidClickComfirmWithType:info:)]) {
        NSDictionary *dict = nil;
        if (self.alertViewType == BTContractAlertViewContractCloseHold) {
            if (self.priceTextField.currentValue.length <= 0 || self.volumeField.currentValue.length <= 0) {
                return;
            }
            dict = @{@"price":self.priceTextField.currentValue,
                     @"volume":self.volumeField.currentValue};
        } else if (self.alertViewType == BTContractAlertViewContractSupplementDeposit) {
            if (self.priceTextField.currentValue.length <= 0) {
                return;
            }
            NSInteger oper_type = 1;
            if (self.reduceDepositBtn.selected) {
                oper_type = 2;
            }
            
            dict = @{@"vol":self.priceTextField.currentValue,@"oper_type":@(oper_type)};
        }
        [self.delegate contractAlertViewDidClickComfirmWithType:self.alertViewType info:dict];
    }
}

- (void)contractAlertViewDidClickMarketClose:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contractAlertViewDidClickMarketPriceCloseWithtype:)]) {
        [self.delegate contractAlertViewDidClickMarketPriceCloseWithtype:self.alertViewType];
    }
}

- (void)didClickCirCleBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [BTStoreData setStoreBoolAndKey:!sender.selected Key:SL_SHOW_CONTRACT_DETAIL];
}

- (void)didClickSupporDepositBtn:(UIButton *)sender {
    sender.selected = YES;
    self.reduceDepositBtn.selected = NO;
    self.priceTextField.defineView.text = @"";
    self.tipsLabel.text = [NSString stringWithFormat:@"最大可增加：%@ %@",[self.asset.contract_avail toSmallValueWithContract:self.position.instrument_id],self.position.contractInfo.margin_coin];
    self.allBtn.hidden = NO;
    [self contractTextViewValuehasChange:self.priceTextField];
}

- (void)didClickReduceDepositBtn:(UIButton *)sender {
    sender.selected = YES;
    self.supporDepositBtn.selected = NO;
    self.priceTextField.defineView.text = @"";
    self.tipsLabel.text = [NSString stringWithFormat:@"最大可减少：%@ %@",[self.position.reduceDeposit_Max toSmallValueWithContract:self.position.instrument_id],self.position.contractInfo.margin_coin];
    self.allBtn.hidden = YES;
    [self contractTextViewValuehasChange:self.priceTextField];
}

- (void)didClickAllBtn:(UIButton *)sender {
    if (self.alertViewType == BTContractAlertViewContractSupplementDeposit) {
        if (self.reduceDepositBtn.selected) { // 减少保证金
            if ([self.position.reduceDeposit_Max GreaterThan:BT_ZERO]) {
                self.priceTextField.defineView.text = [self.position.reduceDeposit_Max toSmallValueWithContract:self.position.instrument_id];
            }
        } else {
            if ([self.asset.contract_avail GreaterThan:BT_ZERO]) {
                self.priceTextField.defineView.text = [self.asset.contract_avail toSmallValueWithContract:self.position.instrument_id];
            }
        }
        [self contractTextViewValuehasChange:self.priceTextField];
    } else {
        if ([self.delegate respondsToSelector:@selector(contractAlertViewDidClickAllBtnWithtype:)]) {
            [self.delegate contractAlertViewDidClickAllBtnWithtype:self.alertViewType];
        }
    }
}

#pragma mark - lazy
- (UIScrollView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIScrollView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 8;
        _mainView.layer.masksToBounds = YES;
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.scrollsToTop = YES;
        [self addSubview:_mainView];
    }
    return _mainView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = DARK_BARKGROUND_COLOR;
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self.mainView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = DARK_BARKGROUND_COLOR;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        [self.mainView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIButton *)crossBtn {
    if (_crossBtn == nil) {
        _crossBtn = [[UIButton alloc] init];
        [_crossBtn setImage:[UIImage imageWithName:@"icon-close2"] forState:UIControlStateNormal];
        [self.mainView addSubview:_crossBtn];
        [_crossBtn addTarget:self action:@selector(contractAlertViewDidClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _crossBtn;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = MAIN_BTN_COLOR.CGColor;
        _cancelBtn.layer.borderWidth = 1.5;
        _cancelBtn.layer.cornerRadius = 2;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(contractAlertViewDidClickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UIButton *)marketClose {
    if (_marketClose == nil) {
        _marketClose = [[UIButton alloc] init];
        [_marketClose setTitleColor:MAIN_BTN_COLOR forState:UIControlStateNormal];
        _marketClose.layer.borderColor = MAIN_BTN_COLOR.CGColor;
        _marketClose.layer.borderWidth = 1.5;
        _marketClose.layer.cornerRadius = 2;
        _marketClose.layer.masksToBounds = YES;
        _marketClose.titleLabel.font = [UIFont systemFontOfSize:17];
        [_marketClose setTitle:@"市价全平" forState:UIControlStateNormal];
        [_marketClose addTarget:self action:@selector(contractAlertViewDidClickMarketClose:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_marketClose];
    }
    return _marketClose;
}

- (BTMainButton *)comfirmBtn {
    if (_comfirmBtn == nil) {
        _comfirmBtn = [BTMainButton blueBtnWithTitle:@"确认" target:self action:@selector(contractAlertViewDidClickComfirm:)];
        [self.mainView addSubview:_comfirmBtn];
    }
    return _comfirmBtn;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithHex:@"#f3f4f7"];
        [self.mainView addSubview:_coverView];
    }
    return _coverView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [self.mainView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)contractType {
    if (_contractType == nil) {
        _contractType = [[UILabel alloc] init];
        _contractType.layer.borderWidth = 1;
        _contractType.font = [UIFont systemFontOfSize:11];
        [self.coverView addSubview:_contractType];
    }
    return _contractType;
}

- (UILabel *)coinLabel {
    if (_coinLabel == nil) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = [UIFont systemFontOfSize:14];
        _coinLabel.textColor = DARK_BARKGROUND_COLOR;
        [self.coverView addSubview:_coinLabel];
    }
    return _coinLabel;
}

- (BTContractLabel *)entrustLabel {
    if (_entrustLabel == nil) {
        _entrustLabel = [[BTContractLabel alloc] init];
        _entrustLabel.font = [UIFont systemFontOfSize:15];
        _entrustLabel.mainColor = GARY_BG_TEXT_COLOR;
        _entrustLabel.markColor = DARK_BARKGROUND_COLOR;
        [self.coverView addSubview:_entrustLabel];
    }
    return _entrustLabel;
}

- (BTContractAlertLabel *)label1 {
    if (_label1 == nil) {
        _label1 = [[BTContractAlertLabel alloc] init];
        [self.mainView addSubview:_label1];
    }
    return _label1;
}

- (BTContractAlertLabel *)label2 {
    if (_label2 == nil) {
        _label2 = [[BTContractAlertLabel alloc] init];
        [self.mainView addSubview:_label2];
    }
    return _label2;
}

- (BTContractAlertLabel *)label3 {
    if (_label3 == nil) {
        _label3 = [[BTContractAlertLabel alloc] init];
        [self.mainView addSubview:_label3];
    }
    return _label3;
}

- (BTContractTextView *)priceTextField {
    if (_priceTextField == nil) {
        _priceTextField = [[BTContractTextView alloc] initWithFrame:CGRectMake(SL_getWidth(20), CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 2, self.sl_width - SL_getWidth(50) - SL_getWidth(40), SL_getWidth(45))];
        _priceTextField.type = BTContractTextLimitPrice;
        [self.mainView addSubview:_priceTextField];
        _priceTextField.backgroundColor = [UIColor whiteColor];
        _priceTextField.layer.borderWidth = 1;
        _priceTextField.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        _priceTextField.defineView.textColor = DARK_BARKGROUND_COLOR;
        [_priceTextField.defineView becomeFirstResponder];
        _priceTextField.delegate = self;
    }
    return _priceTextField;
}

- (BTContractTextView *)volumeField {
    if (_volumeField == nil) {
        _volumeField = [[BTContractTextView alloc] initWithFrame:CGRectMake(self.priceTextField.sl_x, CGRectGetMaxY(self.priceTextField.frame) + SL_MARGIN, self.priceTextField.sl_width, self.priceTextField.sl_height)];
        [self.mainView addSubview:_volumeField];
        _volumeField.type = BTContractTextVolume;
        _volumeField.backgroundColor = [UIColor whiteColor];
        _volumeField.layer.borderWidth = 1;
        _volumeField.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
        _volumeField.defineView.textColor = DARK_BARKGROUND_COLOR;
    }
    return _volumeField;
}

- (UIButton *)allBtn {
    if (_allBtn == nil) {
        _allBtn = [[UIButton alloc] init];
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        _allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_allBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateNormal];
        [_allBtn addTarget:self action:@selector(didClickAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_allBtn];
    }
    return _allBtn;
}

- (BTContractLabel *)avaibalance {
    if (_avaibalance == nil) {
        _avaibalance = [[BTContractLabel alloc] init];
        _avaibalance.font = [UIFont systemFontOfSize:13];
        _avaibalance.mainColor = GARY_BG_TEXT_COLOR;
        _avaibalance.markColor = DARK_BARKGROUND_COLOR;
        [self.mainView addSubview:_avaibalance];
    }
    return _avaibalance;
}

- (BTDetailLabel *)priceDetail {
    if (_priceDetail == nil) {
        _priceDetail = [[BTDetailLabel alloc] initWithFrame:CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.contentLabel.frame) + SL_MARGIN, (SL_SCREEN_WIDTH - SL_getWidth(120))/3.0, SL_getWidth(40)) andType:1];
        _priceDetail.nameFont = [UIFont systemFontOfSize:14];
        _priceDetail.font = [UIFont systemFontOfSize:16];
        [self.mainView addSubview:_priceDetail];
    }
    return _priceDetail;
}

- (BTDetailLabel *)volumeDetail {
    if (_volumeDetail == nil) {
        _volumeDetail = [[BTDetailLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceDetail.frame) + SL_MARGIN, self.priceDetail.sl_y, self.priceDetail.sl_width, self.priceDetail.sl_height) andType:1];
        _volumeDetail.nameFont = [UIFont systemFontOfSize:14];
        _volumeDetail.font = [UIFont systemFontOfSize:16];
        _volumeDetail.alignment = NSTextAlignmentCenter;
        [self.mainView addSubview:_volumeDetail];
    }
    return _volumeDetail;
}

- (BTDetailLabel *)leverageDetail {
    if (_leverageDetail == nil) {
        _leverageDetail = [[BTDetailLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.volumeDetail.frame) + SL_MARGIN, self.priceDetail.sl_y, self.priceDetail.sl_width, self.priceDetail.sl_height) andType:1];
        _leverageDetail.nameFont = [UIFont systemFontOfSize:14];
        _leverageDetail.font = [UIFont systemFontOfSize:16];
        [self.mainView addSubview:_leverageDetail];
    }
    return _leverageDetail;
}

- (UILabel *)leverLabel {
    if (_leverLabel == nil) {
        _leverLabel = [[UILabel alloc] init];
        _leverLabel.textAlignment = NSTextAlignmentCenter;
        _leverLabel.textColor = GARY_BG_TEXT_COLOR;
        _leverLabel.font = [UIFont systemFontOfSize:15];
        [self.mainView addSubview:_leverLabel];
    }
    return _leverLabel;
}

- (BTOrderViewInfoView *)entrustValue {
    if (_entrustValue == nil) {
        _entrustValue = [[BTOrderViewInfoView alloc] initWithFrame:CGRectZero];
        [self.mainView addSubview:_entrustValue];
    }
    return _entrustValue;
}

- (BTOrderViewInfoView *)costLabel {
    if (_costLabel == nil) {
        _costLabel = [[BTOrderViewInfoView alloc] initWithFrame:CGRectZero];
        [self.mainView addSubview:_costLabel];
       
    }
    return _costLabel;
}

- (BTOrderViewInfoView *)balanceLabel {
    if (_balanceLabel == nil) {
        _balanceLabel = [[BTOrderViewInfoView alloc] initWithFrame:CGRectZero];
        [self.mainView addSubview:_balanceLabel];
    }
    return _balanceLabel;
}

- (BTOrderViewInfoView *)holdSize {
    if (_holdSize == nil) {
        _holdSize = [[BTOrderViewInfoView alloc] initWithFrame:CGRectZero];
        [self.mainView addSubview:_holdSize];
    }
    return _holdSize;
}

- (BTOrderViewInfoView *)markPrice {
    if (_markPrice == nil) {
        _markPrice = [[BTOrderViewInfoView alloc] initWithFrame:CGRectZero];
        [self.mainView addSubview:_markPrice];
    }
    return _markPrice;
}

- (BTOrderViewInfoView *)closePrice {
    if (_closePrice == nil) {
        _closePrice = [[BTOrderViewInfoView alloc] initWithFrame:CGRectZero];
        [self.mainView addSubview:_closePrice];
    }
    return _closePrice;
}

- (BTOrderViewInfoView *)difference {
    if (_difference == nil) {
        _difference = [[BTOrderViewInfoView alloc] initWithFrame:CGRectZero];
        [self.mainView addSubview:_difference];
    }
    return _difference;
}

- (UIButton *)circleBtn {
    if (_circleBtn == nil) {
        _circleBtn = [[UIButton alloc] init];
        [_circleBtn setImage:[UIImage imageWithName:@"icon-choose2_nor"] forState:UIControlStateNormal];
        [_circleBtn setImage:[UIImage imageWithName:@"icon-choose2_sel"] forState:UIControlStateSelected];
        [_circleBtn addTarget:self action:@selector(didClickCirCleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_circleBtn];
    }
    return _circleBtn;
}

- (UILabel *)tipsLabel {
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = GARY_BG_TEXT_COLOR;
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        [self.mainView addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

- (BTMainButton *)supporDepositBtn {
    if (_supporDepositBtn == nil) {
        _supporDepositBtn = [BTMainButton bbAccountWithTitle:@"增加保证金" target:self action:@selector(didClickSupporDepositBtn:)];
        [self.mainView addSubview:_supporDepositBtn];
    }
    return _supporDepositBtn;
}

- (BTMainButton *)reduceDepositBtn {
    if (_reduceDepositBtn == nil) {
        _reduceDepositBtn = [BTMainButton bbAccountWithTitle:Launguage(@"str_transferim_position2contract") target:self action:@selector(didClickReduceDepositBtn:)];
        [self.mainView addSubview:_reduceDepositBtn];
    }
    return _reduceDepositBtn;
}

- (UITextView *)contentTextView {
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.editable = NO;
        _contentTextView.font = [UIFont systemFontOfSize:15];
        _contentTextView.textColor = GARY_BG_TEXT_COLOR;
        [self.mainView addSubview:_contentTextView];
    }
    return _contentTextView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = GARY_BG_TEXT_COLOR;
        [self.mainView addSubview:_lineView];
    }
    return _lineView;
}

- (BTSlider *)tradeSlider {
    if (_tradeSlider == nil) {
        _tradeSlider = [[BTSlider alloc] initWithFrame:CGRectMake(SL_getWidth(25), CGRectGetMaxY(self.volumeField.frame), SL_SCREEN_WIDTH - SL_getWidth(90), SL_getWidth(50))];
        _tradeSlider.titleArray = @[@"0%", @"25%", @"50%", @"75%", @"100%"];
        _tradeSlider.numberOfStep = _tradeSlider.titleArray.count;
        _tradeSlider.lineWidth = 4;
        _tradeSlider.lineColor = GARY_BG_TEXT_COLOR;
        _tradeSlider.titleOffset = 25;
        _tradeSlider.titleColor = GARY_BG_TEXT_COLOR;
        _tradeSlider.thumbColor = GARY_BG_TEXT_COLOR;
        _tradeSlider.stepColor = GARY_BG_TEXT_COLOR;
        _tradeSlider.value = .50;
        self.currentSliderValue = [NSString stringWithFormat:@"%.8f",_tradeSlider.value];
        _tradeSlider.selectedStepImage = [UIImage imageWithName:@"icon-circle-small"];
        _tradeSlider.stepWidth = 15;
        _tradeSlider.sliderOffset = -8;
        _tradeSlider.stepTouchRate = 2;
        _tradeSlider.thumbImage = [UIImage imageWithName:@"icon-circle-big"];
        _tradeSlider.thumbSize = CGSizeMake(23, 23);
        _tradeSlider.thumbTouchRate = 2;
        [_tradeSlider addTarget:self action:@selector(valueChangeAction:) forControlEvents:UIControlEventValueChanged];
        _tradeSlider.backgroundColor = MAIN_BTN_TITLE_COLOR;
        [self.mainView addSubview:_tradeSlider];
    }
    return _tradeSlider;
}

- (void)valueChangeAction:(BTSlider *)sender {
    self.currentSliderValue = [NSString stringWithFormat:@"%.8f",sender.value];
    [self chandeSliderValue:self.currentSliderValue];
}

- (void)chandeSliderValue:(NSString *)value {
    if (self.alertViewType == BTContractAlertViewContractCloseHold) {
        NSString *result = [[[self.position.cur_qty bigSub:self.position.freeze_qty] toSmallVolumeWithContractID:self.position.instrument_id] bigMul:value];
        self.volumeField.defineView.text = [result toString:0];
    }
}

#pragma mark - 对外接口

+ (void)showContractAlertViewWithData:(id)data andAlertType:(BTContractAlertViewType)alertViewType andSetDelegate:(id <BTContractAlertViewDelegate>) delegate {
    BTContractAlertView *alertView = [[BTContractAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([delegate respondsToSelector:@selector(contractAlertViewDidClickCancelWithType:)] || [delegate respondsToSelector:@selector(contractAlertViewDidClickComfirmWithType:info:)]) {
        alertView.delegate = delegate;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    alertView.alertViewType = alertViewType;
    [alertView loadDataWithData:data];
}

+ (void)hideContractAlertViewWithType:(BTContractAlertViewType)alertViewType {
    for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:self]) {
            BTContractAlertView *alertView = (BTContractAlertView *)subView;
            if (alertView.alertViewType == alertViewType) {
                [subView removeFromSuperview];
            }
            break;
        }
    }
}

@end
