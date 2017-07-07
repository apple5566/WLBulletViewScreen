//
//  WLBulletView.m
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/4.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import "WLBulletView.h"
#import "WLBulletViewCell.h"

@interface WLBulletView ()

/***********保存当前进入的弹幕的总数***********/
@property (assign,nonatomic) NSInteger intputTotal;

/***********通道的数目***********/
@property (assign,nonatomic) NSInteger galleries;

/***********初始化轨道的数组***********/
@property (strong,nonatomic) NSMutableArray *galleriesArray;

/***********监听最后一个是否刚刚完全进入弹幕***********/
@property (assign,nonatomic) BOOL lastIsOut;

/***********保存最开始的总数***********/
@property (assign,nonatomic) NSInteger initCount;

/***********存储初始化是否发生改变***********/
@property (assign,nonatomic) BOOL isInitCountChange;

/***********记录每次弹幕刚刚完全出去视图的弹幕的个数***********/
@property (assign,nonatomic) NSInteger count;

/***********再次保存最初化的总数(为了方便进行最后一个弹幕刚刚完全进入视图的校验)***********/
@property (assign,nonatomic) NSInteger saveInitTotal;

/***********是否关闭弹幕***********/
@property (assign,nonatomic) BOOL close;







@end

@implementation WLBulletView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpBasic];
    }
    
    return self;
}

- (NSMutableArray *)galleriesArray
{
    _galleriesArray = [NSMutableArray arrayWithCapacity:self.galleries];
    for (int i = 0; i < self.galleries; i++) {
        [_galleriesArray addObject:@(i)];
    }
    return _galleriesArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUpBasic];
}

- (void)setUpBasic
{
    _speed = 50;
    _bulletViewCellHMargin = 20;
    _bulletViewCellVMargin = 50;
    _intputTotal = -1;
    _lastIsOut = YES;
    _count = 0;
}


- (NSInteger)galleries
{
    if (!_galleries)
    {
        if ([_dataSource respondsToSelector:@selector(bulletViewNumberOfGallerys:)])
        {
            _galleries = [_dataSource bulletViewNumberOfGallerys:self];
            
        }else
        {
            NSException *exception = [[NSException alloc] initWithName:@"没有设置通道的数目" reason:NSStringFromSelector(@selector(bulletViewNumberOfGallerys:)) userInfo:nil];
            [exception raise];
        }
    
    }
    
    return _galleries;
}

// 发送消息
- (void)sendBulletViewCellsCount:(NSInteger)count
{
    if(!count) return ;
    
    if (_close)
    {// 如果你关闭的弹幕，但是你在发送数据，我采用的是先把他存储起来，等你打开了弹幕在统一做动画
        _initCount += count;
        return ;
    }
    
    // 先判断当前弹幕剩余的数量
    if (_intputTotal == -1)
    {// 没有弹幕了
        if (_lastIsOut)
        {// 查看最后一个是否出去
            
            _isInitCountChange = NO;
            _lastIsOut = NO;
            _initCount = count;
            _saveInitTotal = _initCount;
            _intputTotal = _initCount-1;
            // 记录弹幕完全出去的个数要清0
            _count = 0;
            
            // 初始化轨道动画
            [self galleriesArray];
            [self initStartAnimation];
            
        }else
        {// 最后一个没有出去，但是这个你在点击弹幕的时候防止进行弹幕进行重叠，我们先把它存起来，等最后一个弹幕刚刚完全出视图我们在把它显示出来
            
            _initCount += count;
            _isInitCountChange = YES;
            
        }
        
    }else
    {// 弹幕没有全部出去，如果你想继续叠加
        
        _intputTotal += count;
        _saveInitTotal += count;
        
    }
    
    
}


// 对于初始化轨道的分配
- (void)initStartAnimation
{
    WLBulletViewCell *cell;
    NSInteger arcIndex ,count = (_intputTotal+1)> _galleries? _galleries : (_intputTotal+1);
    // 默认每个弹幕的宽度为44
    CGFloat cellW = 44,width = self.bounds.size.width ;
   
    for (int i = 0; i < count; i++) {
        
        if ([_dataSource respondsToSelector:@selector(bulletViewCellSetUp:)])
        {
            
            cell = [_dataSource bulletViewCellSetUp:self];
            
            if (!cell)
            {
                NSException *exception = [[NSException alloc] initWithName:@"弹幕为空" reason:NSStringFromSelector(@selector(bulletViewCellSetUp:)) userInfo:nil];
                [exception raise];
            }
            
            _intputTotal--;
            
            cell.number = _intputTotal;
            
            arcIndex = arc4random_uniform((uint32_t)_galleriesArray.count);
            NSInteger gallery = [_galleriesArray[arcIndex] integerValue];
            [_galleriesArray removeObjectAtIndex:arcIndex];
            
            
            if ([_delegate respondsToSelector:@selector(bulletViewCellWidth:)])
            {
                cellW = [_delegate bulletViewCellWidth:self];
            }
            
            cell.frame = CGRectMake(width+_bulletViewCellHMargin, (_bulletViewCellVMargin+_bulletViewCellHeight)*gallery, cellW, _bulletViewCellHeight);
            [self addSubview:cell];
            
            __weak typeof(self) weakSelf = self;
            __weak typeof(cell) weakCell = cell;
            
            [cell animteWithSpeed:_speed WithStart:^{
                
                if ([_delegate respondsToSelector:@selector(bulletViewCellStartAnimate:)])
                {
                    [_delegate bulletViewCellStartAnimate:weakSelf];
                }
                
                if (weakCell.number == -1)
                {
                    _initCount = 0;
                }
                
                
            } WithBeginCellAllScreen:^{
                
                // 记录弹幕刚刚完全进入视图的个数
                _count++;
                
                if (_count == _saveInitTotal)
                {
    
                    if (_isInitCountChange)
                    {
                        _lastIsOut = YES;
                        _count= 0;
                        [self sendBulletViewCellsCount:_initCount];
                        
                    }else
                    {
                        _count= 0;
                        _lastIsOut = YES;
                    }

                    return ;
                }
                
                [weakSelf  notInitAnimate:gallery];
                
            } WithEndAnimate:^{
                
                [weakCell removeFromSuperview];
                
            }];
            
        }else
        {
            NSException *exception = [[NSException alloc] initWithName:@"没有设置弹幕的样式" reason:NSStringFromSelector(@selector(bulletViewCellSetUp:)) userInfo:nil];
            [exception raise];
        }
    
    }
    
    
    
    
    
}

// 对于非初始化轨道的处理
- (void)notInitAnimate:(NSInteger)gallery
{
    if (_intputTotal == -1)
    {
        return ;
        
    }

    WLBulletViewCell *cell;
    CGFloat cellW = 44,width = self.bounds.size.width ;

    if ([_dataSource respondsToSelector:@selector(bulletViewCellSetUp:)])
    {
        
        cell = [_dataSource bulletViewCellSetUp:self];
        
        if (!cell)
        {
            NSException *exception = [[NSException alloc] initWithName:@"弹幕为空" reason:NSStringFromSelector(@selector(bulletViewCellSetUp:)) userInfo:nil];
            [exception raise];
        }
        
        _intputTotal--;
        cell.number = _intputTotal;

        
        if ([_delegate respondsToSelector:@selector(bulletViewCellWidth:)])
        {
            cellW = [_delegate bulletViewCellWidth:self];
        }
        
        cell.frame = CGRectMake(width+_bulletViewCellHMargin, (_bulletViewCellVMargin+_bulletViewCellHeight)*gallery, cellW, _bulletViewCellHeight);
        
        [self addSubview:cell];
        
        __weak typeof(self) weakSelf = self;
        __weak typeof(cell) weakCell = cell;
        
        [cell animteWithSpeed:_speed WithStart:^{
            
            if ([_delegate respondsToSelector:@selector(bulletViewCellStartAnimate:)])
            {
                [_delegate bulletViewCellStartAnimate:weakSelf];
            }
            
            if (weakCell.number == -1)
            {
                _initCount = 0;
            }
            
        } WithBeginCellAllScreen:^{
            
            // 记录弹幕刚刚完全进入视图的个数
            _count++;

            if (_count == _saveInitTotal)
            {// 当最后弹幕刚刚完全进入视图
                
                if (_isInitCountChange)
                {// 初始化值有改变
                    
                    _lastIsOut = YES;
                    _count = 0;
                    [self sendBulletViewCellsCount:_initCount];
                    
                }else
                {// 反之
                    _count = 0;
                    _lastIsOut = YES;
                }
                
                return ;
            }
            
            // 采用递归方式处理
            [weakSelf  notInitAnimate:gallery];
            
        } WithEndAnimate:^{
            
            [weakCell removeFromSuperview];
            
        }];
        
    }else
    {
        NSException *exception = [[NSException alloc] initWithName:@"没有设置弹幕的样式" reason:NSStringFromSelector(@selector(bulletViewCellSetUp:)) userInfo:nil];
        [exception raise];
    }
    
}

// 关闭弹幕
- (void)closeBulletView
{
    for (WLBulletViewCell *subCell in self.subviews) {
        [subCell.layer removeAllAnimations];
        // 由于我是通过延迟时间来判断弹幕完全进入视图的，当我点击关闭弹幕，再点击恢复弹幕和再发送会回调弹幕完全进入视图的block导致会有重叠的现象，为了避免出现这个情况我们必须取消当弹幕完全进入的视图的函数避免
        [NSObject cancelPreviousPerformRequestsWithTarget:subCell];
        [subCell removeFromSuperview];
    }
    _initCount = _intputTotal + 1;
    // 出去弹幕的数量清空
    _intputTotal = -1;
    // 最后一个也无所谓出去了
    _lastIsOut = YES;
    _close = YES;
}

// 打开弹幕
- (void)openBulletView
{
    _close = NO;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [touches.anyObject locationInView:self];
    for (WLBulletViewCell *subCell in self.subviews) {
        if ([subCell.layer.presentationLayer hitTest:point])
        {
            if ([_delegate respondsToSelector:@selector(bulletViewdidSelectedCell:WithBulletView:)])
            {
                [_delegate bulletViewdidSelectedCell:subCell WithBulletView:self];
            }
        }
    }

}






@end
