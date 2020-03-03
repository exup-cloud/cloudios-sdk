//
//  SLBaseCusNavBarController.m
//  ColorfulClouds
//
//  Created by  on 2019/3/21.
//  Copyright © 2019 . All rights reserved.
//

#import "SLBaseCusNavBarController.h"

@interface SLBaseCusNavBarController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView  * navView;
@property (nonatomic, strong) UILabel * navTitleLabel;
@property (nonatomic, strong) UIView  * navTitleView;
@property (nonatomic, strong) UIView  * lineView;

@property (nonatomic, copy) NSString * navTitle;

@end

@implementation SLBaseCusNavBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    self.view.backgroundColor = [SLConfig defaultConfig].contentViewColor;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    [self p_addNotification];
    
    // 当隐藏导航栏之后返回手势会失效, 所以需要手动设置一下代理
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    
    [self p_removeNotification];
}

- (void)initNavigationBar {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SL_SafeAreaTopHeight)];
    self.navView.backgroundColor = [SLConfig defaultConfig].navBarBackgroundColor;
    [self.view addSubview:self.navView];
    
    // 创建导航栏的titleLabel
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, SL_SafeAreaTopHeight - 44, SL_SCREEN_WIDTH - 120, 44)];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navTitleLabel.textColor = [SLConfig defaultConfig].navTitleColor;
    if (self.navTitle) {
        self.navTitleLabel.text = self.navTitle;
    }
    [self.navView addSubview:self.navTitleLabel];
    
    // 创建导航栏左按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, SL_SafeAreaTopHeight - 44, 30, 44);
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftButton setImage:[UIImage imageWithName:@"btn-back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:leftButton];
}

/// 导航栏左边按钮方法
- (void)preAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - 通知

- (void)p_addNotification {
    
}

- (void)p_removeNotification {
    
}


#pragma mark - 对外方法

- (void)changeLineHiddenStatus:(BOOL)isHidden {
    self.lineView.hidden = isHidden;
}

- (void)setCustomLeftView:(UIView *)customView {
    customView.sl_x = 10;
    customView.sl_maxY = SL_SafeAreaTopHeight;
    [self.navView addSubview:customView];
}

- (void)setCustomTitleView:(UIView *)customView {
    _navTitleView = customView;
    customView.sl_centerX = self.navView.sl_width / 2;
    customView.sl_maxY = self.navView.sl_height;
    [self.navView addSubview:customView];
    self.navTitleLabel.hidden = YES;
}

- (void)setCustomRightView:(UIView *)customView {
    customView.sl_maxX = self.navView.sl_width - 10;
    customView.sl_maxY = SL_SafeAreaTopHeight;
    [self.navView addSubview:customView];
}

- (void)updateNavBackgroundColor:(UIColor *)color {
    self.navView.backgroundColor = color;
}

- (void)updateNavTitle:(NSString *)title {
    self.navTitle = title;
    self.navTitleLabel.text = title;
}


#pragma mark - lazy load

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navView.sl_height - 2, self.navView.sl_width, 2)];
        _lineView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
        _lineView.hidden = YES;
        [self.navView addSubview:_lineView];
    }
    return _lineView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)dealloc {
//    SLLog(@"memory: %@ dealloc", self);
//}

@end
