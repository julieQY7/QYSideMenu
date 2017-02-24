//
//  QYMenuViewControllerManager.m
//  QYSideMenu
//
//  Created by ZLJuan on 16/5/12.
//  Copyright © 2016年 ZLJuan. All rights reserved.
//

#import "QYMenuViewControllerManager.h"
#define D_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define D_AnimateDefultTime 0.3

typedef NS_ENUM(NSInteger, TouchLocationType) {
    TouchLocationType_Center,
    TouchLocationType_Left,
    TouchLocationType_Right
};

@interface QYMenuViewControllerManager ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer    *panRecognizer;
@property (nonatomic, assign) CGPoint                   centerViewOriginPoint;

@property (nonatomic, strong) UITapGestureRecognizer    *tapRecognizer;

@property (nonatomic, assign) TouchLocationType         touchLocationType;

@property (nonatomic, strong) UIView                    *transparentView;

@end

static QYMenuViewControllerManager *__manager;

@implementation QYMenuViewControllerManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[QYMenuViewControllerManager alloc] init];
    });
    return __manager;
}

- (void)setCenterViewController:(UIViewController *)centerViewController
{
    if (_centerViewController == centerViewController) {
        return;
    }
    if (_centerViewController) {
        if (self.panRecognizer) {
            [_centerViewController.view removeGestureRecognizer:self.panRecognizer];
        }
        if (self.tapRecognizer) {
            [_centerViewController.view removeGestureRecognizer:self.tapRecognizer];
        }
    }
    _centerViewController = centerViewController;
    [self setupData];
    [self setupRecognizer];
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (_leftViewController == leftViewController) {
        return;
    }
    if (_leftViewController) {
        [_leftViewController.view removeFromSuperview];
    }
    _leftViewController = leftViewController;
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (_rightViewController == rightViewController) {
        return;
    }
    if (_rightViewController) {
        [_rightViewController.view removeFromSuperview];
    }
    _rightViewController = rightViewController;
}

- (void)setupData
{
    self.menuWidth = self.menuWidth == 0 ? D_ScreenWidth * 0.8 : self.menuWidth;
    self.effectiveDragWidth = self.effectiveDragWidth == 0 ? 80 : self.effectiveDragWidth;
    self.transparentView = [[UIView alloc] initWithFrame:self.centerViewController.view.bounds];
    self.transparentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

#pragma mark - recoginzer
- (void)setupRecognizer
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selectorToPanRecognizer:)];
    self.panRecognizer.delegate = self;
    [self.centerViewController.view addGestureRecognizer:self.panRecognizer];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorToTapRecognizer:)];
    self.tapRecognizer.delegate = self;
    [self.centerViewController.view addGestureRecognizer:self.tapRecognizer];
}

- (void)selectorToTapRecognizer:(UITapGestureRecognizer *)tapRecognizer
{
    [self hideMenu];
}

#pragma mark - panRecognizer
- (void)selectorToPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self panRecognizerStateBegan:panRecognizer];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self panRecognizerStateChanged:panRecognizer];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self panRecognizerStateEnded:panRecognizer];
        }
            break;
        default:
            break;
    }
}

- (void)panRecognizerStateBegan:(UIPanGestureRecognizer *)panRecognizer
{
    self.centerViewOriginPoint = self.centerViewController.view.frame.origin;
    
    [self resetTouchType:panRecognizer];
    [self resetCurrentMenuType];
    
    if (self.showMenuType == ShowMenuType_Center) {
        
        [self.leftViewController.view removeFromSuperview];
        [self.rightViewController.view removeFromSuperview];
        
        if (self.touchLocationType == TouchLocationType_Left) {
            [self.centerViewController.view.window insertSubview:self.leftViewController.view atIndex:0];
        } else if (self.touchLocationType == TouchLocationType_Right) {
            [self.centerViewController.view.window insertSubview:self.rightViewController.view atIndex:0];
        }
    }
}

- (void)resetTouchType:(UIGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.centerViewController.view];
    if (touchPoint.x <= self.effectiveDragWidth) {
        self.touchLocationType = TouchLocationType_Left;
    } else if (touchPoint.x >= D_ScreenWidth - self.effectiveDragWidth) {
        self.touchLocationType = TouchLocationType_Right;
    } else {
        self.touchLocationType = TouchLocationType_Center;
    }
}

- (void)resetCurrentMenuType
{
    CGPoint origin = self.centerViewController.view.frame.origin;
    if (origin.x > 3) {
        _showMenuType = ShowMenuType_Left;
    } else if (origin.x < -3) {
        _showMenuType = ShowMenuType_Right;
    } else {
        _showMenuType = ShowMenuType_Center;
    }
}

- (void)panRecognizerStateChanged:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint movePoint = [panRecognizer translationInView:self.centerViewController.view];
    if ([self checkPanRecognizerChange:panRecognizer] == NO) {
        return;
    }
    CGRect frame = self.centerViewController.view.frame;
    frame.origin = CGPointMake(movePoint.x + self.centerViewOriginPoint.x, 0);
    self.centerViewController.view.frame = frame;
}

- (BOOL)checkPanRecognizerChange:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint movePoint = [panRecognizer translationInView:self.centerViewController.view];
    CGFloat absMoveX = fabs(movePoint.x);
    if (absMoveX > self.menuWidth) return NO;
    
    if (self.showMenuType == ShowMenuType_Center) {
        if (self.touchLocationType == TouchLocationType_Left && movePoint.x < 0) return NO;
        if (self.touchLocationType == TouchLocationType_Right && movePoint.x > 0) return NO;
    }
    if (self.showMenuType == ShowMenuType_Left && movePoint.x > 0) return NO;
    if (self.showMenuType == ShowMenuType_Right && movePoint.x < 0) return NO;
    
    return YES;
}

- (void)panRecognizerStateEnded:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint movePoint = [panRecognizer translationInView:self.centerViewController.view];
    CGFloat absMoveX = fabs(movePoint.x);
    CGFloat speed = [panRecognizer velocityInView:self.centerViewController.view].x;
    CGFloat time = (self.menuWidth - absMoveX) / fabs(speed);
    time = time > 0.3 ? 0.3 : time;
    if (absMoveX < self.menuWidth / 2.0) {
        time = fabs(speed) * absMoveX;
        time = time > 0.15 ? 0.15 : time;
        [self rollBackViewWithTime:time];
        return;
    }
    switch (self.showMenuType) {
        case ShowMenuType_Left:
        case ShowMenuType_Right:
        {
            [self hideMenuWithTime:time];
        }
            break;
        case ShowMenuType_Center:
        {
            if (movePoint.x > 0) {
                [self showLeftMenuWithTime:time];
            } else {
                [self showRightMenuWithTime:time];
            }
        }
            break;
    }
}

#pragma mark - Recognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self resetTouchType:gestureRecognizer];
    [self resetCurrentMenuType];
    
    if (self.canSideSlip == NO) return NO;
    
    if (gestureRecognizer == self.panRecognizer) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        if ([self shouldBeginPanRecognizer:panRecognizer] == NO) {
            return NO;
        }
    } else if (gestureRecognizer == self.tapRecognizer) {
        if (self.showMenuType == ShowMenuType_Center) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)shouldBeginPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint touchLocation = [panRecognizer locationInView:panRecognizer.view];
    if (self.showMenuType == ShowMenuType_Center) {
        if (touchLocation.x > self.effectiveDragWidth && touchLocation.x < D_ScreenWidth - self.effectiveDragWidth) return NO;
    }
    
    if (self.banRightMenu && self.touchLocationType == TouchLocationType_Right) return NO;
    if (self.banLeftMenu && self.touchLocationType == TouchLocationType_Left) return NO;
    
    CGPoint movePoint = [panRecognizer translationInView:self.centerViewController.view];
    if (self.showMenuType == ShowMenuType_Center) {
        if (self.touchLocationType == TouchLocationType_Left && movePoint.x < 0) return NO;
        if (self.touchLocationType == TouchLocationType_Right && movePoint.x > 0) return NO;
    }
    if (self.showMenuType == ShowMenuType_Left && movePoint.x > 0) return NO;
    if (self.showMenuType == ShowMenuType_Right && movePoint.x < 0) return NO;
    
    return YES;
}

#pragma mark - animate
- (void)showLeftMenu
{
    [self.leftViewController.view removeFromSuperview];
    [self.rightViewController.view removeFromSuperview];
    [self.centerViewController.view.window insertSubview:self.leftViewController.view atIndex:0];
    [self showLeftMenuWithTime:D_AnimateDefultTime];
}

- (void)showRightMenu
{
    [self.leftViewController.view removeFromSuperview];
    [self.rightViewController.view removeFromSuperview];
    [self.centerViewController.view.window insertSubview:self.rightViewController.view atIndex:0];
    [self showRightMenuWithTime:D_AnimateDefultTime];
}

- (void)hideMenuWithAnimation:(BOOL)animation
{
    if (animation) {
        [self hideMenuWithTime:D_AnimateDefultTime];
    } else {
        [self.transparentView removeFromSuperview];
        CGRect frame = self.centerViewController.view.frame;
        frame.origin = CGPointZero;
        self.centerViewController.view.frame = frame;
        [self.leftViewController.view removeFromSuperview];
        [self.rightViewController.view removeFromSuperview];
        [self resetCurrentMenuType];
    }
}

- (void)hideMenu
{
    [self hideMenuWithTime:D_AnimateDefultTime];
}

- (void)rollBackViewWithTime:(CGFloat)time
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.centerViewController.view.frame;
        frame.origin = self.centerViewOriginPoint;
        self.centerViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        [self resetCurrentMenuType];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)hideMenuWithTime:(CGFloat)time
{
    [self.transparentView removeFromSuperview];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.centerViewController.view.frame;
        frame.origin = CGPointZero;
        self.centerViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self resetCurrentMenuType];
            [self.leftViewController.view removeFromSuperview];
            [self.rightViewController.view removeFromSuperview];
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)showLeftMenuWithTime:(CGFloat)time
{
    if (self.banLeftMenu) return;
    
    [self.centerViewController.view addSubview:self.transparentView];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.centerViewController.view.frame;
        frame.origin = CGPointMake(self.menuWidth, 0);
        self.centerViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        [self resetCurrentMenuType];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)showRightMenuWithTime:(CGFloat)time
{
    if (self.banRightMenu) return;
    
    [self.centerViewController.view addSubview:self.transparentView];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.centerViewController.view.frame;
        frame.origin = CGPointMake(-self.menuWidth, 0);
        self.centerViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        [self resetCurrentMenuType];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

@end
