//
//  GiffyListViewController.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import UIKit
import Combine

class GiffyListViewController: UIViewController {
    
    // MARK: Register all the sections you need in CollectionView
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
        configureCollectionViewItemSize(height: 64.0)
        title = Ln10.GiffyListViewController.title
    }
    
    // MARK: Set collectionview flowlayout Size on rotaion
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, windowScene.activationState == .foregroundActive else { return }

        switch windowScene.interfaceOrientation {
        case .portrait, .portraitUpsideDown:
            configureCollectionViewItemSize(height: 64.0)
            
        case .landscapeLeft, .landscapeRight:
            configureCollectionViewItemSize(height: 104.0)

        default:
            break
        }

         flowLayout.invalidateLayout()
    }
        
    // MARK: Configure collection View Cell, datasource and delegate
    private func configureCollecitonView() {
        self.collectionView.registerNibCell(ofType: LoadingCollectionCell.self)
        self.collectionView.registerNibCell(ofType: GiffyCollectionViewCell.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // MARK: Set CollectionViewLayout
    private func configureCollectionViewItemSize(height: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //this is for direction
        layout.minimumInteritemSpacing = 0 // this is for spacing between cells
        
        let width = (self.collectionView.frame.size.width) //some width
        layout.itemSize = CGSize(width: width, height: height) //this is for cell size
        self.collectionView.collectionViewLayout = layout
    }
    
    //MARK: Register Binders
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
            .sink(receiveValue: { [weak self] error in
                guard let self = self else {return}
                self.showAlert(title: error.asString)
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
            let cell = collectionView.dequeueCell(GiffyCollectionViewCell.self, indexPath: indexPath)
            let model = self.viewModel.trendingGifDataSource?[indexPath.row]
            cell.model = model
            return cell

        default:
            let loadingCell = collectionView.dequeueCell(LoadingCollectionCell.self, indexPath: indexPath)
            loadingCell.configure(data: .init(state: self.viewModel.loadingState))
            loadingCell.retryIntent = { [weak self] in
                self?.viewModel.fetchTrendingGifsFromServer()
            }
            return loadingCell
        }
    }
}

extension GiffyListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch Section(rawValue: indexPath.section) {
        case .gif:
            if indexPath.row == (self.viewModel.trendingGifDataSource?.count ?? 0) - 8 {
                self.viewModel.loadMoreGifs()
            }
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .gif:
            if let model = self.viewModel.trendingGifDataSource?[indexPath.row] {
                viewModel.showGifDetail(model: model)
            }
        default:
            break
        }
    }
}
