//
//  NSString+CalculateSize.h
//  AppHelperXQ
//
//  Created by WWLY on 15/11/20.
//  Copyright © 2015年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (CalculateSize)
- (CGSize)sizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font;
- (NSUInteger)charactorNumber;
@end

