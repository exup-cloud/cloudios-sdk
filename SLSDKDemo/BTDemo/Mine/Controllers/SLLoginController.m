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
#import "BTSettingBingTool.h"
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
    // 13273189359  wang19951119
    
//    self.userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, self.view.sl_width - 100, 40)];
//    self.userNameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
//    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
//    self.userNameTF.textColor = [SLConfig defaultConfig].lightTextColor;
//    self.userNameTF.placeholder = @"邮箱/手机号";
//    self.userNameTF.layer.cornerRadius = 2;
//    self.userNameTF.layer.borderWidth = 1;
//    self.userNameTF.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
//    self.userNameTF.text = @"+86 11142587528"; // @"apolloz@qq.com";
//    [self.view addSubview:self.userNameTF];
//
//    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(self.userNameTF.sl_x, self.userNameTF.sl_maxY + 25, self.userNameTF.sl_width, self.userNameTF.sl_height)];
//    self.passwordTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
//    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
//    self.passwordTF.textColor = [SLConfig defaultConfig].lightTextColor;
//    self.passwordTF.placeholder = @"密码";
//    self.passwordTF.layer.cornerRadius = 2;
//    self.passwordTF.layer.borderWidth = 1;
//    self.passwordTF.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
//    self.passwordTF.text = @"tiger123456"; // @"z1234566";
//    [self.view addSubview:self.passwordTF];
    
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
    account.Token = @"7af5683c07c58db9c110149dee090df2";
    account.access_key = @"3e0b5935-6e67-4b55-b345-6f0ed43fafa8";
    account.expiredTs = @"1583901738000000";
    
    [[SLPlatformSDK sharedInstance] sl_startWithAccountInfo:account];
    [[SLPlatformSDK sharedInstance] sl_loadUserContractPerpotyCallBack:^(NSArray<BTItemCoinModel *> *assets) {
        // 订阅合约资产信息
        [[SLSocketDataManager sharedInstance] sl_subscribeContractUnicastData];
        [self.navigationController pushViewController:[SLSelectController new] animated:YES];
    }];
}

@end
