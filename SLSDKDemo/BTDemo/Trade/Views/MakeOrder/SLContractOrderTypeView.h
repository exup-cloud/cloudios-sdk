//
//  SLContractOrderTypeView.h
//  BTTest
//
//  Created by wwly on 2019/9/7.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLContractOrderTypeViewDelegate <NSObject>

- (void)orderTypeView_orderTypeChanged:(BTContractOrderCategory)orderType;

@end

/// 选择委托类型
@interface SLContractOrderTypeView : UIView

@property (nonatomic, weak) id <SLContractOrderTypeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
