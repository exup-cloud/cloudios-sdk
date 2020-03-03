//
//  SLMineRecordCell.m
//  BTTest
//
//  Created by WWLy on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMineRecordCell.h"
#import "BTContractLabel.h"

#define WAITECOLOR [UIColor colorWithHex:@"#D9A959"]
@interface SLMineRecordCell ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) BTContractLabel *coinLabel;
@property (nonatomic, strong) BTContractLabel *typeLabel;
@property (nonatomic, strong) BTContractLabel *numbLabel;
@property (nonatomic, strong) BTContractLabel *feeLabel;
@property (nonatomic, strong) BTContractLabel *balanceLabel;
@property (nonatomic, strong) BTContractLabel *timeLabel;

@end

@implementation SLMineRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)setupChildViewsFrame {
    self.coinLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN, self.contentView.sl_width * 0.5 - SL_MARGIN, (self.contentView.sl_height - 3 * SL_MARGIN)/ 3.0);
    self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.coinLabel.frame), self.coinLabel.sl_y, self.coinLabel.sl_width, self.coinLabel.sl_height);
    self.numbLabel.frame = CGRectMake(self.coinLabel.sl_x, CGRectGetMaxY(self.coinLabel.frame) + SL_MARGIN * 0.5, self.coinLabel.sl_width, self.coinLabel.sl_height);
    self.feeLabel.frame = CGRectMake(self.typeLabel.sl_x, self.numbLabel.sl_y, self.numbLabel.sl_width, self.numbLabel.sl_height);
    self.balanceLabel.frame = CGRectMake(self.numbLabel.sl_x, CGRectGetMaxY(self.numbLabel.frame) + SL_MARGIN * 0.5, self.numbLabel.sl_width, self.numbLabel.sl_height);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.balanceLabel.frame), self.balanceLabel.sl_y, self.balanceLabel.sl_width, self.balanceLabel.sl_height);

    self.topLine.frame = CGRectMake(0, 0, SL_SCREEN_WIDTH, 1);
}

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupChildViewsFrame];
}

- (void)setCashBookModel:(BTCashBooksModel *)cashBookModel {
    _cashBookModel = cashBookModel;
    
    self.coinLabel.text = [NSString stringWithFormat:@"%@%@", @"币种：", cashBookModel.coin_code];
    [self.coinLabel layoutStringArr:@[cashBookModel.coin_code]];
    
    NSString *typeStr = @"--";
    switch (cashBookModel.action) {
        case CONTRACT_ORDER_WAY_BUY_OPEN_LONG:
            typeStr = Launguage(@"BT_CA_KDMR");
            break;
        case CONTRACT_ORDER_WAY_BUY_CLOSE_SHORT:
            typeStr = @"买入平空";
            break;
        case CONTRACT_ORDER_WAY_SELL_CLOSE_LONG:
            typeStr = @"卖出平多";
            break;
        case CONTRACT_ORDER_WAY_SELL_OPEN_SHORT:
            typeStr = Launguage(@"BT_CA_KKMC");
            break;
        case CONTRACT_WAY_BB_TRANSFER_IN:
        case CONTRACT_WAY_CONTRACT_TRANSFER_IN:
            typeStr = Launguage(@"str_transfer_bb2contract");
            break;
        case CONTRACT_WAY_TRANSFER_TO_BB:
        case CONTRACT_WAY_TRANSFER_TO_CONTRACT:
            typeStr = Launguage(@"str_transfer_contract2bb");
            break;
        case CONTRACT_WAY_REDUCE_DEPOSIT_TRANSFER:
            typeStr = Launguage(@"str_transferim_position2contract");
            break;
        case CONTRACT_WAY_INCREA_DEPOSIT_TRANSFER:
            typeStr = @"增加保证金";
            break;
        case CONTRACT_WAY_POSITION_FUND_FEE:
            typeStr = Launguage(@"BT_CA_ZJFL");
            break;
        default:
            break;
    }
    self.typeLabel.text = [NSString stringWithFormat:@"%@%@", @"类型：", typeStr];
    [self.typeLabel layoutStringArr:@[typeStr]];
    self.numbLabel.text = [NSString stringWithFormat:@"%@%@", @"数额：", [cashBookModel.deal_count toSmallVolumeWithSpot_coin:cashBookModel.coin_code]];
    [self.numbLabel layoutStringArr:@[[cashBookModel.deal_count toSmallVolumeWithSpot_coin:cashBookModel.coin_code]]];
    
    NSString *fee = cashBookModel.fee;
    fee = [fee toSmallVolumeWithSpot_coin:cashBookModel.coin_code];
    self.feeLabel.text = [NSString stringWithFormat:@"%@%@", @"手续费：", fee];
    [self.feeLabel layoutStringArr:@[fee]];
    NSString *balance = cashBookModel.last_assets;
    balance = [balance toSmallVolumeWithContractID:cashBookModel.instrument_id];
    self.balanceLabel.text = [NSString stringWithFormat:@"%@%@", @"余额：", balance];
    [self.balanceLabel layoutStringArr:@[balance]];
    NSString *time = [BTFormat date2localTimeStr:[BTFormat dateFromUTCString:cashBookModel.created_at] format:DATE_FORMAT_YMDHm];
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@", Launguage(@"str_time3"), time];
    [self.timeLabel layoutStringArr:@[time]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = DARK_BARKGROUND_COLOR;
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}

- (BTContractLabel *)coinLabel {
    if (_coinLabel == nil) {
        _coinLabel = [self createContractLabel];
    }
    return _coinLabel;
}

- (BTContractLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [self createContractLabel];
    }
    return _typeLabel;
}

- (BTContractLabel *)numbLabel {
    if (_numbLabel == nil) {
        _numbLabel = [self createContractLabel];
    }
    return _numbLabel;
}

- (BTContractLabel *)feeLabel {
    if (_feeLabel == nil) {
        _feeLabel = [self createContractLabel];
    }
    return _feeLabel;
}

- (BTContractLabel *)balanceLabel {
    if (_balanceLabel == nil) {
        _balanceLabel = [self createContractLabel];
    }
    return _balanceLabel;
}

- (BTContractLabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [self createContractLabel];
    }
    return _timeLabel;
}

- (BTContractLabel *)createContractLabel {
    BTContractLabel *contractLabel = [[BTContractLabel alloc] init];
    contractLabel.mainColor = GARY_BG_TEXT_COLOR;
    contractLabel.markColor = MAIN_GARY_TEXT_COLOR;
    contractLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:contractLabel];
    return contractLabel;
}

@end
