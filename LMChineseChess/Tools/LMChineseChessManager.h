//
//  LMChineseChessManager.h
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/11.
//  Copyright © 2018年 转角街坊. All rights reserved.
//  象棋棋盘棋盘规则管理人员

#import <Foundation/Foundation.h>
#import "LMChessmanButton.h"

#define kChineseChessManager [LMChineseChessManager sharedInstance]

/*
 棋子移动状态
 */
typedef NS_ENUM(NSInteger, LMChessmanActionType) {
    LMChessmanActionType_move,      //移动棋子
    LMChessmanActionType_eat,       //吃掉棋子
};

/*
 被将状态
 */
typedef NS_ENUM(NSInteger, LMCheckedType) {
    LMCheckedType_noChecked,        //没有被将
    LMCheckedType_redChecked,       //红棋被将
    LMCheckedType_blackChecked,     //红棋被将
};

// 防止有子类 (感谢评论区网友提醒)
__attribute__((objc_subclassing_restricted))

@interface LMChineseChessManager : NSObject

//是否是红方先行
@property (assign, nonatomic, getter=isRedStart) BOOL redStart;
//面向自己这边是否是红方
@property (assign, nonatomic, getter=isMeIsRed) BOOL meIsRed;
//下一步是否是红棋走
@property (assign, nonatomic, getter=isNextIsRed) BOOL nextIsRed;
//被将状态
@property (assign, nonatomic) LMCheckedType checkedType;

/**
 单例类方法
 @return 返回一个共享对象
 */
+ (instancetype)sharedInstance;
/**
 配置起步规则
 */
- (void)configure;
/**
 是否能选中棋子
 */
- (BOOL)isCanSelectedWithModel:(LMChessmanModel *)chessmanModel;
//=================== 棋子移动 ===================
/*
 是否 firstChessmanModel 能吃掉 secondChessmanModel
 */
- (BOOL)isModel:(LMChessmanModel *)firstChessmanModel canEatModel:(LMChessmanModel *)secondChessmanModel withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr;
/*
 是否 ChessmanModel 能更新到 coordinate
 */
- (BOOL)isModel:(LMChessmanModel *)chessmanModel canUpdateToCoordinate:(LMCoordinate *)coordinate withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr;
//=================== 判断将军 ===================
/*
 判断是否处于将军的状态
 */
- (LMCheckedType)isCheckedWithRedKingModel:(LMChessmanModel *)redKingModel andBlackKingModel:(LMChessmanModel *)blackKingModel withRedModelArr:(NSMutableArray<LMChessmanButton *> *)redButtonArr anBlackModelArr:(NSMutableArray<LMChessmanButton *> *)blackButtonArr withButtonArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr;
/*
 判断红方是否处于将军的状态
 */
- (LMCheckedType)isCheckedWithRedKingModel:(LMChessmanModel *)redKingModel andBlackModelArr:(NSMutableArray<LMChessmanButton *> *)blackButtonArr withButtonArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr;
/*
 判断黑方是否处于将军的状态
 */
- (LMCheckedType)isCheckedWithBlackKingModel:(LMChessmanModel *)blackKingModel andRedModelArr:(NSMutableArray<LMChessmanButton *> *)redButtonArr withButtonArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr;
@end
