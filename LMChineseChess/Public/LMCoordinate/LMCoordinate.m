//
//  LMCoordinate.m
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/10.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import "LMCoordinate.h"

@implementation LMCoordinate
+ (LMCoordinate *)coordinateWithX:(NSInteger)x withY:(NSInteger)y
{
    LMCoordinate *coordicate = [[LMCoordinate alloc]init];
    coordicate.x = x;
    coordicate.y = y;
    return coordicate;
}
/*
 判断两个二维坐标是否相等
 */
- (BOOL)isEqualtToCoordinate:(LMCoordinate *)coordinate
{
    return (self.x == coordinate.x) && (self.y == coordinate.y);
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%zd, %zd", self.x, self.y];
}
@end
