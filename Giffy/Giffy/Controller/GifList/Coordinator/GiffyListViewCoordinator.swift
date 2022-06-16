//
//  GiffyListViewCoordinator.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import UIKit

protocol GiffyListViewCoordinatorInput {
    func showGifDetail(model: TrendingGIFModel)
}

class GiffyListViewCoordinator: Coordinator, GiffyListViewCoordinatorInput {
    
    var rootController: UIViewController?
    
    //Create View Controller instance with all possible initialization for viewModel and controller
    func makeModule() -> UIViewController {
        let vc = createViewController()
        return vc
    }
    
    private func createViewController() -> GiffyListViewController {
        // initializing view controller
        let view = GiffyListViewController.instantiateFromStoryboard()
        let viewModel = GiffyListViewModel(coordinator: self)
        view.viewModel = viewModel
        return view
    }
    
    //Pass the navigationController to the initial controller
    func start(from presentingController: UIViewController) {
        rootController = presentingController
    }
    
    func showGifDetail(model: TrendingGIFModel) {
        let vc = GifDetailViewCoordinator().makeModule(model: model)
        rootController?.navigationController?.pushViewController(vc, animated: true)
    }
}
