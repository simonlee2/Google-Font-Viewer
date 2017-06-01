//
//  GoogleFontAPI.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/28/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import Alamofire

class GoogleFontAPI {
    static let apiKey = GoogleFontAPIKey
    
    static let baseURL = "https://www.googleapis.com/webfonts/v1"
    
    enum Endpoints {
        case webfonts(SortType?)
        
        enum SortType: String {
            case alpha = "alpha"
            case date = "date"
            case popularity = "popularity"
            case style = "style"
            case trending = "trending"
        }
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .webfonts:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .webfonts:
                return "\(baseURL)/webfonts"
            }
        }
        
        var parameters: [String: Any] {
            var parameters = [
                "format": "json",
                "key": apiKey
            ]
            
            switch self {
            case .webfonts(let sortType):
                parameters["sort"] = sortType?.rawValue
                break
            }
            
            return parameters
        }
    }
    
    func request(endpoint: Endpoints) -> DataRequest {
        return Alamofire.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters
        )
    }
}
