//
//  LMChineseChessManager.m
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/11.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import "LMChineseChessManager.h"
#import <math.h>

static LMChineseChessManager* kLMChineseChessManager = nil;


/**
 方位
 */
typedef NS_ENUM(NSInteger, LMDirectionType) {
    LMDirectionType_top,            //上
    LMDirectionType_top_left,       //上左
    LMDirectionType_left,           //左
    LMDirectionType_left_bottom,    //左下
    LMDirectionType_bottom,         //下
    LMDirectionType_bottom_right,   //下右
    LMDirectionType_right,          //右
    LMDirectionType_right_top,      //右上
};

@implementation LMChineseChessManager
/**
 配置起步规则
 */
- (void)configure
{
    //配置先行方
    self.redStart = YES;
    //配置自己这方为红棋
    self.meIsRed = YES;
    //下一步是否是是红棋走
    self.nextIsRed = YES;
    //清空被将
    self.checkedType = LMCheckedType_noChecked;
}
/**
 是否能选中棋子
 */
- (BOOL)isCanSelectedWithModel:(LMChessmanModel *)chessmanModel
{
    return self.isNextIsRed == chessmanModel.isRed;
}
/*
 是否 firstChessmanModel 能吃掉 secondChessmanModel
 */
- (BOOL)isModel:(LMChessmanModel *)firstChessmanModel canEatModel:(LMChessmanModel *)secondChessmanModel withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    //先简单判断  需要优化
    if ((self.isNextIsRed == firstChessmanModel.isRed) && (self.isNextIsRed != secondChessmanModel.isRed)) {//吃别人的子
        //判断是否在攻击范围内
        return [self isModel:firstChessmanModel canAttackModel:secondChessmanModel withChessmanArr:chessmanButtonArr];
    } else {//不能吃自己的子
        return NO;
    }
}
/*
 是否 firstChessmanModel 能攻击到 secondChessmanModel 的位置
 */
- (BOOL)isModel:(LMChessmanModel *)firstChessmanModel canAttackModel:(LMChessmanModel *)secondChessmanModel withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    if ([self isModel:firstChessmanModel canMoveToCoordinate:secondChessmanModel.coordinate withChessmanArr:chessmanButtonArr] && [self isMeetModel:firstChessmanModel withDestinationCoordinate:secondChessmanModel.coordinate withChessmanArr:chessmanButtonArr withActiontype:LMChessmanActionType_eat]) {//当前棋子是否能移动到下个位置 && 附加规则
        return YES;
    } else {//不能移动到下个位置
        return NO;
    }
}
/*
 是否 ChessmanModel 能更新到 coordinate
 */
- (BOOL)isModel:(LMChessmanModel *)chessmanModel canUpdateToCoordinate:(LMCoordinate *)coordinate withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    return [self isModel:chessmanModel canMoveToCoordinate:coordinate withChessmanArr:chessmanButtonArr] && [self isMeetModel:chessmanModel withDestinationCoordinate:coordinate withChessmanArr:chessmanButtonArr withActiontype:LMChessmanActionType_move];
}
/*
 是否 ChessmanModel 能移动到 coordinate
 */
- (BOOL)isModel:(LMChessmanModel *)chessmanModel canMoveToCoordinate:(LMCoordinate *)coordinate withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    NSLog(@"currentCoordinate = %@ destinationCoordinate = %@", chessmanModel.coordinate.description, coordinate.description);
    switch (chessmanModel.chessmanType) {
        case LMChessmanType_Pawns:{//兵
            if (self.meIsRed == chessmanModel.isRed) {//自己这方的兵
                if (chessmanModel.coordinate.y >= 5) {//自己这方未过河
                    return (chessmanModel.coordinate.x == coordinate.x) && (chessmanModel.coordinate.y == coordinate.y + 1);
                } else {//自己这方过河兵
                    if (coordinate.y > chessmanModel.coordinate.y) {//不能倒着走
                        return NO;
                    } else {//正着走
                        if ((coordinate.x == chessmanModel.coordinate.x) && (coordinate.y == chessmanModel.coordinate.y - 1)) {//往前走
                            return YES;
                        } else if (coordinate.y == chessmanModel.coordinate.y) {
                            return (coordinate.x == chessmanModel.coordinate.x + 1) || (coordinate.x == chessmanModel.coordinate.x - 1);
                        } else {
                            return NO;
                        }
                    }
                }
            } else {
                if (chessmanModel.coordinate.y < 5) {//对面这方未过河
                    return (chessmanModel.coordinate.x == coordinate.x) && (chessmanModel.coordinate.y == coordinate.y - 1);
                } else {//对面这方过河兵
                    if (coordinate.y < chessmanModel.coordinate.y) {//不能倒着走
                        return NO;
                    } else {//正着走
                        if ((coordinate.x == chessmanModel.coordinate.x) && (coordinate.y == chessmanModel.coordinate.y + 1)) {//往前走
                            return YES;
                        } else if (coordinate.y == chessmanModel.coordinate.y) {
                            return (coordinate.x == chessmanModel.coordinate.x + 1) || (coordinate.x == chessmanModel.coordinate.x - 1);
                        } else {
                            return NO;
                        }
                    }
                }
            }
            return NO;
        }
            break;
        case LMChessmanType_Cannons:{//炮
            //炮走直线
            return (coordinate.x == chessmanModel.coordinate.x) || (coordinate.y == chessmanModel.coordinate.y);
        }
            break;
        case LMChessmanType_Rooks:{//车
            //车走直线
            return (coordinate.x == chessmanModel.coordinate.x) || (coordinate.y == chessmanModel.coordinate.y);
        }
            break;
        case LMChessmanType_Knights:{//马
            //马走日
            long xLabsValue = labs((int)coordinate.x - chessmanModel.coordinate.x);
            long yLabsValue = labs((int)coordinate.y - chessmanModel.coordinate.y);
            return (xLabsValue == 1 && yLabsValue == 2) || (xLabsValue == 2 && yLabsValue == 1);
        }
            break;
        case LMChessmanType_Elephants:{//象
            //是否过河
            if (self.isMeIsRed == chessmanModel.isRed) {//朝自己这方
                if (coordinate.y <= 4) {
                    NSLog(@"象不能过河");
                    return NO;
                }
            } else {
                if (coordinate.y > 4) {
                    NSLog(@"象不能过河");
                    return NO;
                }
            }
            //象走田
            long xLabsValue = labs((int)coordinate.x - chessmanModel.coordinate.x);
            long yLabsValue = labs((int)coordinate.y - chessmanModel.coordinate.y);
            return (xLabsValue == 2 && yLabsValue == 2);
        }
            break;
        case LMChessmanType_Mandarins:{//士
            //是否过出宫
            if (self.isMeIsRed == chessmanModel.isRed) {//朝自己这方
                if (!((coordinate.x >= 3) && (coordinate.x <= 5) && (coordinate.y >= 7))) {
                    NSLog(@"士不能出宫");
                    return NO;
                }
            } else {
                if (!((coordinate.x >= 3) && (coordinate.x <= 5) && (coordinate.y <= 2))) {
                    NSLog(@"士不能出宫");
                    return NO;
                }
            }
            //士走斜
            long xLabsValue = labs((int)coordinate.x - chessmanModel.coordinate.x);
            long yLabsValue = labs((int)coordinate.y - chessmanModel.coordinate.y);
            return (xLabsValue == 1 && yLabsValue == 1);
        }
            break;
        case LMChessmanType_king:{//帥
            //是否过出宫
            if (self.isMeIsRed == chessmanModel.isRed) {//朝自己这方
                if (!((coordinate.x >= 3) && (coordinate.x <= 5) && (coordinate.y >= 7))) {
                    NSLog(@"帥不能出宫");
                    return NO;
                }
            } else {
                if (!((coordinate.x >= 3) && (coordinate.x <= 5) && (coordinate.y <= 2))) {
                    NSLog(@"帥不能出宫");
                    return NO;
                }
            }
            //将一步一步走
            long xLabsValue = labs((int)coordinate.x - chessmanModel.coordinate.x);
            long yLabsValue = labs((int)coordinate.y - chessmanModel.coordinate.y);
            return ((xLabsValue == 1 && yLabsValue == 0) || (xLabsValue == 0 && yLabsValue == 1));
        }
            break;
        default://默认不能移动
            return NO;
            break;
    }
}
/*
 是否满足相对应的规则 如：中间是否隔子、拗马脚、拗象脚
 */
- (BOOL)isMeetModel:(LMChessmanModel *)chessmanModel withDestinationCoordinate:(LMCoordinate *)coordinate withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr withActiontype:(LMChessmanActionType)actionType
{
    switch (chessmanModel.chessmanType) {
        case LMChessmanType_Pawns:{//卒 兵没有其他规则
            return YES;
        }
            break;
        case LMChessmanType_Cannons:{//炮
            //是否走直线
            if ((chessmanModel.coordinate.x != coordinate.x) && chessmanModel.coordinate.y != coordinate.y) {//炮不走直线就不好玩了
                NSLog(@"炮走直线的好嘛😓");
                return NO;
            } else {//炮走直线
                NSInteger barrierNum = [self isHaveBarrierWirhModel:chessmanModel WithDestinationCoordinate:coordinate withChessmanArr:chessmanButtonArr];
                if (barrierNum == 0) {//没障碍
                    //判断目标点是否有棋子
                    if ([self chessmanButtonWithCoordinate:coordinate withChessmanArr:chessmanButtonArr]) {//目标点有棋子
                        return NO;
                    } else {//无障碍，落子点没有棋子
                        return YES;
                    }
                } else if (barrierNum == 1) {//障碍数等于 1
                    switch (actionType) {
                        case LMChessmanActionType_move://不能隔子移动
                            return NO;
                            break;
                            case LMChessmanActionType_eat://可以隔子吃子
                            return YES;
                            break;
                        default:
                            break;
                    }
                } else {//障碍数量大于 1
                    return NO;
                }
            }
        }
            break;
        case LMChessmanType_Rooks:{//车
            //是否走直线
            if ((chessmanModel.coordinate.x != coordinate.x) && chessmanModel.coordinate.y != coordinate.y) {//车不走直线就不好玩了
                NSLog(@"车走直线的好嘛😓");
                return NO;
            } else {//车走直线
                NSInteger barrierNum = [self isHaveBarrierWirhModel:chessmanModel WithDestinationCoordinate:coordinate withChessmanArr:chessmanButtonArr];
                if (barrierNum == 0) {//没障碍
                    //判断目标点是否有棋子
                    LMChessmanButton *chessmanButton = [self chessmanButtonWithCoordinate:coordinate withChessmanArr:chessmanButtonArr];
                    if (chessmanButton) {//目标点有棋子
                        if (chessmanModel.isRed == chessmanButton.chessmanModel.isRed) {//落子点是自己的棋子
                            return NO;
                        } else {//吃掉对面的棋子
                            return YES;
                        }
                    } else {//无障碍，落子点没有棋子
                        return YES;
                    }
                } else {//有障碍
                    return NO;
                }
            }
        }
            break;
        case LMChessmanType_Knights:{//马
            LMDirectionType directionType;
            //是否走日
            NSInteger xValue = coordinate.x - chessmanModel.coordinate.x;
            NSInteger yValue = coordinate.y - chessmanModel.coordinate.y;
            long xLabsValue = labs((long)xValue);
//            long yLabsValue = labs((long)yValue);
            if (xLabsValue == 2) {
                if (xValue > 0) {
                    directionType = LMDirectionType_right;
                } else {
                    directionType = LMDirectionType_left;
                }
            } else {
                if (yValue > 0) {
                    directionType = LMDirectionType_bottom;
                } else {
                    directionType = LMDirectionType_top;
                }
            }
            //障碍方向
            LMCoordinate *barrierCoordinate = [[LMCoordinate alloc]init];
            switch (directionType) {
                case LMDirectionType_top:{
                    barrierCoordinate.x = chessmanModel.coordinate.x;
                    barrierCoordinate.y = chessmanModel.coordinate.y - 1;
                }
                    break;
                case LMDirectionType_bottom:{
                    barrierCoordinate.x = chessmanModel.coordinate.x;
                    barrierCoordinate.y = chessmanModel.coordinate.y + 1;
                }
                    break;
                case LMDirectionType_left:{
                    barrierCoordinate.x = chessmanModel.coordinate.x - 1;
                    barrierCoordinate.y = chessmanModel.coordinate.y;
                }
                    break;
                case LMDirectionType_right:{
                    barrierCoordinate.x = chessmanModel.coordinate.x + 1;
                    barrierCoordinate.y = chessmanModel.coordinate.y;
                }
                    break;
                default:
                    break;
            }
            if ([self chessmanButtonWithCoordinate:barrierCoordinate withChessmanArr:chessmanButtonArr]) {//有障碍
                NSLog(@"拗马脚");
                return NO;
            } else {
                return YES;
            }
        }
            break;
        case LMChessmanType_Elephants:{//象
            //障碍方向
            LMDirectionType directionType;
            //是否走田
            NSInteger xValue = coordinate.x - chessmanModel.coordinate.x;
            NSInteger yValue = coordinate.y - chessmanModel.coordinate.y;
//            long xLabsValue = labs((long)xValue);
            //            long yLabsValue = labs((long)yValue);
            if (xValue > 0) {
                if (yValue > 0) {
                    directionType = LMDirectionType_bottom_right;
                } else {
                    directionType = LMDirectionType_right_top;
                }
            } else {
                if (yValue > 0) {
                    directionType = LMDirectionType_left_bottom;
                } else {
                    directionType = LMDirectionType_top_left;
                }
            }
            //障碍方向
            LMCoordinate *barrierCoordinate = [[LMCoordinate alloc]init];
            switch (directionType) {
                case LMDirectionType_right_top:{
                    barrierCoordinate.x = chessmanModel.coordinate.x + 1;
                    barrierCoordinate.y = chessmanModel.coordinate.y - 1;
                }
                    break;
                case LMDirectionType_bottom_right:{
                    barrierCoordinate.x = chessmanModel.coordinate.x + 1;
                    barrierCoordinate.y = chessmanModel.coordinate.y + 1;
                }
                    break;
                case LMDirectionType_top_left:{
                    barrierCoordinate.x = chessmanModel.coordinate.x - 1;
                    barrierCoordinate.y = chessmanModel.coordinate.y - 1;
                }
                    break;
                case LMDirectionType_left_bottom:{
                    barrierCoordinate.x = chessmanModel.coordinate.x - 1;
                    barrierCoordinate.y = chessmanModel.coordinate.y + 1;
                }
                    break;
                default:
                    break;
            }
            if ([self chessmanButtonWithCoordinate:barrierCoordinate withChessmanArr:chessmanButtonArr]) {//有障碍
                NSLog(@"拗象脚");
                return NO;
            } else {
                return YES;
            }
        }
            break;
        case LMChessmanType_Mandarins:{//士
            return YES;
        }
            break;
        case LMChessmanType_king:{//帥
            return YES;
        }
            break;
        default:
            break;
    }
    return NO;
}
/*
 中间是否有障碍 障碍的数量
 */
- (NSInteger)isHaveBarrierWirhModel:(LMChessmanModel *)chessmanModel WithDestinationCoordinate:(LMCoordinate *)coordinate withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    //默认沿着 x 轴 x 变 y 不变
    BOOL isAlongWithX = (coordinate.y == chessmanModel.coordinate.y);
    NSInteger maxLocation;
    NSInteger minLocation;
    if (isAlongWithX) {
        if (chessmanModel.coordinate.x > coordinate.x) {
            maxLocation = chessmanModel.coordinate.x;
            minLocation = coordinate.x;
        } else {
            maxLocation = coordinate.x;
            minLocation = chessmanModel.coordinate.x;
        }
    } else {
        if (chessmanModel.coordinate.y > coordinate.y) {
            maxLocation = chessmanModel.coordinate.y;
            minLocation = coordinate.y;
        } else {
            maxLocation = coordinate.y;
            minLocation = chessmanModel.coordinate.y;
        }
    }
    
    //遍历棋盘 检查中间是否有障碍
    BOOL isHaveBarrier = NO;
    //中间障碍数量
    NSInteger barrierNum = 0;
    for (NSInteger i = 0; i < chessmanButtonArr.count; ++i) {
//        if (chessmanButtonArr[i].isHidden == NO) {//场上的棋子
        if (chessmanButtonArr[i].isExist) {//场上的棋子
            if (isAlongWithX && (chessmanButtonArr[i].coordinate.y == coordinate.y) && (chessmanButtonArr[i].coordinate.x < maxLocation) && (chessmanButtonArr[i].coordinate.x > minLocation)) {//沿着 x 轴走
                //有障碍棋子
                NSLog(@"中间有障碍棋子");
                isHaveBarrier = YES;
                barrierNum += 1;
            } else if ((!isAlongWithX) && (chessmanButtonArr[i].coordinate.x == coordinate.x) &&  (chessmanButtonArr[i].coordinate.y < maxLocation) && (chessmanButtonArr[i].coordinate.y > minLocation)) {//沿着 y 轴走
                //有障碍棋子
                NSLog(@"中间有障碍棋子");
                isHaveBarrier = YES;
                barrierNum += 1;
            }
        }
    }
//    return @[[NSNumber numberWithBool:isHaveBarrier], [NSNumber numberWithInteger:barrierNum]];
    return barrierNum;
}
/*
 根据坐标找棋子，可能没有棋子
 */
- (LMChessmanButton *)chessmanButtonWithCoordinate:(LMCoordinate *)coordinate withChessmanArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    for (NSInteger i = 0; i < chessmanButtonArr.count; ++i) {
//        if ((chessmanButtonArr[i].isHidden == NO) && [coordinate isEqualtToCoordinate:chessmanButtonArr[i].coordinate]) {
        if ((chessmanButtonArr[i].isExist) && [coordinate isEqualtToCoordinate:chessmanButtonArr[i].coordinate]) {
            return chessmanButtonArr[i];
        }
    }
    return nil;
}
/*
 判断是否处于将军的状态
 */
- (LMCheckedType)isCheckedWithRedKingModel:(LMChessmanModel *)redKingModel andBlackKingModel:(LMChessmanModel *)blackKingModel withRedModelArr:(NSMutableArray<LMChessmanButton *> *)redButtonArr anBlackModelArr:(NSMutableArray<LMChessmanButton *> *)blackButtonArr withButtonArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    //循环判断自红方的老帅是否在别人的攻击范围内
    for (LMChessmanButton *blackFirstModel in blackButtonArr) {
        if ([self isModel:blackFirstModel.chessmanModel canAttackModel:redKingModel withChessmanArr:chessmanButtonArr]) {
            return LMCheckedType_redChecked;
        }
    }
    //循环判断黑方的老帅是否在我的攻击范围内
    for (LMChessmanButton *redFirstModel in redButtonArr) {
        if ([self isModel:redFirstModel.chessmanModel canAttackModel:blackKingModel withChessmanArr:chessmanButtonArr]) {
            return LMCheckedType_blackChecked;
        }
    }
    return LMCheckedType_noChecked;
}
/*
 判断红方是否处于将军的状态
 */
- (LMCheckedType)isCheckedWithRedKingModel:(LMChessmanModel *)redKingModel andBlackModelArr:(NSMutableArray<LMChessmanButton *> *)blackButtonArr withButtonArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    for (LMChessmanButton *blackFirstModel in blackButtonArr) {
        if ([self isModel:blackFirstModel.chessmanModel canAttackModel:redKingModel withChessmanArr:chessmanButtonArr]) {
            return LMCheckedType_redChecked;
        }
    }
    return LMCheckedType_noChecked;
}
/*
 判断黑方是否处于将军的状态
 */
- (LMCheckedType)isCheckedWithBlackKingModel:(LMChessmanModel *)blackKingModel andRedModelArr:(NSMutableArray<LMChessmanButton *> *)redButtonArr withButtonArr:(NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    for (LMChessmanButton *redButton in redButtonArr) {
        NSLog(@"name = %@ description = %@", redButton.chessmanModel.nameString, redButton.chessmanModel.coordinate.description);
        if ([self isModel:redButton.chessmanModel canAttackModel:blackKingModel withChessmanArr:chessmanButtonArr]) {
            return LMCheckedType_blackChecked;
        }
    }
    return LMCheckedType_noChecked;
}
//=================== 创建单例 ===================
/** 单例类方法 */
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kLMChineseChessManager = [[super allocWithZone:NULL] init];
    });
    
    return kLMChineseChessManager;
}

// 重写创建对象空间的方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    // 直接调用单例的创建方法
    return [self sharedInstance];
}

// 重写copy方法
- (id)copy {
    return kLMChineseChessManager;
}

// 重写 mutableCopy 方法
- (id)mutableCopy {
    return kLMChineseChessManager;
}

#pragma mark - 感觉没有上面的经典
//// 重写copy方法
//- (id)copy {
//    return [self.class sharedInstance];
//}
//
//// 重写 mutableCopy 方法
//- (id)mutableCopy {
//    return [self.class sharedInstance];
//}

#pragma mark - 支持MRC
#if !__has_feature(objc_arc)
- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return 1;
}

- (id)autorelease {
    return self;
}

- (oneway void)release {
}
#endif
@end
