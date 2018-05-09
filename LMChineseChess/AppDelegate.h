//
//  AppDelegate.h
//  LMChineseChess
//
//  Created by 转角街坊 on 2018/5/9.
//  Copyright © 2018年 转角街坊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

