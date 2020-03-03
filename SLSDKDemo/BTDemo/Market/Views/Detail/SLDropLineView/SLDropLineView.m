//
//  SLDropLineView.m
//  BTTest
//
//  Created by 健 王 on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLDropLineView.h"

@interface SLDropLineView ()

@end

@implementation SLDropLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MAIN_COLOR;
    }
    return self;
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [self drawRect:self.frame];
}

- (void)drawRect:(CGRect)rect {// 可以通过 setNeedsDisplay 方法调用 drawRect:
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // 绘制线的宽度
    CGContextSetLineWidth(context,1.0);
    
    // 线的颜色
    CGContextSetStrokeColorWithColor(context, [GARY_BG_TEXT_COLOR colorWithAlphaComponent:0.6].CGColor);
    
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线绘制起点
    CGContextMoveToPoint(context,0,self.sl_height * 0.5);
    // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    CGFloat lengths[] = {2,3};
    // 虚线的起始点
    CGContextSetLineDash(context,0, lengths, 2);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context,self.sl_width,self.sl_height * 0.5);
    // 绘制
    CGContextStrokePath(context);
    // 关闭图像
    CGContextClosePath(context);
    
}
@end
