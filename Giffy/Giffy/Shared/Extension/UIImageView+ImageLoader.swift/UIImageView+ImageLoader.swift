//
//  UIImageView+ImageLoader.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit
import SwiftyGif

extension UIImageView {
    
    func downloadImage(from url: String?,
                       placeholderImage: UIImage?) {

        self.image = nil
        guard let originalUrlString = url else {
            image = placeholderImage
            return
        }

        if let transformedUrl = URL(string: originalUrlString) {
            self.setGifFromURL(transformedUrl)
        }
    }
}
