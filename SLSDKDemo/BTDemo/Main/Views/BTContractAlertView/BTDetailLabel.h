//
//  BTDetailLabel.h
//  BTStore
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTDetailLabel;
@protocol BTDetailLabelDelegate <NSObject>

@optional
- (void)detailLabelDidClickTipsWith:(BTDetailLabel *)detailLabel;

@end

@interface BTDetailLabel : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *nameFont;
@property (nonatomic, strong) UIColor *nameColor;
@property (nonatomic, strong) UIColor *numberColor;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, assign) BOOL isDetail;

@property (nonatomic, weak) id <BTDetailLabelDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andType:(NSUInteger)type;

- (void)setName:(NSString *)name andNumber:(NSString *)number;

- (instancetype)initWithFrame:(CGRect)frame hasButton:(BOOL)hasButton;

@end
