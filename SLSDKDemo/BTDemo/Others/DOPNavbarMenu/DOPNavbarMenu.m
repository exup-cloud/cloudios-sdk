//
//  DOPNavbarMenu.m
//  DOPNavbarMenu
//
//  Created by weizhou on 5/14/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import "DOPNavbarMenu.h"

@implementation UITouchGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateRecognized;
}

@end

@implementation DOPNavbarMenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    self = [super init];
    if (self == nil) return nil;
    _title = title;
    _icon = icon;
    return self;
}

+ (DOPNavbarMenuItem *)ItemWithTitle:(NSString *)title icon:(UIImage *)icon {
    return [[self alloc] initWithTitle:title icon:icon];
}

@end

static NSInteger rowHeight = 50;
static CGFloat titleFontSize = 14.0;

@interface DOPNavbarMenu ()

@property (strong, nonatomic) UIView *background;
@property (assign, nonatomic) CGRect beforeAnimationFrame;
@property (assign, nonatomic) CGRect afterAnimationFrame;
@property (assign, nonatomic) NSInteger numberOfRow;

@end

@implementation DOPNavbarMenu

- (instancetype)initWithItems:(NSArray *)items
                        frame:(CGRect)frame
           maximumNumberInRow:(NSInteger)max {
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    _items = items;
    _open = NO;
    _maximumNumberInRow = max;
    _numberOfRow = (_items.count - 1 ) / _maximumNumberInRow + 1;
    self.dop_height = (_numberOfRow) * rowHeight;
    self.dop_y = -self.dop_height;
    _beforeAnimationFrame = self.frame;
    _afterAnimationFrame = self.frame;
    _background = [[UIView alloc] initWithFrame:CGRectZero];
    self.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
    self.layer.borderWidth = 0.6;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    UITouchGestureRecognizer *gr = [[UITouchGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [_background addGestureRecognizer:gr];
    _textColor = GARY_BG_TEXT_COLOR;
    _separatarColor = [GARY_BG_TEXT_COLOR colorWithAlphaComponent:0.8];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonWidth = self.dop_width/self.maximumNumberInRow;
    CGFloat buttonHeight = rowHeight;
    [self.items enumerateObjectsUsingBlock:^(DOPNavbarMenuItem *obj, NSUInteger idx, BOOL *stop) {
        CGFloat buttonX = (idx % self.maximumNumberInRow) * buttonWidth;
        CGFloat buttonY = ((idx / self.maximumNumberInRow)) * buttonHeight;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.accessibilityLabel = obj.title; //for users of voiceOver
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        button.tag = idx;
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        if (obj.icon) {
            UIImageView *icon = [[UIImageView alloc] initWithImage:obj.icon];
            //        icon.center = CGPointMake(buttonHeight/2, buttonHeight/2);
            icon.frame = CGRectMake(10, 15, buttonHeight-30, buttonHeight-30);
            [button addSubview:icon];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(buttonHeight -10, buttonHeight-15, buttonWidth - buttonHeight, 20)];
            label.sl_centerY = icon.sl_centerY;
            label.text = obj.title;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = self.textColor;
            label.font = [UIFont systemFontOfSize:titleFontSize];
            [button addSubview:label];
        } else {
            [button setTitle:obj.title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
            [button setTitleColor:self.textColor forState:UIControlStateNormal];
        }
        if ((idx+1)%self.maximumNumberInRow != 0) {
            UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth-0.5, 0, 0.5, buttonHeight)];
            separatar.backgroundColor = self.separatarColor;
            [button addSubview:separatar];
        }
        if (self.numberOfRow > 1 && idx/self.maximumNumberInRow < (self.numberOfRow-1)) {
            UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight-0.25, buttonWidth, 0.25)];
            separatar.backgroundColor = self.separatarColor;
            [button addSubview:separatar];
        }
    }];
}

- (void)showInView:(UIView *)view {
    [[UIApplication sharedApplication].keyWindow addSubview:self.background];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (CGRectEqualToRect(self.beforeAnimationFrame, self.afterAnimationFrame)) {
        CGRect tmp = self.afterAnimationFrame;
        tmp.origin.y += (SL_SafeAreaTopHeight + SL_getWidth(90) + rowHeight*self.numberOfRow);
        self.afterAnimationFrame = tmp;
    }
    self.beforeAnimationFrame = CGRectMake(SL_MARGIN, SL_SafeAreaTopHeight + SL_getWidth(80), self.beforeAnimationFrame.size.width, self.beforeAnimationFrame.size.height);
    self.background.frame = CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT);
    [UIView animateWithDuration:0.1
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.dop_y = self.afterAnimationFrame.origin.y;
                         self.hidden = YES;
                     } completion:^(BOOL finished) {
                         if ([self.delegate respondsToSelector:@selector(didShowMenu:)]) {
                             [self.delegate didShowMenu:self];
                         }
                         self.open = YES;
                         self.hidden = NO;
                     }];
}

- (void)showInNavigationController:(UINavigationController *)nvc {
    [nvc.view insertSubview:self.background belowSubview:nvc.navigationBar];
    [nvc.view insertSubview:self belowSubview:nvc.navigationBar];
    if (CGRectEqualToRect(self.beforeAnimationFrame, self.afterAnimationFrame)) {
        CGRect tmp = self.afterAnimationFrame;
        tmp.origin.y += ([UIApplication sharedApplication].statusBarFrame.size.height+nvc.navigationBar.dop_height+rowHeight*self.numberOfRow);
        self.afterAnimationFrame = tmp;
    }
    self.background.frame = nvc.view.frame;
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.dop_y = self.afterAnimationFrame.origin.y;
                     } completion:^(BOOL finished) {
                         if ([self.delegate respondsToSelector:@selector(didShowMenu:)]) {
                             [self.delegate didShowMenu:self];
                         }
                         self.open = YES;
                     }];
}

- (void)dismissWithAnimation:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        [self removeFromSuperview];
        [self.background removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(didDismissMenu:)]) {
            [self.delegate didDismissMenu:self];
        }
        self.open = NO;
    };
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.dop_y += 20;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.dop_y = self.beforeAnimationFrame.origin.y;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    } else {
        self.dop_y = self.beforeAnimationFrame.origin.y;
        completion();
    }
}

- (void)didViewDismissMenu:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        [self removeFromSuperview];
        [self.background removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(didDismissMenu:)]) {
            [self.delegate didDismissMenu:self];
        }
        self.open = NO;
    };
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.dop_y += 20;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.dop_y = self.beforeAnimationFrame.origin.y;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    } else {
        self.dop_y = self.beforeAnimationFrame.origin.y;
        completion();
    }
}

- (void)dismissMenu {
    [self dismissWithAnimation:YES];
}

- (void)buttonTapped:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didSelectedMenu:atIndex:)]) {
        [self.delegate didSelectedMenu:self atIndex:button.tag];
    }
    [self dismissMenu];
}
@end
