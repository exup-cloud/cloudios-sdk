//
//  SLContractMakeOrderView.h
//  BTTest
//
//  Created by wwly on 2019/9/3.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 开仓 / 平仓 下单视图
@class SLContractMakeOrderView;
@protocol SLContractMakeOrderViewDelegate <NSObject>

- (void)contractMakeOrdersViewDidClickWithLeverArr:(NSArray *)itemArr leverage:(NSString *)leverage handle:(void(^)(UITableViewCell *))result;

- (void)defineContractViewDidClickBuyOrSellWithContractOrderType:(BTContractOrderType)orderType order:(BTContractOrderModel *)order;

@end


@class BTItemModel;
@interface SLContractMakeOrderView : UIView

@property (nonatomic, strong) BTItemModel *itemModel;
@property (nonatomic, weak) id <SLContractMakeOrderViewDelegate> delegate;

@property (nonatomic, copy) NSString *buyOnePrice;
@property (nonatomic, copy) NSString *sellOnePrice;
@property (nonatomic, copy) NSString *selectedPrice;

@property (nonatomic, strong, readonly) BTContractOrderModel * currentOrderModel;
/// 开仓 平仓
@property (nonatomic, assign, readonly) BTContractOrderType currentOrderType;

/// 切换 开仓 平仓 状态
- (void)updateViewWithContractOrderType:(BTContractOrderType)orderType;

@end

NS_ASSUME_NONNULL_END
