//
//  SLTradePriceTableView.h
//  BTTest
//
//  Created by wwly on 2019/8/28.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLTradePriceTableViewDelegate <NSObject>

- (void)tableView_didSelectCellWithModel:(BTContractOrderModel *)orderModel;

@end

@interface SLTradePriceTableView : UITableView

/// 买 / 卖
@property (nonatomic, assign) BTOrderWay orderWay;

@property (nonatomic, weak) id <SLTradePriceTableViewDelegate> cus_delegate;


#pragma mark - 视图更新

- (void)updateViewWithModelArray:(NSArray <BTContractOrderModel *> *)dataArray decimalType:(BTDepthPriceDecimalType)decimalType;

@end

NS_ASSUME_NONNULL_END
