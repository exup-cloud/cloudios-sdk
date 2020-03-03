//
//  BTDrawLineManager.m
//  BTStore
//
//  Created by 健 王 on 2018/3/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTDrawLineManager.h"
#import "BTDrawLineDataCatch.h"


@interface BTDrawLineManager ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, BTDrawLineDataCatch *> *dataDict;

@end

@implementation BTDrawLineManager

static BTDrawLineManager *manager = nil;
+ (instancetype)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[BTDrawLineManager alloc] init];
    });
    return manager;
}

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)loadDataWithCoin:(NSString *)coin
              contractID:(int64_t)contract_id
                dataType:(SLStockLineDataType)dataType
                 success:(void (^)(NSArray<BTItemModel *> *itemModelArray, BOOL isCotainNewData, BOOL isFirstData))success
                 failure:(void (^)(NSError *))failure {
    BTDrawLineDataCatch *dataCatch;
    NSString *tempKey;
    if (dataType == SLStockLineDataTypeTimely) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_M coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_M coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeFiveMinutes) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_5M coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            NSString *minKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_5M coinName:coin contractID:contract_id];
            BTDrawLineDataCatch *minCatch = self.dataDict[minKey];// 获得此类一分钟的catch
            if (minCatch) {
                NSMutableArray *minDataArr = [minCatch getLineData];
                dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_5M coinName:coin contractID:contract_id lineData:minDataArr];
            } else {
                dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_5M coinName:coin contractID:contract_id];
            }
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeThirtyMinutes) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_30M coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_30M coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeOneHour) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_1H coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            NSString *thrityKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_30M coinName:coin contractID:contract_id];
            BTDrawLineDataCatch *thrityCatch = self.dataDict[thrityKey];// 获得此类30分钟的catch
            if (thrityCatch) {
                NSMutableArray *thrityDataArr = [thrityCatch getLineData];
                dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_1H coinName:coin contractID:contract_id lineData:thrityDataArr];
            } else {
                dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_1H coinName:coin contractID:contract_id];
            }
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
        
    } else if (dataType == SLStockLineDataTypeOneDay) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_1D coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_1D coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeOneWeek) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_1W coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_1W coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeOneMinute) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_1K coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_1K coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeFifteenMinutes) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_15K coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_15K coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeTwoHours) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_2H coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_2H coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeFourHours) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_4H coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_4H coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeSixHours) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_6H coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_6H coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    } else if (dataType == SLStockLineDataTypeTwelveHours) {
        tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:FREQUENCY_TYPE_12H coinName:coin contractID:contract_id];
        if ([[self.dataDict allKeys] containsObject:tempKey]) {
            dataCatch = self.dataDict[tempKey];
        } else {
            dataCatch = [[BTDrawLineDataCatch alloc] initWithFrequencyType:FREQUENCY_TYPE_12H coinName:coin contractID:contract_id];
            [self.dataDict setObject:dataCatch forKey:tempKey];
        }
    }
    [dataCatch freshDataWithSuccess:^(BOOL isCotainNewData, BOOL isFirstData) {
        if (success) {
            if (isCotainNewData) {
                success([dataCatch getLineData], isCotainNewData, isFirstData);
            } else {
                success(nil, isCotainNewData, isFirstData);
            }
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (NSMutableDictionary *)dataDict {
    if (_dataDict == nil) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

- (void)resetFlushCount:(NSString *)coin contractID:(int64_t)contract_id {
    for(NSUInteger type = FREQUENCY_TYPE_M;type <= FREQUENCY_TYPE_1W;++type){
        NSString *tempKey = [BTDrawLineDataCatch makeKeyWithFrequencyType:type coinName:coin contractID:contract_id];
        BTDrawLineDataCatch* dataCatch = [self.dataDict objectForKey:tempKey];
        if ( nil != dataCatch ) {
            [dataCatch resetFlushCount];
        }
    }
    
}

@end
