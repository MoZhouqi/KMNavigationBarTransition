//
//  UIViewController+KMNavigationBarTransition.m
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

#import "UIViewController+KMNavigationBarTransition.h"
#import <objc/runtime.h>
#import "KMSwizzle.h"
#import "UINavigationController+KMNavigationBarTransition.h"
#import "UINavigationController+KMNavigationBarTransition_Internal.h"

@implementation UIViewController (KMNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KMSwizzleMethod([self class],
                        @selector(viewWillLayoutSubviews),
                        @selector(km_viewWillLayoutSubviews));
        
        KMSwizzleMethod([self class],
                        @selector(viewDidAppear:),
                        @selector(km_viewDidAppear:));
    });
}

- (void)km_viewDidAppear:(BOOL)animated {
    if (self.km_transitionNavigationBar) {
        self.navigationController.navigationBar.barTintColor = self.km_transitionNavigationBar.barTintColor;
        [self.navigationController.navigationBar setBackgroundImage:[self.km_transitionNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:self.km_transitionNavigationBar.shadowImage];
        
        UIViewController *transitionViewController = self.navigationController.km_transitionContextToViewController;
        if (!transitionViewController || [transitionViewController isEqual:self]) {
            [self.km_transitionNavigationBar removeFromSuperview];
            self.km_transitionNavigationBar = nil;
            self.navigationController.km_transitionContextToViewController = nil;
        }
    }
    self.km_prefersNavigationBarBackgroundViewHidden = NO;
    [self km_viewDidAppear:animated];
}

- (void)km_viewWillLayoutSubviews {
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *fromViewController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([self isEqual:self.navigationController.viewControllers.lastObject] && [toViewController isEqual:self] && self.navigationController.km_transitionContextToViewController) {
        if (self.navigationController.navigationBar.translucent) {
            [tc containerView].backgroundColor = [self.navigationController km_containerViewBackgroundColor];
        }
        fromViewController.view.clipsToBounds = NO;
        toViewController.view.clipsToBounds = NO;
        if (!self.km_transitionNavigationBar) {
            [self km_addTransitionNavigationBarIfNeeded];
            
            self.km_prefersNavigationBarBackgroundViewHidden = YES;
        }
        [self km_resizeTransitionNavigationBarFrame];
    }
    if (self.km_transitionNavigationBar) {
        [self.view bringSubviewToFront:self.km_transitionNavigationBar];
    }
    [self km_viewWillLayoutSubviews];
}

- (void)km_resizeTransitionNavigationBarFrame {
    if (!self.view.window) {
        return;
    }
    UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    self.km_transitionNavigationBar.frame = rect;
}

- (void)km_addTransitionNavigationBarIfNeeded {
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    if (!self.navigationController.navigationBar) {
        return;
    }
    [self km_adjustScrollViewContentOffsetIfNeeded];
    UINavigationBar *bar = [[UINavigationBar alloc] init];
    bar.barStyle = self.navigationController.navigationBar.barStyle;
    if (bar.translucent != self.navigationController.navigationBar.translucent) {
        bar.translucent = self.navigationController.navigationBar.translucent;
    }
    bar.barTintColor = self.navigationController.navigationBar.barTintColor;
    [bar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    bar.shadowImage = self.navigationController.navigationBar.shadowImage;
    [self.km_transitionNavigationBar removeFromSuperview];
    self.km_transitionNavigationBar = bar;
    [self km_resizeTransitionNavigationBarFrame];
    if (!self.navigationController.navigationBarHidden && !self.navigationController.navigationBar.hidden) {
        [self.view addSubview:self.km_transitionNavigationBar];
    }
}

- (void)km_adjustScrollViewContentOffsetIfNeeded {
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.view;
        const CGFloat topContentOffsetY = -scrollView.contentInset.top;
        const CGFloat bottomContentOffsetY = scrollView.contentSize.height - (CGRectGetHeight(scrollView.bounds) - scrollView.contentInset.bottom);
        
        CGPoint adjustedContentOffset = scrollView.contentOffset;
        if (adjustedContentOffset.y > bottomContentOffsetY) {
            adjustedContentOffset.y = bottomContentOffsetY;
        }
        if (adjustedContentOffset.y < topContentOffsetY) {
            adjustedContentOffset.y = topContentOffsetY;
        }
        [scrollView setContentOffset:adjustedContentOffset animated:NO];
    }
}

- (UINavigationBar *)km_transitionNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKm_transitionNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, @selector(km_transitionNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)km_prefersNavigationBarBackgroundViewHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKm_prefersNavigationBarBackgroundViewHidden:(BOOL)hidden {
    [[self.navigationController.navigationBar valueForKey:@"_backgroundView"]
     setHidden:hidden];
    objc_setAssociatedObject(self, @selector(km_prefersNavigationBarBackgroundViewHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
