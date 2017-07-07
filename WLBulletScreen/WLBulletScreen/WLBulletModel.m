//
//  WLBulletModel.m
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/5.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import "WLBulletModel.h"

@implementation WLBulletModel

+ (instancetype)bulletModelWithDict:(NSDictionary *)dict
{
    WLBulletModel *model = [self new];
    [model setValuesForKeysWithDictionary:dict];
    model.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
