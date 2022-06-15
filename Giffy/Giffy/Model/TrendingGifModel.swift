//
//  TrendingGifModel.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import Foundation

import Foundation

// MARK: - TrendingGIFModel
struct ResponseModel: BaseModel {
    let data: [TrendingGIFModel]
}

// MARK: - Datum
struct TrendingGIFModel: BaseModel {
    var id: String
    var source : String
    //var gifUrl: URL
    var title: String
    var rating : String
    var images : Images
    
    
    struct Images : Codable{
        var downsized : Downsized
        
        struct Downsized : Codable{
            var width : String
            var height: String
            var url : String
        }
    }
}
