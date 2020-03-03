//
//  BTMarketFuturesCell.h
//  SLContractSDK
//
//  Created by WWLy on 2019/8/14.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 市场 USDT 合约 cell
@interface BTMarketFuturesCell : UITableViewCell

@property (nonatomic, strong, readonly) BTItemModel * itemModel;

- (void)updateViewWithModel:(BTItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
