//
//  Font.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 29/09/24.
//

import UIKit

extension UIFont {
    
    static func responsiveAvenirFont(forTextStyle textStyle: UIFont.TextStyle, weight: UIFont.Weight = .regular) -> UIFont {
        let preferredFontSize: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredFontSize = UIFont.preferredFont(forTextStyle: textStyle).pointSize * 1.4
        } else {
            preferredFontSize = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        }
        
        if let helveticaFont = UIFont(name: "Avenir Medium", size: preferredFontSize) {
            return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: helveticaFont)
        } else {
            return UIFont.systemFont(ofSize: preferredFontSize, weight: weight)
        }
    }
    
    static func responsiveAvenirRegularTitleFont(size: CGFloat = 18) -> UIFont {
        let preferredFontSize: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredFontSize = size * 1.4
        } else {
            preferredFontSize = size
        }
        
        return UIFont(name: "Avenir-Roman", size: preferredFontSize) ?? UIFont.boldSystemFont(ofSize: preferredFontSize)
    }
    
    static func responsiveAvenirBlackTitleFont(size: CGFloat = 18) -> UIFont {
        let preferredFontSize: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredFontSize = size * 1.4
        } else {
            preferredFontSize = size
        }
        
        return UIFont(name: "Avenir-Black", size: preferredFontSize) ?? UIFont.boldSystemFont(ofSize: preferredFontSize)
    }
    
    static func responsiveAvenirItalicTextFont(size: CGFloat = 16) -> UIFont {
        let preferredFontSize: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredFontSize = size * 1.4
        } else {
            preferredFontSize = size
        }
        
        return UIFont(name: "Avenir-Oblique", size: preferredFontSize) ?? UIFont.italicSystemFont(ofSize: preferredFontSize)
    }
    
}

