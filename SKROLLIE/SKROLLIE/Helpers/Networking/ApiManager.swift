//
//  ApiManager.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2018 Smit Patel. All rights reserved.
//


import Foundation
import Alamofire

class ApiManager {
    
    class func requestApi(method: Alamofire.HTTPMethod, urlString: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil, success successBlock:@escaping (([String: Any]) -> Void), failure failureBlock:((NSError) -> Bool)?) -> DataRequest
    {
        var finalParameters = [String: Any]()
        if(parameters != nil)
        {
            finalParameters = parameters!
        }
        
        
        print("parameters = \(finalParameters)")
        print("urlString = \(urlString)")
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.timeoutInterval = 60
        request.httpMethod = method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !finalParameters.isEmpty
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: finalParameters)
        }
        
        
        return Alamofire.request(request)
            .responseString { response in
                
                print( "Response String: \(String(describing: response.result.value))")
                
            }
            .responseJSON { response in
                
                print( "Response Error: \(String(describing: response.result.error))")
                print( "Response JSON: \(String(describing: response.result.value))")
                print( "response.request: \(String(describing: response.request?.allHTTPHeaderFields))")
                
                
                if(response.result.error == nil) {
                    let responseObject = response.result.value as! [NSObject: Any]
                    successBlock(responseObject as! [String : Any])
                } else {
                    if(failureBlock != nil && failureBlock!(response.result.error! as NSError))
                    {
                        if let statusCode = response.response?.statusCode
                        {
                            ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                        }
                    }
                }
        }
    }
    
    class func callApi(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, success successBlock:@escaping ((Any?, Int?) -> Void), failure failureBlock: ((Error, Int?) -> Bool)?) -> DataRequest
    {
        var finalParameters = [String: Any]()
        if parameters != nil {
            finalParameters = parameters!
        }
        
        DLog("parameters = ", finalParameters)
        DLog("apiURL = ", apiURL)
        
        return Alamofire.request(apiURL, method: method, parameters: finalParameters, encoding: URLEncoding.default, headers: headers)
            .responseString { response in
                
                DLog("Response String: \(String(describing: response.result.value))")
                
            }
            .responseJSON { response in
                
                DLog("Response Error: ", response.result.error)
                DLog("Response JSON: ", response.result.value)
                DLog("response.request: ", response.request?.allHTTPHeaderFields)
                DLog("Response Status Code: ", response.response?.statusCode)
                
                DispatchQueue.main.async {
                     if (response.result.error == nil) {
                        let responseObject = response.result.value
                        
                        if response.response?.statusCode == 401 {
                            //Utility.appDelegate().logoutFromApplication()
                        }
                        
                        successBlock(responseObject, response.response?.statusCode)
                        
                    } else {
                        if failureBlock != nil && failureBlock!(response.result.error! as NSError, response.response?.statusCode) {
                            if let statusCode = response.response?.statusCode {
                                ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                            }
                        }
                    }
                }
        }
    }

    class func callApiWithUpload(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String : Any]? = nil, headers: [String: String]? = nil, fileData: Data?, success successBlock: @escaping ((Any?, Int?) -> Void), failure failureBlock: ((Error, Int?) -> Bool)?) {
        
        var finalParameters = [String : Any]()
        if parameters != nil {
            finalParameters = parameters!
        }

        return Alamofire.upload(multipartFormData: { multipartFormData in

            if fileData != nil {
                multipartFormData.append(fileData!, withName: "profile_pic", fileName: "image.jpeg", mimeType: "image")
            }
            
            for (key, value) in finalParameters {
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
            DLog("parameters = ", multipartFormData)
        }, usingThreshold: UInt64.init(), to: apiURL, method: method, headers: headers, encodingCompletion: { result in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseString { response in
                    
                    DLog("Response String: \(String(describing: response.result.value))")
                }
                
                upload.responseJSON { response in
                    
                    DLog("Response Error: ", response.result.error)
                    DLog("Response JSON: ", response.result.value)
                    DLog("response.request: ", response.request?.allHTTPHeaderFields)
                    DLog("Response Status Code: ", response.response?.statusCode)
                    
                    DispatchQueue.main.async {
                        if(response.response?.statusCode == 401) {
                            
                        } else if (response.result.error == nil) {
                            let responseObject = response.result.value
                            successBlock(responseObject, response.response?.statusCode)
                        } else {
                            if failureBlock != nil && failureBlock!(response.result.error! as NSError, response.response?.statusCode) {
                                if let statusCode = response.response?.statusCode {
                                    ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                                }
                            }
                        }
                    }
                    
                    
                }
            case .failure(let encodingError):
                
                Utility.showMessageAlert(title: "Error", andMessage: "\(encodingError)", withOkButtonTitle: "OK")
            }
        })
    }

    class func callApiWithUpload(apiURL: String, method: Alamofire.HTTPMethod, parameters: [String: AnyObject]? = nil, fileDataParameters: [AnyObject]? = nil, headers: [String: String]? = nil, success successBlock:@escaping ((Any?, Int?) -> Void), failure failureBlock: ((Error, Int?) -> Bool)?) {
        
        var finalParameters = [String: AnyObject]()
        if parameters != nil {
            finalParameters = parameters!
        }
        
        DLog("parameters = ", finalParameters)
        DLog("apiURL = ", apiURL)
        
        return Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append("".data(using: String.Encoding.utf8)!, withName: "")
            
            for (key, value) in finalParameters {
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
            
            if fileDataParameters != nil && (fileDataParameters?.count)! > 0 {
                for i in 0...(fileDataParameters!.count - 1) {
                    let dict = fileDataParameters![i] as! [String: AnyObject]
                    multipartFormData.append(dict["data"] as! Data, withName: dict["param_name"] as! String, fileName: dict["file_name"] as! String, mimeType: dict["mime_type"] as! String)
                }
            }
            
        }, to: apiURL, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseString { response in
                    
                    DLog("Response String: \(String(describing: response.result.value))")
                }
                
                upload.responseJSON { response in
                    
                    DLog("Response Error: ", response.result.error)
                    DLog("Response JSON: ", response.result.value)
                    DLog("response.request: ", response.request?.allHTTPHeaderFields)
                    DLog("Response Status Code: ", response.response?.statusCode)
                    
                    DispatchQueue.main.async {
                        if(response.response?.statusCode == 401)
                        {
                        }
                        else if (response.result.error == nil) {
                            let responseObject = response.result.value
                            //let response = responseObject as! [String: AnyObject]
                            
                            /*if (response["status"] as? NSNumber)?.intValue == ResponseFlag.sessionExpired
                             {
                             let baseVc = BaseViewController()
                             baseVc.logoutUser()
                             
                             }*/
                            
                            successBlock(responseObject, response.response?.statusCode)
                        } else {
                            if failureBlock != nil && failureBlock!(response.result.error! as NSError, response.response?.statusCode) {
                                if let statusCode = response.response?.statusCode {
                                    ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                                }
                            }
                        }
                    }
                    
                    
                }
            case .failure(let encodingError):
                
                Utility.showMessageAlert(title: "Error", andMessage: "\(encodingError)", withOkButtonTitle: "OK")
                
            }
        })
        
    }
    
    class func handleAlamofireHttpFailureError(statusCode: Int) {
        switch statusCode {
        case NSURLErrorUnknown:
            
            Utility.showMessageAlert(title: "Error", andMessage: "Ooops!! Something went wrong, please try after some time!", withOkButtonTitle: "OK")
            
        case NSURLErrorCancelled:
            
            break
        case NSURLErrorTimedOut:
            
            Utility.showMessageAlert(title: "Error", andMessage: "The request timed out, please verify your internet connection and try again.", withOkButtonTitle: "OK")
            
        case NSURLErrorNetworkConnectionLost:
            //displayAlert("Error", andMessage: NSLocalizedString("network_lost", comment: ""))
            break
            
        case NSURLErrorNotConnectedToInternet:
            //displayAlert("Error", andMessage: NSLocalizedString("internet_appears_offline", comment: ""))
            break
            
        default:
            
            Utility.showMessageAlert(title: "Error", andMessage: "Ooops!! Something went wrong, please try after some time!", withOkButtonTitle: "OK")
            
        }
    }
}
