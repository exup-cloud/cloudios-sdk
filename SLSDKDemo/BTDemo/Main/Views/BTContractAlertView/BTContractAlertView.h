//
//  BTContractAlertView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/17.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BTContractAlertViewType) {
    BTContractAlertViewMarketPriceClose1 = 1,       // 市价全平1
    BTContractAlertViewMarketPriceClose2,           // 市价全平2
    BTContractAlertViewMarketPriceClose3,           // 市价全平3
    BTContractAlertViewMarketPriceClose4,           // 市价全平4
    BTContractAlertViewPriceExplain,                // 价格解释
    BTContractAlertViewContractTerm,                // 合约名词
    BTContractAlertViewContractBreakHold,           // 爆仓明细
    BTContractAlertViewContractCloseHold,           // 确认平仓
    BTContractAlertViewContractSupplementDeposit,   // 调整保证金
    BTContractAlertViewContractFuturesOrder,        // 合约订单
    BTContractAlertViewSendCloseOrder,              // 提交平仓单
    BTContractAlertViewPriceExplain2,               // 价格解释2
    BTContractAlertViewContractReduceDetail,        // 减仓明细
    BTContractAlertViewContractOpenAccount,         // 开通账户
    BTContractAlertViewContractBonus,               // 赠金
    BTContractAlertViewContractFairPrice,           // 合理价格
    BTContractAlertViewContractLeverage,            // 全仓或者逐仓
    BTContractAlertViewContractPlanEntrust,         // 计划委托
    BTContractAlertViewContractFundRate,            // 资金费率
    BTContractAlertViewDepositTips,                 // 充值提醒弹框
    BTContractAlertViewPlanOrderTips,               // 计划委托失败原因
    BTContractAlertViewInsufficient,                // 余额不足
    BTContractAlertViewOTCBuyCoin,                  // 没有资产一键买币
};

@protocol BTContractAlertViewDelegate <NSObject>

@optional
- (void)contractAlertViewDidClickCancelWithType:(BTContractAlertViewType)type;
- (void)contractAlertViewDidClickComfirmWithType:(BTContractAlertViewType)type info:(NSDictionary *)info;
- (void)contractAlertViewDidClickMarketPriceCloseWithtype:(BTContractAlertViewType)type;
- (void)contractAlertViewDidClickAllBtnWithtype:(BTContractAlertViewType)type;
@end

@interface BTContractAlertView : UIView

@property (nonatomic, weak) id <BTContractAlertViewDelegate> delegate;

+ (void)showContractAlertViewWithData:(id)data andAlertType:(BTContractAlertViewType)alertViewType andSetDelegate:(id <BTContractAlertViewDelegate>) delegate;
+ (void)hideContractAlertViewWithType :(BTContractAlertViewType)alertViewType;

@end
