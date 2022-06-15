//
//  GiffyListViewModel.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import Foundation

protocol GiffyListViewModelInput {
    func fetchTrendingGifsFromServer()
}

protocol GiffyListViewModelOutput {
    
}

protocol DefaultGiffyListViewModel: GiffyListViewModelInput, GiffyListViewModelOutput {}

final class GiffyListViewModel: DefaultGiffyListViewModel {
    
    private var coordinator: GiffyListViewCoordinatorInput
    private var apiService: GifAPIRepositoryView
    
    private var limit = 25
    private var offset = 0
    
    init(coordinator: GiffyListViewCoordinatorInput,
         apiService: GifAPIRepositoryView = GifAPIRepository()) {
        self.coordinator = coordinator
        self.apiService = apiService
    }
    
    func fetchTrendingGifsFromServer() {
        apiService.fetchTrendingGifs(limit: limit, offset: offset) { [weak self] (result: APIResult<[TrendingGIFModel], APIError>) in
            switch result {
            case .success(let gifArray):
                guard let self = self else {return}
                print(gifArray)
            case .error(let error):
                guard let self = self else {return}
            }
        }
    }
}
