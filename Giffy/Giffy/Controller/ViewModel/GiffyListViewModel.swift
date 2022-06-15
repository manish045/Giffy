//
//  GiffyListViewModel.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import Foundation
import Combine

protocol GiffyListViewModelInput {
    func fetchTrendingGifsFromServer()
    func loadMoreGifs()
}

protocol GiffyListViewModelOutput {

    var loadDataSource: Published<TrendingGIFModelList?>.Publisher{ get }
    var loadingState: LoadingState {get}
    var error: PassthroughSubject<APIError, Never> {get}
    var trendingGifDataSource: TrendingGIFModelList? {get}
}

protocol DefaultGiffyListViewModel: GiffyListViewModelInput, GiffyListViewModelOutput {}

final class GiffyListViewModel: DefaultGiffyListViewModel {
    
    @Published var trendingGifDataSource: TrendingGIFModelList? = []
    var loadDataSource: Published<TrendingGIFModelList?>.Publisher {$trendingGifDataSource}
    var error = PassthroughSubject<APIError, Never>()
    var loadingState: LoadingState = .loading

    private var coordinator: GiffyListViewCoordinatorInput
    private var apiService: GifAPIRepositoryView
    
    private var limit = 20
    private var offset = 0
    private var loadMoreData = true
    
    init(coordinator: GiffyListViewCoordinatorInput,
         apiService: GifAPIRepositoryView = GifAPIRepository()) {
        self.coordinator = coordinator
        self.apiService = apiService
    }
    
    func loadMoreGifs() {
        if !loadMoreData {return}
        fetchTrendingGifsFromServer()
    }
    
    /// Fetching gif's from server
    func fetchTrendingGifsFromServer() {
        self.loadMoreData = false
        
        apiService.fetchTrendingGifs(limit: limit, offset: offset) { [weak self] (result: APIResult<TrendingGIFModelList, APIError>) in
            switch result {
            case .success(let gifArray):
                guard let self = self else {return}
                self.gifFetchedSuccessfully(gifArray: gifArray)
            case .error(let error):
                guard let self = self else {return}
                self.loadingState = .failed
                self.error.send(error)
            }
        }
    }
    
    /// Increase offset and change limit once data has been fetched successfully
    ///
    private func gifFetchedSuccessfully(gifArray: TrendingGIFModelList) {
        self.limit = 25
        self.offset += 1
        loadingState = gifArray.count == 0 ? .completed : .loading
        self.loadMoreData = gifArray.count > 0
        self.trendingGifDataSource?.append(contentsOf: gifArray)
    }
}
