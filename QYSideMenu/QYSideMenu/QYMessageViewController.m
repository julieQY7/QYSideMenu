//
//  QYMessageViewController.m
//  QYSideMenu
//
//  Created by ZLJuan on 2017/2/15.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import "QYMessageViewController.h"

@interface QYMessageViewController ()

- (IBAction)respondsToDetailButton;

@end

@implementation QYMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
}

- (IBAction)respondsToDetailButton
{
    NSLog(@"---respondsToDetailButton");
    UIViewController *detailVC = [[UIViewController alloc] init];
    detailVC.view.backgroundColor = [UIColor yellowColor];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
