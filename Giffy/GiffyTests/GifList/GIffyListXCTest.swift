//
//  GIffyListXCTest.swift
//  GiffyTests
//
//  Created by Manish Tamta on 17/06/2022.
//

import XCTest
import Combine
@testable import Giffy

class GIffyListXCTest: XCTestCase {

    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
    }
    
    func testControllerIBConnections() throws {
        let sut = try makeSUT()
        
        XCTAssertNotNil(sut.collectionView)
    }
    
    //MARK: Test the datasource before request to server
    func testEmptyValueInDataSourceWhenLoadingDataFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected two section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: 0), 0)
        
        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: 1), 1)
    }
    
    
    
    func testObservers() throws {
        let sut = try makeSUT()
        
        let viewModel = sut.viewModel!
        
        let expectation = XCTestExpectation(description: "load data")
        let errorExpectation = XCTestExpectation(description: "Error Occured")
        
        viewModel.loadDataSource
            .receive(on: RunLoop.main)
            .sink (receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.error
            .receive(on: RunLoop.main)
            .sink { _ in
                errorExpectation.fulfill()
            }
            .store(in: &cancellables)
        
    }
    
    private func makeSUT() throws -> GiffyListViewController  {
        let coordinator = GiffyListViewCoordinator()
        let sut = try XCTUnwrap(coordinator.makeModule() as? GiffyListViewController)
        let viewModel = GiffyListViewModel(coordinator: coordinator)
        sut.viewModel = viewModel
        _ = sut.view
        return sut
    }
}
