//
//  BTSelectItemMenuView.h
//  GGEX_Appstore//
//  Created by 健 王 on 2018/11/5.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTSelectItemMenuViewDelegate <NSObject>
- (void)selectItemDidClickSelected:(BTItemModel *)itemModel;
@end

@interface BTSelectItemMenuView : UIView

@property (nonatomic, strong) id <BTSelectItemMenuViewDelegate> delegate;

@property (nonatomic, strong) BTItemModel *itemModel;

- (instancetype)initWithFrame:(CGRect)frame btnArr:(NSArray *)btnArr;

@end
