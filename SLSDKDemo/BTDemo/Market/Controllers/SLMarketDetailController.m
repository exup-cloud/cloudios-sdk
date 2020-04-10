//
//  SLMarketDetailController.m
//  BTTest
//
//  Created by wwly on 2019/9/10.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMarketDetailController.h"
#import "SLMarketDetailHeaderView.h"
#import "SLKLineChartView.h"
#import "BTFuturesBottomView.h"
#import "SLContractTradeController.h"
#import "SLButton.h"
#import "BTShareView.h"
#import <SLContractSDK/BTDrawLineManager.h>
#import "SLMarketDetailIndexController.h"
#import "BTUtility.h"

#define FLUSH_CHART_TIMESPAN 6
#define FLUSH_HEADER_TIMESPAN 3

@interface SLMarketDetailController () <SLKLineChartViewDelegate, BTHorScreenViewDelegate, SLMarketDetailHeaderViewDelegate>

@property (nonatomic, strong) UIScrollView * contentScrollView;

@property (nonatomic, strong) SLMarketDetailHeaderView * headerView;

@property (nonatomic, strong) SLKLineChartView * lineChartView;

@property (nonatomic, assign) SLStockLineDataType kLineDataType;

@property (nonatomic, strong) NSArray <BTItemModel *> * kLineModelArray;

@property (nonatomic, strong) BTFuturesBottomView * futuresBottomView;

@property (nonatomic, strong) UIView * bottomTradeView;

@end

@implementation SLMarketDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self requestDefaultData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 监听实时价格更新
    [SLNoteCenter addObserver:self selector:@selector(didReceiveTickerDataFromSocket:) name:SLSocketDataUpdate_Ticker_Notification object:nil];
    // 订阅并监听最新成交
    [[SLSocketDataManager sharedInstance] sl_subscribeContractTradeDataWithInstrument:self.itemModel.instrument_id];
    [SLNoteCenter addObserver:self selector:@selector(didReceiveTradeDataFromSocket:) name:SLSocketDataUpdate_Trade_Notification object:nil];
    // 订阅并监听深度数据
    [[SLSocketDataManager sharedInstance] sl_unSubscribeContractDepthDataWithInstrument:self.itemModel.instrument_id];
    [SLNoteCenter addObserver:self selector:@selector(didReceiveDepthDataFromSocket:) name:SLSocketDataUpdate_Depth_Notification object:nil];
    // 订阅并监听 k 线数据
    [[SLSocketDataManager sharedInstance] sl_subscribeQuoteBinDataWithContractID:self.itemModel.instrument_id stockLineDataType:self.kLineDataType];
    [SLNoteCenter addObserver:self selector:@selector(didReceiveQuoteBinDataFromSocket:) name:SLSocketDataUpdate_QuoteBin_Notification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SLNoteCenter removeObserver:self name:SLSocketDataUpdate_Ticker_Notification object:nil];
    [[SLSocketDataManager sharedInstance] sl_unSubscribeContractTradeDataWithInstrument:self.itemModel.instrument_id];
    [SLNoteCenter removeObserver:self name:SLSocketDataUpdate_Trade_Notification object:nil];
//    [[SLSocketDataManager sharedInstance] sl_unsubscribeDepthDataWithContractID:self.itemModel.instrument_id];
    [SLNoteCenter removeObserver:self name:SLSocketDataUpdate_Depth_Notification object:nil];
    [[SLSocketDataManager sharedInstance] sl_unsubscribeQuoteBinDataWithContractID:self.itemModel.instrument_id stockLineDataType:self.kLineDataType];
    [SLNoteCenter removeObserver:self name:SLSocketDataUpdate_QuoteBin_Notification object:nil];
}

- (void)initUI {
    [self initNav];
    [self initContentView];
}

- (void)initNav {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageWithName:@"icon-share"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setTitleColor:[SLConfig defaultConfig].lightTextColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setCustomRightView:rightButton];
    
    [self updateNavTitle:self.itemModel.name];
    [self changeLineHiddenStatus:NO];
}

- (void)initContentView {
    CGFloat bottomTradeViewHeight = SL_SafeAreaBottomHeight + 60;
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, self.view.sl_height - bottomTradeViewHeight - SL_SafeAreaTopHeight)];
    self.contentScrollView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
//    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    
    if (@available(iOS 11.0, *)) {
        self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.headerView = [[SLMarketDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.sl_width, 140)];
    self.headerView.delegate = self;
    [self.contentScrollView addSubview:self.headerView];
    
    UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.sl_maxY, self.view.sl_width, 6)];
    marginView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [self.contentScrollView addSubview:marginView];
    
    self.lineChartView = [[SLKLineChartView alloc] initWithFrame:CGRectMake(0, marginView.sl_maxY, self.view.sl_width, 400)];
    self.lineChartView.delegate = self;
    [self.contentScrollView addSubview:self.lineChartView];
    
    marginView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineChartView.sl_maxY + 5, self.view.sl_width, 6)];
    marginView.backgroundColor = [SLConfig defaultConfig].marginLineColor;
    [self.contentScrollView addSubview:marginView];
    
    self.futuresBottomView = [[BTFuturesBottomView alloc] initWithFrame:CGRectMake(0, marginView.sl_maxY, SL_SCREEN_WIDTH, 440)];
    self.futuresBottomView.itemModel = self.itemModel;
    [self.contentScrollView addSubview:self.futuresBottomView];
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.futuresBottomView.sl_maxY + SL_SafeAreaBottomHeight);
    
    self.bottomTradeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.sl_height - bottomTradeViewHeight, self.view.sl_width, bottomTradeViewHeight)];
    self.bottomTradeView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    [self.view addSubview:self.bottomTradeView];
    
    UIButton *buyButton = [UIButton buttonExtensionWithTitle:Launguage(@"BT_CA_MRKD") TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:15] target:self action:@selector(buyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    buyButton.layer.cornerRadius = 2;
    buyButton.backgroundColor = [SLConfig defaultConfig].greenColorForBuy;
    buyButton.frame = CGRectMake(10, 10, (self.bottomTradeView.sl_width - 10 * 3) / 2, 40);
    [self.bottomTradeView addSubview:buyButton];
    
    UIButton *sellButton = [UIButton buttonExtensionWithTitle:Launguage(@"BT_CA_MCKK") TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:15] target:self action:@selector(sellButtonClick) forControlEvents:UIControlEventTouchUpInside];
    sellButton.layer.cornerRadius = 2;
    sellButton.backgroundColor = [SLConfig defaultConfig].redColorForSell;
    sellButton.frame = CGRectMake(buyButton.sl_maxX + 10, buyButton.sl_y, buyButton.sl_width, buyButton.sl_height);
    [self.bottomTradeView addSubview:sellButton];
}

- (void)rightNavButtonClick {
    UIImage *screenImage = [BTUtility doScreenShotWithView:[UIApplication sharedApplication].keyWindow];
    BTShareView *shareView = [BTShareView shareViewWithImage:screenImage frame:CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - SL_getWidth(180))];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    UIImage *shareImage = [shareView screenShotWithFrameContentImage];
    NSString *shareText = @"BBX.com 领先的加密货币指数交易平台";
    NSArray *activityItems = @[shareText, shareImage];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError){
        [shareView removeFromSuperview];
        if (completed){
            SLLog(@"分享完成");
        } else {
            SLLog(@"取消分享");
        }
    };
    // 在 ipad 上分享需要指定 sourceView
    activityVC.popoverPresentationController.sourceView = self.view;
    activityVC.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, 1.0, 1.0);
    activityVC.completionWithItemsHandler = myBlock;
    activityVC.excludedActivityTypes = nil;
    [self presentViewController:activityVC animated:YES completion:nil];
}

/// 买入开多
- (void)buyButtonClick {
    SLContractTradeController *contractTradeVC = [SLContractTradeController new];
    contractTradeVC.itemModel = self.itemModel;
    [self.navigationController pushViewController:contractTradeVC animated:YES];
}

/// 卖出开空
- (void)sellButtonClick {
    SLContractTradeController *contractTradeVC = [SLContractTradeController new];
    contractTradeVC.itemModel = self.itemModel;
    [self.navigationController pushViewController:contractTradeVC animated:YES];
}


#pragma mark - Update Data

- (void)setItemModel:(BTItemModel *)itemModel {
    _itemModel = itemModel;
}

/// 初始化默认数据
- (void)requestDefaultData {
    
    [self.headerView updateViewWithItemModel:self.itemModel];

    [[BTDrawLineManager shareManager] resetFlushCount:self.itemModel.name contractID:self.itemModel.instrument_id];
    
    self.kLineDataType = SLStockLineDataTypeFiveMinutes;
    
    // 默认显示 5 分数据
    [self requestAndUpdateLineChartViewWithKLineDataType:SLStockLineDataTypeFiveMinutes];
}

/// 根据 k 线数据类型更新数据和视图
- (void)requestAndUpdateLineChartViewWithKLineDataType:(SLStockLineDataType)kLineDataType {
    [[BTDrawLineManager shareManager] loadDataWithCoin:@"" contractID:self.itemModel.instrument_id type:3 count:kLineDataType success:^(NSArray<BTItemModel *> *itemModelArray, BOOL isCotainNewData, BOOL isFirstData) {
        if (kLineDataType != self.kLineDataType) {
            return;
        }
        self.kLineModelArray = itemModelArray;
        [self updateLineChartViewWithLineData:itemModelArray kLineDataType:kLineDataType isCotainNewData:isCotainNewData];
        // 重置 socket 订阅
        [[SLSocketDataManager sharedInstance] sl_subscribeQuoteBinDataWithContractID:self.itemModel.instrument_id stockLineDataType:kLineDataType];
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateLineChartViewWithLineData:(NSArray *)lineData kLineDataType:(SLStockLineDataType)kLineDataType isCotainNewData:(BOOL)isCotainNewData {
    switch (kLineDataType) {
        case SLStockLineDataTypeTimely:
            [self.lineChartView updataTimeLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeOneMinute:
            [self.lineChartView updataOneKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeFiveMinutes:
            [self.lineChartView updataFiveKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeFifteenMinutes:
            [self.lineChartView updataFifteenKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeThirtyMinutes:
            [self.lineChartView updataThirtyKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeOneHour:
            [self.lineChartView updataHourKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeTwoHours:
            [self.lineChartView updataTwoHourKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeFourHours:
            [self.lineChartView updataFourHourKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeSixHours:
            [self.lineChartView updataSixHourKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeTwelveHours:
            [self.lineChartView updataTwelveHourKLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeOneDay:
            [self.lineChartView updataKDayLine:lineData hasChange:isCotainNewData];
            break;
        case SLStockLineDataTypeOneWeek:
            [self.lineChartView updataKWeekLine:lineData hasChange:isCotainNewData];
            break;
        default:
            break;
    }
}


#pragma mark - Socket Data

/// Ticker 数据
- (void)didReceiveTickerDataFromSocket:(NSNotification *)notify {
    BTItemModel *itemModel = notify.userInfo[@"data"];
    if ([itemModel isKindOfClass:[BTItemModel class]]) {
        if (itemModel.instrument_id == self.itemModel.instrument_id) {
            [self.headerView updateViewWithItemModel:itemModel];
        }
    }
}

/// 最新成交
- (void)didReceiveTradeDataFromSocket:(NSNotification *)notify {
    NSArray <BTContractTradeModel *> *trades = notify.userInfo[@"data"];
    if ([trades isKindOfClass:[NSArray class]] && trades.count > 0) {
        [self.futuresBottomView updateViewWithNewTradesArray:trades];
    }
}

/// 深度数据
- (void)didReceiveDepthDataFromSocket:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    NSArray <BTContractOrderModel *> *buys = userInfo[@"buys"];
    NSArray <BTContractOrderModel *> *sells = userInfo[@"sells"];
    
    if (buys.count > 0 || sells.count > 0) {
        // 更新视图
        [self.futuresBottomView updateViewWithNewBuysArray:buys sellsArray:sells];
    }
}

/// k 线数据
- (void)didReceiveQuoteBinDataFromSocket:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    NSArray <BTItemModel *> *itemModelArray = userInfo[@"data"];
    SLStockLineDataType kLineDataType = [userInfo[@"kLineDataType"] integerValue];
    // 分时 和 1 分钟 返回的都是 SLStockLineDataTypeOneMinute
    if ((kLineDataType == SLStockLineDataTypeOneMinute && self.kLineDataType != SLStockLineDataTypeTimely) && kLineDataType != self.kLineDataType) {
        return;
    }
    // 同一条数据
    if (itemModelArray.firstObject.timestamp == self.kLineModelArray.lastObject.timestamp) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.kLineModelArray];
        [mArr removeLastObject];
        [mArr addObjectsFromArray:itemModelArray];
        self.kLineModelArray = mArr.copy;
        [self updateLineChartViewWithLineData:self.kLineModelArray kLineDataType:self.kLineDataType isCotainNewData:YES];
    }
    // 新数据
    else if (itemModelArray.firstObject.timestamp > self.kLineModelArray.lastObject.timestamp) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.kLineModelArray];
        [mArr addObjectsFromArray:itemModelArray];
        self.kLineModelArray = mArr.copy;
        [self updateLineChartViewWithLineData:self.kLineModelArray kLineDataType:self.kLineDataType isCotainNewData:YES];
    }
}


#pragma mark - <SLMarketDetailHeaderViewDelegate>

/// 跳转至币种信息详情页
- (void)headerView_rightArrowButtonClick {
    SLMarketDetailIndexController *detailIndexVC = [[SLMarketDetailIndexController alloc] init];
    detailIndexVC.itemModel = self.itemModel;
    [self.navigationController pushViewController:detailIndexVC animated:YES];
}


#pragma mark - <SLKLineChartViewDelegate>

- (void)lineChartView_didClickSegmentWithKLineDataType:(SLStockLineDataType)dataType {
    if (self.kLineDataType == dataType) {
        return;
    }
    self.kLineDataType = dataType;
    
    [self requestAndUpdateLineChartViewWithKLineDataType:dataType];
}

- (void)lineChartView_scrollVerticallyWithOffsetY:(CGFloat)offsetY isEnd:(BOOL)isEnd {
    CGFloat pointY = self.contentScrollView.contentOffset.y;

    offsetY = pointY - offsetY;
    
    __block CGFloat offsetY_block = offsetY;
    
    if (isEnd) {
        if (offsetY_block < 0) {
            offsetY_block = sqrt(-offsetY_block);
            CGFloat duration = offsetY_block / 100;
            [UIView animateWithDuration:duration delay:0.f options:(UIViewAnimationOptionCurveLinear) animations:^{
                [self.contentScrollView setContentOffset:CGPointMake(0, -offsetY_block)];
            } completion:^(BOOL finished) {
                offsetY_block = 0;
                [UIView animateWithDuration:0.75f delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:5.f options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                    [self.contentScrollView setContentOffset:CGPointMake(0, offsetY_block)];
                } completion:nil];
            }];
        } else if (offsetY_block > self.contentScrollView.contentSize.height - self.contentScrollView.sl_height) {
            offsetY_block = sqrt(offsetY_block - (self.contentScrollView.contentSize.height - self.contentScrollView.sl_height)) + self.contentScrollView.contentSize.height - self.contentScrollView.sl_height;
            CGFloat duration = (offsetY_block - self.contentScrollView.contentSize.height + self.contentScrollView.sl_height) / 100;
            [UIView animateWithDuration:duration delay:0.f options:(UIViewAnimationOptionCurveLinear) animations:^{
                [self.contentScrollView setContentOffset:CGPointMake(0, offsetY_block)];
            } completion:^(BOOL finished) {
                offsetY_block = self.contentScrollView.contentSize.height - self.contentScrollView.sl_height;
                [UIView animateWithDuration:0.75f delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:5.f options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                    [self.contentScrollView setContentOffset:CGPointMake(0, offsetY_block)];
                } completion:nil];
            }];
        }
    } else {
        [self.contentScrollView setContentOffset:CGPointMake(0, offsetY) animated:NO];
    }
}

#pragma mark - <BTHorScreenViewDelegate>

- (void)horScreenView_didCickSegmentWithDataType:(SLStockLineDataType)dataType {
    if (self.kLineDataType == dataType) {
        return;
    }
    self.kLineDataType = dataType;
    
    [self.lineChartView changeDataType:dataType];
    
    [self requestAndUpdateLineChartViewWithKLineDataType:dataType];
}

- (void)scrollHorScreenViewVerticallyWithOffsetY:(CGFloat)offsetY isEnd:(BOOL)isEnd {
    [self scrollVerticallyWithOffsetY:offsetY isEnd:isEnd];
}

- (void)horScreenViewDidClickCancelView:(BTHorScreenView *)screenView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    for (UIView *view in screenView.subviews) {
        [view removeFromSuperview];
    }
    [screenView removeFromSuperview];
    self.lineChartView.hasShowScreen = NO;
}

- (void)scrollVerticallyWithOffsetY:(CGFloat)offsetY isEnd:(BOOL)isEnd {
    CGFloat pointY = self.contentScrollView.contentOffset.y;
    self.contentScrollView.contentOffset = CGPointMake(0, pointY - offsetY);
    
    if (isEnd && pointY < -64) {
        [self.contentScrollView setContentOffset:CGPointMake(0, -64) animated:YES];
    }
}


- (void)dealloc {
    [SLNoteCenter removeObserver:self];
}

@end
