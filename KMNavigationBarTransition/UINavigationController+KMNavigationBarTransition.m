//
//  UINavigationController+KMNavigationBarTransition.m
//
//  Copyright (c) 2016 Zhouqi Mo (https://github.com/MoZhouqi)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UINavigationController+KMNavigationBarTransition.h"
#import "UIViewController+KMNavigationBarTransition.h"
#import <objc/runtime.h>
#import "KMSwizzle.h"

@implementation UINavigationController (KMNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KMSwizzleMethod([self class],
                        @selector(pushViewController:animated:),
                        @selector(km_pushViewController:animated:));
        
        KMSwizzleMethod([self class],
                        @selector(popViewControllerAnimated:),
                        @selector(km_popViewControllerAnimated:));
        
        KMSwizzleMethod([self class],
                        @selector(popToViewController:animated:),
                        @selector(km_popToViewController:animated:));
        
        KMSwizzleMethod([self class],
                        @selector(popToRootViewControllerAnimated:),
                        @selector(km_popToRootViewControllerAnimated:));
    });
}

- (UIColor *)km_containerViewBackgroundColor {
    return [UIColor whiteColor];
}

- (void)km_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (!disappearingViewController) {
        return [self km_pushViewController:viewController animated:animated];
    }
    [disappearingViewController km_addTransitionNavigationBarIfNeeded];
    disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
    return [self km_pushViewController:viewController animated:animated];
}

- (UIViewController *)km_popViewControllerAnimated:(BOOL)animated {
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController km_addTransitionNavigationBarIfNeeded];
    if (self.viewControllers.count >= 2) {
        UIViewController *appearingViewController = self.viewControllers[self.viewControllers.count - 2];
        if (appearingViewController.km_transitionNavigationBar) {
            UINavigationBar *appearingNavigationBar = appearingViewController.km_transitionNavigationBar;
            self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
            [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
            self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
        }
    }
    disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
    return [self km_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)km_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (!disappearingViewController) {
        return [self km_popToViewController:viewController animated:animated];
    }
    [disappearingViewController km_addTransitionNavigationBarIfNeeded];
    if (viewController.km_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = viewController.km_transitionNavigationBar;
        self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
    }
    disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
    return [self km_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)km_popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (!disappearingViewController) {
        return [self km_popToRootViewControllerAnimated:animated];
    }
    [disappearingViewController km_addTransitionNavigationBarIfNeeded];
    UIViewController *rootViewController = self.viewControllers.firstObject;
    if (rootViewController.km_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = rootViewController.km_transitionNavigationBar;
        self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
    }
    disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
    return [self km_popToRootViewControllerAnimated:animated];
}

@end
