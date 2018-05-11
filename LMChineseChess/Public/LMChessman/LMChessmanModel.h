//
//  LMChessmanModel.h
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/10.
//  Copyright © 2018年 转角街坊. All rights reserved.
//  棋子 model

#import <Foundation/Foundation.h>
#import "LMCoordinate.h"

typedef NS_ENUM(NSInteger, LMChessmanType) {
    LMChessmanType_Rooks,       //车
    LMChessmanType_Knights,     //马
    LMChessmanType_Elephants,   //象
    LMChessmanType_Mandarins,   //士
    LMChessmanType_king,        //将
    LMChessmanType_Cannons,     //炮
    LMChessmanType_Pawns,       //卒
};
@interface LMChessmanModel : NSObject
//是否从棋盘上移除了
@property (assign, nonatomic, getter=isRemoved) BOOL removed;
//是否是红方的棋子
@property (assign, nonatomic, getter=isRed) BOOL red;
//自己这方
@property (assign, nonatomic, getter=isMe) BOOL me;
//棋子类型
@property (nonatomic, assign) LMChessmanType chessmanType;
//同类棋子编号
@property (nonatomic, assign) NSInteger number;
//棋子x坐标
@property (nonatomic, assign) NSInteger x;
//棋子y坐标
@property (nonatomic, assign) NSInteger y;
//棋子的二维坐标
@property (strong, nonatomic) LMCoordinate *coordinate;
/*
 构造器
 */
+ (LMChessmanModel *)chessmanModelWithType:(LMChessmanType)type andNumber:(NSInteger)number;
/*
 显示名称
 */
- (NSString *)nameString;
/*
 是否能移动到坐标点
 */
- (BOOL)isCanMoveToCoordinate:(LMCoordinate *)coordinate;
@end
