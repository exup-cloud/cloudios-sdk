//
//  SLMineRecordCell.h
//  BTTest
//
//  Created by WWLy on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLMineRecordCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong) BTCashBooksModel *cashBookModel;

@end

NS_ASSUME_NONNULL_END
