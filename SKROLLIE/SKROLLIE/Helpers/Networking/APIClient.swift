//
//  APIClient.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2018 Smit Patel. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    class func LogIn(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .post, urlString: API.Login, parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
}
