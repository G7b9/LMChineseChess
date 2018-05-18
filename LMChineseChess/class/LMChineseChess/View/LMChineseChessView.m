//
//  LMChineseChessView.m
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/9.
//  Copyright © 2018年 转角街坊. All rights reserved.
//
#define gridColNum 9        //每一列的格子数
#define rowLineNum  11      //线行数
#define rowGridNum  4       //上下部分格子行数
#define colLineNum 9        //线列数

#define chessmanSizeRate 0.9//棋子宽度与格子宽度比例

/*
 LMChessmanType_Rooks,       //车
 LMChessmanType_Knights,     //马
 LMChessmanType_Elephants,   //象
 LMChessmanType_Mandarins,   //士
 LMChessmanType_king,        //将
 LMChessmanType_Cannons,     //炮
 LMChessmanType_Pawns,       //卒
 */
//棋子个数
#define RooksNum 2      //车
#define KnightsNum 2    //马
#define ElephantsNum 2  //象
#define MandarinsNum 2  //士
#define kingNum 1       //将
#define CannonsNum 2    //炮
#define PawnsNum 5      //卒

#import "LMChineseChessView.h"
#import "LMChineseChessManager.h"
#import "LMChessmanButton.h"
#import "LMCoordinate.h"

@interface LMChineseChessView ()
//整盘棋子
@property (strong, nonatomic) NSMutableArray<LMChessmanButton *> *chessmanButtonArr;
//红方棋子
@property (strong, nonatomic) NSMutableArray<LMChessmanButton *> *redChessmanButtonArr;
//黑方棋子
@property (strong, nonatomic) NSMutableArray<LMChessmanButton *> *blackChessmanButtonArr;
//红方老帥
@property (strong, nonatomic) LMChessmanButton *redKingButton;
//黑方老将
@property (strong, nonatomic) LMChessmanButton *blackKingButton;
//选中的棋子
@property (strong, nonatomic) LMChessmanButton *selectedButton;
//棋子移动终点位置
@property (assign, nonatomic) CGPoint destinationPoint;
//棋子进行状态
@property (assign, nonatomic) LMChessmanActionType chessmanStatusType;
@end
@implementation LMChineseChessView
/*
 创建棋盘
 */
+ (LMChineseChessView *)chessView
{
    LMChineseChessView *chessView = [[LMChineseChessView alloc]init];
    //初始化棋盘
    [chessView configure];
    return chessView;
}
/*
 配置棋盘
 */
- (void)configure
{
    //配置红方棋子
    [self setupChessmanIsRed:YES];
    //配置黑方棋子
    [self setupChessmanIsRed:NO];
    
    //配置其实规则
    [kChineseChessManager configure];
    
//    //配置先行方
//    self.redStart = YES;
//    //配置自己这方为红棋
//    self.meIsRed = YES;
//    //下一步是否是是红棋走
//    self.nextIsRed = YES;
}
- (void)setupChessmanIsRed:(BOOL)isRed
{
    for (NSInteger i = 0; i < 7; ++i) {
        [self createChessmanWithType:i isRed:isRed];
    }
    /*
     //兵
     [self createChessmanWithType:LMChessmanType_Pawns isRed:isRed];
     
     //炮
     [self createChessmanWithType:LMChessmanType_Cannons isRed:isRed];
     
     //车
     [self createChessmanWithType:LMChessmanType_Rooks isRed:isRed];
     
     //马
     [self createChessmanWithType:LMChessmanType_Knights isRed:isRed];
     
     //象
     [self createChessmanWithType:LMChessmanType_Elephants isRed:isRed];
     
     //士
     [self createChessmanWithType:LMChessmanType_Mandarins isRed:isRed];
     
     //将
     [self createChessmanWithType:LMChessmanType_king isRed:isRed];
     */
}
/*
 创建对应类型的棋子
 */
- (void)createChessmanWithType:(LMChessmanType)type isRed:(BOOL)isRed
{
    CGFloat gridWidth = SCREEN_WIDTH / gridColNum;          //格子的宽
    //    CGFloat gridHalfWidth = gridWidth * 0.5;
    CGFloat gridHeight = gridWidth;                         //格子的高
    //    CGFloat gridHalfHeight = gridHeight * 0.5;
    CGFloat buttonWidth = gridWidth * chessmanSizeRate;
    CGFloat buttonHeight = gridHeight * chessmanSizeRate;
    
    NSArray<NSString *> *coordinateArr;
    switch (type) {
        case LMChessmanType_Pawns://兵
            coordinateArr = isRed ? @[@"0-6", @"2-6", @"4-6", @"6-6", @"8-6"] : @[@"0-3", @"2-3", @"4-3", @"6-3", @"8-3"];
            break;
        case LMChessmanType_Cannons:
            coordinateArr = isRed ? @[@"1-7", @"7-7"] : @[@"1-2", @"7-2"];
            break;
        case LMChessmanType_Rooks:
            coordinateArr = isRed ? @[@"0-9", @"8-9"] : @[@"0-0", @"8-0"];
            break;
        case LMChessmanType_Knights:
            coordinateArr = isRed ? @[@"1-9", @"7-9"] : @[@"1-0", @"7-0"];
            break;
        case LMChessmanType_Elephants:
            coordinateArr = isRed ? @[@"2-9", @"6-9"] : @[@"2-0", @"6-0"];
            break;
        case LMChessmanType_Mandarins:
            coordinateArr = isRed ? @[@"3-9", @"5-9"] : @[@"3-0", @"5-0"];
            break;
        case LMChessmanType_king:
            coordinateArr = isRed ? @[@"4-9"] : @[@"4-0"];
            break;
        default:
            break;
    }
    for (NSInteger i = 0; i < coordinateArr.count; ++i) {
        LMChessmanButton *button = [LMChessmanButton chessmanButtonWithType:type andNumber:i isRed:isRed];
        //绑定老帥、老将
        if (type == LMChessmanType_king) {
            if (isRed) {
                self.redKingButton = button;
            } else {
                self.blackKingButton = button;
            }
        }
        [button addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        //设置圆角
        [button setCornerRadiusWith:buttonWidth * 0.5];
        [self addSubview:button];
        //添加到棋盘
        [self.chessmanButtonArr addObject:button];
        if (isRed) {
            [self.redChessmanButtonArr addObject:button];
        } else {
            [self.blackChessmanButtonArr addObject:button];
        }
        NSArray<NSString *> *coordinatStringeArr = [coordinateArr[i] componentsSeparatedByString:@"-"];
        LMCoordinate *coordinate = [LMCoordinate coordinateWithX:[coordinatStringeArr[0] integerValue] withY:[coordinatStringeArr[1] integerValue]];
        button.coordinate = coordinate;
        CGPoint point = [self chessmanPointWithCoordinateX:coordinate.x withY:coordinate.y];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
            make.left.mas_equalTo(point.x);
            make.top.mas_equalTo(point.y);
        }];
    }
}
- (void)updateConstraints
{
    switch (self.chessmanStatusType) {
        case LMChessmanActionType_move:{//移动棋子
            [self.selectedButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.destinationPoint.x);
                make.top.mas_equalTo(self.destinationPoint.y);
            }];
        }
            break;
        case LMChessmanActionType_eat:{//吃掉棋子
            [self.selectedButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.destinationPoint.x);
                make.top.mas_equalTo(self.destinationPoint.y);
            }];
        }
            break;
        default:
            break;
    }
    [super updateConstraints];
}
#pragma mark - 事件处理
/*
 选中（取消）棋子
 */
- (void)selectedAction:(LMChessmanButton *)sender {
    
    if (self.selectedButton == nil) {//选中第一颗棋子
        if ([kChineseChessManager isCanSelectedWithModel:sender.chessmanModel] == NO) {//不能选中这颗
            return;
        }
        sender.selected = YES;
        self.selectedButton = sender;
    } else {//选中第二颗棋子
        if (self.selectedButton.chessmanModel.isRed == sender.chessmanModel.isRed) {//选择的同一方的棋子
            if ([sender isEqual:self.selectedButton]) {//选中/取消选中当前棋子
                sender.selected = !sender.isSelected;
                self.selectedButton = sender.isSelected ? sender : nil;
                return;
            } else {//选中其他棋子
                self.selectedButton.selected = NO;
                sender.selected = !sender.isSelected;
                self.selectedButton = sender;
                return;
            }
        }
        if ([kChineseChessManager isModel:self.selectedButton.chessmanModel canEatModel:sender.chessmanModel withChessmanArr:self.chessmanButtonArr] == NO) {//不可以吃掉这颗
            return;
        }
        //=================== 开始吃 ===================
        LMCoordinate *tempCoordinate = [LMCoordinate coordinateWithX:self.selectedButton.coordinate.x withY:self.selectedButton.coordinate.y];
        self.selectedButton.coordinate.x = sender.coordinate.x;
        self.selectedButton.coordinate.y = sender.coordinate.y;
        sender.exist = NO;
        BOOL isCanEat = YES;
        //将军提示
        NSString *checkedTipStr;
        switch (kChineseChessManager.checkedType) {
            case LMCheckedType_redChecked:{
                checkedTipStr = @"红方正在被将军";
                isCanEat = !([kChineseChessManager isCheckedWithRedKingModel:self.redKingButton.chessmanModel andBlackModelArr:self.blackChessmanButtonArr withButtonArr:self.chessmanButtonArr] == kChineseChessManager.checkedType);
            }
                break;
            case LMCheckedType_blackChecked:{
                checkedTipStr = @"黑方正在被将军";
                isCanEat = !(kChineseChessManager.checkedType == [kChineseChessManager isCheckedWithBlackKingModel:self.blackKingButton.chessmanModel andRedModelArr:self.redChessmanButtonArr withButtonArr:self.chessmanButtonArr]);
            }
                break;
            case LMCheckedType_noChecked:{
                checkedTipStr = @"将会被将军！不能走这里！";
                BOOL redWillBeChecked = [kChineseChessManager isCheckedWithRedKingModel:self.redKingButton.chessmanModel andBlackModelArr:self.blackChessmanButtonArr withButtonArr:self.chessmanButtonArr] == LMCheckedType_redChecked;
                BOOL blackWillBeChecked = [kChineseChessManager isCheckedWithBlackKingModel:self.blackKingButton.chessmanModel andRedModelArr:self.redChessmanButtonArr withButtonArr:self.chessmanButtonArr] == LMCheckedType_blackChecked;
                isCanEat = !((redWillBeChecked && kChineseChessManager.isNextIsRed) || (blackWillBeChecked && !kChineseChessManager.isNextIsRed));
            }
                break;
            default:
                break;
        }
        
        self.selectedButton.coordinate.x = tempCoordinate.x;
        self.selectedButton.coordinate.y = tempCoordinate.y;
        sender.exist = YES;
        if (!isCanEat) {//依旧被将
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = checkedTipStr;
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:0.6f];
            return;
        }
        
        
        
        
        
        
        NSLog(@"开吃的棋子%@", self.selectedButton.coordinate.description);
        NSLog(@"被吃掉的棋子%@", sender.coordinate.description);
        //禁用用户交互
        self.userInteractionEnabled = NO;
        //吃掉棋子
        self.destinationPoint = [self chessmanPointWithCoordinateX:sender.coordinate.x withY:sender.coordinate.y];
        self.chessmanStatusType = LMChessmanActionType_eat;
        
        // 告诉self约束需要更新
        [self setNeedsUpdateConstraints];
        // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:0.8 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            //修改先后手
            kChineseChessManager.nextIsRed = !kChineseChessManager.isNextIsRed;
            
            //移除被吃掉的棋子
            sender.hidden =YES;
            [sender removeFromSuperview];
            //更新棋子二维坐标
            self.selectedButton.coordinate.x = sender.coordinate.x;
            self.selectedButton.coordinate.y = sender.coordinate.y;
            //取消选中
            self.selectedButton.selected = NO;
            self.selectedButton = nil;
            
            //检查将军
            [self checkCheck];
            
            //开启用户交互
            self.userInteractionEnabled = YES;
        
            if ([sender isking]) {
                NSLog(@"老帅被吃了");
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(chineseChessViewWithGameOverWithStatus:)]) {
                    [self.delegate chineseChessViewWithGameOverWithStatus:!sender.chessmanModel.isRed];
                }
            }
        }];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.selectedButton == nil || self.selectedButton.isSelected == NO) {//不需要做动作
        return;
    }
    
    CGPoint location = [touches.anyObject locationInView:self];
    NSLog(@"location.point ---> %@",NSStringFromCGPoint(location));
    //转换成 x y 坐标
    LMCoordinate *coordinate = [self coordinateWithTouchlocation:location];
    NSLog(@"%@", coordinate.description);
    
    
    //如果该位置有棋子，则什么都不做，只能通过选择按钮来吃掉
    for (NSInteger i = 0; i < self.redChessmanButtonArr.count; ++i) {
        if ([self.redChessmanButtonArr[i].coordinate isEqualtToCoordinate:coordinate] && (self.redChessmanButtonArr[i].hidden == NO) ){
            return;
        }
    }
    for (NSInteger i = 0; i < self.blackChessmanButtonArr.count; ++i) {
        if ([self.blackChessmanButtonArr[i].coordinate isEqualtToCoordinate:coordinate] && (self.blackChessmanButtonArr[i].hidden == NO)) {
            return;
        }
    }
    //=================== 该位置没有棋子，正常移动 ===================
    
    //判断能否移动
    if ([kChineseChessManager isModel:self.selectedButton.chessmanModel canUpdateToCoordinate:coordinate withChessmanArr:self.chessmanButtonArr] == NO) {
        NSLog(@"不能更新到这个位置");
        return;
    }
    //=================== 开始移动 ===================
    LMCoordinate *tempCoordinate = [LMCoordinate coordinateWithX:self.selectedButton.coordinate.x withY:self.selectedButton.coordinate.y];
    self.selectedButton.coordinate.x = coordinate.x;
    self.selectedButton.coordinate.y = coordinate.y;
    BOOL isCanMove = YES;
    //将军提示
    NSString *checkedTipStr;
    switch (kChineseChessManager.checkedType) {
        case LMCheckedType_redChecked:{
            checkedTipStr = @"红方正在被将军";
            isCanMove = !([kChineseChessManager isCheckedWithRedKingModel:self.redKingButton.chessmanModel andBlackModelArr:self.blackChessmanButtonArr withButtonArr:self.chessmanButtonArr] == kChineseChessManager.checkedType);
        }
            break;
        case LMCheckedType_blackChecked:{
            checkedTipStr = @"黑方正在被将军";
            isCanMove = !(kChineseChessManager.checkedType == [kChineseChessManager isCheckedWithBlackKingModel:self.blackKingButton.chessmanModel andRedModelArr:self.redChessmanButtonArr withButtonArr:self.chessmanButtonArr]);
        }
            break;
        case LMCheckedType_noChecked:{
            checkedTipStr = @"将会被将军！不能走这里！";
            BOOL redWillBeChecked = [kChineseChessManager isCheckedWithRedKingModel:self.redKingButton.chessmanModel andBlackModelArr:self.blackChessmanButtonArr withButtonArr:self.chessmanButtonArr] == LMCheckedType_redChecked;
            BOOL blackWillBeChecked = [kChineseChessManager isCheckedWithBlackKingModel:self.blackKingButton.chessmanModel andRedModelArr:self.redChessmanButtonArr withButtonArr:self.chessmanButtonArr] == LMCheckedType_blackChecked;
            isCanMove = !((redWillBeChecked && kChineseChessManager.isNextIsRed) || (blackWillBeChecked && !kChineseChessManager.isNextIsRed));
        }
            break;
        default:
            break;
    }
    
    self.selectedButton.coordinate.x = tempCoordinate.x;
    self.selectedButton.coordinate.y = tempCoordinate.y;
    if (!isCanMove) {//依旧被将
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = checkedTipStr;
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:0.6f];
        return;
    }
    
    //终点坐标（左上角）
    self.destinationPoint = [self chessmanPointWithCoordinateX:coordinate.x withY:coordinate.y];
    // 告诉self约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    
    //禁用用户交互
    self.userInteractionEnabled = NO;
    //移动棋子
    self.chessmanStatusType = LMChessmanActionType_move;
    [UIView animateWithDuration:0.8 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //修改先后手
        kChineseChessManager.nextIsRed = !kChineseChessManager.isNextIsRed;
        //更新棋子二维坐标
        self.selectedButton.coordinate.x = coordinate.x;
        self.selectedButton.coordinate.y = coordinate.y;
        //取消选中
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        //检查将军
        [self checkCheck];
        //开启用户交互
        self.userInteractionEnabled = YES;
    }];
}
#pragma mark - extension function
/*
 检查将军
 */
- (void)checkCheck
{
    kChineseChessManager.checkedType = [kChineseChessManager isCheckedWithRedKingModel:self.redKingButton.chessmanModel andBlackKingModel:self.blackKingButton.chessmanModel withRedModelArr:self.redChessmanButtonArr anBlackModelArr:self.blackChessmanButtonArr withButtonArr:self.chessmanButtonArr];
    if (kChineseChessManager.checkedType != LMCheckedType_noChecked) {
        NSLog(@"将军！!!!!!!!!!!!!!!!!!!");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"将军";
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:0.6f];
    }
}
- (LMCoordinate *)coordinateWithTouchlocation:(CGPoint)point
{
    CGFloat gridWidth = SCREEN_WIDTH / gridColNum;          //格子的宽
//    CGFloat gridHalfWidth = gridWidth * 0.5;
    CGFloat gridHeight = gridWidth;                         //格子的高
//    CGFloat gridHalfHeight = gridHeight * 0.5;
    
    return [LMCoordinate coordinateWithX:point.x / gridWidth withY:point.y / gridHeight];
}
/**
 棋子左上角的 CGPoint

 @param x 横坐标
 @param y 纵坐标
 @return CGPoint
 */
- (CGPoint)chessmanPointWithCoordinateX:(NSInteger)x withY:(NSInteger)y
{
    CGFloat gridWidth = SCREEN_WIDTH / gridColNum;          //格子的宽
//    CGFloat gridHalfWidth = gridWidth * 0.5;
    CGFloat gridHeight = gridWidth;                         //格子的高
//    CGFloat gridHalfHeight = gridHeight * 0.5;
//    CGFloat buttonWidth = gridWidth * chessmanSizeRate;
//    CGFloat buttonHeight = gridHeight * chessmanSizeRate;
    
    return CGPointMake(x * gridWidth + gridWidth * (1 - chessmanSizeRate) * 0.5, y * gridHeight + gridWidth * (1 - chessmanSizeRate) * 0.5);
}
/**
 线交叉点的 CGPoint
 将棋盘指定坐标（左上角(0, 0) 右上角(8, 0)
 左下角(9, 0) 右下角(8. 9)）
 
 @param x 横坐标
 @param y 纵坐标
 @return CGPoint
 */
- (CGPoint)pointWithCoordinateX:(NSInteger)x withY:(NSInteger)y
{
    CGFloat gridWidth = SCREEN_WIDTH / gridColNum;          //格子的宽
    CGFloat gridHalfWidth = gridWidth * 0.5;
    CGFloat gridHeight = gridWidth;                         //格子的高
    CGFloat gridHalfHeight = gridHeight * 0.5;
    return CGPointMake(gridHalfWidth + x * gridWidth, gridHalfHeight + y * gridHeight);
}
- (void)drawRect:(CGRect)rect {
    
    CGFloat gridWidth = SCREEN_WIDTH / gridColNum;          //格子的宽
    CGFloat gridHalfWidth = gridWidth * 0.5;
    CGFloat gridHeight = gridWidth;                         //格子的高
    CGFloat gridHalfHeight = gridHeight * 0.5;
    //    CGSize gridSize = CGSizeMake(gridWidth, gridHeight);    //格子的尺寸
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    
    //行
    for (NSInteger i = 0; i < rowLineNum; ++i) {
        [bezierPath moveToPoint:CGPointMake(gridHalfWidth, gridHalfHeight + i * gridHeight)];
        [bezierPath addLineToPoint:CGPointMake(width - gridHalfWidth, gridHalfHeight + i * gridHeight)];
    }
    //左右两列的边界线
    [bezierPath moveToPoint:CGPointMake(gridHalfWidth, gridHalfHeight)];
    [bezierPath addLineToPoint:CGPointMake(gridHalfWidth, height - gridHalfHeight)];
    [bezierPath moveToPoint:CGPointMake(width - gridHalfWidth, gridHalfHeight)];
    [bezierPath addLineToPoint:CGPointMake(width - gridHalfWidth, height - gridHalfHeight)];
    
    //列
    for (NSInteger i = 1; i < colLineNum - 1; ++i) {
        //上半部分
        [bezierPath moveToPoint:CGPointMake(gridHalfWidth + i * gridWidth, gridHalfHeight)];
        [bezierPath addLineToPoint:CGPointMake(gridHalfWidth + i * gridWidth, gridHalfHeight + rowGridNum * gridHeight)];
        //下半部分
        [bezierPath moveToPoint:CGPointMake(gridHalfWidth + i * gridWidth, height - gridHalfHeight)];
        [bezierPath addLineToPoint:CGPointMake(gridHalfWidth + i * gridWidth, height - gridHalfHeight - rowGridNum * gridHeight)];
    }
    
    //交叉
    [bezierPath moveToPoint:CGPointMake(gridHalfWidth + 3 * gridWidth, gridHalfHeight)];
    [bezierPath addLineToPoint:CGPointMake(gridHalfWidth + 5 * gridWidth, gridHalfHeight + gridHeight * 2)];
    
    [bezierPath moveToPoint:CGPointMake(gridHalfWidth + 5 * gridWidth, gridHalfHeight)];
    [bezierPath addLineToPoint:CGPointMake(gridHalfWidth + 3 * gridWidth, gridHalfHeight + gridHeight * 2)];
    
    [bezierPath moveToPoint:CGPointMake(gridHalfWidth + 3 * gridWidth, height - gridHalfHeight)];
    [bezierPath addLineToPoint:CGPointMake(gridHalfWidth + 5 * gridWidth, height - gridHalfHeight - gridHeight * 2)];
    
    [bezierPath moveToPoint:CGPointMake(gridHalfWidth + 5 * gridWidth, height - gridHalfHeight)];
    [bezierPath addLineToPoint:CGPointMake(gridHalfWidth + 3 * gridWidth, height - gridHalfHeight - gridHeight * 2)];
    
    //兵的点
    NSArray<NSString *> *pointArr = @[@"1-2", @"7-2", @"0-3", @"2-3", @"4-3", @"6-3", @"8-3", @"1-7", @"7-7", @"0-6", @"2-6", @"4-6", @"6-6", @"8-6"];
    for (NSUInteger i = 0; i < pointArr.count; ++i) {
        NSArray<NSString *> *pointStringArr = [pointArr[i] componentsSeparatedByString:@"-"];
        LMCoordinate *coordinate = [LMCoordinate coordinateWithX:[pointStringArr[0] integerValue] withY:[pointStringArr[1] integerValue]];
        [self drawLineWithBezierPath:bezierPath withPoint:[self pointWithCoordinateX:coordinate.x withY:coordinate.y]];
    }
    //    [self drawLineWithBezierPath:bezierPath withPoint:CGPointMake(gridHalfWidth + gridWidth, gridHalfHeight + gridHeight * 2)];
    
    [[UIColor blackColor] setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    //绘制文字
    NSString *chuStr = @"楚";
    NSString *heStr = @"河";
    NSString *hanStr = @"汉";
    NSString *jieStr = @"界";
    CGFloat strWidth = gridWidth * 0.7;
    [chuStr drawInRect:CGRectMake(2.5 * gridWidth - strWidth, 4.5 * gridHeight +0.15 * gridHeight , strWidth, strWidth) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    [heStr drawInRect:CGRectMake(2.5 * gridWidth + gridWidth * 0.3, 4.5 * gridHeight +0.15 * gridHeight , strWidth, strWidth) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    [hanStr drawInRect:CGRectMake(6.5 * gridWidth - strWidth, 4.5 * gridHeight +0.15 * gridHeight , strWidth, strWidth) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    [jieStr drawInRect:CGRectMake(6.5 * gridWidth + gridWidth * 0.3, 4.5 * gridHeight +0.15 * gridHeight , strWidth, strWidth) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
}

/**
 绘制炮、兵的棋盘背景花纹
 
 @param centerPoint 中心点位置
 */
- (void)drawLineWithBezierPath:(UIBezierPath *)bezierPath withPoint:(CGPoint)centerPoint
{
    CGFloat margin = 2;
    CGFloat lineLength = 5;
    
    CGFloat gridWidth = SCREEN_WIDTH / gridColNum;          //格子的宽
    CGFloat gridHalfWidth = gridWidth * 0.5;
//    CGFloat gridHeight = gridWidth;                         //格子的高
    CGFloat width = self.frame.size.width;
    
    //左上角
    if (centerPoint.x > gridHalfWidth) {
        [bezierPath moveToPoint:CGPointMake(centerPoint.x - margin, centerPoint.y - margin - lineLength)];
        [bezierPath addLineToPoint:CGPointMake(centerPoint.x - margin, centerPoint.y - margin)];
        [bezierPath addLineToPoint:CGPointMake(centerPoint.x - margin - lineLength, centerPoint.y - margin)];
    }
    
    //右上角
    if (centerPoint.x < width - gridHalfWidth) {
        [bezierPath moveToPoint:CGPointMake(centerPoint.x + margin, centerPoint.y - margin - lineLength)];
        [bezierPath addLineToPoint:CGPointMake(centerPoint.x + margin, centerPoint.y - margin)];
        [bezierPath addLineToPoint:CGPointMake(centerPoint.x + margin + lineLength, centerPoint.y - margin)];
    }
    //左下角
    if (centerPoint.x > gridHalfWidth) {
        [bezierPath moveToPoint:CGPointMake(centerPoint.x - margin, centerPoint.y + margin + lineLength)];
        [bezierPath addLineToPoint:CGPointMake(centerPoint.x - margin, centerPoint.y + margin)];
        [bezierPath addLineToPoint:CGPointMake(centerPoint.x - margin - lineLength, centerPoint.y + margin)];
    }
    //右下角
    if (centerPoint.x < width - gridHalfWidth) {
        [bezierPath moveToPoint:CGPointMake(centerPoint.x + margin, centerPoint.y + margin + lineLength)];
        [bezierPath addLineToPoint:CGPointMake(centerPoint.x + margin, centerPoint.y + margin)];
        [bezierPath addLineToPoint:CGPointMake(centerPoint.x + margin + lineLength, centerPoint.y + margin)];
    }
}
#pragma mark - Getter & Setter
- (NSMutableArray<LMChessmanButton *> *)chessmanButtonArr
{
    if (!_chessmanButtonArr) {
        _chessmanButtonArr = [NSMutableArray array];
    }
    return _chessmanButtonArr;
}
- (NSMutableArray<LMChessmanButton *> *)redChessmanButtonArr
{
    if (!_redChessmanButtonArr) {
        _redChessmanButtonArr = [NSMutableArray array];
    }
    return _redChessmanButtonArr;
}
- (NSMutableArray<LMChessmanButton *> *)blackChessmanButtonArr
{
    if (!_blackChessmanButtonArr) {
        _blackChessmanButtonArr = [NSMutableArray array];
    }
    return _blackChessmanButtonArr;
}
@end
