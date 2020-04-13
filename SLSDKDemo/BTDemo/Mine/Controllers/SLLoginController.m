//
//  SLLoginController.m
//  BTTest
//
//  Created by WWLy on 2019/9/16.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLLoginController.h"
#import "BTNetsVerifyCodeTool.h"
#import "SLContractMarketController.h"
#import "SLSelectController.h"
#import "NSString+SLHash.h"

@interface SLLoginController ()<SLFutureDataRefreshProtocol>

@property (nonatomic, strong) UITextField * userNameTF;
@property (nonatomic, strong) UITextField * passwordTF;

@property (nonatomic, strong) UIButton * loginButton;

@end

@implementation SLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)initUI {
    
    self.loginButton = [UIButton buttonExtensionWithTitle:@"普通登录" TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:16] target:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.backgroundColor = [SLConfig defaultConfig].blueTextColor;
    self.loginButton.layer.cornerRadius = 2;
    self.loginButton.frame = CGRectMake(50, self.view.sl_height * 0.4, self.view.sl_width - 50 * 2, 45);
    [self.view addSubview:self.loginButton];
    
}


/// 普通登录
- (void)loginButtonClick {
    [self.view endEditing:YES];
    
    BTAccount *account = [[BTAccount alloc] init];
    // 账户 id, 如果没有, 可以不传
//    account.Uid = @"2556353284";
    account.Token = @"d48cf68a78114e107800269aa20b99b3";
    account.access_key = @"72f9e158-6dc1-4154-92fb-47e0e959935a";
    account.expiredTs = @"1758290096781000";
    
    [[SLPlatformSDK sharedInstance] sl_startWithAccountInfo:account];
    [[SLPlatformSDK sharedInstance] sl_loadUserContractPerpotyCallBack:^(NSArray<BTItemCoinModel *> *assets) {
        // 订阅合约资产信息
        [[SLSocketDataManager sharedInstance] sl_subscribeContractUnicastData];
    }];
     [self.navigationController pushViewController:[SLSelectController new] animated:YES];
}

@end
