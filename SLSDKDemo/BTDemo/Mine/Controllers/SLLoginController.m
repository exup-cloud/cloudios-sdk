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
    
    self.userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, self.view.sl_width - 100, 40)];
    self.userNameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTF.textColor = [SLConfig defaultConfig].lightTextColor;
    self.userNameTF.placeholder = @"邮箱/手机号";
    self.userNameTF.layer.cornerRadius = 2;
    self.userNameTF.layer.borderWidth = 1;
    self.userNameTF.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
    self.userNameTF.text = @"+86 11142587528"; // @"apolloz@qq.com";
    [self.view addSubview:self.userNameTF];

    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(self.userNameTF.sl_x, self.userNameTF.sl_maxY + 25, self.userNameTF.sl_width, self.userNameTF.sl_height)];
    self.passwordTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTF.textColor = [SLConfig defaultConfig].lightTextColor;
    self.passwordTF.placeholder = @"密码";
    self.passwordTF.layer.cornerRadius = 2;
    self.passwordTF.layer.borderWidth = 1;
    self.passwordTF.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
    self.passwordTF.text = @"tiger123456"; // @"z1234566";
    [self.view addSubview:self.passwordTF];
    
    self.loginButton = [UIButton buttonExtensionWithTitle:@"普通_登录" TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:16] target:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.backgroundColor = [SLConfig defaultConfig].blueTextColor;
    self.loginButton.layer.cornerRadius = 2;
    self.loginButton.frame = CGRectMake(50, self.view.sl_height * 0.4, self.view.sl_width - 50 * 2, 45);
    [self.view addSubview:self.loginButton];
}


/// 普通登录
- (void)loginButtonClick {
    [self.view endEditing:YES];
    
    //    // 判断是否需要验证
    [BTSettingBingTool captchCheckShowImageWithType:LOGINVerifyCode success:^(BOOL result) {
        if (result) {
            BTNetsVerifyCodeTool *netsTool = [BTNetsVerifyCodeTool defaultNetsVerifyCodeTool];
            [netsTool showNetsVerifyCodeOnView:nil];
            [netsTool setValidateFinish:^(BOOL result, NSString *validate, NSString *message) {
                if (result) {
                    NSString *nonce = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000000)];
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    if ([self.userNameTF.text containsString:@"@"]) {
                        param[@"email"] = self.userNameTF.text;
                    } else {
                        param[@"phone"] = self.userNameTF.text;
                    }
                    param[@"password"] = [[NSString stringWithFormat:@"%@%@", [self.passwordTF.text md5String], nonce] md5String];
                    param[@"nonce"] = @([nonce longLongValue]);
                    if (validate) {
                        param[@"validate"] = validate;
                    }
                    NSString *loginUrl = [BTBasePath sharedBasePath].login;
                    [BTSecureHttp KAuthPOST:loginUrl parameters:param success:^(id responseHeader, id responseObject) {
                        NSLog(@"responseHeader:%@",responseObject);
                        id data = responseObject[@"data"];
                        if (![data isKindOfClass:[NSDictionary class]]) {
                            return;
                        }
                        if (![responseHeader isKindOfClass:[NSDictionary class]]) {
                            return;
                        }
                        if (!responseHeader[KEY_USER_TOKEN] || !responseHeader[KEY_USER_SS_ID] || !responseHeader[KEY_USER_U_ID]) {
                            return;
                        }
                        BTAccount *account = [[BTAccount alloc] init];
                        account.Token = responseHeader[KEY_USER_TOKEN];
                        account.Ssid = responseHeader[KEY_USER_SS_ID];
                        account.Uid = responseHeader[KEY_USER_U_ID];
                        if (account) {
                            [[SLPlatformSDK sharedInstance] sl_startWithAccountInfo:account]; // 里面会加载合约资产
                            [self.navigationController pushViewController:[SLContractMarketController new] animated:YES];
                        }
                    } failure:^(NSError *error) {
                    }];
                }
            }];
        } else {

        }
    } failure:^(id error) {

    }];
}

@end
