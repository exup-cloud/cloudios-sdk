//
//  BTDepthModel.h
//  BTStore
//
//  Created by WWLy on 2018/2/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTContractOrderModel;
@interface BTDepthModel : NSObject
@property (nonatomic, strong) NSArray <BTContractOrderModel *>*sells;
@property (nonatomic, strong) NSArray <BTContractOrderModel *>*buys;

@property (nonatomic, strong) BTContractOrderModel *buyOneOrder;
@property (nonatomic, strong) BTContractOrderModel *sellOneOrder;

@end
