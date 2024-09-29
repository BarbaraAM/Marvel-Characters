//
//  GlobalAppearance.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 28/09/24.
//

import Foundation
import UIKit

protocol UIColorGlobalAppearance {
    func configureAppearance()
}

extension UIColorGlobalAppearance where Self: UIViewController {
    func configureAppearance() {
        view.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            default:
                return UIColor(red: 242/255, green: 241/255, blue: 246/255, alpha: 1)
            }
        }
        
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        if let navigationBar = navigationController?.navigationBar {
            let barColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
                default:
                    return UIColor(red: 242/255, green: 241/255, blue: 246/255, alpha: 1)
                }
            }
            
            navigationBar.barTintColor = barColor
            
            navigationBar.setResponsiveAvenirTitleFont()
            
            
            navigationBar.barStyle = traitCollection.userInterfaceStyle == .dark ? .black : .default
        }
    }
}

