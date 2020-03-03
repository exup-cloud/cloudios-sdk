//
//  BTDefinePickView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2019/4/9.
//  Copyright © 2019年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class BTDefinePickView;
@protocol BTDefinePickViewDelegate <NSObject>

- (void)definePickViewDidClickBtnItem:(NSInteger)tag pickView:(BTDefinePickView *)pickView;

@end

@interface BTDefinePickView : UIView

@property (nonatomic, weak) id <BTDefinePickViewDelegate>delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *defaultItem;

- (instancetype)initWithItems:(NSArray *)items frame:(CGRect)frame type:(NSInteger)type;

- (void)didViewDismissPickView;

@end

NS_ASSUME_NONNULL_END
