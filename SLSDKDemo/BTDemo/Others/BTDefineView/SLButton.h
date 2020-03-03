//
//  SLButton.h
//  BTStore
//
//  Created by 健 王 on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BTContentFrameType) {
    BTTiTleLabelInFontType,
    BTImageViewInFontType,
    BTImageViewTopType,
    BTFundTranImageType,
    BTUploadImageViewType,
    BTCurrentSelectItemBtn
};

@interface SLButton : UIButton

@property (nonatomic, strong) BTItemModel *itemModel;

- (instancetype)initWithContentFrameType:(BTContentFrameType)type;

@end
