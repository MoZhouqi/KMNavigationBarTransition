//
//  UINavigationController+KMNavigationBarTransition.m
//
//  Copyright (c) 2017 Zhouqi Mo (https://github.com/MoZhouqi)
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
#import "UINavigationController+KMNavigationBarTransition_Internal.h"
#import "UIViewController+KMNavigationBarTransition.h"
#import "UIViewController+KMNavigationBarTransition_internal.h"
#import "KMWeakObjectContainer.h"
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
        
        KMSwizzleMethod([self class],
                        @selector(setViewControllers:animated:),
                        @selector(km_setViewControllers:animated:));
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
    if (!self.km_transitionContextToViewController || !disappearingViewController.km_transitionNavigationBar) {
    [disappearingViewController km_addTransitionNavigationBarIfNeeded];
    }
    if (animated) {
        self.km_transitionContextToViewController = viewController;
        if (disappearingViewController.km_transitionNavigationBar) {
            disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
        }
    }
    return [self km_pushViewController:viewController animated:animated];
}

- (UIViewController *)km_popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count < 2) {
        return [self km_popViewControllerAnimated:animated];
    }
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController km_addTransitionNavigationBarIfNeeded];
    UIViewController *appearingViewController = self.viewControllers[self.viewControllers.count - 2];
    if (appearingViewController.km_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = appearingViewController.km_transitionNavigationBar;
        self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
    }
    if (animated) {
        disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
    }
    return [self km_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)km_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![self.viewControllers containsObject:viewController] || self.viewControllers.count < 2) {
        return [self km_popToViewController:viewController animated:animated];
    }
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController km_addTransitionNavigationBarIfNeeded];
    if (viewController.km_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = viewController.km_transitionNavigationBar;
        self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
    }
    if (animated) {
        disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
    }
    return [self km_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)km_popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count < 2) {
        return [self km_popToRootViewControllerAnimated:animated];
    }
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController km_addTransitionNavigationBarIfNeeded];
    UIViewController *rootViewController = self.viewControllers.firstObject;
    if (rootViewController.km_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = rootViewController.km_transitionNavigationBar;
        self.navigationBar.barTintColor = appearingNavigationBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingNavigationBar.shadowImage;
    }
    if (animated) {
        disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
    }
    return [self km_popToRootViewControllerAnimated:animated];
}

- (void)km_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (animated && disappearingViewController && ![disappearingViewController isEqual:viewControllers.lastObject]) {
        [disappearingViewController km_addTransitionNavigationBarIfNeeded];
        if (disappearingViewController.km_transitionNavigationBar) {
            disappearingViewController.km_prefersNavigationBarBackgroundViewHidden = YES;
        }
    }
    return [self km_setViewControllers:viewControllers animated:animated];
}

- (UIViewController *)km_transitionContextToViewController {
    return km_objc_getAssociatedWeakObject(self, _cmd);
}

- (void)setKm_transitionContextToViewController:(UIViewController *)viewController {
    km_objc_setAssociatedWeakObject(self, @selector(km_transitionContextToViewController), viewController);
}

@end
