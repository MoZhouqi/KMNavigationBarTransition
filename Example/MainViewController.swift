//
//  MainViewController.swift
//  KMNavigationBarTransition
//
//  Created by Zhouqi Mo on 1/1/16.
//  Copyright © 2017 Zhouqi Mo. All rights reserved.
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
        nextNavigationBarPrefersHiddenSwitch.isOn = nextNavigationBarData.prefersHidden
        nextNavigationBarPrefersShadowImageHiddenSwitch.isOn = nextNavigationBarData.prefersShadowImageHidden
        
        navigationController?.navigationBar.barTintColor = currentNavigationBarData.barTintColor.toUIColor
        navigationController?.navigationBar.setBackgroundImage(currentNavigationBarData.backgroundImageColor.toUIImage, for: .default)
        navigationController?.navigationBar.shadowImage = (currentNavigationBarData.prefersShadowImageHidden) ? UIImage() : nil
        
        title = "Title " + "\(navigationController!.viewControllers.count)"

        edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(currentNavigationBarData.prefersHidden, animated: animated)
    }
    
}

// MARK: - Target Action

extension MainViewController {
    
    @IBAction func nextNavigationBarPrefersShadowImageHidden(_ sender: UISwitch) {
        nextNavigationBarData.prefersShadowImageHidden = sender.isOn
    }
    
    @IBAction func nextNavigationBarPrefersHidden(_ sender: UISwitch) {
        nextNavigationBarData.prefersHidden = sender.isOn
    }
    
    @IBAction func navigationBarTranslucent(_ sender: UISwitch) {
        navigationController?.navigationBar.isTranslucent = sender.isOn
    }
    
}

// MARK: - Table view data source

extension  MainViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return navigationController?.viewControllers.first == self ? 2 : 1
    }
    
}

// MARK: - Table view delegate

extension  MainViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0), (0, 1):
            performSegue(withIdentifier: Constants.Segue.SetStyleIdentifier, sender: self)
        default:
            break
        }
    }
    
}

// MARK: - Navigation

extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.Segue.SetStyleIdentifier:
                guard let settingsViewController = segue.destination as? SettingsViewController else {
                    return
                }
                guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                    return
                }
                
                var colorsArray = [NavigationBarBackgroundViewColor]()
                var selectedIndex: Int?
                var block: ((_ color: NavigationBarBackgroundViewColor) -> Void)?
                
                switch (selectedIndexPath.section, selectedIndexPath.row) {
                case (0, 0):
                    colorsArray = NavigationBarData.BarTintColorArray
                    selectedIndex = colorsArray.index(of: NavigationBarBackgroundViewColor(rawValue: nextNavigationBarTintColorText.text!)!)
                    block = {
                        self.nextNavigationBarData.barTintColor = $0
                        self.nextNavigationBarTintColorText.text = $0.rawValue
                    }
                case (0, 1):
                    colorsArray = NavigationBarData.BackgroundImageColorArray
                    selectedIndex = colorsArray.index(of: NavigationBarBackgroundViewColor(rawValue: nextNavigatioBarBackgroundImageColorText.text!)!)
                    block = {
                        self.nextNavigationBarData.backgroundImageColor = $0
                        self.nextNavigatioBarBackgroundImageColorText.text = $0.rawValue
                    }
                default:
                    break
                }
                settingsViewController.colorsData = (colorsArray, selectedIndex)
                settingsViewController.configurationBlock = block
                settingsViewController.titleText = tableView.cellForRow(at: selectedIndexPath)?.textLabel?.text ?? ""
                
            case Constants.Segue.ShowNextIdentifier:
                guard let viewController = segue.destination as? MainViewController else {
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
