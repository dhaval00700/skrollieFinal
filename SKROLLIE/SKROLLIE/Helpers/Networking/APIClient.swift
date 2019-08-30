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
    
    
    class func ForgotPassword(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        return ApiManager.requestApi(method: .get, urlString: API.ForgotPassword, parameters: parameters, headers: headers.parameters, success: { (response) in
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
        let url = API.SendOTP + "?idUser=\(AppPrefsManager.shared.getUserProfileData().id)&phone=\(mobileNumber)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func VerifyOTP(OTP:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.VerifyOTP + "?idUser=\(AppPrefsManager.shared.getUserProfileData().id)&OTP=\(OTP)"
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
    
    class func Get24HourPostByUserId(userId: String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetLatest24HoursPostByUser + "?idUser=\(userId)" + "&Limit=\(PostCountLimit)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetForevetPostByUserId(userId: String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetForeverPostByUser + "?idUser=\(userId)" + "&Limit=\(PostCountLimit)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
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
    
    class func GetAllMyUnFriend(limit:Int, page:Int, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetAllMyUnFriend + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)&limit=\(limit)&page=\(page)"
        
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetAllMyFriend(limit:Int, page:Int, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetAllMyFriend + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)&limit=\(limit)&page=\(page)"
        
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
    
    class func CancleFriendRequest(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.CancelledFriendRequest
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetAllBlockFriendByUser(userId: String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetAllBlockFriendByUser + "?idUser=\(userId)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func BlockUnblockFriendByUser(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.BlockUnblockFriendByUser
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }

    class func ChangePassword(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.ChangePassword
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func UnFriendByUser(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.UnFriendUser
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func ReportUser(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.ReportUser
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetFriendReuestedByUser(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetFriendReuestedByUser + "?idUser=\(AppPrefsManager.shared.getUserData().UserId)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func AcceptFriendRequest(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.AcceptFriendRequest
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func DeactivateAccount(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.DeactivateAccount
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetUserBySearch(limit:Int,page:Int,searchText:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetAlluserWuthSearch + "?limit=\(limit)&page=\(page)&idUser=\(AppPrefsManager.shared.getUserData().UserId)&Search=\(searchText)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func LikePostByUser(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.LikePostByUser
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetAllLike(idPost:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetAllLikeByPostId + "?idPost=\(idPost)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func UnlockComment(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.SavePostUnblock
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func GetAllComment(idPost:String, success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.GetAllCommentByPostId + "?idPost=\(idPost)"
        return ApiManager.requestApi(method: .get, urlString: url , parameters: nil, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
    
    class func SavePostComment(parameters: [String : Any], success successBlock: @escaping ([String : Any]?) -> Void) -> DataRequest {
        let headers = HeaderRequestParameter()
        let url = API.SavePostComment
        return ApiManager.requestApi(method: .post, urlString: url , parameters: parameters, headers: headers.parameters, success: { (response) in
            successBlock(response)
        }, failure: { (error) -> Bool in
            DLog(error)
            return true
        })
    }
}
