//
//  SLTradePriceCell.h
//  BTTest
//
//  Created by wwly on 2019/8/28.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTContractOrderModel;

NS_ASSUME_NONNULL_BEGIN

@interface SLTradePriceCell : UITableViewCell

- (void)updateViewWithModel:(BTContractOrderModel *)model;

@end

NS_ASSUME_NONNULL_END
