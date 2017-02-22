//
//  AppDelegate.m
//  QYSideMenu
//
//  Created by ZLJuan on 16/5/12.
//  Copyright © 2016年 ZLJuan. All rights reserved.
//

#import "AppDelegate.h"
#import "QYMenuViewControllerManager.h"
#import "QYNavigationController.h"

#import "QYMessageViewController.h"
#import "QYContactViewController.h"
#import "QYStatusViewController.h"
#import "QYLeftMenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    QYMessageViewController *messageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QYMessageViewController"];
    QYNavigationController *messageNC = [[QYNavigationController alloc] initWithRootViewController:messageVC];
    QYContactViewController *contactVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QYContactViewController"];
    QYNavigationController *contactNC = [[QYNavigationController alloc] initWithRootViewController:contactVC];
    QYStatusViewController *statusVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QYStatusViewController"];
    QYNavigationController *statusNC = [[QYNavigationController alloc] initWithRootViewController:statusVC];
    tabBarC.viewControllers = @[messageNC, contactNC, statusNC];
    
    QYMenuViewControllerManager *menuVCManager = [QYMenuViewControllerManager shareManager];
    menuVCManager.centerViewController = tabBarC;
    menuVCManager.banRightMenu = YES;
    
    QYLeftMenuViewController *leftMenuVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QYLeftMenuViewController"];
    menuVCManager.leftViewController = leftMenuVC;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabBarC;
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
