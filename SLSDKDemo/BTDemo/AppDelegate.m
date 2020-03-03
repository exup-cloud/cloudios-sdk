//
//  AppDelegate.m
//  BTDemo_Test
//
//  Created by WWLy on 2019/9/26.
//  Copyright © 2019 SL. All rights reserved.
//

#import "AppDelegate.h"
#import "SLSelectController.h"
#import "SLContractMarketController.h"
#import "SLLoginController.h"

#define SL_Web_Socket_HOST    @"wss://api.tigermex.com/wsswap/realTime"
#define LAUNGUAGE_RES                       @"languageRes.plist"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 连接 socket
    [[SLContractSocketManager sharedManager] SRWebSocketOpenWithURLString:SL_Web_Socket_HOST];
    
    NSString *urlString = @"https://api.tigermex.com";
    [[SLSDK sharedInstance] sl_startWithAppID:@"Test" launchOption:@{@"base_host": urlString,@"host_Header":@"Tmex",@"PRIVATE_KEY":@"OZ1WNXAlbe84Kpq8"} callBack:^(id result, NSError *error) {
        SLLog(@"******** SDK 初始化 result: %@", result);
        NSString *lanpath = [[NSBundle mainBundle] pathForResource:LAUNGUAGE_RES ofType:nil];
        NSDictionary *landata = [NSDictionary dictionaryWithContentsOfFile:lanpath];
        NSString *currentLanguage =[[BTLanguageTool sharedInstance] getCurrentLanguage];
        if (!currentLanguage) {
            currentLanguage = EN;
        }
        if (landata) {
            [BTLanguageTool sharedInstanceWithLanguage:landata[currentLanguage]];
        }
        
        
        self.window = [[UIWindow alloc] initWithFrame:SL_SCREEN_BOUNDS];
        [self.window makeKeyAndVisible];
        [[BTLanguageTool sharedInstance] setCurrentLaunguage:CNS];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[SLLoginController new]];
        self.window.rootViewController = navVC;
    }];
    
    return YES;
}


@end
