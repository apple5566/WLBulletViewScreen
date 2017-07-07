//
//  WLBulletView.h
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/4.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLBulletViewDataSource.h"
#import "WLBulletViewDelegate.h"

@interface WLBulletView : UIView

/***********弹幕的速度***********/
@property (assign,nonatomic) CGFloat speed;

/***********弹幕的高度***********/
@property (assign,nonatomic) CGFloat bulletViewCellHeight;

/***********弹幕竖轴之间的间距***********/
@property (assign,nonatomic) CGFloat bulletViewCellVMargin;

/***********弹幕横轴之间的间距***********/
@property (assign,nonatomic) CGFloat bulletViewCellHMargin;

/***********弹幕的数据源代理***********/
@property (weak,nonatomic) id<WLBulletViewDataSource> dataSource;

/***********弹幕的代理***********/
@property (weak,nonatomic) id<WLBulletViewDelegate> delegate;

/********设置弹幕的数量********/
- (void)sendBulletViewCellsCount:(NSInteger)count;

/********打开弹幕**********/
- (void)closeBulletView;

/*********关闭弹幕***********/
- (void)openBulletView;




@end
