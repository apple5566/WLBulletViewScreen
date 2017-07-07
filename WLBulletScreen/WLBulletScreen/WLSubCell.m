//
//  WLSubCell.m
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/5.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import "WLSubCell.h"
#import "WLBulletModel.h"

@interface WLSubCell ()

/***********弹幕内容标签***********/
@property (weak,nonatomic) UILabel *textLabel;

@end

@implementation WLSubCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpBasic];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpBasic];
}

- (void)setUpBasic
{
    UILabel *textLabel = [UILabel new];
    textLabel.textColor = [UIColor whiteColor];
    _textLabel = textLabel;
    [self addSubview:textLabel];
}

- (void)setModel:(WLBulletModel *)model
{
    _model = model;
    
    _textLabel.text = model.message;
    [_textLabel sizeToFit];
    self.backgroundColor = model.backgroundColor;
    model.bulletCellWidth = _textLabel.bounds.size.width;
}



@end
