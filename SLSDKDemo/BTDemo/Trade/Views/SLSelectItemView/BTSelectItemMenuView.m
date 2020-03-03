//
//  BTSelectItemMenuView.m
//  GGEX_Appstore//
//  Created by 健 王 on 2018/11/5.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTSelectItemMenuView.h"
#import "BTSelectedItemCell.h"

@interface BTSelectItemMenuView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *btnArr;
@property (nonatomic, strong) UITableView *itemTableView;
@property (nonatomic, strong) NSArray *itemArr;
@end

@implementation BTSelectItemMenuView

- (instancetype)initWithFrame:(CGRect)frame btnArr:(NSArray *)btnArr {
    if (self = [super initWithFrame:frame]) {
        self.btnArr = btnArr;
        [self addChildViewsWithArray:btnArr];
    }
    return self;
}

- (void)addChildViewsWithArray:(NSArray *)arr {
    self.backgroundColor = DARK_BARKGROUND_COLOR;
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.btnArr.count];
    for (int i = 0; i < self.btnArr.count; i++) {
        UIButton *btn = [self createBtn];
        btn.frame = CGRectMake(0, i * SL_getWidth(40), SL_getWidth(100), SL_getWidth(45));
        btn.tag = i;
        [btn setTitle:self.btnArr[i] forState:UIControlStateNormal];
        [arrM addObject:btn];
    }
    self.btnArr = arrM.copy;
    self.itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(SL_getWidth(100), 0, SL_SCREEN_WIDTH - SL_getWidth(100), self.sl_height) style:UITableViewStylePlain];
    self.itemTableView.backgroundColor = MAIN_COLOR;
    self.itemTableView.delegate = self;
    self.itemTableView.dataSource = self;
    [self.itemTableView registerClass:[BTSelectedItemCell class] forCellReuseIdentifier:@"selectItemCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.itemTableView.rowHeight = SL_getWidth(40);
    [self addSubview:self.itemTableView];
}

- (void)setItemModel:(BTItemModel *)itemModel {
    _itemModel = itemModel;
    UIButton *btn = nil;
    BTContractsModel *contract = itemModel.contractInfo;
    if (contract.area == CONTRACT_BLOCK_USDT) {
        btn = self.btnArr[0];
    } else if (contract.area == CONTRACT_BLOCK_INVERSE)  { // 币本位
        btn = self.btnArr[1];
    } else if (contract.area == CONTRACT_BLOCK_SIMULATION) {
        if (self.btnArr.count > 2) {
            btn = self.btnArr[2];
        }
    }
    [self didClickBtn:btn];
}

- (void)didClickBtn:(UIButton *)sender {
    sender.selected = YES;
    [sender setBackgroundColor:MAIN_COLOR];
    if (sender.tag == 0) {
        UIButton *btn1 = self.btnArr[1];
        UIButton *btn2 ;
        if (self.btnArr.count > 2) {
            btn2 = self.btnArr[2];
        }
        [btn1 setBackgroundColor:DARK_BARKGROUND_COLOR];
        [btn2 setBackgroundColor:DARK_BARKGROUND_COLOR];
        btn1.selected = NO;
        btn2.selected = NO;
        if (self.btnArr.count == 4) {
            UIButton *btn3 = self.btnArr[3];
            btn3.selected = NO;
            [btn3 setBackgroundColor:DARK_BARKGROUND_COLOR];
        }
        self.itemArr = [BTMaskFutureTool shareMaskFutureTool].USDTArr;
    } else if (sender.tag == 1) {
        UIButton *btn = self.btnArr[0];
        UIButton *btn2;
        if (self.btnArr.count > 2) {
            btn2 = self.btnArr[2];
        }
        btn.selected = NO;
        btn2.selected = NO;
        if (self.btnArr.count == 4) {
            UIButton *btn3 = self.btnArr[3];
            btn3.selected = NO;
            [btn3 setBackgroundColor:DARK_BARKGROUND_COLOR];
        }
        [btn setBackgroundColor:DARK_BARKGROUND_COLOR];
        [btn2 setBackgroundColor:DARK_BARKGROUND_COLOR];
        self.itemArr = [BTMaskFutureTool shareMaskFutureTool].standardArr;
    } else if (sender.tag == 2) {
        UIButton *btn = self.btnArr[0];
        btn.selected = NO;
        UIButton *btn1 = self.btnArr[1];
        btn1.selected = NO;
        [btn1 setBackgroundColor:DARK_BARKGROUND_COLOR];
        [btn setBackgroundColor:DARK_BARKGROUND_COLOR];
        self.itemArr = [BTMaskFutureTool shareMaskFutureTool].imitateArr;
    }
    [self.itemTableView reloadData];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTSelectedItemCell *cell = (BTSelectedItemCell *)[tableView dequeueReusableCellWithIdentifier:@"selectItemCell"];
    cell.backgroundColor = MAIN_COLOR;
    BTItemModel *itemModel = self.itemArr[indexPath.row];
    cell.title.text = itemModel.name;
    NSString *rate = [itemModel.change_rate toPercentString:2];
    if (itemModel.trend == BTPriceFluctuationUp) {
        cell.rate.textColor = UP_WARD_COLOR;
        rate = [NSString stringWithFormat:@"+%@",rate];
    } else {
        cell.rate.textColor = DOWN_COLOR;
    }
    if (itemModel.instrument_id == self.itemModel.instrument_id) {
        cell.title.textColor = MAIN_BTN_COLOR;
    } else {
        cell.title.textColor = MAIN_GARY_TEXT_COLOR;
    }
    
    cell.rate.text = rate;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BTItemModel *selectedItem = self.itemArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectItemDidClickSelected:)]) {
        [self.delegate selectItemDidClickSelected:selectedItem];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.sl_width, SL_getWidth(30))];
    [self.itemTableView addSubview:view];
    UILabel *label1 = [self createLabelWithTitle:Launguage(@"str_pairs") frame:CGRectMake(SL_MARGIN, SL_MARGIN * 0.5, view.sl_width *0.5 - SL_MARGIN, SL_getWidth(20))];
    [view addSubview:label1];
    UILabel *label2 = [self createLabelWithTitle:Launguage(@"BT_MAR_CH") frame:CGRectMake(CGRectGetMaxX(label1.frame), SL_MARGIN * 0.5, label1.sl_width, SL_getWidth(20))];
    label2.textAlignment = NSTextAlignmentRight;
    [view addSubview:label2];
    view.backgroundColor = MAIN_COLOR;
    return view;
}

- (NSArray *)btnArr {
    if (_btnArr == nil) {
        _btnArr = [NSArray array];
    }
    return _btnArr;
}

- (UIButton *)createBtn {
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:MAIN_GARY_TEXT_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
    [btn setBackgroundColor:MAIN_COLOR];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (NSArray *)itemArr {
    if (_itemArr == nil) {
        _itemArr = [NSArray array];
    }
    return _itemArr;
}

- (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = GARY_BG_TEXT_COLOR;
    return label;
}

@end
