//
//  AppError.swift
//  OPTC
//
//  Created by Prashant on 2/23/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import Foundation
import Alamofire

enum AppError: Error, LocalizedError {
    
    case parseFailed
    case commonError(String)
    
    var localizedDescription: String {
        switch self {
        case .parseFailed:
            return "Unable to parse response value"
        case .commonError(let message):
            return message
        }
    }
}

enum ResponseError {
    case failed(Error)
    
    var description: String {
        switch self {
        case .failed(let error):
            if let appError = error as? AppError {
                return appError.localizedDescription
            }
            return error.localizedDescription
        }
    }
}
