//
//  WLBulletViewDataSource.h
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/5.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WLBulletView,WLBulletViewCell;
@protocol WLBulletViewDataSource <NSObject>

@required

/*******设置有多少个通道*********/
- (NSInteger)bulletViewNumberOfGallerys:(WLBulletView *)bulletView ;

/********设置每个弹幕长啥样子**********/
- (WLBulletViewCell *)bulletViewCellSetUp:(WLBulletView *)bulletView;


@end
