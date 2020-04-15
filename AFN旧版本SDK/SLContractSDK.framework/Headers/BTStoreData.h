//
//  BTStoreData.h
//  BTStore
//
//  Created by WWLy on 2018/1/30.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPrivateConfig.h"

#define KEY_BASEPATH_URL                    [SLPrivateConfig sharedConfig].base_host

#define KEY_VER                             [NSString stringWithFormat:@"%@-Ver",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_DEV                             [NSString stringWithFormat:@"%@-Dev",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_ASSETP                          [NSString stringWithFormat:@"%@-AssetPassword",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_USER_TOKEN                      [NSString stringWithFormat:@"%@-Token",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_USER_SS_ID                      [NSString stringWithFormat:@"%@-Ssid",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_USER_U_ID                       [NSString stringWithFormat:@"%@-Uid",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_Accesskey                       [NSString stringWithFormat:@"%@-Accesskey",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_ExpiredTs                       [NSString stringWithFormat:@"%@-ExpiredTs",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_USER_TS                         [NSString stringWithFormat:@"%@-Ts",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_USER_SIGN                       [NSString stringWithFormat:@"%@-Sign",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_DEVICE_UDID                     [NSString stringWithFormat:@"%@-udid",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_DEVICE_IDFA                     [NSString stringWithFormat:@"%@-idfa",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_DEVICE_IDFV                     [NSString stringWithFormat:@"%@-idfv",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_DEVICE_MODEL                    [NSString stringWithFormat:@"%@-model",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_CONNECTION_TYPE                 [NSString stringWithFormat:@"%@-Connection-Type",[SLPrivateConfig sharedConfig].host_Header]
#define KEY_ACCEPT_LANGUAGE                 [NSString stringWithFormat:@"%@-Language",[SLPrivateConfig sharedConfig].host_Header]

#define BTIndexKey                          @"BTCurrentSpotIndex"

#define BTContractIDKey                     @"BTContractIDKey"

#define BTCollectSpotCoins                  @"BTCollectSpotCoins"
#define BTCollectFuturesCoins               @"BTCollectFuturesCoins"

#define BTFuturesContractID                 @"BTFuturesContractID"

#define BTUserAccounts                      @"BTUserAccounts"
#define BTCurrentPropertyCoin               @"BTCurrentPropertyCoin"
#define BTCurrentPropertyContractCoin               @"BTCurrentPropertyContractCoin"

#define BTDepositCoin                       @"BTDepositCoin"
#define BTWithdrawlCoin                     @"BTWithdrawlCoin"

#define BT_isFirst_load                     @"isFirstLoadApp"

#define BT_sendDepositBegin                 @"BT_sendDepositBegin"
#define BT_senderDepositNote                @"BT_senderDepositNote"

#define BT_LEVERAGE                         @"BT_LEVERAGE" // 杠杆倍数
#define BT_LEVERAGE_NUM                     @"BT_LEVERAGE_NUM" // 杠杆倍数

#define BT_UNIT_VOL                         @"BT_UNIT_VOL" // 合约单位
#define ST_UNREA_CARCUL                     @"ST_UNREA_CARCUL" // 未实现盈亏计算依据 0、合理价格   1、最新价格
#define ST_DATE_CYCLE                       @"ST_DATE_CYCLE"   // 计算委托时间周期
#define ST_TIGGER_PRICE                     @"ST_TIGGER_PRICE" // 触发价格依据 0、最新价 1、合理价 2、指数价

#define BT_TRANSFER_KEY                     @"BT_TRANSFER_KEY"
#define BT_SHOW_ZENGJIN                     @"BT_SHOW_ZENGJIN"// 弹出赠金框
#define BT_SHOW_LEADVIEW                    @"showLeadView"
#define BT_SHOW_CONTRACT_LEAD               @"BT_SHOW_CONTRACT_LEAD"
#define BT_HIDE_SMALL                       @"BT_HIDE_SMALL" // 隐藏较小金额
#define BT_CONTRACT_INS                     @"BT_CONTRACT_INS" // 合约账户余额不足
#define BT_LEADERTO_OTC                     @"BT_LEADERTO_OTC" // 引导去OTC

@interface BTStoreData : NSObject

+ (id)storeObjectForKey:(NSString *)key;
+ (void)setStoreObjectAndKey:(id)object Key:(NSString *)key;

+ (id)storePersonalObjectForKey:(NSString *)key;
+ (void)setPersonalObjectAndKey:(id)object Key:(NSString *)key;
+ (void)clearObjectForKey:(NSString *)key;
+ (void)clearAllObject;

+ (BOOL)storeBoolForKey:(NSString *)key;
+ (void)setStoreBoolAndKey:(BOOL)value Key:(NSString *)key;

@end
