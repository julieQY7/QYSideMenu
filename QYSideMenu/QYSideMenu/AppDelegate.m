//
//  AppDelegate.m
//  QYSideMenu
//
//  Created by ZLJuan on 16/5/12.
//  Copyright © 2016年 ZLJuan. All rights reserved.
//

#import "AppDelegate.h"
#import "QYMenuViewControllerManager.h"
#import "QYDemo1NavigationController.h"
#import "QYLeftMenuViewController.h"
#import "ViewController.h"

/*
 demo1
 适用于，首页固定不变，其他页面均基于首页来自push或model出来的情况：例如APP<米其林指南上海2017>
 此时可以设计naviController为单例，或通过通知的方式对leftmenu点击进行处理
 如果你想实现的是多个独立模块分别基于navi，你可以设计模块entity，存储其对应的navi及rootVC，切换做菜单时更换QYMenuViewControllerManager的centerVC以及window的rootVC，后期会更新相关Demo到Demo2
 */

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
    QYDemo1NavigationController *navi = [QYDemo1NavigationController shareInstance];
    navi.viewControllers = @[vc];
    
    QYMenuViewControllerManager *menuVCManager = [QYMenuViewControllerManager shareManager];
    QYLeftMenuViewController *leftVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QYLeftMenuViewController"];
    menuVCManager.leftViewController = leftVC;
    menuVCManager.centerViewController = navi;
    menuVCManager.banRightMenu = YES;
    menuVCManager.menuWidth = [UIScreen mainScreen].bounds.size.width * 0.75;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navi;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//- (void)setupMenuViewController
//{
//    QYLeftMenuViewController *leftMenuVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QYLeftMenuViewController"];
//    QYRightMenuViewController *rightMenuVC = [[QYRightMenuViewController alloc] init];
//    QYNavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QYNavigationController"];
//    QYMenuViewControllerManager *manager = [QYMenuViewControllerManager shareManager];
//    manager.leftViewController = leftMenuVC;
//    manager.rightViewController = rightMenuVC;
//    manager.centerViewController = nav;
//    manager.banRightMenu = YES;
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = nav;
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//}

@end
