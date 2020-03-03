//
//  BTSlider.m
//  BTStore
//
//  Created by 健 王 on 2018/3/5.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTSlider.h"

@implementation BTSlider {
    CGPoint touchPoint;
    CGPoint thumbPoint;
    CGRect thumbRect;
    NSMutableArray *stepRectArray;
    CGFloat startPoint;
    CGFloat endPoint;
    CGFloat y;
    
    BOOL istap;
    BOOL isrun;
    
    BOOL isChangeValueDirectly;
    
    /**
     类型为步长时，当前 index
     */
//    NSInteger index;
}

- (void)changeValue:(CGFloat)value {
    self.value = value;
    isChangeValueDirectly = YES;
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = MAIN_COLOR;
    
    _thumbBordColor = [UIColor colorWithWhite:0.99 alpha:1];
    _thumbColor = [UIColor colorWithHex:@"#101216"];
    _stepColor = [UIColor colorWithHex:@"#101216"];
    _selectedStepColor = [UIColor colorWithHex:@"#101216"];
    _lineColor = [UIColor colorWithWhite:0.9 alpha:1];
    _selectedLineColor = MAIN_BTN_COLOR;
    
    _minTrackColor = [UIColor cyanColor];
    _maxTrackColor = _lineColor;
    
    _minimumValue = 0;
    _maximumValue = 1;
    
    _value = 0;
//    index = 0;
    
    _thumbTouchRate = 2;
    _stepTouchRate = 2;
    
    _margin = 12.5;
    _lineWidth = 8;
    
    _numberOfStep = 5;
    
    _titleOffset = 25;
    _sliderOffset = 0;
    
    _thumbSize = CGSizeMake(25, 25);
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSAssert(_maximumValue > _minimumValue, @"最大值要大于最小值");
    
    if (_maximumValue <= _minimumValue) {
        _minimumValue = 0;
        _maximumValue = 1;
    }
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        stepRectArray = [NSMutableArray array];
        
        CGFloat width = rect.size.width - _margin*2;
        
        y  = CGRectGetMidY(rect);
        y += _sliderOffset;
        
        startPoint = _margin;
        endPoint = rect.size.width - _margin;
        
        if (!isrun || isChangeValueDirectly) {
//            if (index >= stepRectArray.count) {
//                index = stepRectArray.count - 1;
//                if (index < 0) {
//                    index = 0;
//                }
//            }
            
            thumbPoint = CGPointMake([self ChangeX] - _thumbSize.width/2, y - _thumbSize.height/2);
            
            isrun = YES;
            
            isChangeValueDirectly = NO;
        }
        
        CGFloat selectedEndPoint = thumbPoint.x + _thumbSize.width/2;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (_selectedLineImage) {
            [_selectedLineImage drawInRect:CGRectMake(startPoint, y-_lineWidth/2, selectedEndPoint-startPoint, _lineWidth)];
            if (_lineImage) {
                [_lineImage drawInRect:CGRectMake(selectedEndPoint, y-_lineWidth/2, endPoint-selectedEndPoint, _lineWidth)];
            }
        } else {
            [self drawLine:context startX:startPoint endX:selectedEndPoint lineColor:self.selectedLineColor];
            [self drawLine:context startX:selectedEndPoint endX:endPoint lineColor:self.lineColor];
        }
        
        CGFloat stWidth = _stepWidth?_stepWidth:_lineWidth;
        for (int i = 0; i < _numberOfStep; i++) {
            CGRect stepOvalRect = CGRectMake(startPoint + width/(_numberOfStep-1)*i - stWidth/2, y - stWidth/2, stWidth, stWidth);
            
            if (stepOvalRect.origin.x + stWidth/2 <= selectedEndPoint) {
                if (_selectedStepImage) {
                    [_selectedStepImage drawInRect:stepOvalRect];
                } else {
                    CGContextAddEllipseInRect(context, stepOvalRect);
                    [self.selectedStepColor set];
                    CGContextFillPath(context);
                }
            } else {
                if (_stepImage) {
                    [_stepImage drawInRect:stepOvalRect];
                } else {
                    CGContextAddEllipseInRect(context, stepOvalRect);
                    [self.stepColor set];
                    CGContextFillPath(context);
                }
            }
            
            [stepRectArray addObject:[NSValue valueWithCGRect:stepOvalRect]];
            
            NSString *title = @"";
            
            if (self.titleArray.count > i) {
                title = self.titleArray[i];
            }
            
            CGPoint titlePoint = CGPointMake(CGRectGetMidX(stepOvalRect), CGRectGetMinY(stepOvalRect));
            
            CGSize titleSize = [title sizeWithAttributes:self.titleAttributes];
            
            titlePoint.y += _titleOffset;
            titlePoint.x -= titleSize.width/2;
            
            CGRect titleRect = {titlePoint,titleSize};
            
            [title drawInRect:titleRect withAttributes:self.titleAttributes];
        }
        
        thumbRect = CGRectMake(thumbPoint.x, thumbPoint.y, _thumbSize.width, _thumbSize.height);
        
        if (_thumbImage) {
            [_thumbImage drawInRect:thumbRect];
        } else {
            CGContextAddEllipseInRect(context, thumbRect);
            
            [self.thumbColor set];
            CGContextSetLineWidth(context, 0.3);
            CGContextSetStrokeColorWithColor(context, self.thumbBordColor.CGColor);
            CGContextSetFillColorWithColor(context, self.thumbColor.CGColor);
            CGContextSetShadow(context, CGSizeMake(0, 1), 0.05);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    } completion:nil];
}


- (void)drawLine:(CGContextRef) context startX:(CGFloat)startX endX:(CGFloat)endX lineColor:(UIColor *)lineColor {
    
    CGContextMoveToPoint(context, startX, y);
    CGContextAddLineToPoint(context, endX, y);
    CGContextSetLineWidth(context, _lineWidth); // 线的宽度
    CGContextSetLineCap(context, kCGLineCapRound); // 起点和重点圆角
    CGContextSetLineJoin(context, kCGLineJoinRound); // 转角圆角
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    CGContextStrokePath(context);
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    touchPoint = [touch locationInView:self];
    
    CGRect tempThumbRect = thumbRect;
    tempThumbRect.size.width  = tempThumbRect.size.width * _thumbTouchRate;
    tempThumbRect.size.height = tempThumbRect.size.height * _thumbTouchRate;
    tempThumbRect.origin.x   -= (tempThumbRect.size.width - thumbRect.size.width)/2;
    tempThumbRect.origin.y   -= (tempThumbRect.size.height - thumbRect.size.height)/2;
    
    istap = YES;
    
    for (NSValue *value in stepRectArray) {
        CGRect oldrect = [value CGRectValue];
        
        CGRect newrect = oldrect;
        newrect.size.width = newrect.size.width*_stepTouchRate;
        newrect.size.height = newrect.size.height*_stepTouchRate;
        newrect.origin.x -= (newrect.size.width - oldrect.size.width)/2;
        newrect.origin.y -= (newrect.size.height - oldrect.size.height)/2;
        if (CGRectContainsPoint(newrect, touchPoint)) {
            thumbPoint = CGPointMake(CGRectGetMidX(newrect) - _thumbSize.width/2, CGRectGetMidY(newrect) - _thumbSize.height/2);
            [self setNeedsDisplay];
            return YES;
        }
    }
    
    return CGRectContainsPoint(tempThumbRect, touchPoint);
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    touchPoint = [touch locationInView:self];
    
    CGFloat x = touchPoint.x;
    
    thumbPoint.x = x - _thumbSize.width/2;
    
    if (x < startPoint) {
        thumbPoint.x = startPoint - _thumbSize.width/2;
    }
    
    if (x > endPoint) {
        thumbPoint.x = endPoint - _thumbSize.width/2;
    }
//    index = 0;
    for (int i = 0; i < stepRectArray.count; i++) {
        NSValue *value = stepRectArray[i];
        CGRect rect = [value CGRectValue];
        CGFloat x1 = rect.origin.x;
        x1 += rect.size.width/2;
        
//        if (x > x1) {
//            index = i;
//        }
    }
    
    [self valueChangeForX:x];
    
    [self valueRefresh];
    
    istap = NO;
    
    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    touchPoint = [touch locationInView:self];
    
    SLLog(@"touchPoint: %@", [NSValue valueWithCGPoint:touchPoint]);
    
    NSInteger tempIndex = 0;
    if (istap) {
        
        for (NSValue *value in stepRectArray) {
            CGRect oldrect = [value CGRectValue];
            CGRect newrect = CGRectMake(oldrect.origin.x, oldrect.origin.y, oldrect.size.width, oldrect.size.height);
            
            newrect.size.width  = newrect.size.width  * _stepTouchRate;
            newrect.size.height = newrect.size.height * _stepTouchRate;
            newrect.origin.x   -= (newrect.size.width - oldrect.size.width)/2;
            newrect.origin.y   -= (newrect.size.height - oldrect.size.height)/2;
            
            tempIndex++;
            
            if (CGRectContainsPoint(newrect, touchPoint)) {
                thumbPoint = CGPointMake(CGRectGetMidX(newrect) - _thumbSize.width/2, CGRectGetMidY(newrect) - _thumbSize.height/2);
                
//                index = tempIndex - 1;
                
                [self valueChangeForX:CGRectGetMidX(oldrect)];
                
                [self valueRefresh];
                
                break;
            } else {
                [self valueRefresh];
            }
        }
    } else {
        [self valueRefresh];
    }
}


- (CGFloat)ChangeX {
    if (self.value == _minimumValue) {
        return startPoint;
    }
    
    if (self.value == _maximumValue) {
        return endPoint;
    }
    
    return fabs(self.value)/(_maximumValue - _minimumValue)*(endPoint - startPoint)+ startPoint;
}


- (void)valueChangeForX:(CGFloat)x {
    
    CGFloat changeRale = (x - startPoint)/(endPoint - startPoint);
    
    CGFloat temp = changeRale * (_maximumValue - _minimumValue);
    
    if (_minimumValue >= 0 ) {
        self.value = temp;
    } else {
        
        if (temp < fabs(_minimumValue)) {
            self.value = -temp;
        }
        
        self.value = temp - fabs(_minimumValue);
    }
}

- (void)valueRefresh {
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (CGFloat)value {
    if (_value <= _minimumValue) {
        _value = _minimumValue;
    }
    
    if (_value >= _maximumValue) {
        _value = _maximumValue;
    }
    return _value;
}

- (void)setNumberOfStep:(NSInteger)numberOfStep {
    
    if (numberOfStep < 2) {
        numberOfStep = 2;
    }
    
    _numberOfStep = numberOfStep;
}

- (NSDictionary *)titleAttributes {
    if (!_titleAttributes) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = self.titleColor?self.titleColor:[UIColor lightGrayColor]; // 文字颜色
        dict[NSFontAttributeName] = self.titleFont?self.titleFont:[UIFont systemFontOfSize:10]; // 字体
        _titleAttributes = dict;
    }
    
    return _titleAttributes;
}

@end
