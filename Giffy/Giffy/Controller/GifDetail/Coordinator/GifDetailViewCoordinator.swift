//
//  GifDetailViewCoordinator.swift
//  Giffy
//
//  Created by Manish Tamta on 17/06/2022.
//

import UIKit

protocol GifDetailViewCoordinatorInput {
    
}


class GifDetailViewCoordinator: Coordinator, GifDetailViewCoordinatorInput {
    
    var rootController: UIViewController?
    
    //Create View Controller instance with all possible initialization for viewModel and controller
    func makeModule(model: TrendingGIFModel) -> UIViewController {
        let vc = createViewController(model: model)
        return vc
    }
    
    private func createViewController(model: TrendingGIFModel) -> GifDetailViewController {
        // initializing view controller
        let view = GifDetailViewController.instantiateFromStoryboard()
        let viewModel = GifDetailViewModel(coordinator: self,
                                           model: model)
        view.viewModel = viewModel
        return view
    }
    
    //Pass the navigationController to the initial controller
    func start(from presentingController: UIViewController) {
        rootController = presentingController
    }
    
}
