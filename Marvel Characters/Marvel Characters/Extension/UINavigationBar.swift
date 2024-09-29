//
//  UINavigationBar.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 29/09/24.
//

import UIKit

extension UINavigationBar {
    /// Configura a fonte responsiva para a NavigationBar com Avenir Bold
    func setResponsiveAvenirTitleFont() {
        let preferredFontSize: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredFontSize = UIFont.preferredFont(forTextStyle: .headline).pointSize * 1.4
        } else {
            preferredFontSize = UIFont.preferredFont(forTextStyle: .headline).pointSize
        }
        
        let titleFont = UIFont(name: "Avenir-Heavy", size: preferredFontSize) ?? UIFont.boldSystemFont(ofSize: preferredFontSize)
        
        let titleColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: titleFont
        ]
        
        
        self.titleTextAttributes = textAttributes
        self.largeTitleTextAttributes = textAttributes
        self.tintColor = titleColor 
        
        let appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = textAttributes
        appearance.largeTitleTextAttributes = textAttributes
        appearance.tintColor = titleColor
    }
}


