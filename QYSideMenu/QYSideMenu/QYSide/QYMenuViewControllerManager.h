//
//  QYMenuViewControllerManager.h
//  QYSideMenu
//
//  Created by ZLJuan on 16/5/12.
//  Copyright © 2016年 ZLJuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

/**
 根据项目架构需要可以设置centerViewController为NavigationController、TabBarViewController...
 项目架构类似于QQ时，设置为TabBarViewController
 项目架构类似于米其林指南是，设置为NavigationController
 应用实例效果：参见APP：米其林指南
 */

typedef NS_ENUM(NSInteger, ShowMenuType) {
    ShowMenuType_Center,
    ShowMenuType_Left,
    ShowMenuType_Right
};

@interface QYMenuViewControllerManager : NSObject

@property (nonatomic, strong) UIViewController          *leftViewController;
@property (nonatomic, strong) UIViewController          *rightViewController;
@property (nonatomic, strong) UIViewController          *centerViewController;
@property (nonatomic, assign) CGFloat                   effectiveDragWidth;
@property (nonatomic, assign) CGFloat                   menuWidth;
@property (nonatomic, assign) BOOL                      canSideSlip;
@property (nonatomic, assign) BOOL                      banRightMenu;
@property (nonatomic, assign) BOOL                      banLeftMenu;
@property (nonatomic, assign, readonly) ShowMenuType    showMenuType;

+ (instancetype)shareManager;
- (void)showLeftMenu;
- (void)showRightMenu;
- (void)hideMenu;
- (void)hideMenuWithAnimation:(BOOL)animation;

@end
