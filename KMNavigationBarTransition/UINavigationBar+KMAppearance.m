//
//  UINavigationBar+KMAppearance.m
//
//  Copyright (c) 2017 Tinpont (https://github.com/tinpont)
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

#import "UINavigationBar+KMAppearance.h"

@implementation UINavigationBar (KMAppearance)

- (void)km_updateAppearanceFromNavigationBar:(UINavigationBar *)navigationBar {
    self.barStyle = navigationBar.barStyle;
    self.translucent = navigationBar.translucent;
    self.tintColor = navigationBar.tintColor;
    self.barTintColor = navigationBar.barTintColor;
    self.titleTextAttributes = navigationBar.titleTextAttributes;
    [self setBackgroundImage:[navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = navigationBar.shadowImage;
}

- (UINavigationBar *)km_AppearanceCopy {
    UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
    navigationBar.barStyle = self.barStyle;
    navigationBar.translucent = self.translucent;
    navigationBar.tintColor = self.tintColor;
    navigationBar.barTintColor = self.barTintColor;
    navigationBar.titleTextAttributes = self.titleTextAttributes;
    [navigationBar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = self.shadowImage;
    return navigationBar;
}

@end
