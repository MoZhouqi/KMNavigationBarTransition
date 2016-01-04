//
//  SettingsViewController.swift
//  KMNavigationBarTransition
//
//  Created by Zhouqi Mo on 1/1/16.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: Constants
    
    struct Constants {
        struct TableViewCell {
            static let Identifier = "Cell"
        }
    }
    
    // MARK: Properties
    
    var colorsData: (colorsArray: [NavigationBarBackgroundViewColor], selectedIndex: Int?)!
    var configurationBlock: ((color: NavigationBarBackgroundViewColor) -> Void)!
    var titleText = ""
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        title = titleText
    }
    
}

// MARK: - Table view data source

extension SettingsViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorsData.colorsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.Identifier, forIndexPath: indexPath)
        cell.textLabel?.text = colorsData.colorsArray[indexPath.row].rawValue
        cell.accessoryType = (indexPath.row == colorsData.selectedIndex) ? .Checkmark : .None
        
        return cell
    }
    
}

// MARK: - Table view delegate

extension SettingsViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedIndex = colorsData.selectedIndex {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))?.accessoryType = .None
        }
        colorsData.selectedIndex = indexPath.row
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        configurationBlock?(color: colorsData.colorsArray[indexPath.row])
    }
    
}
