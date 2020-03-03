//
//  SLContractTableViewCell.m
//  BTTest
//
//  Created by 健 王 on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractTableViewCell.h"

@interface SLContractTableViewCell ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *selectView;
@end

@implementation SLContractTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.topView = [self creatView];
        self.bottomView = [self creatView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.noIcon) {
        self.textLabel.frame = CGRectMake(SL_MARGIN, self.imageView.sl_y, self.contentView.sl_width - (CGRectGetMaxX(self.imageView.frame) + 2 * SL_MARGIN) - SL_getWidth(30), SL_getHeight(30));
    } else {
        self.imageView.frame = CGRectMake(SL_MARGIN, SL_MARGIN, SL_getWidth(30), SL_getWidth(30));
        self.imageView.sl_centerY = self.contentView.sl_height * 0.5;
        self.imageView.layer.cornerRadius = self.imageView.sl_width * 0.5;
        self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 2 * SL_MARGIN, self.imageView.sl_y, self.contentView.sl_width - (CGRectGetMaxX(self.imageView.frame) + 2 * SL_MARGIN) - SL_getWidth(30), SL_getHeight(30));
    }
    self.textLabel.sl_centerY = self.sl_height* 0.5;
    self.selectView.frame = CGRectMake(self.contentView.sl_width - SL_getWidth(30), 0, SL_getWidth(20), SL_getWidth(20));
    self.selectView.sl_centerY = self.contentView.sl_height * 0.5;
    self.topView.frame = CGRectMake(0, 0, self.contentView.sl_width, 0.5);
    self.bottomView.frame = CGRectMake(0, self.sl_height - 0.5, self.sl_width, 0.5);
}

- (void)setHasSelect:(BOOL)hasSelect {
    _hasSelect = hasSelect;
    if (hasSelect) {
        self.selectView.hidden = NO;
    } else {
        self.selectView.hidden = YES;
    }
}

- (UIImageView *)selectView {
    if (_selectView == nil) {
        _selectView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"icon-finish"]];
        _selectView.hidden = YES;
        [self.contentView addSubview:_selectView];
    }
    return _selectView;
}

- (UIView *)creatView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = DARK_BARKGROUND_COLOR;
    [self.contentView addSubview:line];
    return line;
}

@end
