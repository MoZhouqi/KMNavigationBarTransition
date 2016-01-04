//
//  MainViewController.swift
//  KMNavigationBarTransition
//
//  Created by Zhouqi Mo on 1/1/16.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    // MARK: Constants
    
    struct Constants {
        struct Segue {
            static let ShowNextIdentifier = "Show Next"
            static let SetStyleIdentifier = "Set Style"
        }
    }
    
    // MARK: Properties
    
    var currentNavigationBarData: NavigationBarData!
    var nextNavigationBarData: NavigationBarData!
    
    @IBOutlet weak var nextNavigationBarTintColorText: UILabel!
    @IBOutlet weak var nextNavigatioBarBackgroundImageColorText: UILabel!
    @IBOutlet weak var nextNavigationBarPrefersHiddenSwitch: UISwitch!
    @IBOutlet weak var nextNavigationBarPrefersShadowImageHiddenSwitch: UISwitch!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentNavigationBarData == nil {
            currentNavigationBarData = NavigationBarData()
        }
        nextNavigationBarData = currentNavigationBarData
        
        nextNavigationBarTintColorText.text = nextNavigationBarData.barTintColor.rawValue
        nextNavigatioBarBackgroundImageColorText.text = nextNavigationBarData.backgroundImageColor.rawValue
        nextNavigationBarPrefersHiddenSwitch.on = nextNavigationBarData.prefersHidden
        nextNavigationBarPrefersShadowImageHiddenSwitch.on = nextNavigationBarData.prefersShadowImageHidden
        
        navigationController?.navigationBar.barTintColor = currentNavigationBarData.barTintColor.toUIColor
        navigationController?.navigationBar.setBackgroundImage(currentNavigationBarData.backgroundImageColor.toUIImage, forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = (currentNavigationBarData.prefersShadowImageHidden) ? UIImage() : nil
        
        title = "Title " + "\(navigationController!.viewControllers.count)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(currentNavigationBarData.prefersHidden, animated: animated)
    }
    
}

// MARK: - Target Action

extension MainViewController {
    
    @IBAction func nextNavigationBarPrefersShadowImageHidden(sender: UISwitch) {
        nextNavigationBarData.prefersShadowImageHidden = sender.on
    }
    
    @IBAction func nextNavigationBarPrefersHidden(sender: UISwitch) {
        nextNavigationBarData.prefersHidden = sender.on
    }
    
    @IBAction func navigationBarTranslucent(sender: UISwitch) {
        navigationController?.navigationBar.translucent = sender.on
    }
    
}

// MARK: - Table view data source

extension  MainViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return navigationController?.viewControllers.first == self ? 2 : 1
    }
    
}

// MARK: - Table view delegate

extension  MainViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0), (0, 1):
            performSegueWithIdentifier(Constants.Segue.SetStyleIdentifier, sender: self)
        default:
            break
        }
    }
    
}

// MARK: - Navigation

extension MainViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.Segue.SetStyleIdentifier:
                guard let settingsViewController = segue.destinationViewController as? SettingsViewController else {
                    return
                }
                guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                    return
                }
                
                var colorsArray = [NavigationBarBackgroundViewColor]()
                var selectedIndex: Int?
                var block: ((color: NavigationBarBackgroundViewColor) -> Void)?
                
                switch (selectedIndexPath.section, selectedIndexPath.row) {
                case (0, 0):
                    colorsArray = NavigationBarData.BarTintColorArray
                    selectedIndex = colorsArray.indexOf(NavigationBarBackgroundViewColor(rawValue: nextNavigationBarTintColorText.text!)!)
                    block = {
                        self.nextNavigationBarData.barTintColor = $0
                        self.nextNavigationBarTintColorText.text = $0.rawValue
                    }
                case (0, 1):
                    colorsArray = NavigationBarData.BackgroundImageColorArray
                    selectedIndex = colorsArray.indexOf(NavigationBarBackgroundViewColor(rawValue: nextNavigatioBarBackgroundImageColorText.text!)!)
                    block = {
                        self.nextNavigationBarData.backgroundImageColor = $0
                        self.nextNavigatioBarBackgroundImageColorText.text = $0.rawValue
                    }
                default:
                    break
                }
                settingsViewController.colorsData = (colorsArray, selectedIndex)
                settingsViewController.configurationBlock = block
                settingsViewController.titleText = tableView.cellForRowAtIndexPath(selectedIndexPath)?.textLabel?.text ?? ""
                
            case Constants.Segue.ShowNextIdentifier:
                guard let viewController = segue.destinationViewController as? MainViewController else {
                    return
                }
                viewController.currentNavigationBarData = nextNavigationBarData
                break
            default:
                break
            }
        }
    }
    
}
