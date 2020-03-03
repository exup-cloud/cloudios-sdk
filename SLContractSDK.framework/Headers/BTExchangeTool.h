//
//  BTExchangeTool.h
//  GGEX_Appstore//
//  Created by WWLy on 2018/5/28.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTItemModel.h"

@class BaseCoinPrice;
@interface BTExchangeTool : NSObject

// 配置币值对价格
- (void)configStockCodePrice:(NSArray <BTItemModel *>*)stocks;
// 配置基础比价格
- (void)configBaseCoinPrices:(NSArray <BaseCoinPrice *>*)baseCoins;

+ (instancetype)shareExchangeTool;
// 转换资产
- (NSString *)assetsConversionWtihFromCoin:(NSString*)fromCoin
                                    toCoin:(NSString*)toCoin
                                  passCoin:(NSString*)passCoin;
@end
