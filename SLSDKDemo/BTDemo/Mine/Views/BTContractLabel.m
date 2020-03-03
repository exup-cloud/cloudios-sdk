//
//  BTContractLabel.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTContractLabel.h"

@implementation BTContractLabel

- (void)layoutStringArr:(NSArray *)array {
    if (self.text.length <= 0 || array.count <= 0) {
        return;
    }
    self.textColor = self.mainColor?self.mainColor:GARY_BG_TEXT_COLOR;
    UIColor *color = self.markColor?self.markColor:MAIN_GARY_TEXT_COLOR;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:self.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    for (NSString *redStr in array) {
        NSRange range = [self.text rangeOfString:redStr];
        if (range.location != NSNotFound) {
            [str addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    self.attributedText = str;
}

@end
