//
//  myAppInfo.h

//

#import <UIKit/UIKit.h>

@interface MyAppInfo : NSObject
+ (NSString *)localAddress;  
+ (NSString*)appShortVersion;       // 获取item的发布版本 CFBundleShortVersionString
+ (NSString *)language;
+ (NSString *)udidString;           // 在服务端区别手机
+ (NSString *)getDeviceModel;       // 获取设备模型
+ (NSString *)idfaString;           // 获取idfa
+ (NSString *)idfvString;           // 获取idfv
+ (NSNumber *)getCurrentDayZeroTimestamp;
+ (NSNumber*)getCurrentTimestamp;    // 获得当前时间戳
+ (NSString*)getNonceWithLength:(NSInteger)length;    // 获得当前时间戳
+ (NSString *)getNumberDayAgoTimestamp:(NSInteger)days;
+ (NSString *)getNowTimeTimestamp;

@end
