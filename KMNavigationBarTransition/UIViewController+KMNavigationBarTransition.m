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
#import "UINavigationController+KMNavigationBarTransition.h"
#import "UINavigationController+KMNavigationBarTransition_internal.h"
#import "UINavigationBar+KMNavigationBarTransition_internal.h"
#import "UIScrollView+KMNavigationBarTransition_internal.h"
#import "KMWeakObjectContainer.h"
#import <objc/runtime.h>
#import "KMSwizzle.h"

@implementation UIViewController (KMNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KMSwizzleMethod([self class],
                        @selector(viewWillLayoutSubviews),
                        [self class],
                        @selector(km_viewWillLayoutSubviews));
        
        KMSwizzleMethod([self class],
                        @selector(viewWillAppear:),
                        [self class],
                        @selector(km_viewWillAppear:));
        
        KMSwizzleMethod([self class],
                        @selector(viewDidAppear:),
                        [self class],
                        @selector(km_viewDidAppear:));
    });
}

- (void)km_viewWillAppear:(BOOL)animated {
    [self km_viewWillAppear:animated];
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([self isEqual:self.navigationController.viewControllers.lastObject] && [toViewController isEqual:self]  && tc.presentationStyle == UIModalPresentationNone) {
        [self km_adjustScrollViewContentInsetAdjustmentBehavior];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.navigationController.navigationBarHidden) {
                [self km_restoreScrollViewContentInsetAdjustmentBehaviorIfNeeded];
            }
        });
    }
}

- (void)km_settingNavigationBarMoreProperty:(UINavigationBar *)bar{
    //revoke navigationBar
    return [self km_settingNavigationBarFrom:bar toBar:self.navigationController.navigationBar];
}

- (void)km_settingNavigationBarFrom:(UINavigationBar *)fromBar toBar:(UINavigationBar *)toBar{
    toBar.barStyle = fromBar.barStyle;
    toBar.barTintColor = fromBar.barTintColor;
    [toBar setBackgroundImage:[fromBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [toBar setShadowImage:fromBar.shadowImage];
    
    toBar.translucent = fromBar.translucent;
    
    toBar.tintColor = fromBar.tintColor;
    toBar.titleTextAttributes = fromBar.titleTextAttributes;
    
    // layer
    toBar.layer.shadowColor = fromBar.layer.shadowColor;
    toBar.layer.shadowOffset = fromBar.layer.shadowOffset;
    toBar.layer.shadowOpacity = fromBar.layer.shadowOpacity;
    toBar.layer.shadowPath = fromBar.layer.shadowPath;
    toBar.layer.shadowRadius = fromBar.layer.shadowRadius;
}

- (void)km_viewDidAppear:(BOOL)animated {
    [self km_restoreScrollViewContentInsetAdjustmentBehaviorIfNeeded];
    UIViewController *transitionViewController = self.navigationController.km_transitionContextToViewController;
    if (self.km_transitionNavigationBar) {
        [self km_settingNavigationBarMoreProperty:self.km_transitionNavigationBar];
        if (!transitionViewController || [transitionViewController isEqual:self]) {
            [self.km_transitionNavigationBar removeFromSuperview];
            self.km_transitionNavigationBar = nil;
        }
    }
    if ([transitionViewController isEqual:self]) {
        self.navigationController.km_transitionContextToViewController = nil;
    }
    self.navigationController.km_backgroundViewHidden = NO;
    [self km_viewDidAppear:animated];
}

- (void)km_viewWillLayoutSubviews {
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *fromViewController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([self isEqual:self.navigationController.viewControllers.lastObject] && [toViewController isEqual:self] && tc.presentationStyle == UIModalPresentationNone) {
        if (self.navigationController.navigationBar.translucent) {
            [tc containerView].backgroundColor = [self.navigationController km_containerViewBackgroundColor];
        }
        fromViewController.view.clipsToBounds = NO;
        toViewController.view.clipsToBounds = NO;
        if (!self.km_transitionNavigationBar) {
            [self km_addTransitionNavigationBarIfNeeded];
            self.navigationController.km_backgroundViewHidden = YES;
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
    bar.km_isFakeBar = YES;
    
    //setting navigatonbar
    [self km_settingNavigationBarFrom:self.navigationController.navigationBar toBar:bar];
    
    [self.km_transitionNavigationBar removeFromSuperview];
    self.km_transitionNavigationBar = bar;
    [self km_resizeTransitionNavigationBarFrame];
    if (!self.navigationController.navigationBarHidden && !self.navigationController.navigationBar.hidden) {
        [self.view addSubview:self.km_transitionNavigationBar];
    }
}

- (void)km_adjustScrollViewContentOffsetIfNeeded {
    UIScrollView *scrollView = self.km_visibleScrollView;
    if (scrollView) {
        UIEdgeInsets contentInset;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            contentInset = scrollView.adjustedContentInset;
        } else {
            contentInset = scrollView.contentInset;
        }
#else
        contentInset = scrollView.contentInset;
#endif
        const CGFloat topContentOffsetY = -contentInset.top;
        const CGFloat bottomContentOffsetY = scrollView.contentSize.height - (CGRectGetHeight(scrollView.bounds) - contentInset.bottom);
    
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

- (void)km_adjustScrollViewContentInsetAdjustmentBehavior {
#ifdef __IPHONE_11_0
    if (self.navigationController.navigationBar.translucent) {
        return;
    }
    if (@available(iOS 11.0, *)) {
        UIScrollView *scrollView = self.km_visibleScrollView;
        if (scrollView) {
            UIScrollViewContentInsetAdjustmentBehavior contentInsetAdjustmentBehavior = scrollView.contentInsetAdjustmentBehavior;
            if (contentInsetAdjustmentBehavior != UIScrollViewContentInsetAdjustmentNever) {
                scrollView.km_originalContentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior;
                scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                scrollView.km_shouldRestoreContentInsetAdjustmentBehavior = YES;
            }
        }
    }
#endif
}

- (void)km_restoreScrollViewContentInsetAdjustmentBehaviorIfNeeded {
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        UIScrollView *scrollView = self.km_visibleScrollView;
        if (scrollView) {
            if (scrollView.km_shouldRestoreContentInsetAdjustmentBehavior) {
                scrollView.contentInsetAdjustmentBehavior = scrollView.km_originalContentInsetAdjustmentBehavior;
                scrollView.km_shouldRestoreContentInsetAdjustmentBehavior = NO;
            }
        }
    }
#endif
}


- (UINavigationBar *)km_transitionNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKm_transitionNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, @selector(km_transitionNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)km_scrollView {
    return km_objc_getAssociatedWeakObject(self, _cmd);
}

- (void)setKm_scrollView:(UIScrollView *)scrollView {
    km_objc_setAssociatedWeakObject(self, @selector(km_scrollView), scrollView);
}

- (UIScrollView *)km_visibleScrollView {
    UIScrollView *scrollView = self.km_scrollView;
    if (!scrollView && [self.view isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *)self.view;
    }
    return scrollView;
}

@end
