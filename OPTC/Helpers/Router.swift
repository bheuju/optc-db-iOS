//
//  Router.swift
//  OPTC
//
//  Created by Prashant on 2/23/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static let baseUrl = "https://optc-db.github.io/common/data/"
    
    case units
    
    var path: String {
        switch self {
        case .units:
            return "units.js"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .units:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let base = try Router.baseUrl.asURL()
        var urlRequest = URLRequest(url: base.appendingPathComponent(path))
        urlRequest.timeoutInterval = 25.0
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("text/plain", forHTTPHeaderField: "Accept")
        
        switch self {
        case .units:
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: nil)
        }
        return urlRequest
    }
    
}

