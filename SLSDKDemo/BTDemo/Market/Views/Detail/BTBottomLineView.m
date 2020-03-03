//
//  BTBottomLineView.m
//  BTTestChart
//
//  Created by 健 王 on 2018/1/8.
//  Copyright © 2018 Karl. All rights reserved.
//

#import "BTBottomLineView.h"

@interface BTBottomLineView ()

@property (nonatomic, assign) CGFloat max_vol_number;
@property (nonatomic, assign) CGFloat min_vol_number;

@property (nonatomic, assign) CGFloat max_price_number;
@property (nonatomic, assign) CGFloat min_price_number;

@property (nonatomic, strong) UILabel *bidView;
@property (nonatomic, strong) UILabel *askView;

@end

@implementation BTBottomLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildUI];
    }
    return self;
}

- (void)addChildUI {
    [self addSubview:self.bidView];
    [self addSubview:self.askView];
}

- (void)setDepthModel:(BTDepthModel *)depthModel {
    _depthModel = depthModel;
    NSArray *sellArr = [Common sequenceWithDepthPriceArr:depthModel.sells.mutableCopy Way:BTOrderWaySell];
    NSArray *buyArr = [Common sequenceWithDepthPriceArr:depthModel.buys.mutableCopy Way:BTOrderWayBuy];
    _depthModel.buys = buyArr;
    _depthModel.sells = sellArr;
    
    if (_depthModel.buys.count > _depthModel.sells.count) {
        _depthModel.buys = [_depthModel.buys subarrayWithRange:NSMakeRange(0, _depthModel.sells.count)];
    } else if (_depthModel.sells.count > _depthModel.buys.count) {
        _depthModel.sells = [_depthModel.sells subarrayWithRange:NSMakeRange(_depthModel.sells.count - _depthModel.buys.count,_depthModel.buys.count)];
    }
    
    self.bottomMargin = (self.bottomMargin !=0)? self.bottomMargin : 40;
    self.topMargin = (self.topMargin != 0)? self.topMargin:30;
    self.font = (self.font != nil)? self.font:[UIFont systemFontOfSize:12];
    [self calculateData];
    [self layoutIfNeeded];
}

#pragma mark - ---------- Data ------------

- (void)calculateData {
    
    // 0. 按照价格排序
    [self sortDataInPrice];
    
    // 1. 累加数据
    [self calculateSumVolNumber];
    
    // 2. 找出最大值和最小值
    [self calculateMaxAndMin];
    
    // 3. 计算每个点的坐标
    [self calculateCoords];
}

- (void)sortDataInPrice {
    [self depthModel];
    self.depthModel.buys = [self.depthModel.buys sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        BTContractOrderModel *model1 = obj1;
        BTContractOrderModel *model2 = obj2;
        return [model1.px compare:model2.px];
    }];
    
    self.depthModel.sells = [self.depthModel.sells sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        BTContractOrderModel *model1 = obj1;
        BTContractOrderModel *model2 = obj2;
        return [model1.px compare:model2.px];
    }];
}

- (void)calculateSumVolNumber {
    if (self.depthModel.sells.count > 0) {
        __block CGFloat sumVolNumber_sells = 0;
        [self.depthModel.sells enumerateObjectsUsingBlock:^(BTContractOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sumVolNumber_sells += obj.qty.doubleValue;
            obj.sumVolNum = [NSString stringWithFormat:@"%.4f",sumVolNumber_sells];
        }];
    }
    
    if(self.depthModel.buys.count > 0){
        __block CGFloat sumVolNumber_buys = 0;
        [self.depthModel.buys enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BTContractOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sumVolNumber_buys += obj.qty.doubleValue;
            obj.sumVolNum = [NSString stringWithFormat:@"%.4f",sumVolNumber_buys];
        }];
    }
}


- (void)calculateMaxAndMin {

    self.min_vol_number = 0;
    
    self.max_vol_number = self.depthModel.sells.lastObject.sumVolNum.doubleValue > self.depthModel.buys.firstObject.sumVolNum.doubleValue ? self.depthModel.sells.lastObject.sumVolNum.doubleValue : self.depthModel.buys.firstObject.sumVolNum.doubleValue;
    // 比最大值多 10%
    self.max_vol_number += self.max_vol_number / 10;
}

- (void)calculateCoords {
    CGFloat viewWidth =  (self.sl_width - SL_MARGIN) / 2;
    CGFloat sell_min_price = [self.depthModel.sells.firstObject.px  doubleValue];
    CGFloat sell_max_price = [self.depthModel.sells.lastObject.px   doubleValue];
    [self.depthModel.sells enumerateObjectsUsingBlock:^(BTContractOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat scale = obj.sumVolNum.doubleValue / (self.max_vol_number - self.min_vol_number);
        
        obj.coordinate_y = (1 - scale) * (self.sl_height - self.topMargin - self.bottomMargin) + self.topMargin;
        
        if ((sell_max_price - sell_min_price) * viewWidth + viewWidth + SL_MARGIN == 0.f || [obj.px doubleValue] - sell_min_price == 0.f) {
            obj.coordinate_x = viewWidth + SL_MARGIN;
        } else {
            obj.coordinate_x = ([obj.px doubleValue] - sell_min_price) / (sell_max_price - sell_min_price) * viewWidth + viewWidth + SL_MARGIN;
        }
    }];
    
    CGFloat buy_min_price = [self.depthModel.buys.firstObject.px  doubleValue];
    CGFloat buy_max_price = [self.depthModel.buys.lastObject.px  doubleValue];
    [self.depthModel.buys enumerateObjectsUsingBlock:^(BTContractOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat scale = obj.sumVolNum.doubleValue / (self.max_vol_number - self.min_vol_number);
        
        obj.coordinate_y = (1 - scale) * (self.sl_height - self.topMargin - self.bottomMargin) + self.topMargin;
        
        if ([obj.px  doubleValue] - buy_min_price == 0 || (buy_max_price - buy_min_price) * viewWidth == 0) {
            obj.coordinate_x = 0;
        } else {
            obj.coordinate_x = ([obj.px  doubleValue] - buy_min_price) / (buy_max_price - buy_min_price) * viewWidth;
        }
    }];
    
    [self setNeedsDisplay];
}



#pragma mark - ---------- UI ------------

- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
    if (self.depthModel == nil) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 1. 绘制刻度横线
//    [self drawGridLineWithContext:context];
    
    // 2. 绘制数据折线及填充色
    [self drawLineWithContext:context];
    
    // 3. 绘制横纵轴刻度标识
    [self drawLabelWithContext:context];
    
    // 4. 绘制边框
    [self drawBigBoardWithContext:context];
}

- (void)drawBigBoardWithContext:(CGContextRef)context {
    [self drawline:context startPoint:CGPointMake(0, self.sl_height-self.bottomMargin) stopPoint:CGPointMake(self.sl_width, self.sl_height-self.bottomMargin) color:MAIN_LINE lineWidth:0.5];
    [self drawline:context startPoint:CGPointMake(0, self.sl_height - 0.5) stopPoint:CGPointMake(self.sl_width, self.sl_height - 0.5) color:MAIN_LINE lineWidth:0.5];
    
    self.askView.frame = CGRectMake(self.sl_width * 0.5 + 15, SL_MARGIN, 35, 20);
    self.bidView.frame = CGRectMake(self.sl_width * 0.5 - 45, SL_MARGIN, 35, 20);
    
}

- (void)drawGridLineWithContext:(CGContextRef)context {
    CGFloat lineContentHeight = self.sl_height - self.topMargin - self.bottomMargin;
    
    NSUInteger lineCount = 6;
    
    CGFloat margin = lineContentHeight / (lineCount-1);
    
    for (int i = 0; i < lineCount; ++i) {
        CGFloat y = margin * i + self.topMargin;
        [self drawline:context startPoint:CGPointMake(0, y) stopPoint:CGPointMake(self.sl_width, y) color:BORDER_COLOR lineWidth:0.3];
    }
}

- (void)drawLineWithContext:(CGContextRef)context {
    [self drawBuyLineWithContext:context];
    [self drawSellLineWithContext:context];
}

- (void)drawBuyLineWithContext:(CGContextRef)context {
    if (nil == self.depthModel.buys || self.depthModel.buys.count == 0){
        return;
    }
    /*------------ Buys -----------*/
    
    CGMutablePathRef buysPath = CGPathCreateMutable();
    
    if (self.depthModel.buys.count == 1) {
        BTContractOrderModel *model = self.depthModel.buys[0];
        [self drawline:context startPoint:CGPointMake(model.coordinate_x, model.coordinate_y) stopPoint:CGPointMake(model.coordinate_x, model.coordinate_y) color:UP_WARD_COLOR lineWidth:0.6];
    } else {
        for (int i = 0; i < self.depthModel.buys.count - 1; ++i) {
            BTContractOrderModel *model = self.depthModel.buys[i];
            BTContractOrderModel *next_model = self.depthModel.buys[i+1];
            
            [self drawline:context startPoint:CGPointMake(model.coordinate_x, model.coordinate_y) stopPoint:CGPointMake(next_model.coordinate_x, next_model.coordinate_y) color:UP_WARD_COLOR lineWidth:0.6];
            if (i == self.depthModel.buys.count - 2) {
                [self drawline:context startPoint:CGPointMake(next_model.coordinate_x, next_model.coordinate_y) stopPoint:CGPointMake(next_model.coordinate_x, self.sl_height - self.bottomMargin) color:UP_WARD_COLOR lineWidth:0.6];
            }
            if (0 == i) {
                CGPathMoveToPoint(buysPath, NULL, model.coordinate_x, self.sl_height - self.bottomMargin);
                CGPathAddLineToPoint(buysPath, NULL, model.coordinate_x, model.coordinate_y);
            } else {
                CGPathAddLineToPoint(buysPath, NULL, model.coordinate_x, model.coordinate_y);
            }
            if ((self.depthModel.buys.count - 2) == i) {
                CGPathAddLineToPoint(buysPath, NULL, next_model.coordinate_x, next_model.coordinate_y);
                CGPathAddLineToPoint(buysPath, NULL, next_model.coordinate_x, self.sl_height - self.bottomMargin);
                CGPathCloseSubpath(buysPath);
            }
        }
        [self drawLinearGradient:context path:buysPath alpha:0.1 startColor:UP_WARD_COLOR.CGColor endColor:UP_WARD_COLOR.CGColor];
    }
    CGPathRelease(buysPath);
}

- (void)drawSellLineWithContext:(CGContextRef)context {
    if (nil == self.depthModel.sells || self.depthModel.sells.count == 0) {
        return;
    }
    /*------------ Sells -----------*/
    
    CGMutablePathRef sellsPath = CGPathCreateMutable();
    
    if (self.depthModel.sells.count == 1) {
        BTContractOrderModel *model = self.depthModel.sells[0];
        [self drawline:context startPoint:CGPointMake(model.coordinate_x, self.sl_height - self.bottomMargin) stopPoint:CGPointMake(model.coordinate_x, model.coordinate_y) color:DOWN_COLOR lineWidth:0.6];
    } else {
        for (int i = 0; i < self.depthModel.sells.count - 1; ++i) {
            BTContractOrderModel *model = self.depthModel.sells[i];
            BTContractOrderModel *next_model = self.depthModel.sells[i+1];
            if (i == 0) {
                [self drawline:context startPoint:CGPointMake(model.coordinate_x, self.sl_height - self.bottomMargin) stopPoint:CGPointMake(model.coordinate_x, model.coordinate_y) color:[UIColor redColor] lineWidth:0.6];
            }
            [self drawline:context startPoint:CGPointMake(model.coordinate_x, model.coordinate_y) stopPoint:CGPointMake(next_model.coordinate_x, next_model.coordinate_y) color:[UIColor redColor] lineWidth:0.6];
            //        if (i == self.depthModel.sells.count - 2) {
            //            [self drawline:context startPoint:CGPointMake(next_model.coordinate_x, next_model.coordinate_y) stopPoint:CGPointMake(next_model.coordinate_x, self.sl_height - bottomMargin) color:[UIColor redColor] lineWidth:1];
            //        }
            
            if (0 == i) {
                CGPathMoveToPoint(sellsPath, NULL, model.coordinate_x, self.sl_height-self.bottomMargin);
                CGPathAddLineToPoint(sellsPath, NULL, model.coordinate_x, model.coordinate_y);
            } else {
                CGPathAddLineToPoint(sellsPath, NULL, model.coordinate_x, model.coordinate_y);
            }
            if ((self.depthModel.sells.count - 2) == i) {
                CGPathAddLineToPoint(sellsPath, NULL, next_model.coordinate_x, next_model.coordinate_y);
                CGPathAddLineToPoint(sellsPath, NULL, next_model.coordinate_x, self.sl_height-self.bottomMargin);
                CGPathCloseSubpath(sellsPath);
            }
        }
        [self drawLinearGradient:context path:sellsPath alpha:0.1 startColor:DOWN_COLOR.CGColor endColor:DOWN_COLOR.CGColor];
    }
    
    CGPathRelease(sellsPath);
}


- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth {
//    if (startPoint.x < self.contentLeft ||stopPoint.x >self.contentRight || startPoint.y <self.contentTop || stopPoint.y < self.contentTop) {
//        return;
//    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}

/// 绘制填充色
- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                     alpha:(CGFloat)alpha
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor {
    if (self.depthModel == nil) {
        return;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextSetAlpha(context, alpha);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawLabelWithContext:(CGContextRef)context {
    
    NSUInteger label_count = 4;
    
    for (int i = 0; i < label_count; ++i) {
        NSDictionary *attrs = @{NSFontAttributeName: self.font,
                                NSForegroundColorAttributeName: GARY_BG_TEXT_COLOR
                                };
        if (_xCount == 2) {
            if (i == 1) {
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", [self.depthModel.buys.lastObject.px doubleValue]] attributes:attrs];
                CGSize string_size = [string size];
                [self drawLabel:context attributesText:string rect:CGRectMake((self.sl_width-SL_MARGIN)/2-string_size.width, self.sl_height - (self.bottomMargin + string_size.height)/2, string_size.width, string_size.height)];
            }
            else if (i == 2) {
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", [self.depthModel.sells.firstObject.px doubleValue]] attributes:attrs];
                CGSize string_size = [string size];
                [self drawLabel:context attributesText:string rect:CGRectMake((self.sl_width-SL_MARGIN)/2 + SL_MARGIN, self.sl_height - (self.bottomMargin + string_size.height)/2, string_size.width, string_size.height)];
            }
        } else {
            if (i == 0) {
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", [self.depthModel.buys.firstObject.px  doubleValue]] attributes:attrs];
                CGSize string_size = [string size];
                [self drawLabel:context attributesText:string rect:CGRectMake(0, self.sl_height - (self.bottomMargin + string_size.height)/2, string_size.width, string_size.height)];
            }
            else if (i == 1) {
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", [self.depthModel.buys.lastObject.px  doubleValue]] attributes:attrs];
                CGSize string_size = [string size];
                [self drawLabel:context attributesText:string rect:CGRectMake((self.sl_width-SL_MARGIN)/2-string_size.width, self.sl_height - (self.bottomMargin + string_size.height)/2, string_size.width, string_size.height)];
            }
            else if (i == 2) {
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", [self.depthModel.sells.firstObject.px doubleValue]] attributes:attrs];
                CGSize string_size = [string size];
                [self drawLabel:context attributesText:string rect:CGRectMake((self.sl_width-SL_MARGIN)/2 + SL_MARGIN, self.sl_height - (self.bottomMargin + string_size.height)/2, string_size.width, string_size.height)];
            }
            else if (i == 3) {
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", [self.depthModel.sells.lastObject.px doubleValue]] attributes:attrs];
                CGSize string_size = [string size];
                [self drawLabel:context attributesText:string rect:CGRectMake(self.sl_width-string_size.width, self.sl_height - (self.bottomMargin + string_size.height)/2, string_size.width, string_size.height)];
            }
        }
    }
    
    /*---------------- 纵 ----------------*/
    
    NSUInteger line_count = (_yCount != 0)?_yCount:7;
    CGFloat tempNum = (self.max_vol_number - self.min_vol_number) / (line_count - 1);
    
    CGFloat lineContentHeight = self.sl_height - self.topMargin - self.bottomMargin;
    CGFloat vert_margin = lineContentHeight / (line_count - 1);
    
    for (int i = 0; i < line_count - 1; ++i) {
        NSDictionary *attrs = @{NSFontAttributeName: self.font,
                                NSForegroundColorAttributeName: GARY_BG_TEXT_COLOR
                                };
        NSString *str = [NSString stringWithFormat:@"%.6f", self.min_vol_number + tempNum*i];
        if ((self.min_vol_number + tempNum*i) == 0.f) {
            str = @"0";
        }
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:attrs];
        
        CGSize string_size = [string size];
        [self drawLabel:context attributesText:string rect:CGRectMake(0, (lineContentHeight - vert_margin * i + self.topMargin - string_size.height), string_size.width, string_size.height)];
    }
}

- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect {
    [attributesText drawInRect:rect];
    //[self drawRect:context rect:rect color:[UIColor clearColor]];
}

- (UILabel *)bidView {
    if (_bidView == nil) {
        _bidView = [[UILabel alloc] init];
        _bidView.frame = CGRectMake(self.sl_width * 0.5 - 45, 0, 30, 15);
        _bidView.textColor = UP_WARD_COLOR;
        _bidView.backgroundColor = [UIColor clearColor];
        _bidView.text = Launguage(@"MK_SP_BI");
        _bidView.textAlignment = NSTextAlignmentCenter;
        _bidView.layer.borderWidth = 1;
        _bidView.layer.borderColor = UP_WARD_COLOR.CGColor;
        _bidView.layer.cornerRadius = 2;
        _bidView.layer.masksToBounds = YES;
        _bidView.font = [UIFont systemFontOfSize:11];
    }
    return _bidView;
}

- (UILabel *)askView {
    if (_askView == nil) {
        _askView = [[UILabel alloc] init];
        _askView.frame = CGRectMake(self.sl_width * 0.5 + 15, 0, 30, 15);
        _askView.textColor = DOWN_COLOR;
        _askView.backgroundColor = [UIColor clearColor];
        _askView.layer.borderWidth = 1;
        _askView.text = Launguage(@"MK_SP_AS");
        _askView.textAlignment = NSTextAlignmentCenter;
        _askView.layer.borderColor = DOWN_COLOR.CGColor;
        _askView.layer.cornerRadius = 2;
        _askView.layer.masksToBounds = YES;
        _askView.font = [UIFont systemFontOfSize:11];
    }
    return _askView;
}
@end


