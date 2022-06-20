//
//  APIFetchGifsTest.swift
//  GiffyTests
//
//  Created by Manish Tamta on 20/06/2022.
//

import XCTest
import Alamofire
@testable import Giffy

class APIFetchGifsTest: XCTestCase {

    var apiService : GifAPIRepositoryView!
    var util: MSUtils!
    var gifList: TrendingGIFModelList!

    override func setUp() {
        fetchResponseFromSampleFile()
        apiService = GifAPIRepository()
        util = MSUtils()
    }
    
    override func tearDown() {
        apiService = nil
        util = nil
        gifList = nil
    }
    
    
    func fetchResponseFromSampleFile() {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "gifSample", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json into string")
        }
        
        let jsonData = json.data(using: .utf8)!
        let model = try! JSONDecoder().decode(ResponseModel.self, from: jsonData)
        gifList = model.data!
    }
    
    //MARK:- Test the get Characters request with passing empty key params.
    func testKeysArePresentInPlistORturnsError() {
        let msUtils = MSUtils()
        let getAPIKeys = msUtils.getAPIKeys()
        XCTAssertNotNil(getAPIKeys[KeyString.apikey.rawValue])
    }
    
    //MARK:- Test the get Characters request passing key params.
    func testCharacterListApiResourceWithEmptyStringRturnsError() {
       
        let url = APIGiffyService.URL(.trending)
        let baseURL = util.buildServiceRequestUrl(baseUrl: url)
        XCTAssertNotNil(baseURL?.isEmpty)
    }
    
    
    //MARK:- Test the get Giffs requeset
    func testCharacterListApiResourceWithParametersReturnsError() throws {
        let reachability = Network()

        try XCTSkipUnless(
            (reachability.isConnectedToInternet != nil) == false,
            "Network connectivity needed for this test."
        )
        
        let expectation = self.expectation(description: "testAPICall")
        apiService.fetchTrendingGifs(limit: 20, offset: 0) { result in
            switch result {
            case .success(let model):
                XCTAssertNotNil(model)
                
                expectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testGifResponse() {
        
        let gifModel = gifList[0]        

        XCTAssertEqual("vVjewRa2HFKuz9EwBt", gifModel.id)
        XCTAssertEqual("", gifModel.source)
        XCTAssertEqual("Be Yourself Mental Health GIF by Bruce Lee Foundation", gifModel.title)
        XCTAssertEqual("g", gifModel.rating)
        XCTAssertEqual("BruceLeeFoundation", gifModel.username)
        XCTAssertEqual("https://media3.giphy.com/media/vVjewRa2HFKuz9EwBt/giphy-downsized.gif?cid=8a206130mp0jysjaea785p9cu8e2e14il7zjo1k8a28xwj8o&rid=giphy-downsized.gif&ct=g", gifModel.images?.downsized?.url)
        XCTAssertEqual("480", gifModel.images?.downsized?.height)
        XCTAssertEqual("480", gifModel.images?.downsized?.width)

        XCTAssertEqual(gifList.count, 3)
    }
}
