//
//  WLBulletViewCell.h
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/4.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLBulletViewCell : UIView


/***********设置你的编号***********/
@property (assign,nonatomic) NSInteger number;



/********用于暂停动画********/
- (void)pause;

/**********恢复动画*********/
- (void)resume;


- (void)animteWithSpeed:(CGFloat)speed WithStart:(void(^)())startBlock WithBeginCellAllScreen:(void(^)())enterScreenBlock WithEndAnimate:(void(^)())endBlock;

@end
