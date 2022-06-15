//
//  GiffyServiceUtil.swift
//  Giffy
//
//  Created by Manish Tamta on 21/05/2022.
//

import Foundation
import CryptoKit


enum KeyString: String {
    case apikey = "api_key"
}


struct MSUtils {
    
    func buildServiceRequestUrl(baseUrl: String) -> String? {
        if var urlComponents = URLComponents(string: baseUrl) {
            
            guard let apikey = getAPIKeys()[KeyString.apikey.rawValue] as? String else {return nil}
                        
            //addd auth params
            var requestParams = [String : String]()
            requestParams["api_key"] = apikey
            
            //build query string
            var queryItems = [URLQueryItem]()
            for (key, value) in requestParams {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponents.queryItems = queryItems
            
            if let urlAbsoluteString = urlComponents.url?.absoluteString {
                return urlAbsoluteString
            }
        }
        
        return nil
    }

    //MARK:- Get Keys from Giffy Plist file
    func getAPIKeys() -> [String: Any] {
        if let path = Bundle.main.path(forResource: "GiffyPlist", ofType: "plist") {
            let plist = NSDictionary(contentsOfFile: path) ?? ["":""]
            let apikey = plist[KeyString.apikey.rawValue] as! String
            let dict = [KeyString.apikey.rawValue : apikey]
            return dict
            
        }
        return ["": ""]
    }
}
