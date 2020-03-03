//
//  BTMineAccountTool.h
//  BTStore
//
//  Created by WWLy on 2018/1/31.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTMineAccountModel.h"
#import "BTWebSocketModel.h"

@interface BTMineAccountTool : NSObject

@property (nonatomic, strong) NSArray <BTItemCoinModel *>*contractAccountArr; // 合约账户资产
@property (nonatomic, assign) BOOL loadAssetSuccess;

+ (instancetype)shareMineAccountTool;

/// 判断该币种有没有开通账户
+ (BOOL)hasOpenContractAccountWithCoin:(NSString *)coinCode;

- (void)loadContractAccountPropertyInfoWithContractID:(NSString *)contractID success:(void (^)(NSArray <BTItemCoinModel *>*response))success failure:(void (^)(NSError *))failure;

/// 处理websocket资产信息
- (void)handNewWebSocketPropertyData:(NSDictionary *)data handleResult:(void (^)(NSArray <BTWebSocketModel *>*, BTSocketDataActionType))success;

/// 获取合约对应币种资产
+ (BTItemCoinModel *)getCoinAssetsWithCoinCode:(NSString *)coin_code;



@end
