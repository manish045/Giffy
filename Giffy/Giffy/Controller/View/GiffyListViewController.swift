//
//  GiffyListViewController.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import UIKit
import Combine

class GiffyListViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case gif
        case loader
    }
 
    var viewModel: DefaultGiffyListViewModel!
    
    private var disposeBag = Set<AnyCancellable>()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollecitonView()
        viewModel.fetchTrendingGifsFromServer()
        addViewModelObservers()
    }
    
    private func configureCollecitonView() {
        self.collectionView.registerNibCell(ofType: LoadingCollectionCell.self)
        self.collectionView.registerNibCell(ofType: GiifyCollectionViewCell.self)
        self.collectionView.dataSource = self
    }
    
    private func addViewModelObservers() {
        viewModel.loadDataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else {return}
                self.collectionView.reloadData()
            })
            .store(in: &disposeBag)
        
        viewModel.error
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else {return}
                self.collectionView.reloadData()
            })
            .store(in: &disposeBag)
    }
}

extension GiffyListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
            
        case .gif:
            return self.viewModel.trendingGifDataSource?.count ?? 0
            
        case .loader:
            return (self.viewModel.loadingState == .completed) ? 0 : 1
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .gif:
            let cell = collectionView.dequeueCell(GiifyCollectionViewCell.self, indexPath: indexPath)
            let model = self.viewModel.trendingGifDataSource?[indexPath.row]
            cell.model = model
            return cell

        default:
            let loadingCell = collectionView.dequeueCell(LoadingCollectionCell.self, indexPath: indexPath)
            loadingCell.configure(data: .init(state: self.viewModel.loadingState))
            return loadingCell
        }
    }
}

