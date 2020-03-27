//
//  SLContractTradeController.m
//  BTTest
//
//  Created by wwly on 2019/8/28.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractTradeController.h"
#import "SLBaseScrollView.h"
#import "SLCurrentPriceView.h"
#import "SLContractMakeOrderView.h"
#import "SLContractPriceView.h"
#import "SLContractListView.h"
#import "SLButton.h"
#import "SLContractTableViewController.h"
#import "BTSelectItemMenuView.h"
#import "DOPNavbarMenu.h"
#import "SLContractRecordController.h"
#import "SLContractSettingController.h"
#import "SLContractCalculatorController.h"
#import "BTContractAlertView.h"
#import "BTAssetPasswordView.h"

@interface SLContractTradeController () <DOPNavbarMenuDelegate, UIScrollViewDelegate, SLContractListViewDelegate, SLContractMakeOrderViewDelegate, BTSelectItemMenuViewDelegate, SLContractPriceViewDelegate, BTContractAlertViewDelegate, BTAssetPasswordViewDelegate>

@property (nonatomic, strong) SLButton * coinNameButton;

@property (nonatomic, strong) DOPNavbarMenu * rightNavMenu;

@property (nonatomic, strong) UIButton * buyButton;
@property (nonatomic, strong) UIButton * sellButton;
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) SLCurrentPriceView * currenPriceView;
@property (nonatomic, strong) SLContractMakeOrderView * makeOrderView;
@property (nonatomic, strong) SLContractPriceView * contractPriceView;

@property (nonatomic, strong) UIView *midLine;
@property (nonatomic, strong) SLContractListView * contractListView;

@property (nonatomic, strong) BTSelectItemMenuView *selectItemMenuView;
@property (nonatomic, strong) UIButton *coverBtn;

@end

@implementation SLContractTradeController {
    CGFloat _headerHeight;
    CGFloat _leftContentX;
    CGFloat _leftContentWidth;
    CGFloat _rightContentX;
    CGFloat _rightContentWidth;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerHeight = 50;
    _leftContentX = SL_MARGIN;
    _leftContentWidth = self.view.sl_width * 0.6 - SL_MARGIN * 2;
    _rightContentX = SL_MARGIN + _leftContentWidth + SL_MARGIN;
    _rightContentWidth = self.view.sl_width * 0.4 - SL_MARGIN;
    [self initUI];
    [self updateViewWithItemModel:self.itemModel];
    
    [SLNoteCenter addObserver:self selector:@selector(didReceiveTickerDataFromSocket:) name:BTSocketDataUpdate_Contract_Ticker_Notification object:nil];
    [SLNoteCenter addObserver:self selector:@selector(didReceiveDepthDataFromSocket:) name:BTSocketDataUpdate_Contract_Depth_Notification object:nil];
    [SLNoteCenter addObserver:self selector:@selector(didReceiveContractDataFromSocket:) name:BTSocketDataUpdate_Contract_Unicast_Notification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.makeOrderView.itemModel = self.itemModel;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initUI {
    self.view.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    [self initNav];
    [self initHeaderView];
    [self initContentView];
    [self initContractListView];
    
    [self initContractConfig];
}

- (void)initNav {
    // 显示分隔线
    [self changeLineHiddenStatus:NO];
    
    SLButton *middleButton = [[SLButton alloc] initWithContentFrameType:BTCurrentSelectItemBtn];
    middleButton.frame = CGRectMake(0, 0, 150, 44);
    [middleButton setTitleColor:[SLConfig defaultConfig].lightTextColor forState:UIControlStateNormal];
    [middleButton setImage:[UIImage imageWithName:@"3j"] forState:UIControlStateNormal];
    middleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [middleButton addTarget:self action:@selector(middleNavButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.coinNameButton = middleButton;
    self.coinNameButton.itemModel = self.itemModel;
    [self setCustomTitleView:middleButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setImage:[UIImage imageWithName:@"icon-more"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightNavButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setCustomRightView:rightButton];
}

- (void)initHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, _headerHeight)];
    headerView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    [self.view addSubview:headerView];
    self.buyButton = [UIButton buttonExtensionWithTitle:Launguage(@"BT_CA_KC") TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:nil font:[UIFont systemFontOfSize:16] target:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
    self.buyButton.selected = YES;
    self.buyButton.layer.cornerRadius = 1;
    self.buyButton.layer.borderWidth = 1;
    self.buyButton.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
    self.buyButton.frame = CGRectMake(SL_MARGIN, 8, (_leftContentWidth - SL_MARGIN) / 2, headerView.sl_height - 16);
    [headerView addSubview:self.buyButton];
    
    self.sellButton = [UIButton buttonExtensionWithTitle:Launguage(@"BT_CA_CP") TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:nil font:[UIFont systemFontOfSize:16] target:self action:@selector(sellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sellButton setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
    self.sellButton.layer.cornerRadius = 1;
    self.sellButton.layer.borderWidth = 1;
    self.sellButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    self.sellButton.frame = CGRectMake(self.buyButton.sl_maxX + SL_MARGIN, self.buyButton.sl_y, self.buyButton.sl_width, self.buyButton.sl_height);
    [headerView addSubview:self.sellButton];
    
    self.currenPriceView = [[SLCurrentPriceView alloc] initWithFrame:CGRectMake(_rightContentX, 0, _rightContentWidth, headerView.sl_height)];
    [self.currenPriceView updateViewWithItemModel:self.itemModel];
    [headerView addSubview:self.currenPriceView];
    
    UIView *marginLineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.sl_height - 1, headerView.sl_width, 1)];
    marginLineView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [headerView addSubview:marginLineView];
}

- (void)initContentView {
    self.contentScrollView = [[SLBaseScrollView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight + _headerHeight, self.view.sl_width, self.view.sl_height - SL_SafeAreaTopHeight - _headerHeight)];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.contentScrollView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    [self.view addSubview:self.contentScrollView];
    self.makeOrderView = [[SLContractMakeOrderView alloc] initWithFrame:CGRectMake(_leftContentX, 0, _leftContentWidth, 450)];
    [self.contentScrollView addSubview:self.makeOrderView];
    self.makeOrderView.delegate = self;
    
    self.contractPriceView = [[SLContractPriceView alloc] initWithFrame:CGRectMake(_rightContentX, 0, _rightContentWidth, self.makeOrderView.sl_height)];
    self.contractPriceView.delegate = self;
    [self.contentScrollView addSubview:self.contractPriceView];
    
    [self.contentScrollView addSubview:self.midLine];
}

- (void)initContractListView {
    self.contractListView = [[SLContractListView alloc] initWithFrame:CGRectMake(0, MAX(self.makeOrderView.sl_maxY, self.midLine.sl_maxY), self.view.sl_width, self.contentScrollView.sl_height)];
    self.contractListView.delegate = self;
    [self.contentScrollView addSubview:self.contractListView];
    self.contentScrollView.contentSize = CGSizeMake(0, self.contractListView.sl_maxY);
}

/// 初始化合约默认设置
- (void)initContractConfig {
    if (![BTStoreData storeObjectForKey:ST_UNREA_CARCUL]) {
        [BTStoreData setStoreObjectAndKey:@"1" Key:ST_UNREA_CARCUL];
    }
    if (![BTStoreData storeObjectForKey:ST_DATE_CYCLE]) {
        [BTStoreData setStoreObjectAndKey:@"7" Key:ST_DATE_CYCLE];
    }
    if (![BTStoreData storeObjectForKey:ST_TIGGER_PRICE]) {
        [BTStoreData setStoreObjectAndKey:@"1" Key:ST_TIGGER_PRICE];
    }
}


#pragma mark - Update Data

- (void)setItemModel:(BTItemModel *)itemModel {
    _itemModel = itemModel;
    [self updateViewWithItemModel:itemModel];

    // 监听深度数据
    [[SLSocketDataManager sharedInstance] sl_subscribeContractDepthDataWithInstrument:self.itemModel.instrument_id];
}

- (void)updateViewWithItemModel:(BTItemModel *)itemModel {
    self.coinNameButton.itemModel = itemModel;
    self.makeOrderView.itemModel = itemModel;
    [self.currenPriceView updateViewWithItemModel:itemModel];
    [self updateContractPriceViewWithItemModel:itemModel];
    [self.contractListView updateViewWithItemModel:itemModel];
}

/// 更新挂单(深度)数据列表
- (void)updateContractPriceViewWithItemModel:(BTItemModel *)itemModel {
    [SLSDK sl_loadFutureDepthWithContractID:itemModel.instrument_id price:itemModel.last_px count:10 success:^(BTDepthModel *depthMdoel) {
        if (depthMdoel != nil) {
            [BTMaskFutureTool shareMaskFutureTool].futureDepth = depthMdoel;
            [self.contractPriceView updateViewWithDepthModel:depthMdoel itemModel:itemModel];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - Notification
/// 接收到资产刷新
- (void)didReceiveContractDataFromSocket:(NSNotification *)notify {
    self.makeOrderView.itemModel = self.itemModel;
}

/// 接收到 socket 实时价格更新
- (void)didReceiveTickerDataFromSocket:(NSNotification *)notify {
    BTItemModel *itemModel = notify.userInfo[@"data"];
    if (itemModel.instrument_id == self.itemModel.instrument_id) {
        self.makeOrderView.itemModel = itemModel;
        [self.currenPriceView updateViewWithItemModel:itemModel];
    }
}

/// 接收到 socket 深度数据更新
- (void)didReceiveDepthDataFromSocket:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    NSArray <BTContractOrderModel *> *buys = userInfo[@"buys"];
    NSArray <BTContractOrderModel *> *sells = userInfo[@"sells"];
    
    if (buys.count > 0) {
        [BTMaskFutureTool shareMaskFutureTool].futureDepth.buys = buys;
    }
    
    if (sells.count > 0) {
        [BTMaskFutureTool shareMaskFutureTool].futureDepth.sells = sells;
    }
    
    if (buys.count > 0 || sells.count > 0) {
        // 更新视图
        [self.contractPriceView updateViewWithBuysArray:buys sellsArray:sells];
    }
}


#pragma mark - events

- (void)leftNavButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)middleNavButtonClick:(UIButton *)sender {
    [self currentItemInfoViewDidSelectedContractItem];
}

- (void)rightNavButtonClick:(UIButton *)sender {
    if (self.rightNavMenu.isOpen) {
        [self.rightNavMenu dismissWithAnimation:YES];
    } else {
        [self.rightNavMenu showInNavigationController:self.navigationController];
    }
}

- (void)buyButtonClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    self.sellButton.selected = NO;
    self.sellButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    sender.selected = YES;
    sender.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
    [self.makeOrderView updateViewWithContractOrderType:BTDefineContractOpen];
}

- (void)sellButtonClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    self.buyButton.selected = NO;
    self.buyButton.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    sender.selected = YES;
    sender.layer.borderColor = [SLConfig defaultConfig].blueTextColor.CGColor;
    [self.makeOrderView updateViewWithContractOrderType:BTDefineContractClose];
}


#pragma mark - <DOPNavbarMenuDelegate>

- (void)didShowMenu:(DOPNavbarMenu *)menu {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didDismissMenu:(DOPNavbarMenu *)menu {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
    if (index == 0) {
        SLContractRecordController *recordVC = [[SLContractRecordController alloc] init];
        recordVC.itemModel = self.itemModel;
        [self.navigationController pushViewController:recordVC animated:YES];
    } else if (index == 1) {
        SLContractSettingController *contractRuleVc = [[SLContractSettingController alloc] init];
        [self.navigationController pushViewController:contractRuleVc animated:YES];
    } else if (index == 2) {
        NSString *lan = @"zh-cn";
        NSString *urlString = [NSString stringWithFormat:@"https://support.bbx.com/hc/%@/sections/360001701593", lan];
        SLBaseWebController *webVc = [[SLBaseWebController alloc] init];
        [webVc updateNavTitle:@"合约交易规则"];
        [webVc loadWebWithUrlString:urlString];
        [self.navigationController pushViewController:webVc animated:YES];
    }  else if (index == 3) {
        SLContractCalculatorController *calculatorVc = [[SLContractCalculatorController alloc] init];
        calculatorVc.itemModel = self.itemModel;
        [self.navigationController pushViewController:calculatorVc animated:YES];
    }
}
        

#pragma mark - <SLContractPriceViewDelegate>

- (void)priceView_didSelectPrice:(NSString *)price {
    self.makeOrderView.selectedPrice = price;
}

- (void)priceView_updateBuyPrice:(NSString *)buyPrice sellPrice:(NSString *)sellPrice {
    if (buyPrice.length > 0) {
        self.makeOrderView.buyOnePrice = buyPrice;
    }
    if (sellPrice.length > 0) {
        self.makeOrderView.sellOnePrice = sellPrice;
    }
}


#pragma mark - <SLContractMakeOrderViewDelegate>

- (void)contractMakeOrdersViewDidClickWithLeverArr:(NSArray *)itemArr leverage:(NSString *)leverage handle:(void (^)(UITableViewCell * _Nonnull))result {
    SLContractTableViewController *vc = [[SLContractTableViewController alloc] initWithTableViewType:SLNewTableViewContractLever];
    vc.title = @"杠杆倍数";
    vc.currentLever = leverage;
    vc.leverArr = itemArr.mutableCopy;
    vc.toSelectCell = result;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)defineContractViewDidClickBuyOrSellWithContractOrderType:(BTContractOrderType)orderType order:(BTContractOrderModel *)order {
    if (self.itemModel) {
        NSString *code = self.itemModel.contractInfo.margin_coin;
        if (code == nil) {
            return;
        }
        if (![BTMineAccountTool hasOpenContractAccountWithCoin:code]) {
            [BTContractAlertView showContractAlertViewWithData:@{@"name":code} andAlertType:BTContractAlertViewContractOpenAccount andSetDelegate:self];
            return;
        }
    }
    // 没有绑定邮箱和绑定充值地址
    if ([SLPlatformSDK sharedInstance].activeAccount.status == BTAccountStatusNotActive) {
        SLLog(@"!!!!!!!!! 账号未绑定邮箱和充值地址 !!!!!!!!!");
        return;
    }
    NSDictionary *dict = [order mj_keyValues];
    if (order.forceTips || [BTStoreData storeBoolForKey:SL_SHOW_CONTRACT_DETAIL]) {
        if (orderType == BTDefineContractOpen) {
            [BTContractAlertView showContractAlertViewWithData:dict andAlertType:BTContractAlertViewContractFuturesOrder andSetDelegate:self];
        } else {
             [BTContractAlertView showContractAlertViewWithData:dict andAlertType:BTContractAlertViewSendCloseOrder andSetDelegate:self];
        }
    } else {
        [self submitOrderWithPassword:nil orderType:orderType order:order];
    }
}

- (void)submitOrderWithPassword:(NSString *)password orderType:(BTContractOrderType)orderType order:(BTContractOrderModel *)order {
    __weak typeof(self) weakSelf = self;
    [BTPreloadingView showPreloadingViewToView:[UIApplication sharedApplication].keyWindow];
    if (order.cycle && order.trend > 0 && order.trigger_type > 0) {
        [BTContractTool submitPlanOrder:order contractOrderType:orderType assetPassword:password success:^(NSNumber *contract_id) {
            [BTPreloadingView hidePreloadingViewToView:[UIApplication sharedApplication].keyWindow];
            [weakSelf submitContractOrderSuccess];
        } failure:^(id error) {
            if ([error isKindOfClass:[NSString class]] &&[error isEqualToString:SHOW_FUND_PWD]) {
                [BTAssetPasswordView showAssetPasswordViewToView:[UIApplication sharedApplication].keyWindow delegate:weakSelf type:BTAssetPasswordVerifyType];
            } else {
                SL_SHOW_ERROR_MESSAGE(error);
            }
            [BTPreloadingView hidePreloadingViewToView:[UIApplication sharedApplication].keyWindow];
        }];
    } else {
        [BTContractTool sendContractsOrder:order contractOrderType:orderType assetPassword:password success:^(NSNumber *contract_id) {
            [BTPreloadingView hidePreloadingViewToView:[UIApplication sharedApplication].keyWindow];
            [weakSelf submitContractOrderSuccess];
        } failure:^(id error) {
            if ([error isKindOfClass:[NSString class]] &&[error isEqualToString:SHOW_FUND_PWD]) {
                [BTAssetPasswordView showAssetPasswordViewToView:[UIApplication sharedApplication].keyWindow delegate:weakSelf type:BTAssetPasswordVerifyType];
            } else {
                SL_SHOW_ERROR_MESSAGE(error);
            }
            [BTPreloadingView hidePreloadingViewToView:[UIApplication sharedApplication].keyWindow];
        }];
    }
}

/// 下单成功之后
- (void)submitContractOrderSuccess {
    // 更新信息
    [self.contractListView refreshContractInfo];
}


#pragma mark - <BTContractAlertViewDelegate>

// alertViewDelegate
- (void)contractAlertViewDidClickCancelWithType:(BTContractAlertViewType)type {
    [BTContractAlertView hideContractAlertViewWithType:type];
}

- (void)contractAlertViewDidClickComfirmWithType:(BTContractAlertViewType)type info:(NSDictionary *)info {
    switch (type) {
        case BTContractAlertViewContractFuturesOrder:
            [self submitOrderWithPassword:nil orderType:self.makeOrderView.currentOrderType order:self.makeOrderView.currentOrderModel];
            break;
        case BTContractAlertViewSendCloseOrder:
            [self submitOrderWithPassword:nil orderType:self.makeOrderView.currentOrderType order:self.makeOrderView.currentOrderModel];
            break;
        case BTContractAlertViewContractOpenAccount:
            [self sendOpenContractAccount];
            break;
        case BTContractAlertViewInsufficient:
            SLLog(@"---- 划转 ----");
            break;
        default:
            break;
    }
    [BTContractAlertView hideContractAlertViewWithType:type];
}

/// 开通合约
- (void)sendOpenContractAccount {
    [BTContractTool createContractAccountWithContractID:self.itemModel.instrument_id success:^(id result) {
        if (![BTStoreData storeBoolForKey:SL_CONTRACT_INS]) {
            BTItemCoinModel *contractItem = [BTMineAccountTool getCoinAssetsWithCoinCode:self.itemModel.contractInfo.margin_coin];

            if ((contractItem == nil || [contractItem.available_vol LessThanOrEqual:BT_ZERO])) {
                [BTContractAlertView showContractAlertViewWithData:@{@"title":self.itemModel.contractInfo.margin_coin} andAlertType:BTContractAlertViewInsufficient andSetDelegate:self];
                [BTStoreData setStoreBoolAndKey:YES Key:SL_CONTRACT_INS];
            }
        }
    } failure:^(id error) {
        SL_SHOW_ERROR_MESSAGE(error)
    }];
}


#pragma mark - <BTAssetPasswordViewDelegate>

- (void)assetPasswordViewDidClickConfirmWithType:(BTAssetPasswordViewType)type password:(NSString *)pwd {
}

- (void)assetPasswordViewDidClickCancel {
    [BTAssetPasswordView hideAssetViewFromView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - < UIScrollViewDelegate, SLContractListViewDelegate>

- (void)contractListView_scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.contentScrollView.contentOffset.y < (self.contentScrollView.contentSize.height - self.contentScrollView.sl_height) && scrollView.contentOffset.y < 10) {
        self.contractListView.canScroll = NO;
    }
    if (!self.contractListView.canScroll) {
        [scrollView setContentOffset:CGPointZero animated:NO];
    }
    if (scrollView.contentOffset.y > 0) {
        if (self.contentScrollView.contentOffset.y < 30) {
            [self.contentScrollView setContentOffset:self.contentScrollView.contentOffset animated:NO];
        } else {
            [self.contentScrollView setContentOffset:CGPointMake(0, self.contentScrollView.contentSize.height - self.contentScrollView.sl_height) animated:NO];
        }
    }
}

CGFloat _historyOffsetY = 0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        // 如果已经滚动到底部
        if (offsetY >= scrollView.contentSize.height - scrollView.sl_height) {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.sl_height) animated:NO];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    _historyOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self p_scrollViewDidEndScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self p_scrollViewDidEndScroll:scrollView];
    }
}

- (void)p_scrollViewDidEndScroll:(UIScrollView *)scrollView {
    self.contractListView.canScroll = YES;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        return;
    }
    // 当从顶部向上滚动超过 50 个像素就自动滚到底部
    if (offsetY - _historyOffsetY > 30) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.sl_height) animated:YES];
    } else if (offsetY - _historyOffsetY > 0) {
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
    // 当从底部向下滚动超过 50 个像素就自动滚动到顶部
    else if (_historyOffsetY - offsetY > 30) {
        [scrollView setContentOffset:CGPointZero animated:YES];
    } else if (_historyOffsetY - offsetY > 0) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.sl_height) animated:YES];
    }
    else {
        [scrollView setContentOffset:CGPointMake(0, offsetY) animated:NO];
    }
}


#pragma mark - <BTSelectItemMenuViewDelegate>

/// 切换交易对
- (void)selectItemDidClickSelected:(BTItemModel *)itemModel {
    self.itemModel = itemModel;
    [self currentItemInfoViewDidSelectedContractItem];
}

- (void)didClickCancelPickView:(UIButton *)sender {
    [self currentItemInfoViewDidSelectedContractItem];
}

- (void)currentItemInfoViewDidSelectedContractItem {
    self.selectItemMenuView.hidden = !self.selectItemMenuView.hidden;
    self.coverBtn.hidden = !self.coverBtn.hidden;
    if (self.selectItemMenuView.hidden == NO) {
        self.selectItemMenuView.itemModel = self.itemModel;
        [self.view bringSubviewToFront:self.selectItemMenuView];
    }
}


#pragma mark - lazy load

- (DOPNavbarMenu *)rightNavMenu {
    if (_rightNavMenu == nil) {
        DOPNavbarMenuItem *item1 = [DOPNavbarMenuItem ItemWithTitle:@"交易记录" icon:[UIImage imageWithName:@"icon-contract-Records"]];
        DOPNavbarMenuItem *item2 = [DOPNavbarMenuItem ItemWithTitle:@"合约设置" icon:[UIImage imageWithName:@"icon-contract-Setup"]];
        DOPNavbarMenuItem *item3 = [DOPNavbarMenuItem ItemWithTitle:@"合约指南" icon:[UIImage imageWithName:@"icon-contract-guide"]];
        DOPNavbarMenuItem *item4 = [DOPNavbarMenuItem ItemWithTitle:@"合约计算器" icon:[UIImage imageWithName:@"icon-contract-Calculator"]];
        
        NSArray *arr = @[item1, item2, item3, item4];
        
        _rightNavMenu = [[DOPNavbarMenu alloc] initWithItems:arr frame:CGRectMake(self.view.sl_width - (self.view.sl_width/2.8 + SL_MARGIN), 0, self.view.sl_width/2.8, 50 * arr.count) maximumNumberInRow:1];
        _rightNavMenu.backgroundColor = MAIN_COLOR;
        _rightNavMenu.separatarColor = GARY_BG_TEXT_COLOR;
        _rightNavMenu.delegate = self;
    }
    return _rightNavMenu;
}

- (BTSelectItemMenuView *)selectItemMenuView {
    if (_selectItemMenuView == nil) {
        if ([BTContractTool hasMoniItemModel]) {
            _selectItemMenuView = [[BTSelectItemMenuView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, SL_SCREEN_WIDTH, SL_getWidth(230)) btnArr:@[@"USDT",@"币本位",@"模拟"]];
        } else {
            _selectItemMenuView = [[BTSelectItemMenuView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, SL_SCREEN_WIDTH, SL_getWidth(230)) btnArr:@[@"USDT",@"币本位"]];
        }
        _selectItemMenuView.hidden = YES;
        _selectItemMenuView.delegate = self;
        [self.view addSubview:_selectItemMenuView];
    }
    return _selectItemMenuView;
}

- (UIButton *)coverBtn {
    if (_coverBtn == nil) {
        _coverBtn = [[UIButton alloc] init];
        [_coverBtn setBackgroundColor:[DARK_BARKGROUND_COLOR colorWithAlphaComponent:0.6]];
        _coverBtn.frame = CGRectMake(0, CGRectGetMaxY(self.selectItemMenuView.frame), SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - (CGRectGetMaxY(self.selectItemMenuView.frame)));
        [[UIApplication sharedApplication].keyWindow addSubview:_coverBtn];
        [_coverBtn addTarget:self action:@selector(didClickCancelPickView:) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn.hidden = YES;
    }
    return _coverBtn;
}

- (UIView *)midLine {
    if (_midLine == nil) {
        _midLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.makeOrderView.sl_maxY, self.view.sl_width, SL_getWidth(10))];
        _midLine.backgroundColor = DARK_BARKGROUND_COLOR;
    }
    return _midLine;
}


- (void)dealloc {
    // 取消订阅 socket 深度数据
    [[SLSocketDataManager sharedInstance] sl_unSubscribeContractDepthDataWithInstrument:self.itemModel.instrument_id];
    [SLNoteCenter removeObserver:self name:SLSocketDataUpdate_Ticker_Notification object:nil];
    [SLNoteCenter removeObserver:self name:SLSocketDataUpdate_Depth_Notification object:nil];
    [SLNoteCenter removeObserver:self];
}

@end
