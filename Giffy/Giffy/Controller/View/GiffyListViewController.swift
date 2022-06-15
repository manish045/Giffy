//
//  GiffyListViewController.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import UIKit

class GiffyListViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case gif
        case loader
    }
 
    var viewModel: DefaultGiffyListViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollecitonView()
        viewModel.fetchTrendingGifsFromServer()
    }
    
    private func configureCollecitonView() {
        self.collectionView.registerNibCell(ofType: LoadingCollectionCell.self)
        self.collectionView.registerNibCell(ofType: GiifyCollectionViewCell.self)
        self.collectionView.dataSource = self
    }
}

extension GiffyListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .gif:
            return 5
            
        case .loader:
            return 1
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .gif:
            let loadingCell = collectionView.dequeueCell(GiifyCollectionViewCell.self, indexPath: indexPath)
            return loadingCell

        default:
            print("default cell")
            let loadingCell = collectionView.dequeueCell(LoadingCollectionCell.self, indexPath: indexPath)
            return loadingCell
        }
    }
}

