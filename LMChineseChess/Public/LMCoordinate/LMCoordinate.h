//
//  LMCoordinate.h
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/10.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMCoordinate : NSObject
//棋盘相交点的 x 坐标
@property (assign, nonatomic) NSInteger x;
//棋盘相交点的 y 坐标
@property (assign, nonatomic) NSInteger y;

+ (LMCoordinate *)coordinateWithX:(NSInteger)x withY:(NSInteger)y;
/*
 判断两个二维坐标是否相等
 */
- (BOOL)isEqualtToCoordinate:(LMCoordinate *)coordinate;
@end
