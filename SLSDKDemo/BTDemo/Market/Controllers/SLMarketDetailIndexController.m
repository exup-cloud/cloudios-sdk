//
//  SLMarketDetailIndexController.m
//  BTDemo_Test
//
//  Created by wwly on 2019/10/21.
//  Copyright © 2019 SL. All rights reserved.
//

#import "SLMarketDetailIndexController.h"
#import "BTIndexDetailView.h"
#import "BTQuoteChangeView.h"
#import "BTIndexDetailBottomView.h"
#import "BTVcTitleView.h"

@interface SLMarketDetailIndexController () <BTIndexDetailBottomViewDelegate>

@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) BTIndexDetailView *headerView;
@property (nonatomic, strong) BTQuoteChangeView *quoteChangeViewMin;
@property (nonatomic, strong) BTQuoteChangeView *quoteChangeViewDay;
@property (nonatomic, strong) BTIndexDetailBottomView *bottomView;

@property (nonatomic, strong) BTVcTitleView *vcTitleView;

@end

@implementation SLMarketDetailIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    
    [self setCustomTitleView:self.vcTitleView];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, self.view.sl_height - SL_SafeAreaTopHeight)];
    self.contentScrollView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    [self.contentScrollView addSubview:self.headerView];
    [self.contentScrollView addSubview:self.quoteChangeViewMin];
    [self.contentScrollView addSubview:self.quoteChangeViewDay];
    [self.contentScrollView addSubview:self.bottomView];
    self.contentScrollView.contentSize = CGSizeMake(SL_SCREEN_WIDTH, CGRectGetMaxY(self.bottomView.frame));
    [self.view addSubview:self.contentScrollView];
}

- (void)setItemModel:(BTItemModel *)itemModel {
    _itemModel = itemModel;
    self.title = [NSString stringWithFormat:@"BBX - %@",itemModel.name];
    NSMutableArray *headerArr = [NSMutableArray arrayWithCapacity:3];
    NSString *value = itemModel.position_size;
    value = value?[value toSmallVolumeWithContractID:itemModel.instrument_id]:@"--";
    NSString *volume = [BTFormat totalVolumeFromNumberStr:itemModel.qty_day];
    NSDictionary *data1 = @{@"first": Launguage(@"str_open_interest"), @"last": value, @"unit": @"张"};
    NSDictionary *data2 = @{@"first": Launguage(@"BT_MAR_CJL"), @"last": volume};
    NSString *hsb = [itemModel.qty_day bigDiv:value];
    NSDictionary *data3 = @{@"first":Launguage(@"str_turn_rate"), @"last":hsb};
    
    [headerArr addObject:data1];
    [headerArr addObject:data2];
    [headerArr addObject:data3];
    self.headerView.dataArr = headerArr.copy;
    [self.quoteChangeViewMin loadDataWithHigh:_itemModel.high low:_itemModel.low open:_itemModel.open close:_itemModel.close currentPrice:_itemModel.last_px];
    [self loadMonthItemModelWithItemModel:_itemModel];
    
    [self loadNetDataWithItemModel:_itemModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)loadMonthItemModelWithItemModel:(BTItemModel *)model {
    __weak typeof(self) weakSelf = self;
    [BTMaskFutureTool getMonthDataWithContractID:model.instrument_id success:^(BTItemModel *itemModel) {
         [weakSelf.quoteChangeViewDay loadDataWithHigh:itemModel.high low:itemModel.low open:model.open close:model.close currentPrice:itemModel.last_px];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

#pragma mark - delegate

- (void)indexDetailBottomDidClickIndex:(NSInteger)index {
    if (index == 0) {
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.quoteChangeViewDay.frame)+8, SL_SCREEN_WIDTH, SL_getWidth(250));
    } else if (index == 1) {
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.quoteChangeViewDay.frame)+8, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - SL_SafeAreaTopHeight - SL_getWidth(40));
    } else {
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.quoteChangeViewDay.frame)+8, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - SL_SafeAreaTopHeight - SL_getWidth(40));
    }
    self.contentScrollView.contentSize = CGSizeMake(SL_SCREEN_WIDTH, CGRectGetMaxY(self.bottomView.frame));
}

#pragma mark - loadNetData

- (void)loadNetDataWithItemModel:(BTItemModel *)itemModel {
    __weak typeof(self) weakSelf = self;
    [BTMaskFutureTool getIndexesInfoWithIndexId:itemModel.contractInfo.index_id success:^(NSString *str) {
        itemModel.index_market = str;
        weakSelf.bottomView.itemModel = itemModel;
    } failure:^(NSError *error) {
        weakSelf.bottomView.itemModel = itemModel;
    }];
}

#pragma mark - lazy
- (BTIndexDetailView *)headerView {
    if (_headerView == nil) {
        _headerView = [[BTIndexDetailView alloc] initWithFrame:CGRectMake(0, 0.5, SL_SCREEN_WIDTH, SL_getWidth(145)) number:3 hasHeader:Launguage(@"str_base_info")];
    }
    return _headerView;
}

- (BTQuoteChangeView *)quoteChangeViewMin {
    if (_quoteChangeViewMin == nil) {
        _quoteChangeViewMin = [[BTQuoteChangeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + 8, SL_SCREEN_WIDTH, SL_getWidth(120)) title:Launguage(@"str_volatility_interval")];
    }
    return _quoteChangeViewMin;
}

- (BTQuoteChangeView *)quoteChangeViewDay {
    if (_quoteChangeViewDay == nil) {
        _quoteChangeViewDay = [[BTQuoteChangeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.quoteChangeViewMin.frame), SL_SCREEN_WIDTH, SL_getWidth(120)) title:Launguage(@"str_volatility_interval_30days")];
    }
    return _quoteChangeViewDay;
}

- (BTIndexDetailBottomView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[BTIndexDetailBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.quoteChangeViewDay.frame)+8, SL_SCREEN_WIDTH, SL_getWidth(250))];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (BTVcTitleView *)vcTitleView {
    if (_vcTitleView == nil) {
        _vcTitleView = [[BTVcTitleView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight - 44, SL_SCREEN_WIDTH * 0.6, 44)];
        _vcTitleView.itemModel = self.itemModel;
        [_vcTitleView sizeToFit];
        _vcTitleView.sl_centerY = SL_getWidth(20);
        _vcTitleView.sl_centerX = SL_SCREEN_WIDTH * 0.5;
    }
    return _vcTitleView;
}


@end
