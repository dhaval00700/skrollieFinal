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
    
    class func CheckEmailAddress(email:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .get, urlString: API.CheckEmailValidator + "?emailaddress=\(email)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func VerifyEmailAddress(email:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .get, urlString: API.CheckEmailExist + "?emailaddress=\(email)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func VerifyUserName(username:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .get, urlString: API.CheckUserExist + "?username=\(username)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func CheckMobileNumber(mobileNumber:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .get, urlString: API.CheckPhoneExist + "?phone=\(mobileNumber)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    
    class func SendOTP(mobileNumber:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.SendOTP + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)&phone=\(mobileNumber)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func VerifyOTP(OTP:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.VerifyOTP + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)&OTP=\(OTP)"
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
    
    class func GetAllPost(success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .get, urlString: API.GetAllPost + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)" , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func Get24HourPostByUserId(success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetLatest24HoursPostByUser + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)" + "&Limit=\(PostCountLimit)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetForevetPostByUserId(success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetForeverPostByUser + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)" + "&Limit=\(PostCountLimit)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetUserById(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .get, urlString: API.Register, parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetUserById(userId: String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetUserById + "?UserId=\(userId)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func UpdateUserById(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.UpdateUserById
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetFriendList(limit:Int, page:Int, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetAllUser + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)&limit=\(limit)&page=\(page)"
        
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func createFriend(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.CreateFriend
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
}
