//
//  UIImage+SLGetImage.m
//  koudaiAppstore
//
//  Created by Mike on 15/11/16.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "UIImage+SLGetImage.h"
#import <ImageIO/CGImageSource.h>

@implementation UIImage (SLGetImage)

+ (UIImage *)imageWithLocalName:(NSString *)name {
    
    UIImage *image = [UIImage imageWithContentsOfFile:[SL_RESOURCE_LOCAL_FOLDER stringByAppendingPathComponent:name]];
    return image;
}

+ (UIImage *)imageWithName:(NSString *)name {
    
    NSString *imageFile = name;
    if (!SL_IOS8_OR_LATER) {
        imageFile = [NSString stringWithFormat:@"%@@2x.png",name];
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:[SL_SL_RESOURCE_BUNDLE_PATH stringByAppendingPathComponent:imageFile]];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[SL_SL_RESOURCE_BUNDLE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@3x.jpg",name]]];
    }
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[SL_SL_RESOURCE_BUNDLE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.jpg",name]]];
    }
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[SL_SL_RESOURCE_BUNDLE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]]];
    }
    
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[SL_SL_RESOURCE_BUNDLE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"GIF2/%@.png",name]]];
    }
    if (!image) {
        image = [[UIImage alloc] init];
    }
    
    return image;
}

+ (UIImage *)JPGImageWithName:(NSString *)image {
    NSString *imageFile = image;
    if ([image pathExtension].length == 0) {
        if (SL_IOS8_OR_LATER) {
            imageFile = [image stringByAppendingPathExtension:@"jpg"];
        } else {
            imageFile = [NSString stringWithFormat:@"%@.jpg",image];
        }
    }
    NSString *filePath = [SL_SL_RESOURCE_BUNDLE_PATH stringByAppendingPathComponent:imageFile];
    UIImage * img = [UIImage imageWithContentsOfFile:filePath];
    
    if (!img) {
        
        //        DDLogError(@"image is nil");
    }
    return img;
}

+ (NSData *)GIFImageWithName:(NSString *)image {
    if ([image pathExtension].length == 0) {
        image = [image stringByAppendingPathExtension:@"gif"];
    }
    
    NSString  *filePath = [[NSBundle mainBundle] pathForResource:[SL_SL_RESOURCE_BUNDLE_NAME stringByAppendingPathComponent:image] ofType:nil];
    
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    return imageData;
}

static NSTimeInterval _sl_CGImageSourceGetGIFFrameDelayAtIndex(CGImageSourceRef source, size_t index) {
    NSTimeInterval delay = 0;
    CFDictionaryRef dic = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (dic) {
        CFDictionaryRef dicGIF = CFDictionaryGetValue(dic, kCGImagePropertyGIFDictionary);
        if (dicGIF) {
            NSNumber *num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFUnclampedDelayTime);
            if (num.doubleValue <= __FLT_EPSILON__) {
                num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFDelayTime);
            }
            delay = num.doubleValue;
        }
        CFRelease(dic);
    }
    
    // http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
    if (delay < 0.02) delay = 0.1;
    return delay;
}

+ (UIImage *)imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)(data), NULL);
    if (!source) return nil;
    
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        CFRelease(source);
        return [self.class imageWithData:data scale:scale];
    }
    
    NSUInteger frames[count];
    double oneFrameTime = 1 / 50.0; // 50 fps
    NSTimeInterval totalTime = 0;
    NSUInteger totalFrame = 0;
    NSUInteger gcdFrame = 0;
    for (size_t i = 0; i < count; i++) {
        NSTimeInterval delay = _sl_CGImageSourceGetGIFFrameDelayAtIndex(source, i);
        totalTime += delay;
        NSInteger frame = lrint(delay / oneFrameTime);
        if (frame < 1) frame = 1;
        frames[i] = frame;
        totalFrame += frames[i];
        if (i == 0) gcdFrame = frames[i];
        else {
            NSUInteger frame = frames[i], tmp;
            if (frame < gcdFrame) {
                tmp = frame; frame = gcdFrame; gcdFrame = tmp;
            }
            while (true) {
                tmp = frame % gcdFrame;
                if (tmp == 0) break;
                frame = gcdFrame;
                gcdFrame = tmp;
            }
        }
    }
    NSMutableArray *array = [NSMutableArray new];
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!imageRef) {
            CFRelease(source);
            return nil;
        }
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        if (width == 0 || height == 0) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, bitmapInfo);
        CGColorSpaceRelease(space);
        if (!context) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef decoded = CGBitmapContextCreateImage(context);
        CFRelease(context);
        if (!decoded) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        UIImage *image = [UIImage imageWithCGImage:decoded scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CGImageRelease(decoded);
        if (!image) {
            CFRelease(source);
            return nil;
        }
        for (size_t j = 0, max = frames[i] / gcdFrame; j < max; j++) {
            [array addObject:image];
        }
    }
    CFRelease(source);
    UIImage *image = [self.class animatedImageWithImages:array duration:totalTime];
    return image;
}

+ (NSArray *)imagesArrayWithGIFData:(NSData *)gifData imageScale:(ImageScale)imageScale {
    if (gifData == nil) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray *imagesArrM = [[NSMutableArray alloc] initWithCapacity:count];
    
    if (count <= 1) {
        return @[[[UIImage alloc] initWithData:gifData]];
    }
    
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (imageRef) {
            UIImage *image = [UIImage imageWithCGImage:imageRef scale:imageScale orientation:0];
            [imagesArrM addObject:image];
        }
        CGImageRelease(imageRef);
    }
    CFRelease(source);
    return imagesArrM.copy;
}

- (UIImage *)scaledToSize:(CGSize)newSize {
    
    CGFloat width = newSize.width;
    CGFloat height = newSize.height;
    
    CGFloat bitsPerComponent = CGImageGetBitsPerComponent(self.CGImage);
    CGFloat bytesPerRow = CGImageGetBytesPerRow(self.CGImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(self.CGImage);
    
    CGContextRef context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextDrawImage(context, CGRectMake(0,0,width,height), self.CGImage);
    
    return [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
