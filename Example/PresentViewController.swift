//
//  PresentViewController.swift
//  KMNavigationBarTransition
//
//  Created by Wilson Yuan on 2017/6/21.
//  Copyright © 2017年 Zhouqi Mo. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.leftBarButtonAction))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(self.rightBarButtonAction))
        
    }

}

///Action
extension PresentViewController {
    
    func leftBarButtonAction() {
        if self.navigationController!.viewControllers.count == 1 {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func rightBarButtonAction() {
        let controller = presentViewController()
        controller.km_disableTransition = true
        self.show(controller, sender: nil)
    }
    
    @IBAction func popToRootAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func popToPenultAction(_ sender: Any) {
        
        guard let navigation = self.navigationController,
            navigation.viewControllers.count > 2 else {
            print("current view controllers count: \(String(describing: self.navigationController?.viewControllers.count))")
            return
        }
        
        let controller = navigation.viewControllers[navigation.viewControllers.count - 3]
        self.navigationController?.popToViewController(controller, animated: true)
    }

    @IBAction func setControllersAction(_ sender: Any) {
        
        let controller = presentViewController()
        controller.view.backgroundColor = UIColor.red
        let blueController = presentViewController()
        blueController.view.backgroundColor = UIColor.blue
        let controllers = [controller, blueController]
        
        self.navigationController?.setViewControllers(controllers, animated: false)
    }
}

/// Private method
extension PresentViewController {
    fileprivate func presentViewController() -> PresentViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: PresentViewController.self))
        let controller = storyboard.instantiateViewController(withIdentifier: "PresentViewController")
        return controller as! PresentViewController
    }
}
