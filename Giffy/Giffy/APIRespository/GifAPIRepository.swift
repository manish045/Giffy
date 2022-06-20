//
//  GifAPIRepository.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import Foundation

protocol GifAPIRepositoryView {
    func fetchTrendingGifs(limit: Int, offset: Int, completion: @escaping (APIResult<TrendingGIFModelList, APIError>) -> Void)
}

struct GifAPIRepository: GifAPIRepositoryView {
    
    func fetchTrendingGifs(limit: Int, offset: Int, completion: @escaping (APIResult<TrendingGIFModelList, APIError>) -> Void) {
        
        let parameters = [
            "limit": limit,
            "offset": offset
        ]
        
        APIGiffyService.shared.performRequest(endPoint: .trending, parameters: parameters) { (result: APIResult<ResponseModel, APIError>) in
            switch result {
            case .success(let model):
                let data = model.data ?? []
                completion(.success(data))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
