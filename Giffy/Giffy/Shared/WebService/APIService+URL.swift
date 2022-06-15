//
//  APIService+URL.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import Foundation
import Alamofire

enum APIEnvironment {
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .staging:
            return "https://api.giphy.com/"
        case .production:
            return ""
        }
    }
}

enum EndPoints {
    case trending

    var url: String {
        switch self {
        case .trending:
            return "v1/gifs/trending"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}

extension APIGiffyService {
    struct URLString {
        private static let environment = APIEnvironment.staging
        static var base: String { environment.baseURL }
    }
    
    static func URL(_ endPoint: EndPoints) -> String {
        return URLString.base + endPoint.url
    }
}

