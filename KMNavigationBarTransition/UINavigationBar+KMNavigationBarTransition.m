//
//  UINavigationBar+KMNavigationBarTransition.m
//  KMNavigationBarTransition
//
//  Created by Yifei Zhou on 1/5/16.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

#import "UINavigationBar+KMNavigationBarTransition.h"

@implementation UINavigationBar (KMNavigationBarTransition)

- (UIView *)km_backgroundView
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            return view;
        }
    }
    return nil;
}

@end
