//
//  SLContractDoneRecordCell.m
//  BTTest
//
//  Created by wwly on 2019/9/21.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractDoneRecordCell.h"
#import "BTAlertView.h"
#import "BTContractAlertView.h"
#import "SLButton.h"

@interface SLContractDoneRecordCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *dealLabel;

@property (nonatomic, strong) UIView *midLine;

@property (nonatomic, strong) UILabel *entrustVolume;
@property (nonatomic, strong) UILabel *entrustNum;

@property (nonatomic, strong) UILabel *dealVolume;
@property (nonatomic, strong) UILabel *dealNum;

@property (nonatomic, strong) UILabel *entrustPrice;
@property (nonatomic, strong) UILabel *priceNum;

@property (nonatomic, strong) UILabel *entrustAvai;
@property (nonatomic, strong) UILabel *avaiNum;

@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) BTContractsModel *contractInfo;

@property (nonatomic, strong) UILabel *triggerTime; // 触发时间
@property (nonatomic, strong) UILabel *triggerNum;

@property (nonatomic, strong) BTContractRecordModel * recordModel;

@end

@implementation SLContractDoneRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = MAIN_COLOR;
    self.typeLabel = [self createLabelWithFont:11 textColor:UP_WARD_COLOR];
    self.typeLabel.layer.cornerRadius = 2;
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.layer.borderWidth = 0.5;
    self.nameLabel = [self createLabelWithFont:15 textColor:MAIN_GARY_TEXT_COLOR];
    self.timeLabel = [self createLabelWithFont:11 textColor:GARY_BG_TEXT_COLOR];
    self.dealLabel = [self createLabelWithFont:15 textColor:MAIN_GARY_TEXT_COLOR];
    self.dealLabel.textAlignment = NSTextAlignmentRight;
    self.midLine = [self createLineView];
    self.entrustVolume = [self createLabelWithFont:14 textColor:GARY_BG_TEXT_COLOR];
    self.entrustNum = [self createLabelWithFont:14 textColor:MAIN_GARY_TEXT_COLOR];
    self.entrustNum.textAlignment = NSTextAlignmentRight;
    self.dealVolume = [self createLabelWithFont:14 textColor:GARY_BG_TEXT_COLOR];
    self.dealNum = [self createLabelWithFont:14 textColor:MAIN_GARY_TEXT_COLOR];
    self.dealNum.textAlignment = NSTextAlignmentRight;
    self.entrustPrice = [self createLabelWithFont:14 textColor:GARY_BG_TEXT_COLOR];
    self.priceNum = [self createLabelWithFont:14 textColor:MAIN_GARY_TEXT_COLOR];
    self.priceNum.textAlignment = NSTextAlignmentRight;
    self.entrustAvai = [self createLabelWithFont:14 textColor:GARY_BG_TEXT_COLOR];
    self.avaiNum = [self createLabelWithFont:14 textColor:MAIN_GARY_TEXT_COLOR];
    self.avaiNum.textAlignment = NSTextAlignmentRight;
    self.bottomLine = [self createLineView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.typeLabel sizeToFit];
    self.typeLabel.sl_x = SL_MARGIN;
    self.typeLabel.sl_y = SL_MARGIN * 0.5;
    self.typeLabel.sl_height = SL_getWidth(20);
    
    [self.nameLabel sizeToFit];
    self.nameLabel.sl_x = CGRectGetMaxX( self.typeLabel.frame) + SL_MARGIN *0.5;
    self.nameLabel.sl_centerY = self.typeLabel.sl_centerY;
    self.timeLabel.frame = CGRectMake(self.typeLabel.sl_x, CGRectGetMaxY(self.typeLabel.frame) + SL_MARGIN * 0.5, SL_getWidth(200), SL_getWidth(15));
    
    self.dealLabel.frame = CGRectMake(self.contentView.sl_width - SL_getWidth(90), 0, SL_getWidth(80), SL_getWidth(20));
    self.dealLabel.sl_centerY = CGRectGetMaxY(self.typeLabel.frame);
    self.midLine.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.timeLabel.frame) + SL_MARGIN * 0.5, self.contentView.sl_width, 1);
    self.entrustVolume.frame = CGRectMake(SL_MARGIN,CGRectGetMaxY(self.midLine.frame) +  SL_MARGIN * 0.5, self.contentView.sl_width * 0.5 - SL_MARGIN, SL_getWidth(20));
    self.entrustNum.frame = CGRectMake(CGRectGetMaxX(self.entrustVolume.frame), self.entrustVolume.sl_y, self.entrustVolume.sl_width, self.entrustVolume.sl_height);
    self.dealVolume.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(self.entrustVolume.frame) + SL_MARGIN * 0.5, self.entrustVolume.sl_width, self.entrustVolume.sl_height);
    self.dealNum.frame = CGRectMake(self.entrustNum.sl_x, self.dealVolume.sl_y, self.dealVolume.sl_width, self.dealVolume.sl_height);
    self.entrustPrice.frame = CGRectMake(self.entrustVolume.sl_x, CGRectGetMaxY(self.dealVolume.frame) + SL_MARGIN * 0.5, self.dealVolume.sl_width, self.dealVolume.sl_height);
    self.priceNum.frame = CGRectMake(self.dealNum.sl_x, self.entrustPrice.sl_y, self.entrustPrice.sl_width, self.entrustPrice.sl_height);
    self.entrustAvai.frame = CGRectMake(self.entrustPrice.sl_x, CGRectGetMaxY(self.entrustPrice.frame) + SL_MARGIN * 0.5, self.entrustPrice.sl_width, self.entrustPrice.sl_height);
    self.avaiNum.frame = CGRectMake(self.priceNum.sl_x, self.entrustAvai.sl_y, self.entrustAvai.sl_width, self.entrustAvai.sl_height);
    self.bottomLine.frame = CGRectMake(0, self.contentView.sl_height - SL_MARGIN * 0.8, self.contentView.sl_width, SL_MARGIN * 0.8);
}

- (void)updateViewWithDoneRecordModel:(BTContractRecordModel *)recordModel {
    self.recordModel = recordModel;
    NSString *unit = @"张";
    self.nameLabel.text = recordModel.symbol;
    self.timeLabel.text = [BTFormat date2localTimeStr:[BTFormat dateFromUTCString:recordModel.created_at] format:DATE_FORMAT_YMDHm];
    switch (recordModel.side) {
        case CONTRACT_ORDER_WAY_BUY_OPEN_LONG:
            self.typeLabel.textColor = UP_WARD_COLOR;
            self.typeLabel.text = [NSString stringWithFormat:@" %@ ", Launguage(@"BT_CA_KDMR")];
            self.typeLabel.layer.borderColor = UP_WARD_COLOR.CGColor;
            break;
        case CONTRACT_ORDER_WAY_BUY_CLOSE_SHORT:
            self.typeLabel.textColor = UP_WARD_COLOR;
            self.typeLabel.text = [NSString stringWithFormat:@" %@ ", @"买入平空"];
            self.typeLabel.layer.borderColor = UP_WARD_COLOR.CGColor;
            break;
        case CONTRACT_ORDER_WAY_SELL_CLOSE_LONG:
            self.typeLabel.textColor = DOWN_COLOR;
            self.typeLabel.text = [NSString stringWithFormat:@" %@ ", @"卖出平多"];
            self.typeLabel.layer.borderColor = DOWN_COLOR.CGColor;
            break;
        case CONTRACT_ORDER_WAY_SELL_OPEN_SHORT:
            self.typeLabel.textColor = DOWN_COLOR;
            self.typeLabel.text = [NSString stringWithFormat:@" %@ ",Launguage(@"BT_CA_KKMC")];
            self.typeLabel.layer.borderColor = DOWN_COLOR.CGColor;
            break;
        default:
            break;
    }
    
    self.entrustVolume.text = @"成交数量";
    self.dealVolume.text = Launguage(@"BT_MAIN_P");
    self.entrustPrice.text = @"价值";
    self.entrustAvai.text = @"佣金费";
    
    NSString *dealVol = recordModel.qty;
    dealVol = [dealVol toSmallVolumeWithContractID:recordModel.instrument_id];
    NSString *marginCode = recordModel.contractInfo.margin_coin;
    self.entrustNum.text = [NSString stringWithFormat:@"%@ %@",dealVol,unit];
    self.dealNum.text = [NSString stringWithFormat:@"%@ %@",recordModel.px?[recordModel.px toSmallPriceWithContractID:recordModel.instrument_id]:@"0",recordModel.contractInfo.quote_coin];
    self.priceNum.text = [NSString stringWithFormat:@"%@ %@",[recordModel.avai toSmallValueWithContract:recordModel.instrument_id],marginCode];
    NSString *fee= [NSString stringWithFormat:@"%.8f %@",[[recordModel.take_fee bigSub:recordModel.make_fee] doubleValue],recordModel.contractInfo.margin_coin];
    self.avaiNum.text = fee;
}


#pragma mark - action

// 点击取消
- (void)contractAlertViewDidClickCancelWithType:(BTContractAlertViewType)type {
    if (type == BTContractAlertViewContractBreakHold) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractBreakHold];
    } else if (type == BTContractAlertViewContractReduceDetail) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractReduceDetail];
    }
}

- (void)contractAlertViewDidClickComfirmWithType:(BTContractAlertViewType)type info:(NSDictionary *)info {
    if (type == BTContractAlertViewPlanOrderTips) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewPlanOrderTips];
        return;
    }
//    NSString *url = nil;
//    NSString *lan = @"zh-cn";
//
//    SLBaseWebController *webVc = nil;
//    if (type == BTContractAlertViewContractBreakHold) {
//        url = [NSString stringWithFormat:@"https://support.bbx.com/hc/%@/articles/360007975034",lan];
//        webVc =[[SLBaseWebController alloc] initWithUrl:url amdMethod:@"GET" Body:nil];
//        webVc.title = str_force_close_mechanism;
//         [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractBreakHold];
//    } else if (type == BTContractAlertViewContractReduceDetail) {
//
//        url = [NSString stringWithFormat:@"https://support.bbx.com/hc/%@/articles/360007975194",lan];
//        webVc =[[SLBaseWebController alloc] initWithUrl:url amdMethod:@"GET" Body:nil];
//        webVc.title = str_reduce_position_mechanism;
//        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractReduceDetail];
//    }
//    [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractBreakHold];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UINavigationController *navigationController = appDelegate.currentNavigationController;
//    [navigationController pushViewController:webVc animated:YES];
}

#pragma mark - create UI

- (UILabel *)triggerTime {
    if (_triggerTime == nil) {
        _triggerTime = [self createLabelWithFont:14 textColor:GARY_BG_TEXT_COLOR];
    }
    return _triggerTime;
}

- (UILabel *)triggerNum {
    if (_triggerNum == nil) {
        _triggerNum = [self createLabelWithFont:14 textColor:MAIN_GARY_TEXT_COLOR];
    }
    return _triggerNum;
}

- (UILabel *)createLabelWithFont:(CGFloat)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = MAIN_COLOR;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    [self.contentView addSubview:label];
    return label;
}

- (UIView *)createLineView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = DARK_BARKGROUND_COLOR;
    [self.contentView addSubview:line];
    return line;
}


@end
