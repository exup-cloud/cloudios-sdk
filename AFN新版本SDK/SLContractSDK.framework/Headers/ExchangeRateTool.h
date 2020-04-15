//
//  BTBaseViewController.m
//  GGEX_Appstore//
//  Created by WWLy on 2018/4/24.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsdRate : NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * rate;
@end

@interface BaseCoinPrice:NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * price_usd;
@property (nonatomic,copy) NSString * price_btc;
@end

@interface StockPrice:NSObject
@property (nonatomic,copy) NSString * lcoin;
@property (nonatomic,copy) NSString * rcoin;
@property (nonatomic,copy) NSString * price;
@end

@interface RateTreeNode:NSObject
@property (nonatomic,strong) StockPrice* value;
@property (nonatomic,strong) NSMutableArray * childs;
@end

@interface ExchangeRateTool : NSObject
@property (nonatomic,strong) NSArray*stockPrices;  // 币值对
@property (nonatomic,strong) NSArray*baseCoinPrices; // 基础币价格
@property (nonatomic,strong) UsdRate* usdRate; // USD转CNY或其他国家币的汇率
-(NSString*)conversionWtihFromCoin:(NSString*)fromCoin
                            toCoin:(NSString*)toCoin
                          passCoin:(NSString*)passCoin;
@end
