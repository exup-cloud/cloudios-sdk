//
//  BTBidAskView.m
//  BTStore
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTBidAskView.h"
#import "BTDetailBidAskCell.h"

@interface BTBidAskView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *bidAskHeaderView;
@end

@implementation BTBidAskView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = MAIN_COLOR;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.scrollEnabled = YES;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[BTDetailBidAskCell class] forCellReuseIdentifier:@"BTDetailBidAskCell"];
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)updataBidAskDataArr:(NSMutableArray *)dataArr {
    self.dataArr = dataArr;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTDetailBidAskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTDetailBidAskCell"];
    cell.cellModel = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.bidAskHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIView *)bidAskHeaderView {
    if (_bidAskHeaderView == nil) {
        _bidAskHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, 36)];
        _bidAskHeaderView.backgroundColor = DARK_BARKGROUND_COLOR;
        UILabel *bidLabel = [self creatLabel];
        bidLabel.text = Launguage(@"b");
        [bidLabel sizeToFit];
        bidLabel.sl_x = SL_MARGIN;
        bidLabel.sl_centerY = _bidAskHeaderView.sl_height * 0.5;
        [_bidAskHeaderView addSubview:bidLabel];
        NSString *f_code = @"";
        NSString *l_code = @"";
        if (self.itemModel.instrument_id > 0) {
            f_code = self.itemModel.contractInfo.base_coin;
            l_code = self.itemModel.contractInfo.margin_coin;
        } else {
            NSArray *arr = [self.itemModel.symbol componentsSeparatedByString:@"/"];
            if (arr.count == 2) {
                f_code = arr[0];
                l_code = arr[1];
            }
        }
        UILabel *b_num = [self creatLabel];
        b_num.text = [NSString stringWithFormat:@"%@(%@)", Launguage(@"BT_MAIN_V"), f_code];
        [b_num sizeToFit];
        b_num.sl_x = CGRectGetMaxX(bidLabel.frame) + SL_MARGIN;
        b_num.sl_centerY = _bidAskHeaderView.sl_height * 0.5;
        [_bidAskHeaderView addSubview:b_num];
        
        UILabel *priceLabel = [self creatLabel];
        priceLabel.text = [NSString stringWithFormat:@"%@(%@)", Launguage(@"BT_MAIN_P"), l_code];
        [priceLabel sizeToFit];
        priceLabel.sl_centerX = _bidAskHeaderView.sl_width * 0.5;
        priceLabel.sl_centerY = _bidAskHeaderView.sl_height * 0.5;
        [_bidAskHeaderView addSubview:priceLabel];
        
        UILabel *askLabel = [self creatLabel];
        [_bidAskHeaderView addSubview:askLabel];
        askLabel.text = Launguage(@"s");
        [askLabel sizeToFit];
        askLabel.sl_x = self.sl_width - SL_MARGIN - askLabel.sl_width;
        askLabel.sl_centerY = _bidAskHeaderView.sl_height * 0.5;
        [_bidAskHeaderView addSubview:askLabel];
        
        UILabel *s_num = [self creatLabel];
        s_num.text = [NSString stringWithFormat:@"%@(%@)", Launguage(@"BT_MAIN_V"), f_code];
        [s_num sizeToFit];
        s_num.sl_x = askLabel.sl_x - SL_MARGIN - s_num.sl_width;
        s_num.sl_centerY = _bidAskHeaderView.sl_height * 0.5;
        [_bidAskHeaderView addSubview:s_num];
        
        [self addSubview:_bidAskHeaderView];
    }
    return _bidAskHeaderView;
}

- (UILabel *)creatLabel {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = DARK_BARKGROUND_COLOR;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = GARY_BG_TEXT_COLOR;
    return label;
}

@end
