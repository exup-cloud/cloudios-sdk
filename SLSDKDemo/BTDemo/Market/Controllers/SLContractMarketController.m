//
//  SLContractMarketController.m
//  BTTest
//
//  Created by WWLy on 2019/9/9.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractMarketController.h"
#import "BTMarketTableView.h"
#import "SLContractTradeController.h"
#import "SLMarketDetailController.h"
#import "SLMineAssetsController.h"

@interface SLContractMarketController () <BTMarketTableViewDelegate>

@property (nonatomic, strong) BTMarketTableView * marketTableView;

@end

@implementation SLContractMarketController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initUI];
    
    // 监听实时价格更新
    [SLNoteCenter addObserver:self selector:@selector(dataUpdatedFromSocket:) name:SLSocketDataUpdate_Ticker_Notification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initNav {
    [self changeLineHiddenStatus:NO];
    [self updateNavTitle:Launguage(@"BT_MK")];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:Launguage(@"ME_GD_AS") forState:UIControlStateNormal];
    [rightButton setTitleColor:[SLConfig defaultConfig].lightTextColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    rightButton.frame = CGRectMake(0, 0, 90, 44);
    [rightButton addTarget:self action:@selector(rightNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setCustomRightView:rightButton];
}

- (void)initUI {
    self.view.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    self.marketTableView = [[BTMarketTableView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, self.view.sl_height - SL_SafeAreaTopHeight)];
    self.marketTableView.marketTableView_delegate = self;
    [self.view addSubview:self.marketTableView];
}

#pragma mark - Events

- (void)rightNavButtonClick {
    SLMineAssetsController *mineAssetsVC = [SLMineAssetsController new];
    [self.navigationController pushViewController:mineAssetsVC animated:YES];
}


#pragma mark - Notification

- (void)dataUpdatedFromSocket:(NSNotification *)notification {
    id model = notification.userInfo[@"data"];
    if ([model isKindOfClass:[BTItemModel class]]) {
        [self.marketTableView updateViewWithItemModel:model];
    }
}


#pragma mark - <BTMarketTableViewDelegate>

- (void)marketTableView_didSelectCell:(BTItemModel *)itemModel {
    // 跳转至详情页
    SLMarketDetailController *detailVC = [[SLMarketDetailController alloc] init];
    detailVC.itemModel = itemModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)dealloc {
    [SLNoteCenter removeObserver:self name:SLSocketDataUpdate_Ticker_Notification object:nil];
    [SLNoteCenter removeObserver:self];
}

@end
