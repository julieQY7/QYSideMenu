//
//  QYNavigationController.m
//  QYSideMenu
//
//  Created by ZLJuan on 16/5/13.
//  Copyright © 2016年 ZLJuan. All rights reserved.
//

#import "QYNavigationController.h"
#import "QYMenuViewControllerManager.h"

@interface QYNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation QYNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [QYMenuViewControllerManager shareManager].canSideSlip = navigationController.viewControllers.count < 2;
}

@end
