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
        view.backgroundColor = .systemBackground
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
 
    }
}
