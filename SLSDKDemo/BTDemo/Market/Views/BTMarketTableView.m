//
//  BTMarketTableView.m
//  SLContractSDK
//
//  Created by wwly on 2019/8/13.
//  Copyright © 2019 Karl. All rights reserved.
//

#import "BTMarketTableView.h"
#import "BTMarketHeaderView.h"
#import "BTMarketFuturesCell.h"

@interface BTMarketTableView () <UITableViewDelegate, UITableViewDataSource, BTMarketHeaderViewDelegate>

@property (nonatomic, strong) BTMarketHeaderView * headerView;

@property (nonatomic, strong) NSArray <BTItemModel *> * itemModelArray;

@property (nonatomic, strong) UIView * gradientView;

@end

static NSString *const reuseID = @"BTMarketFuturesCell_ID";

@implementation BTMarketTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self p_requestData];
    }
    return self;
}

- (void)initUI {
    
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.estimatedRowHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.showsHorizontalScrollIndicator = NO;
    [self registerClass:[BTMarketFuturesCell class] forCellReuseIdentifier:reuseID];
}

- (void)p_requestData {
    [SMProgressHUD showHUD];
    [SLSDK sl_loadFutureMarketData:^(id result, NSError *error) {
        [SMProgressHUD hideHUD];
        if (result) {
            SLLog(@"---- result: %@", result);
            if ([result isKindOfClass:[NSArray class]]) {
                self.itemModelArray = [BTMaskFutureTool shareMaskFutureTool].futureArr;
                [self reloadData];
            }
        } else {
            
        }
    }];
}


- (void)updateViewWithItemModel:(BTItemModel *)itemModel {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.itemModelArray];
    for (int i = 0; i < mArr.count; ++i) {
        BTItemModel *model = mArr[i];
        if (model.instrument_id == itemModel.instrument_id) {
            BTMarketFuturesCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            itemModel.hasCollect = cell.itemModel.hasCollect;
            [mArr replaceObjectAtIndex:i withObject:itemModel];
            [BTMaskFutureTool replayItemModel:itemModel];
            [cell updateViewWithModel:itemModel];
            break;
        }
    }
}


#pragma mark - <BTMarketHeaderViewDelegate>

- (void)headerView_sortTypeChanged:(BTSortType)sortType {
    [self p_sortModelArrayWithSortType:sortType];
}

- (void)p_sortModelArrayWithSortType:(BTSortType)sortType {
    NSMutableArray *mArr = self.itemModelArray.mutableCopy;
    if (sortType == BTSortTypeDefault) {
        [mArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
            if ([obj1 isKindOfClass:[BTItemModel class]] ) {
                BTItemModel *item1 = (BTItemModel *)obj1;
                BTItemModel *item2 = (BTItemModel *)obj2;
                if ([item1.collectTime integerValue] >= [item2.collectTime integerValue]) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
            }
            return 0;
        }];
    } else {
        [mArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
            if ([obj1 isKindOfClass:[BTItemModel class]] ) {
                BTItemModel *item1 = (BTItemModel *)obj1;
                BTItemModel *item2 = (BTItemModel *)obj2;
                switch (sortType) {
                    case BTSortTypePriceAscending: {
                        if (item1.last_px.doubleValue <  item2.last_px.doubleValue) {
                            return NSOrderedAscending;
                        } else {
                            return NSOrderedDescending;
                        }
                    }
                        break;
                    case BTSortTypePriceDescending: {
                        if (item1.last_px.doubleValue <  item2.last_px.doubleValue) {
                            return NSOrderedDescending;
                        } else {
                            return NSOrderedAscending;
                        }
                    }
                        break;
                    case BTSortTypeGainAscending: {
                        if (item1.change_rate.doubleValue <  item2.change_rate.doubleValue) {
                            return NSOrderedAscending;
                        } else {
                            return NSOrderedDescending;
                        }
                    }
                        break;
                    case BTSortTypeGainDescending: {
                        if (item1.change_rate.doubleValue <  item2.change_rate.doubleValue) {
                            return NSOrderedDescending;
                        } else {
                            return NSOrderedAscending;
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
            return 0;
        }];
    }
    self.itemModelArray = mArr.copy;
    [self reloadData];
}


#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTMarketFuturesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateViewWithModel:self.itemModelArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SL_getHeightKeepWHAspectAndWidthEqualScreenW(70.f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BTItemModel *itemModel = self.itemModelArray[indexPath.row];
    if ([self.marketTableView_delegate respondsToSelector:@selector(marketTableView_didSelectCell:)]) {
        [self.marketTableView_delegate marketTableView_didSelectCell:itemModel];
    }
}


#pragma mark - lazy load

- (BTMarketHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[BTMarketHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.sl_width, 30)];
        _headerView.delegate = self;
    }
    return _headerView;
}

@end
