//
//  SLBaseWebController.m
//  BTTest
//
//  Created by wwly on 2019/9/21.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLBaseWebController.h"
#import <WebKit/WebKit.h>

@interface SLBaseWebController ()

@property (nonatomic, strong) WKWebView * contentWebView;

@end

@implementation SLBaseWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.contentWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)loadWebWithUrlString:(NSString *)urlString {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.contentWebView loadRequest:request];
}


#pragma mark - lazy load

- (WKWebView *)contentWebView {
    if (_contentWebView == nil) {
        _contentWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, self.view.sl_height - SL_SafeAreaTopHeight)];
        _contentWebView.backgroundColor = [UIColor whiteColor];
        [_contentWebView setAllowsBackForwardNavigationGestures:true];
        [self.view addSubview:_contentWebView];
    }
    return _contentWebView;
}

@end
