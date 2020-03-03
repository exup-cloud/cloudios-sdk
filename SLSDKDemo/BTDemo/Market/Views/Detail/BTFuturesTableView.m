//
//  BTFuturesTableView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/27.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTFuturesTableView.h"
#import "BTDealBackCell.h"
#import "BTFuturesBottomHeaderView.h"

@interface BTFuturesTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation BTFuturesTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = MAIN_COLOR;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = NO;
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 35;
        [self registerClass:[BTDealBackCell class] forCellReuseIdentifier:@"BTDealBackCell"];
    }
    return self;
}

- (void)loadFuturesTableWithDataArray:(NSArray *)dataArr {
    self.dataArr = dataArr;
    [self reloadData];
    self.contentSize = CGSizeMake(0, self.dataArr.count * 40);
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTDealBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTDealBackCell"];
    cell.type = 1;
    if (!cell) {
        cell = [[BTDealBackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTDealBackCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 35;
    }
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BTFuturesBottomHeaderView *headerView = [[BTFuturesBottomHeaderView alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, 36) titleArr:@[@"时间", [NSString stringWithFormat:@"%@(USDT)",@"价格"], [NSString stringWithFormat:@"%@(%@)",@"成交量",@"张"], @"开平"]];
    return headerView;
}

#pragma mark - lazy

- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
@end
