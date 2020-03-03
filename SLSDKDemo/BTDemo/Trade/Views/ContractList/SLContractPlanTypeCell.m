//
//  SLContractPlanTypeCell.m
//  BTTest
//
//  Created by wwly on 2019/9/8.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractPlanTypeCell.h"

@interface SLContractPlanTypeCell ()

@property (nonatomic, strong) UIButton * currentPlanButton;
@property (nonatomic, strong) UIButton * historyPlanButton;

@end

@implementation SLContractPlanTypeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    
    self.currentPlanButton = [UIButton buttonExtensionWithTitle:Launguage(@"str_present_plan") TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:nil font:[UIFont systemFontOfSize:14] target:self action:@selector(currentPlanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.currentPlanButton setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
    self.currentPlanButton.frame = CGRectMake(20, 5, 80, 30);
    [self.contentView addSubview:self.currentPlanButton];
    
    self.historyPlanButton = [UIButton buttonExtensionWithTitle:Launguage(@"str_history_plan") TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:nil font:[UIFont systemFontOfSize:14] target:self action:@selector(historyPlanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.historyPlanButton setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
    self.historyPlanButton.frame = CGRectMake(self.currentPlanButton.sl_maxX + 10, self.currentPlanButton.sl_y, self.currentPlanButton.sl_width, self.currentPlanButton.sl_height);
    [self.contentView addSubview:self.historyPlanButton];
    
    // 默认选中当前计划
    self.currentPlanButton.selected = YES;
}


#pragma mark - Public

- (void)updateViewWithContractPlanType:(SLContractPlanType)contractPlanType {
    if (contractPlanType == SLContractPlanTypeHistory) {
        self.currentPlanButton.selected = NO;
        self.historyPlanButton.selected = YES;
    } else {
        self.currentPlanButton.selected = YES;
        self.historyPlanButton.selected = NO;
    }
}


#pragma mark - Events

- (void)currentPlanButtonClick:(UIButton *)sender {
    sender.selected = YES;
    self.historyPlanButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(contractPlanTypeCell_selectedContractPlanType:)]) {
        [self.delegate contractPlanTypeCell_selectedContractPlanType:SLContractPlanTypeCurrent];
    }
}

- (void)historyPlanButtonClick:(UIButton *)sender {
    sender.selected = YES;
    self.currentPlanButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(contractPlanTypeCell_selectedContractPlanType:)]) {
        [self.delegate contractPlanTypeCell_selectedContractPlanType:SLContractPlanTypeHistory];
    }
}

@end
