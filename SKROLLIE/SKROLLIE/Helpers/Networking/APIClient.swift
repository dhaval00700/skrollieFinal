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
    
    class func Register(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .post, urlString: API.Register, parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func CheckEmailAddres(email:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        
        
        return ApiManager.requestApi(method: .get, urlString: API.EmailValidation + "?emailaddress=\(email)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func VerifyEmailAddres(email:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        
        
        return ApiManager.requestApi(method: .get, urlString: API.VerifyEmailAddress + "?emailaddress=\(email)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func VerifyUserName(username:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        
        
        return ApiManager.requestApi(method: .get, urlString: API.VerifiyUserName + "?username=\(username)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func CheckMobileNumber(mobileNumber:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        
        
        return ApiManager.requestApi(method: .get, urlString: API.verifyPhoneNumber + "?phone=\(mobileNumber)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    
    class func SendOTP(mobileNumber:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        
        let url = API.sendOtp + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)&phone=\(mobileNumber)"
        
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func VerifyOTP(OTP:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        
        let url = API.verifyOTPUrl + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)&OTP=\(OTP)"
        
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func SavePostImage(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .post, urlString: API.SavePost, parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    
}
