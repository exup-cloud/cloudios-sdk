//
//  SLDefinePickerView.h
//  BTTest
//
//  Created by WWLy on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLDefinePickerViewDelegate <NSObject>

- (void)pickerView_didSelectItem:(NSString *)title index:(NSUInteger)index;

@end

@interface SLDefinePickerView : SLBaseTableView

@property (nonatomic, weak) id <SLDefinePickerViewDelegate> pickerView_delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
