//
//  BTCommTableView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTCommTableView.h"
#import "BTIndexDetailCell.h"
#import "BTIndexDetailHeaderView.h"

@interface BTCommTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation BTCommTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = MAIN_COLOR;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = YES;
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = SL_getWidth(40);
        [self registerClass:[BTIndexDetailCell class] forCellReuseIdentifier:@"BTIndexDetailCell"];
    }
    return self;
}

- (void)loadWithDataArray:(NSArray *)dataArr {
    self.dataArr = dataArr;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTIndexDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTIndexDetailCell"];
    cell.type = self.type;
    BTIndexDetailModel *model = self.dataArr[indexPath.row];
    if (self.unit) {
        model.unit = self.unit;
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BTIndexDetailHeaderView *headerView = [[BTIndexDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_getWidth(40))];
    headerView.str1 = Launguage(@"BT_GLO_DT");
    if (self.type == 1) {
        headerView.str3 = Launguage(@"str_balance_insurance_fund");
    } else {
        headerView.str2 = Launguage(@"str_funds_rate_interval");
        headerView.str3 = Launguage(@"BT_CA_ZJFL");
    }
    return headerView;
}

- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

@end
