//
//  QYLeftMenuViewController.m
//  QYSideMenu
//
//  Created by ZLJuan on 2017/2/15.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import "QYLeftMenuViewController.h"
#import "QYDemo1NavigationController.h"
#import "QYMenuViewControllerManager.h"

@interface QYLeftMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (nonatomic, strong) NSArray               *moduleArray;

@end

@implementation QYLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moduleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.moduleArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[QYMenuViewControllerManager shareManager] hideMenuWithAnimation:YES];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = self.moduleArray[indexPath.row];
    vc.view.backgroundColor = [UIColor yellowColor];
    [[QYDemo1NavigationController shareInstance] pushViewController:vc animated:NO];
}

- (NSArray *)moduleArray
{
    if (_moduleArray == nil) {
        _moduleArray = @[@"个人信息",
                         @"我的相册",
                         @"设置"];
    }
    return _moduleArray;
}

@end
