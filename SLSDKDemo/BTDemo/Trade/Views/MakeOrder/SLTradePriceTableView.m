//
//  SLTradePriceTableView.m
//  BTTest
//
//  Created by wwly on 2019/8/28.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLTradePriceTableView.h"
#import "SLTradePriceCell.h"

@interface SLTradePriceTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray * dataArray;

/// 最多显示的数据条数
@property (nonatomic, assign) NSUInteger maxDataCount;

@property (nonatomic, assign) CGFloat max_volume;

@end

static NSString * const reuseID = @"SLTradePriceCell_ID";

@implementation SLTradePriceTableView {
    CGFloat _cellHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 目前写死显示 7 条数据
        self.maxDataCount = 7;
        _cellHeight = self.sl_height / self.maxDataCount;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = MAIN_COLOR;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scrollEnabled = NO;
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[SLTradePriceCell class] forCellReuseIdentifier:reuseID];
}


#pragma mark - 视图更新

- (void)updateViewWithModelArray:(NSArray <BTContractOrderModel *> *)dataArray decimalType:(BTDepthPriceDecimalType)decimalType {
    // 降序排列
    self.dataArray = [Common sequenceWithDepthPriceArr:dataArray.mutableCopy Way:self.orderWay];
    
    if (self.dataArray.count > self.maxDataCount) {
        // 取出 7 条数据
        if (self.orderWay == BTOrderWayBuy) {
            self.dataArray = [self.dataArray subarrayWithRange:NSMakeRange(0, self.maxDataCount)];
        } else if (self.orderWay == BTOrderWaySell) {
            // 卖盘要反着取
            self.dataArray = [self.dataArray subarrayWithRange:NSMakeRange(self.dataArray.count - self.maxDataCount, self.maxDataCount)];
        }
    }
    
    // 对数据进行精度处理
    self.dataArray = [Common loadDataWithArray:self.dataArray decimalType:decimalType Way:self.orderWay];
    
    self.max_volume = [[self.dataArray valueForKeyPath:@"qty.@max.doubleValue"] doubleValue];

    if (self.dataArray.count < self.maxDataCount) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.dataArray];
        for (int i = 0; i < self.maxDataCount - self.dataArray.count; ++i) {
            BTContractOrderModel *model = [[BTContractOrderModel alloc] init];
            model.px = @"0";
            model.qty = @"0";
            if (self.orderWay == BTOrderWayBuy) {
                model.side = BTContractOrderWayBuy_OpenLong;
                [mArr addObject:model];
            } else if (self.orderWay == BTOrderWaySell) {
                model.side = BTContractOrderWaySell_OpenShort;
                [mArr insertObject:model atIndex:0];
            }
        }
        self.dataArray = mArr.copy;
    }
    
    [self reloadData];
}


#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLTradePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    BTContractOrderModel *model = self.dataArray[indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] init];
    if (self.orderWay == BTOrderWayBuy) {
        cell.selectedBackgroundView.backgroundColor = [UP_WARD_COLOR colorWithAlphaComponent:0.5];
    } else if (self.orderWay == BTOrderWaySell) {
        cell.selectedBackgroundView.backgroundColor = [DOWN_COLOR colorWithAlphaComponent:0.5];
    }
    if (self.orderWay == BTOrderWayBuy) {
        model.side = BTContractOrderWayBuy_OpenLong;
    } else if (self.orderWay == BTOrderWaySell) {
        model.side = BTContractOrderWaySell_OpenShort;
    }
    model.max_volume = [NSString stringWithFormat:@"%f",self.max_volume];
    [cell updateViewWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.cus_delegate respondsToSelector:@selector(tableView_didSelectCellWithModel:)]) {
        [self.cus_delegate tableView_didSelectCellWithModel:self.dataArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
