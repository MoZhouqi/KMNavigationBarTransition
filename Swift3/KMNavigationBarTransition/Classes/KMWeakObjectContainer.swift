//
//  KMWeakObjectContainer.swift
//  KMNavigationBarTransition
//
//  Created by 伯驹 黄 on 2016/12/23.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class KMWeakObjectContainer: NSObject {

    var object: UIViewController?

    init(object: UIViewController?) {
        super.init()
        self.object = object
    }
}
