//
//  BTDrawLineDataCatch.h
//  BTStore
//
//  Created by Jason_Lee on 2018/3/30.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTItemModel;

typedef enum : NSUInteger {
    FREQUENCY_TYPE_M = 0,
    FREQUENCY_TYPE_5M,
    FREQUENCY_TYPE_30M,
    FREQUENCY_TYPE_1H,
    FREQUENCY_TYPE_1D,
    FREQUENCY_TYPE_1W,
    FREQUENCY_TYPE_1K,
    FREQUENCY_TYPE_15K,
    FREQUENCY_TYPE_2H,
    FREQUENCY_TYPE_4H,
    FREQUENCY_TYPE_6H,
    FREQUENCY_TYPE_12H,
} SLFrequencyType;

@interface BTDrawLineDataCatch : NSObject

/// 用来标识每条线的key
@property (nonatomic,readonly) NSString * key;

/**
 根据频率和币的名称,创建标识每条线的key

 @param frequencyType k 线数据类型 分时/1 分/5 分 ...
 @param coinName 币种名称
 @param contract_id 币种 ID
 @return 标识每条线的 key
 */
+ (NSString *)makeKeyWithFrequencyType:(SLFrequencyType)frequencyType
                              coinName:(NSString *)coinName
                            contractID:(int64_t)contract_id;

/**
 初始化

 @param frequencyType k 线数据类型 分时/1 分/5 分 ...
 @param coinName 币种名称
 @param contract_id 币种 ID
 */
- (instancetype)initWithFrequencyType:(SLFrequencyType)frequencyType
                             coinName:(NSString *)coinName
                           contractID:(int64_t)contract_id;

/**
 初始化

 @param frequencyType k 线数据类型 分时/1 分/5 分 ...
 @param coinName 币种名称
 @param contract_id 币种 ID
 @param lineData k 线数据
 */
- (instancetype)initWithFrequencyType:(SLFrequencyType)frequencyType
                             coinName:(NSString *)coinName
                           contractID:(int64_t)contract_id
                             lineData:(NSMutableArray *)lineData;


- (NSMutableArray *)getLineData;

/**
 刷新数据

 @param success 当前缓存的所有画线数据, 是否有新数据,是否是首帧
 */
- (void)freshDataWithSuccess:(void (^)(BOOL isCotainNewData, BOOL isFirstData))success
                     failure:(void (^)(NSError *))failure;

- (void)resetFlushCount;

@end
