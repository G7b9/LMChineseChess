//
//  LMChessmanModel.m
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/10.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import "LMChessmanModel.h"

@implementation LMChessmanModel
/*
 构造器
 */
+ (LMChessmanModel *)chessmanModelWithType:(LMChessmanType)type andNumber:(NSInteger)number
{
    LMChessmanModel *model = [[LMChessmanModel alloc]init];
    model.chessmanType = type;
    model.number = number;
    return model;
}
/*
 显示名称
 */
- (NSString *)nameString
{
    /*
     LMChessmanType_Rooks,       //车
     LMChessmanType_Knights,     //马
     LMChessmanType_Elephants,   //象
     LMChessmanType_Mandarins,   //士
     LMChessmanType_king,        //将
     LMChessmanType_Cannons,     //炮
     LMChessmanType_Pawns,       //卒
     */
    switch (self.chessmanType) {
        case LMChessmanType_Rooks:
            return @"车";
            break;
        case LMChessmanType_Knights:
            return @"马";
            break;
        case LMChessmanType_Elephants:
            return self.isRed ? @"相" : @"象";
            break;
        case LMChessmanType_Mandarins:
            return self.isRed ? @"仕" : @"士";
            break;
        case LMChessmanType_king:
            return self.isRed ? @"帥" : @"将";
            break;
        case LMChessmanType_Cannons:
            return @"炮";
            break;
        case LMChessmanType_Pawns:
            return self.isRed ? @"兵" : @"卒";
            break;
        default:
            return @"奇";
            break;
    }
}
/*
 是否能移动到坐标点
 */
- (BOOL)isCanMoveToCoordinate:(LMCoordinate *)coordinate
{
    switch (self.chessmanType) {
        case LMChessmanType_Pawns:{//兵
            NSLog(@"currentCoordinate = %@ destinationCoordinate = %@", self.coordinate.description, coordinate.description);
            if (self.isRed) {//自己
                if (self.coordinate.y >= 5) {//红方未过河
                    return (self.coordinate.x == coordinate.x) && (self.coordinate.y == coordinate.y + 1);
                } else {//红方过河兵
                    if (coordinate.y > self.coordinate.y) {//不能倒着走
                        return NO;
                    } else {//正着走
                        if ((coordinate.x == self.coordinate.x) && (coordinate.y == self.coordinate.y - 1)) {//往前走
                            return YES;
                        } else if (coordinate.y == self.coordinate.y) {
                            return (coordinate.x == self.coordinate.x + 1) || (coordinate.x == self.coordinate.x - 1);
                        } else {
                            return NO;
                        }
                    }
                }
            } else {
                
            }
            return NO;
        }
            break;
        default://默认不能移动
            return NO;
            break;
    }
}
@end
