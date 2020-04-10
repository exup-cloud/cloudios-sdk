//
//  BTDrawLineDataCatch.h
//  BTStore
//
//  Created by 健 王 on 2018/3/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BTItemModel;

typedef enum : NSUInteger {
    LINE_TYPE_UNKOWN = 0,
    LINE_TYPE_QUOTE = 1,
    LINE_TYPE_SPOT = 2,
    LINE_TYPE_FUTURES = 3,
} eLineType;

typedef enum : NSUInteger {
    FREQUENCY_TYPE_M = 0,
    FREQUENCY_TYPE_1K,
    FREQUENCY_TYPE_5M,
    FREQUENCY_TYPE_15K,
    FREQUENCY_TYPE_30M,
    FREQUENCY_TYPE_1H,
    FREQUENCY_TYPE_2H,
    FREQUENCY_TYPE_4H,
    FREQUENCY_TYPE_6H,
    FREQUENCY_TYPE_12H,
    FREQUENCY_TYPE_1D,
    FREQUENCY_TYPE_1W,
    FREQUENCY_TYPE_1MO,
} eFrequencyType;

@interface BTDrawLineDataCatch : NSObject
// 用来标识每条线的key
@property (nonatomic,readonly) NSString * key;

// frequency, 频率:1分钟,5分钟,30分钟,1小时,1天,1周
// coinName,币的名称
// 根据频率和币的名称,创建标识每条线的key
+(NSString*)makeKeyWithFrequency:(eFrequencyType)frequency
                        coinName:(NSString*)coinName contractID:(int64_t)instrument_id;

// type,线的类型:是现货还是行情还是期货
// frequency, 频率:1分钟,5分钟,30分钟,1小时,1天,1周
// coinName,币的名称
// 创建实例
-(instancetype)initWithType:(eLineType)type
                  frequency:(eFrequencyType)frequency
                   coinName:(NSString*)coinName
                 contractID:(int64_t)instrument_id;

- (instancetype)initWithType:(eLineType)type
                   frequency:(eFrequencyType)frequency
                    coinName:(NSString*)coinName
                  contractID:(int64_t)instrument_id
                    lineData:(NSMutableArray*)lineData;


- (NSMutableArray*)getLineData;

// 刷新数据
// 成功回调的参数说明:success(当前缓存的所有画线数据,是否有新数据,是否是首帧)
- (void)freshDataWithSuccess:(void (^)(BOOL isCotainNewData, BOOL isFirstData))success
                     failure:(void (^)(NSError *))failure;
-(void)resetFlushCount;
@end
