//
//  LMChessmanButton.h
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/10.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMChessmanModel.h"
#import "LMCoordinate.h"

@interface LMChessmanButton : UIButton
//棋子是否存在（棋盘上起作用） 默认是存在的（起作用的）
@property (assign, nonatomic, getter=isExist) BOOL exist;
//棋子的二维坐标
@property (strong, nonatomic) LMCoordinate *coordinate;
//棋子 model
@property (strong, nonatomic) LMChessmanModel *chessmanModel;

+ (LMChessmanButton *)chessmanButtonWithType:(LMChessmanType)type andNumber:(NSInteger)number isRed:(BOOL)isRed;
/*
 设置圆角
 */
- (void)setCornerRadiusWith:(CGFloat)radius;

// =============== 规则 ===============
/*
 是否是老帅
 */
- (BOOL)isking;
/*
 是否能移动到坐标点
 */
- (BOOL)isCanMoveToCoordinate:(LMCoordinate *)coordinate;
@end
