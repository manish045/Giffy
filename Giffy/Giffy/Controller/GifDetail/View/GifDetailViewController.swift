//
//  GifDetailViewController.swift
//  Giffy
//
//  Created by Manish Tamta on 17/06/2022.
//

import UIKit
import FLAnimatedImage

class GifDetailViewController: UIViewController {

    @IBOutlet weak var gifImageView: FLAnimatedImageView!

    var viewModel: DefaultGiffyDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.model.username
        // Do any additional setup after loading the view.
        gifImageView.downloadImage(from: viewModel.model.images?.downsized?.url, placeholderImage: UIImage(named: "Loading"))
    }

}
