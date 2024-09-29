//
//  UITableViewCell.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 29/09/24.
//

import UIKit

extension UITableViewCell {
    
    func setThumbnail(from url: URL?, placeholder: UIImage? = nil, targetSize: CGSize = CGSize(width: 40, height: 40)) {
        self.imageView?.image = placeholder
        self.imageView?.contentMode = .scaleAspectFill
        self.imageView?.clipsToBounds = true
        self.imageView?.layer.cornerRadius = 20
        
        guard let imageUrl = url else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: data) {
                let resizedImage = image.resize(to: targetSize) 
                
                DispatchQueue.main.async {
                    self.imageView?.image = resizedImage
                    self.setNeedsLayout()
                }
            }
        }
    }
}
