//
//  BTMarketTableView.h
//  SLContractSDK
//
//  Created by wwly on 2019/8/13.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BTMarketTableViewDelegate <NSObject>

/**
 点击某个币种

 @param itemModel 币种对应的模型
 */
- (void)marketTableView_didSelectCell:(BTItemModel *)itemModel;

@end

@interface BTMarketTableView : SLBaseTableView

@property (nonatomic, weak) id <BTMarketTableViewDelegate> marketTableView_delegate;

- (void)updateViewWithItemModel:(BTItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
