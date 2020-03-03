//
//  SLContractDoneRecordCell.h
//  BTTest
//
//  Created by wwly on 2019/9/21.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 成交记录
@interface SLContractDoneRecordCell : UITableViewCell

- (void)updateViewWithDoneRecordModel:(BTContractRecordModel *)recordModel;

@end

NS_ASSUME_NONNULL_END
