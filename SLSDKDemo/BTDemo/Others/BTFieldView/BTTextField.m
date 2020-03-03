//
//  BTTextField.m
//  BTStore
//
//  Created by 健 王 on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTTextField.h"

@implementation BTTextField

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *leftVi = [[UIView alloc] init];
        leftVi.frame = CGRectMake(0, 0, 10, 1);
        self.leftView = leftVi;
        self.leftViewMode = UITextFieldViewModeAlways;
//        self.borderStyle = UITextBorderStyleRoundedRect;
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.location>= 64)
        
        return NO;
    
    return YES;
}

@end
