//
//  ViewController.m
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/9.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import "ViewController.h"
#import "LMChineseChessVC.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *enterButton;
@end

@implementation ViewController
#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
#pragma mark - setupUI
/**
 创建子控件
 */
- (void)setupUI
{
    self.title = @"中国象棋";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.enterButton = [[UIButton alloc]init];
    [self.enterButton setTitle:@"进入游戏" forState:UIControlStateNormal];
    self.enterButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    [self.enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.enterButton.backgroundColor = [UIColor blackColor];
    [self.enterButton addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enterButton];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}
#pragma mark - 初始化数据
#pragma mark - 监听通知
#pragma mark - 事件处理
/*
 进入游戏
 */
- (void)enterClick:(UIButton *)sender {
    LMChineseChessVC *vc = [[LMChineseChessVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 通知处理
#pragma mark - 代理方法
#pragma mark - extension function
#pragma mark - getters and setters


@end
