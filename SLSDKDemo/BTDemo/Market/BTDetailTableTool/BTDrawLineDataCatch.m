//
//  BTDrawLineDataCatch.m
//  BTStore
//
//  Created by Jason_Lee on 2018/3/30.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTDrawLineDataCatch.h"

#define MINUTE_1         60 * 1
#define MINUTE_5         60 * 5
#define MINUTE_15        60 * 15
#define MINUTE_30        60 * 30
#define HOUR             60 * 60
#define SIX_HOUR         60 * 60 * 6
#define DAY_TIME         24 * 60 * 60
#define SIX_DAY          24 * 60 * 60 * 6
#define TWELVE_DAY       24 * 60 * 60 * 12

#define SPOT_MASK       @"stockCode"
#define QUOTES_MASK     @"coinCode"

@interface BTDrawLineDataCatch() {
    NSString * _key;
}
@property (nonatomic,assign) long frequency;
@property (nonatomic, assign) SLFrequencyType frequencyType;
@property (nonatomic,copy) NSString * coinName;
@property (nonatomic,copy) NSString * baseUrl;
@property (nonatomic,copy) NSNumber * startTime;
@property (nonatomic,copy) NSNumber * firstFrameStartTime;
@property (nonatomic,assign) BOOL isHaveLoadFirstFrame;
@property (nonatomic,assign) BOOL isHaveLoadFromStart;
@property (nonatomic,assign) int flushCount;
// 画线的数据
@property (nonatomic, strong) NSMutableArray *lineData;
@end

@implementation BTDrawLineDataCatch

+ (NSString *)makeKeyWithFrequencyType:(SLFrequencyType)frequencyType coinName:(NSString *)coinName contractID:(int64_t)contract_id {
    if (contract_id > 0) {
        return [NSString stringWithFormat:@"%lld_%lu", contract_id, (unsigned long)frequencyType];
    }
    return [NSString stringWithFormat:@"%@_%lu", coinName, (unsigned long)frequencyType];
}


- (instancetype)initWithFrequencyType:(SLFrequencyType)frequencyType coinName:(NSString *)coinName contractID:(int64_t)contract_id {
    if (self = [super init]) {
        self.lineData = [NSMutableArray array];
        self.frequency = frequencyType;
        self.coinName = coinName;
        switch (frequencyType) {
            case FREQUENCY_TYPE_M: {
                // 首屏,当前3小时
                // 当天
                NSNumber * currentDayZeroTime = [MyAppInfo getCurrentDayZeroTimestamp];
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                if ( currentTime.longLongValue - currentDayZeroTime.longLongValue > SIX_HOUR) {
                    _firstFrameStartTime = @(currentTime.longLongValue - SIX_HOUR);
                }else{
                    _firstFrameStartTime = currentDayZeroTime;
                }
                _startTime = currentDayZeroTime;
                _frequency =MINUTE_1;
                break;
            }
            case FREQUENCY_TYPE_1K: {
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 16*HOUR);
                _startTime = @(currentTime.longLongValue - 2*DAY_TIME);
                _frequency = MINUTE_1;
                break;
            }
            case FREQUENCY_TYPE_5M: {
                // 首屏,16小时
                // 2天
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 16*HOUR);
                _startTime = @(currentTime.longLongValue - 2*DAY_TIME);
                _frequency = MINUTE_5;
                break;
            }
            case FREQUENCY_TYPE_15K: {
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 24*HOUR);
                _startTime = @(currentTime.longLongValue - 4*DAY_TIME);
                _frequency = MINUTE_15;
                break;
            }
            case FREQUENCY_TYPE_30M: {
                // 首屏,48小时
                // 6天
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - DAY_TIME * 2);
                _startTime = @(currentTime.longLongValue - 6*DAY_TIME);
                _frequency = MINUTE_30;
                break;
            }
            case FREQUENCY_TYPE_1H: {
                // 首屏,96
                // 12天
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 4*DAY_TIME);
                _startTime = @(currentTime.longLongValue - TWELVE_DAY);
                _frequency = HOUR;
                break;
            }
            case FREQUENCY_TYPE_2H: {
                // 首屏,8天
                // 24天
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 8*DAY_TIME);
                _startTime = @(currentTime.longLongValue - TWELVE_DAY * 2);
                _frequency = HOUR * 2;
                break;
            }
            case FREQUENCY_TYPE_4H: {
                // 首屏,16天
                // 48天
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 16 * DAY_TIME);
                _startTime = @(currentTime.longLongValue - TWELVE_DAY * 4);
                _frequency = HOUR * 4;
                break;
            }
            case FREQUENCY_TYPE_6H: {
                // 首屏,20天
                // 60天
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 20 * DAY_TIME);
                _startTime = @(currentTime.longLongValue - TWELVE_DAY * 5);
                _frequency = HOUR * 6;
                break;
            }
            case FREQUENCY_TYPE_12H: {
                // 首屏,40天
                // 60天
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 40 * DAY_TIME);
                _startTime = @(currentTime.longLongValue - TWELVE_DAY * 10);
                _frequency = HOUR * 12;
                break;
            }
            case FREQUENCY_TYPE_1D: {
                // 首屏,1年
                // 全部
                NSNumber *currentTime = [MyAppInfo getCurrentTimestamp];
                _firstFrameStartTime = @(currentTime.longLongValue - 365*DAY_TIME);
                _startTime = @(88888);
                _frequency = DAY_TIME;
                break;
            }
            case FREQUENCY_TYPE_1W:
                // 首屏,全部
                // 全部
                _firstFrameStartTime = @(88888);
                _startTime = @(88888);
                _frequency = DAY_TIME*7;
                break;
            default:
                break;
        }
        _key = [BTDrawLineDataCatch makeKeyWithFrequencyType:frequencyType coinName:coinName contractID:contract_id];
        _baseUrl = [self buildBaseUrlWithFrequency:frequencyType coinName:coinName contractID:contract_id];
    }
    return self;
}

- (instancetype)initWithFrequencyType:(SLFrequencyType)frequencyType coinName:(NSString *)coinName contractID:(int64_t)contract_id lineData:(NSMutableArray *)lineData {
    BTDrawLineDataCatch *instance = [self initWithFrequencyType:frequencyType coinName:coinName contractID:contract_id];
    instance.lineData = lineData;
    return instance;
}


- (NSString *)buildBaseUrlWithFrequency:(SLFrequencyType)frequencyType
                               coinName:(NSString *)coinName
                             contractID:(int64_t)contract_id {
    NSString * hostUrl;
    switch (frequencyType) {
        case FREQUENCY_TYPE_M: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=1&resolution=M",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_1K: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=1&resolution=M",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_5M: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=5&resolution=M",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_15K: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=15&resolution=M",[BTBasePath sharedBasePath].contractQuote,contract_id];
        }
            break;
        case FREQUENCY_TYPE_30M: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=30&resolution=M",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_1H: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=1&resolution=H",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_2H: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=2&resolution=H",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_4H: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=4&resolution=H",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_6H: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=6&resolution=H",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_12H: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=12&resolution=H",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_1D: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=1&resolution=D",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        case FREQUENCY_TYPE_1W: {
            hostUrl = [NSString stringWithFormat:@"%@?contractID=%lld&unit=7&resolution=D",[BTBasePath sharedBasePath].contractQuote,contract_id];
            break;
        }
        default:
            return nil;
            break;
    }
    return hostUrl;
}


- (NSMutableArray *)getLineData{
    if ( nil == _lineData) {
        return nil;
    }
    if (_frequency == HOUR || _frequency == (DAY_TIME*7)) {
        return [self mergeData];
    } else {
        return [_lineData mutableCopy];
    }
}

- (NSString *)key{
    return _key;
}

- (NSMutableArray *)mergeData {
    NSMutableArray * lineData = [NSMutableArray arrayWithCapacity:_lineData.count/2];
    NSMutableArray * preArr = [NSMutableArray array];
    for (BTItemModel * item in _lineData) {
        if ( preArr.count > 0) {
            if( [self isSameTime:preArr.firstObject m2:item] ){
                [preArr addObject:item];
            }else{
                BTItemModel * newItem = [self createNewItem:preArr];
                [lineData addObject:newItem];
                [preArr removeAllObjects];
                [preArr addObject: item];
            }
        }
        else {
            [preArr addObject:item];
        }
    }
    return lineData;
}

- (BTItemModel *)createNewItem:(NSArray *)arr{
    if ( arr.count < 1) {
        return nil;
    } else if (arr.count <2){
        return arr.firstObject;
    }
    BTItemModel * newItem;
    NSString * totalCount = @"0";
    for(BTItemModel * item in arr){
        if (nil != newItem){
            if ([item.qty24 isLessThanOrEqualZero]){
                continue;
            }
            if( [newItem.low GreaterThan:item.low] ){
                newItem.low = item.low;
            }
            if([ newItem.high LessThan:item.high]) {
                newItem.high = item.high;
            }
            newItem.close = item.close;
            newItem.last_px = item.last_px;
            newItem.qty24 = [newItem.qty24 bigAdd:item.qty24];
            
            NSString * count = [item.avg_px bigMul:item.qty24];
            totalCount = [totalCount bigAdd:count];
        }else{
            newItem = [BTItemModel itemModelWithModel:item];
        }
    }
    if (![newItem.qty24 isLessThanOrEqualZero] &&
       ![totalCount isLessThanOrEqualZero]) {
        newItem.avg_px = [totalCount bigDiv:newItem.qty24];
    }
    newItem.change_rate = [newItem.close bigSub:newItem.open];
    if ((![newItem.change_rate isZero])  && (![newItem.open isLessThanOrEqualZero])) {
        newItem.change_rate = [newItem.change_rate bigDiv:newItem.open];
    }
    newItem.timestamp = ((BTItemModel *)(arr.firstObject)).timestamp;
    return newItem;
}

- (BOOL)isSameTime:(BTItemModel *)m1 m2:(BTItemModel *)m2 {
    long long t1 = m1.timestamp.longLongValue - (m1.timestamp.longLongValue % (_frequency));
    long long t2 = m2.timestamp.longLongValue - (m2.timestamp.longLongValue % (_frequency));
    if (t1 == t2) {
        return YES;
    }
    return NO;
}

- (void)freshDataWithSuccess:(void (^)(BOOL isCotainNewData, BOOL isFirstData))success
                     failure:(void (^)(NSError *))failure {
    if (![self isCatchedFirstFram]) {
        [self loadFirstFrameWithSuccess:success failure:failure];
    } else if(![self isCatchedAtStartTime]){
        [self loadFromStartWithSuccess:success failure:failure];
    } else {
        [self loadToNowWithSuccess:success failure:failure];
    }
}

- (BOOL)isCatchedFirstFram {
    if ( nil == self.lineData || self.lineData.count < 1) {
        return NO;
    }
    if (_isHaveLoadFirstFrame) {
        return YES;
    }
    BTItemModel * startPointer = self.lineData[0];
    NSNumber * lineStartTime = startPointer.timestamp;
    if (self.firstFrameStartTime.longLongValue - lineStartTime.longLongValue >= 0 ){
        _isHaveLoadFirstFrame = YES;
        return YES;
    }else if(abs((int)(self.firstFrameStartTime.longLongValue - lineStartTime.longLongValue))<self.frequency){
        _isHaveLoadFirstFrame = YES;
        return YES;
    }
    return NO;
}

- (BOOL)isCatchedAtStartTime {
    if (nil == self.lineData || self.lineData.count < 1){
        return NO;
    }
    if (_isHaveLoadFromStart) {
        return YES;
    }
    BTItemModel * startPointer = self.lineData[0];
    NSNumber * lineStartTime = startPointer.timestamp;
    if ( abs(lineStartTime.intValue - self.startTime.intValue) <= self.frequency ) {
        _isHaveLoadFromStart = YES;
        return YES;
    }
    return NO;
}

- (void)loadFirstFrameWithSuccess:(void (^)(BOOL,BOOL))success failure:(void (^)(NSError *))failure {
    NSNumber * startTime = self.firstFrameStartTime;
    NSNumber * endTime = [MyAppInfo getCurrentTimestamp];
    if ( self.lineData.count > 0) {
        BTItemModel * startPointer = self.lineData[0];
        endTime = @(startPointer.timestamp.longLongValue-1);
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@&startTime=%@&endTime=%@",
                         self.baseUrl,
                         startTime,
                         endTime];
    __weak BTDrawLineDataCatch * weakSelf= self;
    [self loadDataWithUrl:urlStr success:^(NSArray * news) {
        if ( nil == weakSelf) {
            return;
        }
        weakSelf.isHaveLoadFirstFrame = YES;
        BOOL isChanged = [weakSelf appendNewLineData:news];
        if (success) {
            success(isChanged,YES);
        }
    } failure:^(NSError *err) {
        if ( failure) {
            failure(err);
        }
    }];
}

- (void)loadFromStartWithSuccess:(void (^)(BOOL,BOOL))success failure:(void (^)(NSError *))failure {
    NSNumber * startTime = self.startTime;
    BTItemModel * startPointer = self.lineData[0];
    NSNumber * endTime = @(startPointer.timestamp.longLongValue -1);
    NSString * urlStr = [NSString stringWithFormat:@"%@&startTime=%@&endTime=%@",
                         self.baseUrl,
                         startTime,
                         endTime];
    __weak BTDrawLineDataCatch * weakSelf= self;
    [self loadDataWithUrl:urlStr success:^(NSArray * news) {
        if ( nil == weakSelf) {
            return;
        }
        weakSelf.isHaveLoadFromStart = YES;
        BOOL isChanged = [weakSelf appendNewLineData:news];
        if ( success) {
            success(isChanged,NO);
        }
    } failure:^(NSError *err) {
        if ( failure) {
            failure(err);
        }
    }];
}

- (void)loadToNowWithSuccess:(void (^)(BOOL,BOOL))success failure:(void (^)(NSError *))failure {
    BTItemModel * endPointer = [self.lineData lastObject];
    NSNumber * startTime = @(endPointer.timestamp.longLongValue + 1);
    NSNumber * endTime = [MyAppInfo getCurrentTimestamp];

    NSString * urlStr = [NSString stringWithFormat:@"%@&startTime=%@&endTime=%@",
                         self.baseUrl,
                         startTime,
                         endTime];
    __weak BTDrawLineDataCatch * weakSelf= self;
    [self loadDataWithUrl:urlStr success:^(NSArray * news) {
        if ( nil == weakSelf) {
            return;
        }
        BOOL isChanged = [weakSelf appendNewLineData:news];
        if ( success) {
            success(isChanged,NO);
        }
    } failure:^(NSError *err) {
        if ( failure) {
            failure(err);
        }
    }];
}

- (void)loadDataWithUrl:(NSString*)url success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
//    [BTSecureHttp AuthGET:url parameters:nil success:^(id responseHeader, id responseObject) {
//        NSString* err = responseObject[@"errno"];
//        if ( [err isKindOfClass:[NSString class]] && [err isEqualToString: @"NOT_FOUND"]) {
//            if (success) {
//                success(nil);
//            }
//            return;
//        }
//        id data = responseObject[@"data"];
//        if (data != nil) {
//            if (![data isKindOfClass:[NSArray class]]){
//                if (failure) {
//                    failure(nil);
//                }
//                return;
//            }
//            NSMutableArray *arr = [NSMutableArray array];
//            for (NSDictionary *dict in data) {
//                BTItemModel *item = [[BTItemModel alloc] initWithDict:dict];
//                [arr addObject:item];
//            }
//            if (success) {
//                success(arr);
//            }
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
}

- (BOOL)appendNewLineData:(NSArray *)news {
    _flushCount++;
    if (nil == news) {
        if (_flushCount > 1) {
            return NO;
        }else if(_lineData.count > 0){
            return YES;
        }
    }
    if (_lineData.count < 1) {
        [_lineData addObjectsFromArray:news];
        return YES;
    }else{
        BTItemModel * newFirstOne = [news firstObject];
        BTItemModel * lineLastOne = [_lineData lastObject];
        if ( newFirstOne.timestamp.longLongValue > lineLastOne.timestamp.longLongValue) {
            [_lineData addObjectsFromArray:news];
            return YES;
        }
        BTItemModel * newLastOne = [news lastObject];
        BTItemModel * lineFistOne = [_lineData firstObject];
        if ( newLastOne.timestamp.longLongValue < lineFistOne.timestamp.longLongValue) {
            NSMutableArray * arr =[NSMutableArray arrayWithCapacity: _lineData.count + news.count];
            [arr addObjectsFromArray:news];
            [arr addObjectsFromArray:_lineData];
            _lineData = arr;
            return YES;
        }
        BOOL isChanged = NO;
        //////////////////////
        NSMutableArray * mnews = [news mutableCopy];
        for(NSUInteger i = 0; i < news.count;++i){
            BTItemModel * newItem =(BTItemModel *)news[i];
            for (NSInteger j = _lineData.count - 1; j >= 0; j--) {
                BTItemModel * oldItem =(BTItemModel *)_lineData[j];
                if (newItem.timestamp.longLongValue>oldItem.timestamp.longLongValue) {
                    break;
                }
                if (newItem.timestamp.longLongValue == oldItem.timestamp.longLongValue) {
                    if (![newItem isEqual:oldItem]) {
                        _lineData[j] = newItem;
                        [mnews removeObject:newItem];
                        isChanged = YES;
                    }
                    break;
                }
            }
        }
        for(NSUInteger i = 0; i < mnews.count;++i){
            BTItemModel * item = mnews[i];
            if ( item.timestamp.longLongValue > lineLastOne.timestamp.longLongValue) {
                NSArray * subNews =[mnews subarrayWithRange:NSMakeRange(i, mnews.count - i)];
                [_lineData addObjectsFromArray:subNews];
                return YES;
            }
        }
        for(NSInteger i = mnews.count - 1; i >= 0;--i){
            BTItemModel * item = mnews[i];
            if ( item.timestamp.longLongValue < lineFistOne.timestamp.longLongValue) {
                NSArray * subNews =[mnews subarrayWithRange:NSMakeRange(0, i+1)];
                NSMutableArray * arr =[NSMutableArray arrayWithCapacity: _lineData.count + subNews.count];
                [arr addObjectsFromArray:subNews];
                [arr addObjectsFromArray:_lineData];
                _lineData = arr;
                return YES;
            }
        }
        if ( !isChanged) {
            if (_flushCount <= 1) {
                return YES;
            }
        }
        return isChanged;
    }
}

- (void)resetFlushCount {
    _flushCount = 0;
}

@end
