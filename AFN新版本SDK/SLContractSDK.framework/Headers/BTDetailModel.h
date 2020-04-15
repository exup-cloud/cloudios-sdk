//
//  BTDetailModel.h
//  BTStore
//
//  Created by WWLy on 2018/1/9.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BTItemModel;

@interface BTDetailMarketsModel : NSObject
@property (nonatomic, copy) NSString *market_name;
@property (nonatomic, strong) BTItemModel *ticker;

+ (NSArray*)decodeWithArray:(NSArray*)arr;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface BTDetailModel : NSObject
@property (nonatomic, strong) BTItemModel* realtime_ticker;
@property (nonatomic, strong) NSArray <BTDetailMarketsModel *>*markets;

+(BTDetailModel*)decodeModelWithDict:(NSDictionary*)dict;
@end
