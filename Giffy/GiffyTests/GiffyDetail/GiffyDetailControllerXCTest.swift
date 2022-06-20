//
//  GiffyDetailControllerXCTest.swift
//  GiffyTests
//
//  Created by Manish Tamta on 20/06/2022.
//

import XCTest
@testable import Giffy

class GiffyDetailControllerXCTest: XCTestCase {

    func testOutletForNotNil() throws {
        let sut = try makeSUT()
        XCTAssertNotNil(sut.gifImageView)
    }

    private func makeSUT() throws -> GifDetailViewController  {
        let coordinator = GifDetailViewCoordinator()
        
        let model = TrendingGIFModel(id: "123", source: "test", title: "testCase", rating: "1", images: nil, username: "UserTest")

        let sut = try XCTUnwrap(coordinator.makeModule(model: model) as? GifDetailViewController)
        let viewModel = GifDetailViewModel(coordinator: coordinator,
                                           model: model)
        sut.viewModel = viewModel
        _ = sut.view
        return sut
    }
}
