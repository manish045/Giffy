//
//  GifListViewModelXCTest.swift
//  GiffyTests
//
//  Created by Manish Tamta on 20/06/2022.
//

import XCTest
@testable import Giffy

class GifListViewModelXCTest: XCTestCase {

    var viewModel: GiffyListViewModel!
    var mockFetchAPI: MockServiceAPI!
    var coordinator: MockGifListCoordinator!
    
    override func setUp() {
        mockFetchAPI = MockServiceAPI()
        
        
        let navigationController
                    = UINavigationController(rootViewController: GiffyListViewController())
        coordinator = MockGifListCoordinator(rootController: navigationController)
        
        viewModel = GiffyListViewModel(coordinator: coordinator,
                                       apiService: MockServiceAPI())
    }

    override func tearDown() {
        mockFetchAPI = nil
        viewModel = nil
    }
    
    //
    func testFetchGifWithCorrectDetailsSetSuccess() {
        mockFetchAPI.gifResult = .success([])
        mockFetchAPI.fetchTrendingGifs(limit: 0, offset: 0) { result in
            switch result {
            case .success(let array):
                XCTAssertNotNil(array)
            case .error(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    //
    func testFetchGifWithIncorrectDetailsSetFail() {
        mockFetchAPI.gifResult = .error(APIError.somethingWrong)
        mockFetchAPI.fetchTrendingGifs(limit: 0, offset: 0) { result in
            switch result {
            case .error(let error):
                XCTAssertNotNil(error)
            case .success(let array):
                XCTAssertNil(array)
            }
        }
    }
    
    func testNavigationTiDetail() {
        let model = TrendingGIFModel(id: "123", source: "test", title: "testCase", rating: "1", images: nil, username: "UserTest")
        coordinator.showGifDetail(model: model)
        XCTAssertTrue(coordinator.showGifDetail)
    }
}

struct MockServiceAPI: GifAPIRepositoryView {

    var gifResult: APIResult<TrendingGIFModelList, APIError> = .success([])
    
    func fetchTrendingGifs(limit: Int, offset: Int, completion: @escaping (APIResult<TrendingGIFModelList, APIError>) -> Void) {
        completion(gifResult)
    }
    
}


class MockGifListCoordinator: Coordinator, GiffyListViewCoordinatorInput {
   
    var rootController: UIViewController?
    var showGifDetail = false
        
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    func showGifDetail(model: TrendingGIFModel) {
        showGifDetail = true
    }
}
