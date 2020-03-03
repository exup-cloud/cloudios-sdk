//
//  BTSegment.h
//  BTTestChart
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTSegment : UIView

@property (nonatomic, strong, readonly) UIButton * selectedSegmentButton;

@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithTitles:(NSArray *)titles height:(CGFloat)height didClickAction:(void(^)(UIButton *,NSInteger))segmentAction;

- (instancetype)initWithTitles:(NSArray *)titles height:(CGFloat)height font:(UIFont *)font didClickAction:(void(^)(UIButton *, NSInteger))segmentAction;

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles height:(CGFloat)height font:(UIFont *)font didClickAction:(void(^)(UIButton *,NSInteger))segmentAction;

@end
