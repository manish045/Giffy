//
//  GiifyCollectionViewCell.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import UIKit

class GiffyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gifImageView: UIImageView!
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
            gifImageView.downloadImage(from: model.images.downsized.url, placeholderImage: nil)

            gifNameLabel.text = model.title
        }
    }

}
