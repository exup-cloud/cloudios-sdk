//
//  UIView+Frame.m
//  Project
//
//  Created by Jason_Mac on 14/9/6.
//  Copyright (c) 2014年 Jason. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setSl_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)sl_x {
    return self.frame.origin.x;
}

- (void)setSl_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)sl_y {
    return self.frame.origin.y;
}

- (CGFloat)sl_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setSl_maxY:(CGFloat)maxY {
    self.sl_y            = maxY - self.sl_height;
}

- (CGFloat)sl_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setSl_maxX:(CGFloat)maxX {
    self.sl_x            = maxX - self.sl_width;
}

- (CGFloat)sl_centerX {
    return self.center.x;
}

- (void)setSl_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)sl_centerY {
    return self.center.y;
}

- (void)setSl_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)sl_width {
    return self.frame.size.width;
}

- (void)setSl_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)sl_height {
    return self.frame.size.height;
}

- (void)setSl_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)sl_size {
    return self.frame.size;
}

- (void)setSl_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
