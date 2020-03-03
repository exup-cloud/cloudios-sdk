//
//  SLCurrentPriceView.h
//  BTTest
//
//  Created by wwly on 2019/9/3.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 当前价格和涨跌幅
@interface SLCurrentPriceView : UIView

- (void)updateViewWithItemModel:(BTItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
