//
//  BTBottomLineView.h
//  BTTestChart
//
//  Created by 健 王 on 2018/1/8.
//  Copyright © 2018 Karl. All rights reserved.
//


@class BTDepthModel;
@interface BTBottomLineView : UIView

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) NSInteger xCount;
@property (nonatomic, assign) NSInteger yCount;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) BOOL hasBoard;

@property (nonatomic, strong) BTDepthModel * depthModel;
@end
