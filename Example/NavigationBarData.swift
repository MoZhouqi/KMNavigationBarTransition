//
//  NavigationBarData.swift
//  KMNavigationBarTransition
//
//  Created by Zhouqi Mo on 1/1/16.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

struct NavigationBarData {
    
    static let BarTintColorArray: [NavigationBarBackgroundViewColor] = [.Cyan, .Yellow, .Green, .Orange, .lightGray, .NoValue]
    static let BackgroundImageColorArray: [NavigationBarBackgroundViewColor] = [.NoValue, .Transparent, .Cyan, .Yellow, .Green, .Orange, .lightGray]
    
    var barTintColor = NavigationBarData.BarTintColorArray.first!
    var backgroundImageColor = NavigationBarData.BackgroundImageColorArray.first!
    var prefersHidden = false
    var prefersShadowImageHidden = false

}

enum NavigationBarBackgroundViewColor: String {
    case Cyan
    case Yellow
    case Green
    case Orange
    case lightGray
    case Transparent
    case NoValue = "No Value"
    
    var toUIColor: UIColor? {
        switch self {
        case .Cyan:
            return UIColor.cyanColor()
        case .Yellow:
            return UIColor.yellowColor()
        case .Green:
            return UIColor.greenColor()
        case .Orange:
            return UIColor.orangeColor()
        case .lightGray:
            return UIColor.lightGrayColor()
        default:
            return nil
        }
    }
    
    var toUIImage: UIImage? {
        switch self {
        case .Transparent:
            return UIImage()
        default:
            if let color = toUIColor {
                return UIImage(color: color)
            } else {
                return nil
            }
        }
    }
}

