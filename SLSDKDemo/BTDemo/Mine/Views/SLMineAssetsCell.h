//
//  SLMineAssetsCell.h
//  BTTest
//
//  Created by WWLy on 2019/9/16.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLMinePerprotyModel;

NS_ASSUME_NONNULL_BEGIN

@interface SLMineAssetsCell : UITableViewCell

- (void)updateViewWithPerprotyModel:(SLMinePerprotyModel *)perprotyModel;

@end

NS_ASSUME_NONNULL_END
