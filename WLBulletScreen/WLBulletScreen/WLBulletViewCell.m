//
//  WLBulletViewCell.m
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/4.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import "WLBulletViewCell.h"

@interface WLBulletViewCell ()<CAAnimationDelegate>

/***********当弹幕刚完全进入视图的block***********/
@property (copy,nonatomic)  void (^enterScreenBlock)();

/***********当弹幕结束动画的回调***********/
@property (copy,nonatomic) void (^endBlock)();

/***********当弹幕开始动画的回调***********/
@property (copy,nonatomic) void (^startBlock)();

/***********存储当弹幕刚刚完全进入视图的时间***********/
@property (assign,nonatomic) CGFloat enterScreenDuration;


@end

@implementation WLBulletViewCell

// 对于cell动画的处理
- (void)animteWithSpeed:(CGFloat)speed WithStart:(void(^)())startBlock WithBeginCellAllScreen:(void(^)())enterScreenBlock WithEndAnimate:(void(^)())endBlock
{
    _startBlock = startBlock;
    _enterScreenBlock = enterScreenBlock;
    _endBlock = endBlock;
    
    !_startBlock? : _startBlock();
    
    CABasicAnimation *moveAnimate = [CABasicAnimation animationWithKeyPath:@"position.x"];
    moveAnimate.fromValue = @(self.center.x);
    moveAnimate.toValue = @(-(self.bounds.size.width)*0.5);
    moveAnimate.delegate = self;
    // 动画的持续的时间是根据 s = vt ,当速度固定，路程和时间成正比，才能保证弹幕之间的间距相差30；
    CGFloat duration = (CGRectGetMaxX(self.frame)) / speed,enterScreenAnimate = (self.frame.origin.x - [self superview].bounds.size.width+ self.bounds.size.width) / speed;
    moveAnimate.duration = duration;
    _enterScreenDuration = enterScreenAnimate;
    [self.layer addAnimation:moveAnimate forKey:nil];
}

// 当动画开始的回调
- (void)animationDidStart:(CAAnimation *)anim
{
    [self performSelector:@selector(animateEnterScreen) withObject:nil afterDelay:_enterScreenDuration];
}

// 当弹幕整个完全进入视图的回调
- (void)animateEnterScreen
{
    !_enterScreenBlock? : _enterScreenBlock();
}

// 当动画停止的回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        !_endBlock? : _endBlock();
    }
}

- (void)pause
{
    //取得指定图层动画的媒体时间，后面参数用于指定子图层，这里不需要
    //设置时间偏移量，保证暂停时停留在旋转的位置
    self.layer.timeOffset = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0;
}

- (void)resume
{
    // 设置暂停时间为开始的时间
    self.layer.beginTime = CACurrentMediaTime() - self.layer.timeOffset;
    // 设置时间的偏移量为0
    self.layer.timeOffset = 0;
    // 恢复原来的速度,开始运动
    self.layer.speed = 1.0;
    
}



@end
