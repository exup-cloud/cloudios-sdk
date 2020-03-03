//
//  SLMineAssetsHeaderView.h
//  BTTest
//
//  Created by WWLy on 2019/9/16.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLMinePerprotyModel;

NS_ASSUME_NONNULL_BEGIN

/// 个人资产 headerView
@interface SLMineAssetsHeaderView : UIView

- (void)updateViewWithPerprotyModel:(SLMinePerprotyModel *)perprotyModel;

@end

NS_ASSUME_NONNULL_END
