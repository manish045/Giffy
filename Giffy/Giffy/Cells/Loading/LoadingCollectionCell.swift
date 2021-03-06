//
//  LoadingCollectionCell.swift
//  Giffy
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

public class LoadingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var retryButton: UIButton!
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    private var data: LoadingItem? = nil
    
    var retryIntent: (()->Void)?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 14.0, *) {
            retryButton.addAction(UIAction(handler: { [unowned self] _ in
                
                guard let item = data, item.state == .failed else {
                    return
                }
                
                self.retryTapped(for: item)
                
            }), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func configure(data: LoadingItem) {
        self.data = data
        loadingIndicatorView.startAnimating()
        
        if data.state == .failed {
            retryButton.isHidden = false
            loadingIndicatorView.isHidden = true
        } else {
            retryButton.isHidden = true
            loadingIndicatorView.isHidden = false
        }
    }
    
    private func retryTapped(for item: LoadingItem) {
        guard let retryIntent = retryIntent else {
            return
        }
        configure(data: .init(state: .loading))
        retryIntent()
    }
    
}
