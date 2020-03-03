//
//  SLMineAssetsHeaderView.m
//  BTTest
//
//  Created by WWLy on 2019/9/16.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMineAssetsHeaderView.h"

@interface SLMineAssetsHeaderView ()

@property (nonatomic, strong) UIView * assetsView;
@property (nonatomic, strong) UILabel * assetsTitleLabel;
@property (nonatomic, strong) UILabel * assetsLabel;
@property (nonatomic, strong) UILabel * legalTenderPriceLabel;
@property (nonatomic, strong) UIButton * eyesButton;

@property (nonatomic, strong) UIButton * transferButton;
@property (nonatomic, strong) UIButton * tradeButton;

@property (nonatomic, strong) SLMinePerprotyModel * currentPerprotyModel;

@end

@implementation SLMineAssetsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.assetsView = [[UIView alloc] initWithFrame:CGRectMake(SL_MARGIN, SL_MARGIN, self.sl_width - SL_MARGIN * 2, 100)];
    self.assetsView.backgroundColor = [UIColor purpleColor];
    self.assetsView.layer.cornerRadius = 5;
    self.assetsView.layer.masksToBounds = YES;
    [self addSubview:self.assetsView];
    
    self.assetsTitleLabel = [UILabel labelWithText:Launguage(@"str_account_balance") textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(0, 10, self.assetsView.sl_width, 20) superview:self.assetsView];
    
    self.assetsLabel = [UILabel labelWithText:@"--" textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont boldSystemFontOfSize:22] numberOfLines:1 frame:CGRectMake(self.assetsTitleLabel.sl_x, self.assetsTitleLabel.sl_maxY, self.assetsTitleLabel.sl_width, 40) superview:self.assetsView];
    
    self.legalTenderPriceLabel = [UILabel labelWithText:@"≈ 0 ¥" textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightGrayTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(self.assetsLabel.sl_x, self.assetsLabel.sl_maxY, self.assetsLabel.sl_width, 20) superview:self.assetsView];
    
    self.eyesButton = [UIButton buttonExtensionWithTitle:nil TitleColor:nil Image:[UIImage imageNamed:@""] font:nil target:self action:@selector(eyesButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.eyesButton.frame = CGRectMake(self.assetsView.sl_width - 45, 15, 30, 30);
    self.eyesButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.assetsView addSubview:self.eyesButton];
    
    self.transferButton = [UIButton buttonExtensionWithTitle:Launguage(@"BT_HUAZHUAN") TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:[UIImage imageNamed:@""] font:[UIFont systemFontOfSize:13] target:self action:@selector(transferButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.transferButton.frame = CGRectMake(0, self.assetsView.sl_maxY, self.sl_width / 2, 50);
    [self addSubview:self.transferButton];
    
    self.tradeButton = [UIButton buttonExtensionWithTitle:Launguage(@"BT_TD") TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:[UIImage imageNamed:@""] font:[UIFont systemFontOfSize:13] target:self action:@selector(tradeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.tradeButton.frame = CGRectMake(self.transferButton.sl_maxX, self.transferButton.sl_y, self.transferButton.sl_width, self.transferButton.sl_height);
    [self addSubview:self.tradeButton];
}


#pragma mark - Update Data

- (void)updateViewWithPerprotyModel:(SLMinePerprotyModel *)perprotyModel {
    self.currentPerprotyModel = perprotyModel;
    self.assetsLabel.text = [NSString stringWithFormat:@"%@ USDT", self.currentPerprotyModel.total_amount];
    self.legalTenderPriceLabel.text = perprotyModel.convertInto;
}


#pragma mark - Events

- (void)eyesButtonClick {
    self.eyesButton.selected = !self.eyesButton.isSelected;
    if (self.eyesButton.isSelected) {
        self.assetsLabel.text = @"****";
        self.legalTenderPriceLabel.text = @"****";
    } else {
        self.assetsLabel.text = [NSString stringWithFormat:@"%@ USDT", self.currentPerprotyModel.total_amount];
        self.legalTenderPriceLabel.text = self.currentPerprotyModel.convertInto;
    }
}

- (void)transferButtonClick {
    
}

- (void)tradeButtonClick {
    
}

@end
