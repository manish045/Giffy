//
//  TrendingGifModel.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import Foundation

import Foundation

// MARK: - TrendingGIFModel

typealias TrendingGIFModelList = [TrendingGIFModel]
struct ResponseModel: BaseModel {
    let data: TrendingGIFModelList?
}

// MARK: - Datum
struct TrendingGIFModel: BaseModel {
    var id: String
    var source : String?
    var title: String?
    var rating : String?
    var images : Images?
    let username: String?
}

struct Images : BaseModel{
    var downsized : Downsized?
}

struct Downsized : BaseModel{
    var width : String?
    var height: String?
    var url : String?
}
