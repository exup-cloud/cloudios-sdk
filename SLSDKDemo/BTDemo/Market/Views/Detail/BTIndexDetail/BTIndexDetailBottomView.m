//
//  BTIndexDetailBottomView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTIndexDetailBottomView.h"
#import "BTSegment.h"
#import "BTIndexDetailView.h"
#import "BTCommTableView.h"

@interface BTIndexDetailBottomView ()
@property (nonatomic, strong) BTSegment *segment;
@property (nonatomic, strong) BTIndexDetailView *baseInfoView;
@property (nonatomic, strong) BTCommTableView *insuranceFund;
@property (nonatomic, strong) BTCommTableView *fundRateView;
@end

@implementation BTIndexDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.backgroundColor = DARK_BARKGROUND_COLOR;
    __weak BTIndexDetailBottomView *weakSelf = self;
    self.segment = [[BTSegment alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_getWidth(40)) Titles:@[Launguage(@"str_contract_info"), Launguage(@"str_insurance_fund"), Launguage(@"BT_CA_ZJFL")] height:SL_getWidth(40) font:[UIFont systemFontOfSize:15] didClickAction:^(UIButton *btn, NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(indexDetailBottomDidClickIndex:)]) {
            [weakSelf.delegate indexDetailBottomDidClickIndex:index];
        }
        if (index == 0) {
            weakSelf.baseInfoView.hidden = NO;
            weakSelf.insuranceFund.hidden = YES;
            weakSelf.fundRateView.hidden = YES;
        } else if (index == 1) {
            weakSelf.baseInfoView.hidden = YES;
            weakSelf.insuranceFund.hidden = NO;
            weakSelf.insuranceFund.frame = CGRectMake(0, SL_getWidth(40), SL_SCREEN_WIDTH, self.sl_height - SL_getWidth(40));
            weakSelf.fundRateView.hidden = YES;
            [weakSelf loadInsuranceFund];
        } else {
            weakSelf.baseInfoView.hidden = YES;
            weakSelf.insuranceFund.hidden = YES;
            weakSelf.fundRateView.hidden = NO;
            weakSelf.fundRateView.frame = CGRectMake(0, SL_getWidth(40), SL_SCREEN_WIDTH, self.sl_height - SL_getWidth(40));
            [weakSelf loadFundRate];
        }
    }];
    [self addSubview:self.segment];
    [self addSubview:self.baseInfoView];
    [self addSubview:self.insuranceFund];
    [self addSubview:self.fundRateView];
}

- (void)setItemModel:(BTItemModel *)itemModel {
    _itemModel = itemModel;
    BTContractsModel *contract = itemModel.contractInfo;
    NSMutableArray *dataArrM = [NSMutableArray arrayWithCapacity:6];
    NSDictionary *data1 = @{@"first": Launguage(@"str_contract_base_coin"), @"last": contract.base_coin};
    NSDictionary *data2 = @{@"first": Launguage(@"str_margin_coin"), @"last": contract.margin_coin};
    NSDictionary *data3 = @{@"first": Launguage(@"str_contract_property"), @"last": contract.is_reverse ? Launguage(@"str_reserve_contract") : Launguage(@"str_positive_contract")};
    NSDictionary *data4 = @{@"first": Launguage(@"str_contract_size"), @"last": [NSString stringWithFormat:@"每张 %@%@", contract.face_value, contract.price_coin]};
    NSDictionary *data5 = @{@"first": Launguage(@"str_max_leverage"), @"last": [NSString stringWithFormat:@"%@%@", contract.leverageArr[0], Launguage(@"str_bei")]};
    NSDictionary *data6 = @{@"first": Launguage(@"str_index_info"), @"last": itemModel.index_market ? itemModel.index_market : @"--"};
    [dataArrM addObject:data1];
    [dataArrM addObject:data2];
    [dataArrM addObject:data3];
    [dataArrM addObject:data4];
    [dataArrM addObject:data5];
    [dataArrM addObject:data6];
    self.baseInfoView.dataArr = dataArrM.copy;
    self.insuranceFund.unit = contract.margin_coin;
}

// 加载资金费率
- (void)loadFundRate {
    __weak BTIndexDetailBottomView *weakSelf = self;
    [BTContractTool getFundingrateWithContractID:_itemModel.instrument_id success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray *arr = result;
            [weakSelf.fundRateView loadWithDataArray:arr];
        }
    } failure:^(id error) {
    }];
}

// 加载保险基金
- (void)loadInsuranceFund {
    __weak BTIndexDetailBottomView *weakSelf = self;
    [BTContractTool getRiskReservesWithContractID:_itemModel.instrument_id success:^(NSArray *result) {
        [weakSelf.insuranceFund loadWithDataArray:result];
    } failure:^(id error) {
    }];
}

- (BTIndexDetailView *)baseInfoView {
    if (_baseInfoView == nil) {
        _baseInfoView = [[BTIndexDetailView alloc] initWithFrame:CGRectMake(0, SL_getWidth(40) + 1, SL_SCREEN_WIDTH, SL_getWidth(220)) number:6 hasHeader:nil];
    }
    return _baseInfoView;
}

- (BTCommTableView *)insuranceFund {
    if (_insuranceFund == nil) {
        _insuranceFund = [[BTCommTableView alloc] initWithFrame:CGRectMake(0, SL_getWidth(40), SL_SCREEN_WIDTH, self.sl_height - SL_getWidth(40)) style:UITableViewStylePlain];
        _insuranceFund.type = 1;
        _insuranceFund.hidden = YES;
    }
    return _insuranceFund;
}

- (BTCommTableView *)fundRateView {
    if (_fundRateView == nil) {
        _fundRateView = [[BTCommTableView alloc] initWithFrame:CGRectMake(0, SL_getWidth(40), SL_SCREEN_WIDTH, self.sl_height - SL_getWidth(40)) style:UITableViewStylePlain];
        _fundRateView.type = 2;
        _fundRateView.hidden = YES;
    }
    return _fundRateView;
}

@end
