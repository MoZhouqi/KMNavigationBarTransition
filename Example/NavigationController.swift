//
//  NavigationController.swift
//  KMNavigationBarTransition
//
//  Created by Zhouqi Mo on 1/1/16.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }

}

// MARK: Gesture Recognizer Delegate

extension NavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Ignore interactive pop gesture when there is only one view controller on the navigation stack
        if viewControllers.count <= 1 {
            return false
        }
        return true
    }
    
}
