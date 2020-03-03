//
//  BTTextFieldView.h
//  BTStore
//
//  Created by 健 王 on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BTTextFieldType) {
    BTTextFieldDefaultType,
    BTTextFieldLastLabelType,
    BTTextFieldButtonType,
    BTTextFieldTableSelectType,
    BTTextFieldLastButtonType,
    BTTextFieldLastOneButtonType,
    BTTextFieldOTCTextType,
    BTTextFieldDepositType,
    BTTextFieldNoLabelType
};
@class BTTextField, SLButton;
@interface BTTextFieldView : UIView

@property (nonatomic, strong) BTTextField *textField;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *lastLabel;
@property (nonatomic, strong) UIButton *commiTip; // 手续费
@property (nonatomic, assign) BTTextFieldType type;

@property (nonatomic, strong) UIButton *lastButton1;
@property (nonatomic, strong) UIButton *lastButton2;

@end
