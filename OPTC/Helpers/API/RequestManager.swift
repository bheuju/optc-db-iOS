//
//  RequestManager.swift
//  OPTC
//
//  Created by Prashant on 2/23/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import Foundation
import Alamofire

typealias ResponseHandler = (_ success: Bool, _ results: Any, _ error: ResponseError?)->Swift.Void

class RequestManager {
    
    func prepareForPlainRequest(with router: Router, completion: @escaping ResponseHandler) {
        Alamofire.request(router).responseString { (response) in
            if let responseResult = response.result.value {
                completion(true, responseResult, nil)
            } else {
                completion(false, response.result, ResponseError.failed(AppError.commonError((response.result.error?.localizedDescription)!)))
            }
        }
    }
}
