//
//  BTFuturesBottomView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTFuturesBottomView.h"
#import "BTBidAskView.h"
#import "BTBottomLineView.h"
#import "BTSegment.h"
#import "BTFuturesTableView.h"
#import "BTBidAskCellModel.h"
#import "BTDealBackCellModel.h"

@interface BTFuturesBottomView ()

@property (nonatomic, strong) BTBidAskView        * orderTableView;
@property (nonatomic, strong) BTFuturesTableView  * dealTableView;
@property (nonatomic, strong) BTBottomLineView    * depthLineView;
@property (nonatomic, strong) BTSegment           * segment;
@property (nonatomic, strong) NSArray             * dealDataArr;
@property (nonatomic, assign) NSInteger           currentIndex;
@property (nonatomic, strong) BTDepthModel        * depthModel;
@property (nonatomic, strong) NSMutableArray      * trades;

@end

@implementation BTFuturesBottomView

static NSString * const reuseID = @"BTDealBackCell";
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        __weak typeof(self) weakSelf = self;
        // 默认高度是60
        self.segment = [[BTSegment alloc] initWithTitles:@[@"委托", @"成交", @"深度"] height:40 font:[UIFont systemFontOfSize:14] didClickAction:^(UIButton *button,NSInteger index) {
            switch (button.tag) {
                case 0:
                    weakSelf.orderTableView.hidden = NO;
                    weakSelf.dealTableView.hidden = YES;
                    weakSelf.depthLineView.hidden = YES;
                    break;
                case 1:
                    weakSelf.orderTableView.hidden = YES;
                    weakSelf.dealTableView.hidden = NO;
                    weakSelf.depthLineView.hidden = YES;
                    [weakSelf loadNewTrades];
                    break;
                case 2:
                    weakSelf.orderTableView.hidden = YES;
                    weakSelf.dealTableView.hidden = YES;
                    weakSelf.depthLineView.hidden = NO;
                    weakSelf.depthLineView.depthModel = weakSelf.depthModel;
                    break;
                default:
                    break;
            }
            weakSelf.currentIndex = button.tag;
        }];
        [self addSubview:self.segment];
        [self addSubview:self.dealTableView];
        [self addSubview:self.depthLineView];
        [self addSubview:self.orderTableView];
    }
    return self;
}

- (void)setItemModel:(BTItemModel *)itemModel {
     _itemModel = itemModel;
    if (self.currentIndex == 0) {
        self.orderTableView.itemModel = itemModel;
        [self loadEntrustOrder];
    } else if (self.currentIndex == 1) {
        [self loadNewTrades];
    } else if (self.currentIndex == 2) {
        [self loadEntrustOrder];
    }
}


#pragma mark - loadData

/// 获取委托订单
- (void)loadEntrustOrder {
    __weak BTFuturesBottomView *weakSelf = self;
    [BTContractTool getContractDeapthWithContractID:_itemModel.instrument_id price:_itemModel.last_px count:20 success:^(BTDepthModel *depth) {
        weakSelf.depthModel = depth;
        if (weakSelf.currentIndex == 0) {
             [weakSelf handleFlushBidAskResponse:depth];
        } else if (weakSelf.currentIndex == 2) {
            weakSelf.depthLineView.depthModel = depth;
        }
    } failure:^(NSError *error) {
    }];
}

- (void)handleFlushBidAskResponse:(BTDepthModel *)res{
    NSUInteger count = res.sells.count >= res.buys.count? res.sells.count:res.buys.count;
    if (count <= 0) {
        return;
    }

    NSMutableArray *arrMS = [NSMutableArray arrayWithCapacity:res.sells.count];
    for (BTContractOrderModel *model in res.sells) {
        if ([model.px LessThanOrEqual:[self.itemModel.last_px bigMul:@"1.5"]] && [model.px GreaterThanOrEqual:[self.itemModel.last_px bigMul:@"0.5"]]) {
            [arrMS addObject:model];
        }
    }
    res.sells = arrMS.copy;
    __block NSString *sellMax = @"0";
    res.sells = [res.sells sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        BTContractOrderModel *item1 = obj1;
        BTContractOrderModel *item2 = obj2;
        if ([item1.qty GreaterThan:sellMax]) {
            sellMax = item1.qty;
        }
        if ([item2.qty GreaterThan:sellMax]) {
            sellMax = item2.qty;
        }
        if ([item1.px GreaterThan:item2.px]) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:res.buys.count];
    for (BTContractOrderModel *model in res.buys) {
        if ([model.px LessThanOrEqual:[self.itemModel.last_px bigMul:@"1.5"]] && [model.px GreaterThanOrEqual:[self.itemModel.last_px bigMul:@"0.5"]]) {
            [arrM addObject:model];
        }
    }
    res.buys = arrM.copy;
    __block NSString *buyMax = @"0";
    res.buys = [res.buys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        BTContractOrderModel *item1 = obj1;
        BTContractOrderModel *item2 = obj2;
        if ([item1.qty GreaterThan:buyMax]) {
            buyMax = item1.qty;
        }
        if ([item2.qty GreaterThan:buyMax]) {
            buyMax = item2.qty;
        }
        if ([item1.px GreaterThan:item2.px]) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    self.depthModel = res;
    NSArray * buys = [[res.buys reverseObjectEnumerator] allObjects];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; ++i) {
        BTBidAskCellModel *model = [[BTBidAskCellModel alloc] init];
        model.instrument_id = _itemModel.instrument_id;
        model.index = i + 1;
        if (i < res.buys.count){
            BTContractOrderModel * buy = [buys objectAtIndex:i];
            model.bidPrice = [NSString stringWithFormat:@"%@",[buy.px toSmallPriceWithContractID:model.instrument_id]];
            model.bidNum = [NSString stringWithFormat:@"%@",[buy.qty toSmallVolumeWithContractID:model.instrument_id]];
            model.bidLength = [[buy.qty bigDiv:buyMax] doubleValue];
        } else{
            model.bidPrice = @"--";
            model.bidNum = @"--";
        }
        if (i < res.sells.count) {
            BTContractOrderModel * sell = [res.sells objectAtIndex:i];
            model.askPrice = [NSString stringWithFormat:@"%@",[sell.px toSmallPriceWithContractID:model.instrument_id]];
            model.askNum = [NSString stringWithFormat:@"%@",[sell.qty toSmallVolumeWithContractID:model.instrument_id]];
            model.askLength = [[sell.qty bigDiv:sellMax] doubleValue];
        } else {
            model.askPrice = @"--";
            model.askNum = @"--";
        }
        
        [mArr addObject:model];
    }
    NSArray *arr;
    if (arrM.count > 10) {
        arr = [mArr subarrayWithRange:NSMakeRange(0, 10)];
    } else {
        arr = mArr.copy;
    }
    [_orderTableView updataBidAskDataArr:arr.copy];
}

/// 获取最新成交数据
- (void)loadNewTrades {
    __weak BTFuturesBottomView *weakSelf = self;
    [BTContractTool getContractRecordWithContractID:_itemModel.instrument_id success:^(NSArray<BTContractTradeModel *> *trades) {
        [weakSelf updateViewWithTradesArray:trades];
        weakSelf.trades = [NSMutableArray arrayWithArray:trades];
    } failure:^(NSError *error) {
        SLLog(@"error:%@",error);
    }];
}

/// 更新最新成交
/// @param trades socket 返回的最新成交数据
- (void)updateViewWithNewTradesArray:(NSArray <BTContractTradeModel *> *)trades {
    if (self.currentIndex != 1) {
        return;
    }
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, trades.count)];
    [self.trades insertObjects:trades atIndexes:indexes];
    [self updateViewWithTradesArray:self.trades];
}

/// 更新最新深度数据
- (void)updateViewWithNewBuysArray:(NSArray <BTContractOrderModel *> *)buys sellsArray:(NSArray <BTContractOrderModel *> *)sells {
    if (buys.count > 0) {
        self.depthModel.buys = buys;
    }
    if (sells.count > 0) {
        self.depthModel.sells = sells;
    }
    if (self.currentIndex == 0) {
        [self handleFlushBidAskResponse:self.depthModel];
    } else if (self.currentIndex == 2) {
        self.depthLineView.depthModel = self.depthModel;
    }
}

- (void)updateViewWithTradesArray:(NSArray<BTContractTradeModel *> *)trades {
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:trades.count];
    for (BTContractTradeModel *tradeModel in trades) {
        BTDealBackCellModel *model = [[BTDealBackCellModel alloc] init];
        model.time = [BTFormat date2localTimeStr:[BTFormat dateFromUTCString:tradeModel.created_at] format:DATE_FORMAT_Hms];
        model.price = tradeModel.px;
        model.volume = tradeModel.qty;
        model.recordWay = tradeModel.side;
        model.contract_id = tradeModel.instrument_id;
        [arrM addObject:model];
    }
    NSArray *arr;
    if (arrM.count > 10) {
        arr = [arrM subarrayWithRange:NSMakeRange(0, 10)];
    } else {
        arr = arrM.copy;
    }
    [_dealTableView loadFuturesTableWithDataArray:arr];
}


#pragma mark - lazy

- (BTBidAskView *)orderTableView {
    if (_orderTableView == nil) {
        _orderTableView = [[BTBidAskView alloc] initWithFrame:CGRectMake(0, 40, SL_SCREEN_WIDTH, self.sl_height - 40) style:UITableViewStylePlain];
    }
    return _orderTableView;
}

- (BTFuturesTableView *)dealTableView {
    if (_dealTableView == nil) {
        _dealTableView = [[BTFuturesTableView alloc] initWithFrame:CGRectMake(0, 40, SL_SCREEN_WIDTH, self.sl_height - 40) style:UITableViewStylePlain];
    }
    return _dealTableView;
}

- (BTBottomLineView *)depthLineView {
    if (_depthLineView == nil) {
        _depthLineView = [[BTBottomLineView alloc] initWithFrame:CGRectMake(0, 40, self.sl_width, self.sl_height - 40)];
        _depthLineView.hidden = YES;
        _depthLineView.backgroundColor = MAIN_COLOR;
        _depthLineView.font = [UIFont systemFontOfSize:10];
    }
    return _depthLineView;
}

- (BTDepthModel *)depthModel {
    if (_depthModel == nil) {
        _depthModel = [[BTDepthModel alloc] init];
    }
    return _depthModel;
}


- (void)dealloc {
    [SLNoteCenter removeObserver:self];
}

@end
