//
//  BTDealBackCellModel.h
//  BTStore
//
//  Created by 健 王 on 2018/1/21.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTDealBackCellType) {
    BTDealBackCellHeaderType = 0,
    BTDealBackCellUpType,
    BTDealBackCellDownType
};

typedef NS_ENUM(NSInteger, BTTradeWay) {
    BTTradeWayUnkown = 0,
    BTTradeWayBuy,             // 买方主导
    BTTradeWaySell,                 // 卖方主导
};

@interface BTDealBackCellModel : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, assign) BTTradeWay type;

@property (nonatomic, assign) int64_t contract_id;

@property (nonatomic, assign) BTContractTradeWay recordWay;

@end
