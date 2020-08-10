//
//  FlowLayout.m
//  ZFJCollectionView
//
//  Created by xue on 2018/11/16.
//  Copyright © 2018 ZFJ. All rights reserved.
//

#define LineSpacing 50

#import "FlowLayout.h"


@implementation FlowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.minimumLineSpacing = 10;
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;//速率
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //水平方向
    }
    return self;
}

//返回滚动停止的点 自动对齐中心
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGFloat  offSetAdjustment = MAXFLOAT;
    
    //预期停止水平中心点
    CGFloat horizotalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;
    
    //预期滚动停止时的屏幕区域
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    //找出最接近中心点的item
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes * attributes in array) {
        CGFloat currentCenterX = attributes.center.x;
        if (ABS(currentCenterX - horizotalCenter) < ABS(offSetAdjustment)) {
            offSetAdjustment = currentCenterX - horizotalCenter;
        }
    }
    //
    return CGPointMake(proposedContentOffset.x + offSetAdjustment, proposedContentOffset.y);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:original copyItems:YES];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes * attributes in array) {
        //判断相交
        if (CGRectIntersectsRect(visibleRect, rect)) {
            //当前视图中心点 距离item中心点距离
            CGFloat  distance  =  CGRectGetMidX(self.collectionView.bounds) - attributes.center.x;
            CGFloat  normalizedDistance = distance / 200;
            if (ABS(distance) < 200) {
                //放大倍数
                CGFloat zoom = 1 + 0.4 * (1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(1, 1, 1);
                attributes.zIndex = 1;
            }
        }
    }
    
    return array;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
