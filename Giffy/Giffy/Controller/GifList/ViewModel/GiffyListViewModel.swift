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
    func showGifDetail(model: TrendingGIFModel)
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
    private var manager: DBManagerView
    
    init(coordinator: GiffyListViewCoordinatorInput,
         apiService: GifAPIRepositoryView = GifAPIRepository(),
         manager: DBManagerView = DatabaseManager(type: .trendingGif)) {
        
        self.coordinator = coordinator
        self.apiService = apiService
        self.manager = manager
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
                self.fetchSavedData(apiError: error)
            }
        }
    }
    
    /// Increase offset and change limit once data has been fetched successfully
    ///
    private func gifFetchedSuccessfully(gifArray: TrendingGIFModelList) {
        self.saveTrendingGiffData(model: gifArray, removeAllData: (self.offset == 0))
        self.limit = 25
        self.offset += 1
        loadingState = gifArray.count == 0 ? .completed : .loading
        self.loadMoreData = gifArray.count > 0
        self.trendingGifDataSource?.append(contentsOf: gifArray)
    }
    
    /// Push to gif detail screen
    func showGifDetail(model: TrendingGIFModel) {
        self.coordinator.showGifDetail(model: model)
    }
    
    private func saveTrendingGiffData(model: TrendingGIFModelList, removeAllData: Bool) {
        if model.count > 0 {
            let manager = DatabaseManager(type: .trendingGif)
            if removeAllData {
                manager.removeAllTrendingGiffData()
            }
            manager.saveGiffyList(trendingList: model)
        }
    }
    
    private func fetchSavedData(apiError: APIError) {
        self.error.send(apiError)
        manager.fetchTrendingList { [weak self] result in
            switch result {
            case .success(let model):
                guard let self = self else {return}
                if model.count > self.trendingGifDataSource?.count ?? 0 {
                    self.trendingGifDataSource = model
                }
            case .error(_):
                self?.error.send(apiError)
            }
        }
    }
}
