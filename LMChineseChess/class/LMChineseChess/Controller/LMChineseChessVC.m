//
//  LMChineseChessVC.m
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/9.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import "LMChineseChessVC.h"
#import "LMChineseChessView.h"

@interface LMChineseChessVC ()<LMChineseChessViewDelegate>
@property (strong, nonatomic) LMChineseChessView *chessView;

@end

@implementation LMChineseChessVC
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建棋盘
    self.chessView = [LMChineseChessView chessView];
    self.chessView.delegate = self;
    self.chessView.backgroundColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:80/255.0 alpha:1.0];
    [self.view addSubview:self.chessView];
    [self.chessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).multipliedBy(10 / 9.0);
    }];
}
#pragma mark - 初始化数据
#pragma mark - 监听通知
#pragma mark - 事件处理
#pragma mark - 通知处理
#pragma mark - 代理方法
#pragma mark - LMChineseChessViewDelegate
- (void)chineseChessViewWithGameOverWithStatus:(BOOL)isWin
{
    NSString *result = isWin ? @"赢" : @"输";
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"游戏结束" message:[NSString stringWithFormat:@"你%@了！", result] preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@", isWin ? @"对面" : @"",@"不服"] style:UIAlertActionStyleCancel handler:nil]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark - extension function
#pragma mark - getters and setters
@end
