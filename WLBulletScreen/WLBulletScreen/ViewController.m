//
//  ViewController.m
//  WLBulletScreen
//
//  Created by Ghost White on 2017/7/4.
//  Copyright © 2017年 Ghost White. All rights reserved.
//

#import "ViewController.h"
#import "WLBulletView.h"
#import "WLBulletModel.h"
#import "WLSubCell.h"

@interface ViewController ()<WLBulletViewDataSource,WLBulletViewDelegate>

/*****弹幕视图*****/
@property (weak, nonatomic) IBOutlet WLBulletView *bulletView;

/***********模型数组***********/
@property (strong,nonatomic) NSMutableArray *models;

/***********保存所有的模型数组***********/
@property (strong,nonatomic) NSArray *saveModels;


@end

@implementation ViewController

- (NSMutableArray *)models
{
    if (!_models)
    {
        _models = [NSMutableArray array];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BarrageFile" ofType:@"plist"];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in dictArray) {
            WLBulletModel *model = [WLBulletModel bulletModelWithDict:dict];
            [_models addObject:model];
        }
        
        _saveModels = [_models copy];
        
        _models = [NSMutableArray arrayWithArray:[_saveModels subarrayWithRange:NSMakeRange(0, 30)]];
    }
    
    return _models;
}

/***
 我的思路:
 每当我加载一群弹幕的时候，我每加载一个弹幕开始动画，我就删除模型数组第一个模型数据，以此类推。
 对于不间断的弹幕，我才用的思路是如果当前还有弹幕我就拼接数组在后面，在后面去加载。

 ****/

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 在xib加载出来子类的宽度有问题，你要在布局完成在去设置数据源和代理就没有问题(这个方法会被多次调用，但是发送数据只有一次)
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self models];
    
    _bulletView.dataSource = self;
    
    _bulletView.bulletViewCellHeight = 30;
    
    _bulletView.delegate = self;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_bulletView sendBulletViewCellsCount:_models.count];
    });

}

// 设置弹幕的样式
- (WLBulletViewCell *)bulletViewCellSetUp:(WLBulletView *)bulletView
{
    WLSubCell *cell = [[WLSubCell alloc] init];
    
    cell.model = _models.firstObject;
    
    return cell;
}

// 设置有多少个通道
- (NSInteger)bulletViewNumberOfGallerys:(WLBulletView *)bulletView
{
    return 5;
}

// 设置弹幕的宽度
- (CGFloat)bulletViewCellWidth:(WLBulletView *)bulletView;
{
    WLBulletModel *model = _models.firstObject;
    return model.bulletCellWidth;
}

// 当弹幕开始动画的回调
- (void)bulletViewCellStartAnimate:(WLBulletView *)bulletView
{

    [_models removeObjectAtIndex:0];
    
    
}

// 再次发送数据
- (IBAction)sendData:(UIButton *)sender {
    
    NSArray *subArray = [_saveModels subarrayWithRange:NSMakeRange(0, 10)];
    
    [_models addObjectsFromArray:subArray];
    [_bulletView sendBulletViewCellsCount:subArray.count];
}

// 关闭弹幕
- (IBAction)closeBullet:(UIButton *)sender {
    
    [_bulletView closeBulletView];
}

// 打开弹幕
- (IBAction)openBullet:(UIButton *)sender {
    
    [_bulletView openBulletView];
    [_bulletView sendBulletViewCellsCount:_models.count];
}

// 点击了弹幕内容的回调
- (void)bulletViewdidSelectedCell:(WLBulletViewCell *)cell WithBulletView:(WLBulletView *)bulletView
{
    NSLog(@"%@",((WLSubCell *)cell).model.message);
}




@end
