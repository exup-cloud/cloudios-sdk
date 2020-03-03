//
//  BTBasePath.h
//  SLContractSDK
//
//  Created by WWLy on 2018/4/24.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBasePath : NSObject
@property (nonatomic, copy) NSString *mainUrl;
@property (nonatomic, copy) NSString *submitOrder; // 提交订单
@property (nonatomic, copy) NSString *cancelOrder; // 取消订单
@property (nonatomic, copy) NSString *getOrders;
@property (nonatomic, copy) NSString *queryOrder;
@property (nonatomic, copy) NSString *getOrderTrades;
@property (nonatomic, copy) NSString *getUserTrades;
@property (nonatomic, copy) NSString *getStockTrades;
@property (nonatomic, copy) NSString *address; // 绑定充值地址
@property (nonatomic, copy) NSString *rechargeAmount; // 充值通知
@property (nonatomic, copy) NSString *withdraw; // 充值
@property (nonatomic, copy) NSString *usersMe; // 获取用户资产信息
@property (nonatomic, copy) NSString *settlesWithdraw; // 用户提现记录
@property (nonatomic, copy) NSString *settlesDeposit; // 用户充值记录
@property (nonatomic, copy) NSString *rewards; // 用户奖励记录
@property (nonatomic, copy) NSString *settles; // 所有记录
@property (nonatomic, copy) NSString *userConfigs;
@property (nonatomic, copy) NSString *spotGlobal;
@property (nonatomic, copy) NSString *queryDepth;
@property (nonatomic, copy) NSString *spotTickers;
@property (nonatomic, copy) NSString *spotTickerOne;
@property (nonatomic, copy) NSString *spot;
@property (nonatomic, copy) NSString *spot2;
@property (nonatomic, copy) NSString *spothour;
@property (nonatomic, copy) NSString *spotdaily;
@property (nonatomic, copy) NSString *cancelOrders;
@property (nonatomic, copy) NSString *spotDetail;
@property (nonatomic, copy) NSString *tickers;
@property (nonatomic, copy) NSString *registers;
@property (nonatomic, copy) NSString *active;
@property (nonatomic, copy) NSString *bindEmail;
@property (nonatomic, copy) NSString *bindPhone;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *resetPassword;
@property (nonatomic, copy) NSString *users;
@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *actionVerify;
@property (nonatomic, copy) NSString *actionBind;
@property (nonatomic, copy) NSString *checkUpdate;
@property (nonatomic, copy) NSString *assetPassword; // 设置资金密码
@property (nonatomic, copy) NSString *resetAssetPassword; // 重置资金密码
@property (nonatomic, copy) NSString *assetPasswordEffectiveTime; // 设置资金密码时长
@property (nonatomic, copy) NSString *coinBrief; // 货币简介
@property (nonatomic, copy) NSString *coinPrice; // 币种对应USD或者BTC等币的汇率
// karl 6.21
@property (nonatomic, copy) NSString *withdrawAddresses;
// 7.5
@property (nonatomic, copy) NSString *GAKey;
@property (nonatomic, copy) NSString *futures; // 获取合约列表
@property (nonatomic, copy) NSString *userPositions; // 获取用户仓位
@property (nonatomic, copy) NSString *userContractOrders; // 获取用户订单记录
@property (nonatomic, copy) NSString *contracts;    // 获取仓位信息
@property (nonatomic, copy) NSString *submitContractOrder; // 提交合约订单
@property (nonatomic, copy) NSString *submitPlanOrder;  // 提交计划委托
@property (nonatomic, copy) NSString *contractAccounts;
@property (nonatomic, copy) NSString *contractDepth;
@property (nonatomic, copy) NSString *cancelContractOrders; // 取消合约订单
@property (nonatomic, copy) NSString *cancelPlanOrders;     // 取消计划委托单
@property (nonatomic, copy) NSString *contractTrades; // 获取合约的交易记录
@property (nonatomic, copy) NSString *userPlanOrders; // 获取计划委托记录
@property (nonatomic, copy) NSString *contractUserTrades;// 获取用户的某个合约的所有交易记录
@property (nonatomic, copy) NSString *contractQuote; // 获取K线数据

@property (nonatomic, copy) NSString *transferFunds; // 资金划转
@property (nonatomic, copy) NSString *cashBooks;     // 资金流水
@property (nonatomic, copy) NSString *fundingrate;   // 资金费率

@property (nonatomic, copy) NSString *marginOper;   // 调整保证金
@property (nonatomic, copy) NSString *liqRecords;  // 爆仓记录
@property (nonatomic, copy) NSString *createContractAccount; // 创建合约账户
@property (nonatomic, copy) NSString *openAccountRewardCheck; //检查合约账户开通奖励是否被领取
@property (nonatomic, copy) NSString *openAccountRewardReceive; //  领取合约账户开通奖励
@property (nonatomic, copy) NSString *depositRewardCheck;// 检查合约充值奖励是否被领取
@property (nonatomic, copy) NSString *depositRewardReceive;//领取合约充值奖励

@property (nonatomic, copy) NSString *rebates; // 获得邀请人数
@property (nonatomic, copy) NSString *referPrice; // 获取场外交易
@property (nonatomic, copy) NSString *getKYCInfo;
@property (nonatomic, copy) NSString *KYCAuth; // 更新/提交KYC认证信息
@property (nonatomic, copy) NSString *otcAccount; //otc账户
@property (nonatomic, copy) NSString *otcSubmit; // 提交OTC订单
@property (nonatomic, copy) NSString *otcOrders; // 获取OTC订单列表
@property (nonatomic, copy) NSString *otcOrderDetail; // 获取OTC订单详情
@property (nonatomic, copy) NSString *otcOrderCancel; // 取消otc订单
@property (nonatomic, copy) NSString *uploadImage; // 上传图片
@property (nonatomic, copy) NSString *areas; // 世界地区
@property (nonatomic, copy) NSString *otcOrderPayment; // 声明付款
@property (nonatomic, copy) NSString *otcOrderReceipt; // 确认收款
@property (nonatomic, copy) NSString *riskReserves; // 保险基金
@property (nonatomic, copy) NSString *contractIndexes; //合约指数
@property (nonatomic, copy) NSString *captchCheck; // 检查是否需要图片验证码
@property (nonatomic, copy) NSString *stocks; // 替换原来global中 stocks
@property (nonatomic, copy) NSString *accountName; // 设置昵称接口
@property (nonatomic, copy) NSString *banners; // bannerurl
@property (nonatomic, copy) NSString *positionTax; // 仓位资金费用

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)basePathWithDict:(NSDictionary *)dict;

+ (instancetype)sharedBasePath;

+ (void)setSharedBasePath:(BTBasePath *)basePath;

@end
