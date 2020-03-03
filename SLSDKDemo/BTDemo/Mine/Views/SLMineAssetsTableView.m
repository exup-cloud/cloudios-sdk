//
//  SLMineAssetsTableView.m
//  BTTest
//
//  Created by WWLy on 2019/9/16.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMineAssetsTableView.h"
#import "SLMineAssetsHeaderView.h"
#import "SLMineAssetsCell.h"

@interface SLMineAssetsTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SLMineAssetsHeaderView * headerView;

@property (nonatomic, strong) NSArray <BTItemCoinModel *> * itemCoinModelArray;

@end

static NSString *const cellReuseID = @"SLMineAssetsCell_ID";

@implementation SLMineAssetsTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    [self registerClass:[SLMineAssetsCell class] forCellReuseIdentifier:cellReuseID];
    self.showsHorizontalScrollIndicator = NO;
    self.tableHeaderView = self.headerView;
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - Update Data

- (void)updateViewWithItemCoinModelArray:(NSArray<BTItemCoinModel *> *)itemCoinModelArray {
    SLMinePerprotyModel *model = [SLMinePerprotyModel sharedInstance];
    [model conversionContractAssetsWithCoin:@"USDT" property:itemCoinModelArray];
    [self.headerView updateViewWithPerprotyModel:model];
    self.itemCoinModelArray = itemCoinModelArray;
    [self reloadData];
}


#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemCoinModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLMineAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SLMinePerprotyModel *model = [[SLMinePerprotyModel alloc] init];
    [model conversionContractAssetsWithitemModel:self.itemCoinModelArray[indexPath.row]];
    [cell updateViewWithPerprotyModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 166;
}


#pragma mark - lazy load

- (SLMineAssetsHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[SLMineAssetsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.sl_width, 160)];
    }
    return _headerView;
}

@end
