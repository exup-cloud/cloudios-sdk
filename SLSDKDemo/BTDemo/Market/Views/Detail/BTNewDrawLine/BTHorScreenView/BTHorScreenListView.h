//
//  BTHorScreenListView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2019/1/8.
//  Copyright © 2019年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTHorScreenListViewDelegate <NSObject>
- (void)horScreenListViewDidClickMainType:(NSInteger)type andIndex:(NSInteger)index;
@end

@interface BTHorScreenListView : UIView

@property (nonatomic, weak) id <BTHorScreenListViewDelegate>delegate;

- (void)setMainTargetType:(NSInteger)type;

- (void)setDupliTargetType:(NSInteger)type;

@end
