//
//  LMChessmanButton.m
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/10.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import "LMChessmanButton.h"

@interface LMChessmanButton ()

@end
@implementation LMChessmanButton
+ (LMChessmanButton *)chessmanButtonWithType:(LMChessmanType)type andNumber:(NSInteger)number isRed:(BOOL)isRed
{
    LMChessmanButton *button = [[LMChessmanButton alloc]init];
    //默认棋子存在（起作用）
    button.exist = YES;
    LMChessmanModel *model = [LMChessmanModel chessmanModelWithType:type andNumber:number];
    model.red = isRed;
    button.chessmanModel = model;
    return button;
}
#pragma mark - setupUI
/*
 设置圆角
 */
- (void)setCornerRadiusWith:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}
/*
 设置选中的背景颜色
 */
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.backgroundColor = selected ? [UIColor yellowColor] : [self getChessmanBackgroundColor];
}
#pragma mark - extension function
/*
 是否是老帅
 */
- (BOOL)isking
{
    return self.chessmanModel.chessmanType == LMChessmanType_king;
}
/*
 是否能移动到坐标点
 */
- (BOOL)isCanMoveToCoordinate:(LMCoordinate *)coordinate
{
    return [self.chessmanModel isCanMoveToCoordinate:coordinate];
}
/*
 返回背景颜色
 */
- (UIColor *)getChessmanBackgroundColor
{
    return self.chessmanModel.isRed ? [UIColor blackColor] : [UIColor whiteColor];
}
#pragma mark - Getter & Setter
- (void)setChessmanModel:(LMChessmanModel *)chessmanModel
{
    _chessmanModel = chessmanModel;
    //设置名称
    [self setTitle:[chessmanModel nameString] forState:UIControlStateNormal];
    //设置颜色
    [self setTitleColor:chessmanModel.isRed ? [UIColor redColor] : [UIColor blackColor] forState:UIControlStateNormal];
    //设置背景颜色
    self.backgroundColor = [self getChessmanBackgroundColor];
}
- (void)setCoordinate:(LMCoordinate *)coordinate
{
    _coordinate = coordinate;
    self.chessmanModel.coordinate = coordinate;
}
- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    self.exist = !hidden;
    NSLog(@"name = %@ hidden - %ld exist = %ld", self.chessmanModel.nameString, (long)hidden, (long)self.isExist);
}
@end
