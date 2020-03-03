//
//  BTFuturesBottomView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTFuturesBottomView : UIView

@property (nonatomic, strong) BTItemModel *itemModel;

/// 更新最新成交
/// @param trades socket 返回的最新成交数据
- (void)updateViewWithNewTradesArray:(NSArray <BTContractTradeModel *> *)trades;

/// 更新最新深度数据
- (void)updateViewWithNewBuysArray:(NSArray <BTContractOrderModel *> *)buys sellsArray:(NSArray <BTContractOrderModel *> *)sells;

@end
