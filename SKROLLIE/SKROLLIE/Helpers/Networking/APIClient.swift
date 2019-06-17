//
//  APIClient.swift
//  Trustfund
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2018 Smit Patel. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {

    func callApi(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, completion completionBlock: @escaping (ResponseDataModel?, Error?) -> Void) -> DataRequest {
        return ApiManager.callApi(apiURL: apiURL, method: method, parameters: parameters, headers: headers, success: { (response, status) in
            DispatchQueue.main.async {
                let responseObj = (response as? [String : Any]) ?? [String : Any]()
                let responseDataModel = ResponseDataModel(responseObj: responseObj)
                completionBlock(responseDataModel, nil)
            }
        }, failure: { (error, status) -> Bool in
            DLog(error, status)
            DispatchQueue.main.async {
                completionBlock(nil, error)
            }
            return true
        })
    }
    
    func checkEmailExist(parameters: ParameterRequest, completion completionBlock: @escaping (ResponseDataModel?, Error?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return callApi(apiURL: API.BASE_URL, method: .post, parameters: parameters.parameters, headers: headers.parameters, completion: completionBlock)
    }
}
