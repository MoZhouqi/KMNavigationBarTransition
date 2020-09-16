//
//  KMNavigationBarTransitionUtils.m
//  KMNavigationBarTransition
//
//  Created by Zhouqi Mo on 2020/9/17.
//  Copyright © 2020 Zhouqi Mo. All rights reserved.
//

#import "KMNavigationBarTransitionUtils.h"
#import "KMWeakObjectContainer.h"

@implementation KMNavigationBarTransitionUtils

+ (NSBundle *)getBundle {
    NSBundle *bundle = [NSBundle bundleForClass:KMWeakObjectContainer.class];
    NSURL *bundleURL = [bundle URLForResource:@"KMNavigationBarTransition" withExtension:@"bundle"];
    if (!bundleURL) {
        if ([bundle.bundlePath hasSuffix:@"KMNavigationBarTransition.framework"]) {
            return bundle;
        }
    } else {
        bundle = [NSBundle bundleWithURL:bundleURL];
    }
    return  bundle ? bundle : [NSBundle mainBundle];
}

@end
