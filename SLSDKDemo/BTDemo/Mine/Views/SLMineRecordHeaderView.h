//
//  SLMineRecordHeaderView.h
//  BTTest
//
//  Created by WWLy on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SLMineRecordHeaderTypeNone,
    SLMineRecordHeaderTypeCoin,
    SLMineRecordHeaderTypeRecordType,
} SLMineRecordHeaderType;

@protocol SLMineRecordHeaderViewDelegate <NSObject>

- (void)mineRecordsHeaderView_DidClick:(SLMineRecordHeaderType)headerType;

@end

@interface SLMineRecordHeaderView : UIView

@property (nonatomic, copy) NSString *leftStr;
@property (nonatomic, copy) NSString *rightStr;

@property (nonatomic, weak) id <SLMineRecordHeaderViewDelegate> delegate;

/// 恢复原状
- (void)reset;

@end

NS_ASSUME_NONNULL_END
