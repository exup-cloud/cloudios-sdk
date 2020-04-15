//
//  BTMaskFutureTool.h
//  SLContractSDK
//
//  Created by WWLy on 2018/7/11.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTStoreData.h"
#import "SLContractSocketManager.h"
#import "BTDepthModel.h"
#import "BTContractTradeModel.h"

@class BTItemModel,BTContractRecordModel;
@interface BTMaskFutureTool : NSObject

@property (nonatomic, strong) NSArray <BTItemModel *> *futureArr;
@property (nonatomic, strong) NSArray *optionalArr;
@property (nonatomic, strong) NSArray *USDTArr;
@property (nonatomic, strong) NSArray *standardArr;
@property (nonatomic, strong) NSArray *imitateArr;
@property (nonatomic, strong) BTDepthModel *futureDepth;
@property (nonatomic, strong) NSArray *trades;

+ (instancetype)shareMaskFutureTool;

+ (NSString *)marketPriceWithContractID:(int64_t)instrument_id;


+ (void)loadContractTicker;
- (void)loadNetDataWithURL:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(NSArray <BTItemModel *>*))success failure:(void (^)(NSError *))failure;


+ (int64_t)getContractIDWithCode:(NSString *)coin_code;
+ (void)getMonthDataWithContractID:(int64_t)instrument_id success:(void (^)(BTItemModel *))success failure:(void (^)(NSError *))failure;
+ (void)replayItemModel:(BTItemModel *)itemModel;
+ (void)getIndexesInfoWithIndexId:(int64_t)index_id success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;

/// websocket Ticker数据处理
- (void)handNewWebSocketData:(NSDictionary *)response handleResult:(void (^)(BTItemModel *, BTSocketDataActionType))success;
/// websocket 深度数据处理
- (void)handNewWebSocketDepthData:(NSDictionary *)response handleResult:(void (^)(BTSocketDataActionType, int64_t))success;
/// websocket Trade数据处理
- (void)handNewWebSocketTradeData:(NSDictionary *)response handleResult:(void (^)(NSArray <BTContractTradeModel *>*, BTSocketDataActionType))success;

- (void)clearDepth;
@end
