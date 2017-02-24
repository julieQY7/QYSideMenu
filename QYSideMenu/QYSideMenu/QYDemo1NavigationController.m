//
//  QYDemo1NavigationController.m
//  QYSideMenu
//
//  Created by ZLJuan on 2017/2/24.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import "QYDemo1NavigationController.h"

@interface QYDemo1NavigationController ()

@end

QYDemo1NavigationController *__instance;

@implementation QYDemo1NavigationController

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[QYDemo1NavigationController alloc] init];
    });
    return __instance;
}

@end
