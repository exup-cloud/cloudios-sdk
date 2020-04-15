//
//  NSString+compareVersion.h
//  AppInstaller
//
//  Created by WWLY on 15/11/20.
//  Copyright © 2015年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CompareVersion)

- (NSInteger)compareVersion:(NSString*)version;

- (BOOL)firstCharIsInteger;

- (BOOL)firstCharIsNotLetterOrInteger;

@end
