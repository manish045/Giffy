//
//  UIImageView+ImageLoader.swift
//  Giffy
//
//  Created by Manish Tamta on 16/06/2022.
//

import UIKit
import SDWebImage
import FLAnimatedImage

extension FLAnimatedImageView {
    
    func downloadImage(from url: String?,
                       placeholderImage: UIImage?) {

        self.image = nil
        guard let originalUrlString = url else {
            image = placeholderImage
            return
        }

        if let transformedUrl = URL(string: originalUrlString) {
            
            sd_internalSetImage(with: transformedUrl, placeholderImage: placeholderImage, options: SDWebImageOptions(rawValue: 0), context: nil, setImageBlock: { [weak self] (image, imageData, _, _)  in
                guard let strongSelf = self else { return }
                
                let imageFormat = NSData.sd_imageFormat(forImageData: imageData)
                if imageFormat == .GIF {
                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                        let animatedImage = FLAnimatedImage(animatedGIFData: imageData)
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.animatedImage = animatedImage
                            strongSelf.image = nil
                        }
                    }
                } else {
                    strongSelf.image = image
                    strongSelf.animatedImage = nil
                }
                }, progress: nil, completed: nil)
        }
    }
}
