//
//  GifDetailViewModel.swift
//  Giffy
//
//  Created by Manish Tamta on 17/06/2022.
//

import Foundation

protocol GiffyDetailViewModelInput {

}

protocol GiffyDetailViewModelOutput {
    var model: TrendingGIFModel {get}
}

protocol DefaultGiffyDetailViewModel: GiffyDetailViewModelInput, GiffyDetailViewModelOutput {}


final class GifDetailViewModel: DefaultGiffyDetailViewModel {
    
    var model: TrendingGIFModel
    var coordinator: GifDetailViewCoordinatorInput
    
    init(coordinator: GifDetailViewCoordinatorInput,
         model: TrendingGIFModel) {
        self.coordinator = coordinator
        self.model = model
    }
    
}
