//
//  LMChineseChessView.h
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/9.
//  Copyright © 2018年 转角街坊. All rights reserved.
//  中国象棋棋盘

#import <UIKit/UIKit.h>
@class LMChineseChessView;

@protocol LMChineseChessViewDelegate <NSObject>
- (void)chineseChessViewWithGameOverWithStatus:(BOOL)isWin;
@end
@interface LMChineseChessView : UIView
@property (nonatomic, weak) id<LMChineseChessViewDelegate> delegate;
/*
 创建棋盘
 */
+ (LMChineseChessView *)chessView;
@end
