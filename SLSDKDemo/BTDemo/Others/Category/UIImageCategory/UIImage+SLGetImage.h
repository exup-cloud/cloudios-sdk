//
//  UIImage+SLGetImage.h
//  koudaiAppstore
//
//  Created by Mike on 15/11/16.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageScale) {
    ImageScaleDependSystem = 0,
    ImageScaleOneFold = 1,
    ImageScaleTwoFold,
    ImageScaleThreeFold
};

@interface UIImage (SLGetImage)
+ (UIImage *)imageWithLocalName:(NSString *)name;
+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)JPGImageWithName:(NSString *)image;
+ (NSData *)GIFImageWithName:(NSString *)image;
+ (UIImage *)imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;
+ (NSArray *)imagesArrayWithGIFData:(NSData *)gifData imageScale:(ImageScale)imageScale;
- (UIImage *)scaledToSize:(CGSize)newSize;
// 获得高清二维码
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

@end
