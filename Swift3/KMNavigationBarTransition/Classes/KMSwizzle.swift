//
//  KMSwizzle.swift
//  KMNavigationBarTransition
//
//  Created by 伯驹 黄 on 2016/12/23.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import Foundation

func KMSwizzleMethod(_ cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {

    let originalMethod = class_getInstanceMethod(cls, originalSelector)
    let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)

    let didAddMethod = class_addMethod(cls,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod))

    if didAddMethod {
        class_replaceMethod(cls,
            swizzledSelector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
