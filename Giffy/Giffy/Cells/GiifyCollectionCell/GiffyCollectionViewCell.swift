//
//  GiifyCollectionViewCell.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import UIKit
import FLAnimatedImage

class GiffyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var gifNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: TrendingGIFModel? {
        didSet {
            guard let model = model else {
                return
            }
            gifImageView.downloadImage(from: model.images?.downsized?.url, placeholderImage: UIImage(named: "Loading"))
            gifNameLabel.text = model.title
        }
    }

}
