//
//  SLBaseScrollView.m
//  BTTest
//
//  Created by wwly on 2019/9/7.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLBaseScrollView.h"

@implementation SLBaseScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
