//
//  BTKLineSegment.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2019/1/7.
//  Copyright © 2019年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTKLineSegmentDelegate <NSObject>
@optional
- (void)kLineSegmentDidClickMoreAction:(UIButton *)sender;

- (void)kLineSegmentDidClickFullScreenAction:(UIButton *)sender;
@end

@interface BTKLineSegment : UIView
@property (nonatomic, strong) UIButton *selectedSegmentButton;
@property (nonatomic, weak) id <BTKLineSegmentDelegate>delegate;
@property (nonatomic, copy) NSString *moreTitle;
@property (nonatomic, strong) UIButton *moreBtn;

- (void)setSelectedIndex:(NSInteger)index;
- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles height:(CGFloat)height font:(UIFont *)font didClickAction:(void(^)(UIButton *,NSInteger))segmentAction;
- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles height:(CGFloat)height font:(UIFont *)font noFull:(BOOL)hasFull didClickAction:(void(^)(UIButton *,NSInteger))segmentAction;

@end
