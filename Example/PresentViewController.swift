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
    
    func leftBarButtonAction() {
        if self.navigationController!.viewControllers.count == 1 {
           self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func rightBarButtonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: PresentViewController.self))
        let controller = storyboard.instantiateViewController(withIdentifier: "PresentViewController")
        self.show(controller, sender: nil)
    }
}
