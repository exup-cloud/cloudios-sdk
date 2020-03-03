//
//  BTDrawLineManager.h
//  BTStore
//
//  Created by 健 王 on 2018/3/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDrawLineDataCatch.h"

@interface BTDrawLineManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong) NSMutableArray *lineDataArr;

- (instancetype)initWithType:(NSInteger)type;

- (void)loadDataWithCoin:(NSString *)coin
              contractID:(int64_t)contract_id
                dataType:(SLStockLineDataType)dataType
                 success:(void (^)(NSArray <BTItemModel *> *itemModelArray, BOOL isCotainNewData, BOOL isFirstData))success
                 failure:(void (^)(NSError *))failure;

- (void)resetFlushCount:(NSString *)coin contractID:(int64_t)contract_id;

@end
