//
//  DisableTransitionNavigationController.swift
//  KMNavigationBarTransition
//
//  Created by Wilson Yuan on 2017/6/21.
//  Copyright © 2017年 Zhouqi Mo. All rights reserved.
//

import UIKit

class DisableTransitionNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.km_disableTransition = true
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.km_disableTransition = true
    }

}
