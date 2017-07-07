//
//  WLBulletViewDelegate.h
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/5.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WLBulletView;
@protocol WLBulletViewDelegate <NSObject>

@optional

/*******自定义弹幕的宽度********/
- (CGFloat)bulletViewCellWidth:(WLBulletView *)bulletView;

/*************当弹幕开始动画回调*************/
- (void)bulletViewCellStartAnimate:(WLBulletView *)bulletView;

/***********点击了弹幕的回调*************/
- (void)bulletViewdidSelectedCell:(WLBulletViewCell *)cell WithBulletView:(WLBulletView *)bulletView;


@end
