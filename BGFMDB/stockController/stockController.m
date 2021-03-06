//
//  stockController.m
//  BGFMDB
//
//  Created by huangzhibiao on 17/3/9.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import "stockController.h"
#import "stockModel.h"

@interface stockController ()

@property(nonatomic,strong)NSNumber* shenData;
@property(nonatomic,strong)NSNumber* huData;
@property(nonatomic,strong)NSNumber* chuangData;

@property(nonatomic,strong)stockModel* shenStock;
@property(nonatomic,strong)stockModel* huStock;
@property(nonatomic,strong)stockModel* chuangStock;

@property (weak, nonatomic) IBOutlet UILabel *shenLab;
@property (weak, nonatomic) IBOutlet UILabel *huLab;
@property (weak, nonatomic) IBOutlet UILabel *chuangLab;

@property(nonatomic,assign)BOOL updateFlag;//停止循环更新标志;
- (IBAction)backAction:(id)sender;

@end

@implementation stockController

-(void)dealloc{
    //移除数据变化监听.
    [stockModel removeChangeWithName:@"stock"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册数据变化监听.
    [self registerChange];
    
    //深市数据初始
    _shenData = @(10427.24);
    stockModel* shenStock = [stockModel stockWithName:@"深市" stockData:_shenData];
    _shenStock = shenStock;
    [shenStock save];
    //沪市数据初始
    _huData = @(3013.56);
    stockModel* huStock = [stockModel stockWithName:@"沪市" stockData:_huData];
    _huStock = huStock;
    [huStock save];
    //创业板数据初始
    _chuangData = @(1954.91);
    stockModel* chuangStock = [stockModel stockWithName:@"创业版" stockData:_chuangData];
    _chuangStock = chuangStock;
    [chuangStock save];
    
    _updateFlag = YES;//设置循环更新标志.
    [self performSelector:@selector(updateData) withObject:nil afterDelay:1.0];
}

-(void)updateData{
    //更新深市数据
    _shenData = [NSNumber numberWithFloat:(float)(rand()%300) + 10427.24];
    _shenStock.stockData = _shenData;
    [_shenStock updateWhere:@[@"name",@"=",@"深市"]];
    //更新沪市数据
    _huData = [NSNumber numberWithFloat:(float)(rand()%200) + 3013.56];
    _huStock.stockData = _huData;
    [_huStock updateWhere:@[@"name",@"=",@"沪市"]];
    //更新创业板数据
    _chuangData = [NSNumber numberWithFloat:(float)(rand()%500) + 1954.91];
    _chuangStock.stockData = _chuangData;
    [_chuangStock updateWhere:@[@"name",@"=",@"创业版"]];
    
    !_updateFlag?:[self performSelector:@selector(updateData) withObject:nil afterDelay:1.0];
}

//注册数据变化监听.
-(void)registerChange{
    //注册数据变化监听.
    __weak typeof(self) BGSelf = self;
    [stockModel registerChangeWithName:@"stock" block:^(changeState result) {
        NSLog(@"当前线程 = %@",[NSThread currentThread]);
        if ((result==Insert) || (result==Update)){
            //读取深市数据.
            stockModel* shen = [stockModel findWhere:@[@"name",@"=",@"深市"]].lastObject;
            BGSelf.shenLab.text = shen.stockData.stringValue;
            //读取沪市数据.
            stockModel* hu = [stockModel findWhere:@[@"name",@"=",@"沪市"]].lastObject;
            BGSelf.huLab.text = hu.stockData.stringValue;
            //读取创业版数据.
            stockModel* chuang = [stockModel findWhere:@[@"name",@"=",@"创业版"]].lastObject;
            BGSelf.chuangLab.text = chuang.stockData.stringValue;
        }
    }];
}

- (IBAction)backAction:(id)sender {
    _updateFlag = NO;//停止更新操作.
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
