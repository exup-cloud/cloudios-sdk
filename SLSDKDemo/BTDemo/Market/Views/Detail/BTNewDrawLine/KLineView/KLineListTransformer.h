//
//  KLineListTransformer.h
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const kCandlerstickChartsContext;
extern NSString *const kCandlerstickChartsDate;
extern NSString *const kCandlerstickChartsMaxHigh;
extern NSString *const kCandlerstickChartsMinLow;
extern NSString *const kCandlerstickChartsMaxVol;
extern NSString *const kCandlerstickChartsMinVol;
extern NSString *const kCandlerstickChartsRSI;

/**
 *  extern key 可修改为Entity
 */
@interface KLineListTransformer : NSObject

+ (instancetype)sharedInstance;

- (id)managerTransformData:(NSArray*)data;

@end
