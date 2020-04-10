//
//  BTDrawLineManager.h
//  BTStore
//
//  Created by 健 王 on 2018/3/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDrawLineDataCatch.h"

typedef NS_ENUM(NSInteger, BTDrawLineViewType) {
    BTDrawLineViewThreeHourType = -1,
    BTDrawLineViewTimeType = 0,
    BTDrawLineViewOneMinType, // 新增一分钟线
    BTDrawLineViewFiveMinType,
    BTDrawLineViewOneFifteenMinType, // 新增十五分钟线
    BTDrawLineViewThirtyMinType,
    BTDrawLineViewOneHourType,
    BTDrawLineViewTwoHourType, // 新增两小时线
    BTDrawLineViewFourHourType, // 新增四小时线
    BTDrawLineViewSixHourType, // 新增六小时线
    BTDrawLineViewTwelveHourType, // 新增十二小时线
    BTDrawLineViewOneDayType,
    BTDrawLineViewOneWeekType,
    BTDrawLineViewOneMonthType,
};

@class BTLineDataModel;
@interface BTDrawLineManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong) NSMutableArray <BTLineDataModel *>*lineDataArr;

- (instancetype)initWithType:(NSInteger)type;

- (NSMutableArray*)queryLineDataWithCoin:(NSString *)coin type:(eFrequencyType)type contractID:(int64_t)instrument_id;

- (void)loadDataWithCoin:(NSString *)coin contractID:(int64_t)instrument_id type:(eLineType)type count:(NSInteger)count success:(void (^)(NSArray <BTItemModel *> *itemModelArray, BOOL isCotainNewData, BOOL isFirstData))success failure:(void (^)(NSError *))failure;

- (void)resetFlushCount:(NSString *)coin contractID:(int64_t)instrument_id;
@end
