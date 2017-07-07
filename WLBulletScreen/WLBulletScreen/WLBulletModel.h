//
//  WLBulletModel.h
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/5.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLBulletModel : NSObject

/***********弹幕的内容***********/
@property (strong,nonatomic) NSString *message;

+ (instancetype)bulletModelWithDict:(NSDictionary *)dict;

/***********弹幕的背景颜色***********/
@property (strong,nonatomic) UIColor *backgroundColor;

/***********弹幕的宽度***********/
@property (assign,nonatomic) CGFloat bulletCellWidth;

@end
