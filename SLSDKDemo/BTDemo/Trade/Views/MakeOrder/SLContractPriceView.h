//
//  SLContractPriceView.h
//  BTTest
//
//  Created by wwly on 2019/8/28.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLContractPriceViewDelegate <NSObject>

- (void)priceView_updateBuyPrice:(NSString *)buyPrice sellPrice:(NSString *)sellPrice;

- (void)priceView_didSelectPrice:(NSString *)price;

@end

/// 合约挂单(深度)列表
@interface SLContractPriceView : UIView

@property (nonatomic, weak) id <SLContractPriceViewDelegate> delegate;

/// 更新整个列表数据
- (void)updateViewWithDepthModel:(BTDepthModel *)depthModel itemModel:(BTItemModel *)itemModel;

/// 更新部分数据
- (void)updateViewWithBuysArray:(NSArray <BTContractOrderModel *> *)buys sellsArray:(NSArray <BTContractOrderModel *> *)sells;

@end

NS_ASSUME_NONNULL_END
