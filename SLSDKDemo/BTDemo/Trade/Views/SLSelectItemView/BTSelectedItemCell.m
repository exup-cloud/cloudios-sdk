//
//  BTSelectedItemCell.m
//  GGEX_Appstore//
//  Created by 健 王 on 2018/11/5.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTSelectedItemCell.h"

@implementation BTSelectedItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.title = [self createLabelWithFrame:CGRectMake(SL_MARGIN, 0, self.sl_width * 0.6 - SL_MARGIN, SL_getWidth(20))];
    self.title.sl_centerY = self.contentView.sl_height * 0.5;
    
    self.rate = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.title.frame), 0, self.sl_width - CGRectGetMaxX(self.title.frame) - SL_MARGIN, SL_getWidth(20))];
    self.rate.sl_centerY = self.contentView.sl_height * 0.5;
    self.rate.textAlignment = NSTextAlignmentRight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.title.frame = CGRectMake(SL_MARGIN, 0, self.sl_width * 0.6 - SL_MARGIN, SL_getWidth(20));
    self.title.sl_centerY = self.contentView.sl_height * 0.5;
    self.rate.frame = CGRectMake(CGRectGetMaxX(self.title.frame), 0, self.sl_width - CGRectGetMaxX(self.title.frame) - SL_MARGIN, SL_getWidth(20));
    self.rate.sl_centerY = self.contentView.sl_height * 0.5;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)createLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = MAIN_GARY_TEXT_COLOR;
    [self.contentView addSubview:label];
    return label;
}

@end
