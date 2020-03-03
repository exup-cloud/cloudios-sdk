//
//  SLDefinePickerView.m
//  BTTest
//
//  Created by WWLy on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLDefinePickerView.h"

@interface SLDefinePickerCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation SLDefinePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    self.titleLabel = [UILabel labelWithText:nil textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightTextColor font:[UIFont systemFontOfSize:14] numberOfLines:1 frame:CGRectMake(0, 0, self.contentView.sl_width, self.contentView.sl_height) superview:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
}

- (void)updateViewWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end


@interface SLDefinePickerView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray <NSString *> * titles;

@end

static NSString *const reuseID = @"SLDefinePickerCell_ID";

@implementation SLDefinePickerView {
    CGFloat _cellHeight;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.titles = titles;
        _cellHeight = 40;
        if (_cellHeight * self.titles.count < self.sl_height) {
            self.sl_height = _cellHeight * self.titles.count;
        }
        [self reloadData];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    [self registerClass:[SLDefinePickerCell class] forCellReuseIdentifier:reuseID];
}


#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLDefinePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    [cell updateViewWithTitle:self.titles[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.pickerView_delegate respondsToSelector:@selector(pickerView_didSelectItem:index:)]) {
        [self.pickerView_delegate pickerView_didSelectItem:self.titles[indexPath.row] index:indexPath.row];
    }
}

@end
