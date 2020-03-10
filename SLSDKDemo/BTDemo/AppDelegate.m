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

#define SL_Base_HOST                        @"http://co.mybts.info/"
#define SL_Web_Socket_HOST                  @"ws://ws3.mybts.info/wsswap/realTime"
#define LAUNGUAGE_RES                       @"languageRes.plist"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 连接 socket
    [[SLContractSocketManager sharedManager] SRWebSocketOpenWithURLString:SL_Web_Socket_HOST];
    
    [[SLSDK sharedInstance] sl_startWithAppID:@"Test" launchOption:@{@"base_host": SL_Base_HOST,@"host_Header":@"EX"} callBack:^(id result, NSError *error) {
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
