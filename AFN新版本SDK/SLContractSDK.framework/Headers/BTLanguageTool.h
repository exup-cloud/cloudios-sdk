//
//  BTLanguageTool.h
//  BTStore
//
//  Created by WWLy on 2018/1/25.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CNS @"zh-cn"
#define EN @"en"
#define Launguage(obj) [[BTLanguageTool sharedInstanceWithLanguage:nil] getStringForKey:obj]

@interface BTLanguageTool : NSObject

@property (nonatomic, strong) NSArray *launguageArr;
@property (nonatomic, strong) NSDictionary *languageDict;

+ (instancetype)sharedInstanceWithLanguage:(NSDictionary *)language;

+ (instancetype)sharedInstance;

- (NSString *)getCurrentLanguage;

- (void)setCurrentLaunguage:(NSString *)launguage;

/**
 *  返回plist中指定的key的值
 *
 *  @param key   key
 *
 *  @return 返回plist中指定的key的值
 */
- (NSString *)getStringForKey:(NSString *)key;

/**
 *  返回plist中指定的key的值
 *
 *  @return 返回plist中的语言种类
 */
- (NSInteger)getLanguageNumForPlist;

/**
 *  根据plist设置新的语言
 *
 *  @param language 新语言
 */
- (void)setPlistNewLanguage:(NSString*)language;

- (void)resetRootViewController;

@end
