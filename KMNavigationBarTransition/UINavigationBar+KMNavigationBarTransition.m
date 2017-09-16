//
//  UINavigationBar+KMNavigationBarTransition.m
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

#import "UINavigationBar+KMNavigationBarTransition.h"
#import <objc/runtime.h>
#import "KMSwizzle.h"

@implementation UINavigationBar (KMNavigationBarTransition)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		KMSwizzleMethod([self class],
						@selector(layoutSubviews),
						@selector(km_layoutSubviews));
	});
}

- (void)km_layoutSubviews {
	[self km_layoutSubviews];
	for (UIView *subview in self.subviews) {
		if ([NSStringFromClass([subview class]) containsString:@"BarBackground"]) {
			CGRect subViewFrame = subview.frame;
			if ([self km_useExtendedHeight]) {
                subViewFrame.size.height = self.frame.size.height + fabs(self.frame.origin.y);
			}
			[subview setFrame: subViewFrame];
		}
	}
}

- (BOOL)km_useExtendedHeight {
	return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKm_useExtendedHeight:(BOOL)useHeight {
	objc_setAssociatedObject(self, @selector(km_useExtendedHeight), @(useHeight), OBJC_ASSOCIATION_ASSIGN);
	[self setNeedsLayout];
	[self layoutIfNeeded];
}


@end
