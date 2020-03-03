//
//  SLButton.m
//  BTStore
//
//  Created by 健 王 on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "SLButton.h"

@interface SLButton ()
@property (nonatomic, assign) BTContentFrameType type;
@property (nonatomic, strong) UILabel *typeLabel;
@end

@implementation SLButton

- (instancetype) initWithContentFrameType:(BTContentFrameType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)setItemModel:(BTItemModel *)itemModel {
    _itemModel = itemModel;
    BTContractsModel *contract = _itemModel.contractInfo;
    [self setTitle:contract.symbol forState:UIControlStateNormal];
    
    if (contract.area == CONTRACT_BLOCK_USDT) {
        self.typeLabel.text = @" USDT ";
    } else if (contract.area == CONTRACT_BLOCK_INVERSE) {
        self.typeLabel.text = [NSString stringWithFormat:@" %@ ",@"币本位"];
    } else if ( contract.area == CONTRACT_BLOCK_SIMULATION){
        self.typeLabel.text = [NSString stringWithFormat:@" %@ ",@"模拟"];
    }
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.type == BTTiTleLabelInFontType) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.imageView.sl_width, 0, self.imageView.sl_width)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.sl_width, 0, -self.titleLabel.sl_width)];
    } else if (self.type == BTImageViewTopType) {
        self.imageView.frame = CGRectMake(SL_getWidth(15), SL_MARGIN * 0.5,self.sl_width - SL_getWidth(30), self.sl_width - SL_getWidth(30));
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.sl_width, SL_getWidth(20));
    } else if (self.type == BTFundTranImageType) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.imageView.sl_width, 0, self.imageView.sl_width)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.sl_width, 0, -self.titleLabel.sl_width)];
        self.imageView.frame = CGRectMake(self.titleLabel.sl_width + SL_MARGIN* 0.5, 0,self.sl_height, self.sl_height);
    } else if (self.type == BTUploadImageViewType) {
        self.imageView.frame = CGRectMake(self.sl_width * 0.32, self.sl_width * 0.25,self.sl_width * 0.36, self.sl_width * 0.36);
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+ SL_MARGIN * 0.5, self.sl_width, SL_getWidth(20));
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    } else if (self.type == BTCurrentSelectItemBtn) {
        [self.titleLabel sizeToFit];
        self.titleLabel.sl_x = 0;
        self.titleLabel.sl_centerY = self.sl_height * 0.5;
        BTContractsModel *contract = self.itemModel.contractInfo;
        if (contract.area == CONTRACT_BLOCK_USDT || contract.area == CONTRACT_BLOCK_INVERSE || contract.area == CONTRACT_BLOCK_SIMULATION) {
            [self.typeLabel sizeToFit];
            self.typeLabel.sl_x = CGRectGetMaxX(self.titleLabel.frame) +5;
            self.typeLabel.sl_centerY = self.titleLabel.sl_centerY;
            self.imageView.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame), self.typeLabel.sl_y, SL_getWidth(20), SL_getWidth(20));
        } else {
            self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), self.typeLabel.sl_y, SL_getWidth(20), SL_getWidth(20));
        }
        self.imageView.sl_centerY = self.titleLabel.sl_centerY;
        self.sl_width = CGRectGetMaxX(self.imageView.frame);
    }
    
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:10];
        _typeLabel.textColor = MAIN_BTN_COLOR;
        _typeLabel.layer.borderColor = MAIN_BTN_COLOR.CGColor;
        _typeLabel.layer.borderWidth = 0.8;
        _typeLabel.layer.cornerRadius = 1;
        _typeLabel.layer.masksToBounds = YES;
        [self addSubview:_typeLabel];
    }
    return _typeLabel;
}

@end
