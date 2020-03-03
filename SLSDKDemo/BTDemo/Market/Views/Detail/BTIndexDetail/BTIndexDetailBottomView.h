//
//  BTIndexDetailBottomView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTIndexDetailBottomViewDelegate < NSObject>

- (void)indexDetailBottomDidClickIndex:(NSInteger)index;

@end

@interface BTIndexDetailBottomView : UIView

@property (nonatomic, weak) id <BTIndexDetailBottomViewDelegate> delegate;

@property (nonatomic, strong) BTItemModel *itemModel;

@end
