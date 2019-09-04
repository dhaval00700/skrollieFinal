//
//  BaseViewController.swift
//  SKROLLIE
//
//  Created by PC on 25/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func goToHomePage() {
        let navVc = AppDelegate.sharedDelegate().window?.rootViewController as! UINavigationController
        for temp in navVc.viewControllers{
            
            if let vc = temp as? HomeViewController{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func showNetworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }
    
    func hideNewtworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }
    
    
    func getUserProfileData(userId: String, complation success: ((Bool, UserProfileModel) -> Void)? = nil) {
        
        _ = APIClient.GetUserById(userId: userId) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let totalTodayPost = response["TotalTodayPost"] as? String ?? (response["TotalTodayPost"] as? NSNumber)?.stringValue ?? ""
                let totalForeverPost = response["TotalForeverPost"] as? String ?? (response["TotalForeverPost"] as? NSNumber)?.stringValue ?? ""
               let userProfileData = UserProfileModel(data: responseData.data as? [String: Any] ?? [String : Any](), totalTodayPost: totalTodayPost, totalForeverPost: totalForeverPost)
                AppPrefsManager.shared.saveUserProfileData(model: userProfileData)
                if success != nil {
                    success!(true, userProfileData)
                }
            }
        }
    }
    
    func updateUserProfileData(parameters: [String : Any], complation success: ((Bool) -> Void)? = nil) {
        
        _ = APIClient.UpdateUserById(parameters: parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let totalTodayPost = response["TotalTodayPost"] as? String ?? (response["TotalTodayPost"] as? NSNumber)?.stringValue ?? ""
                let totalForeverPost = response["TotalForeverPost"] as? String ?? (response["TotalForeverPost"] as? NSNumber)?.stringValue ?? ""
                let userProfileData = UserProfileModel(data: responseData.data as? [String: Any] ?? [String : Any](), totalTodayPost: totalTodayPost, totalForeverPost: totalForeverPost)
                AppPrefsManager.shared.saveUserProfileData(model: userProfileData)
                if success != nil {
                    success!(true)
                }
            }
        }
    }
    
    func createFriend(userId: String, completion success: ((Bool) -> Void)? = nil) {
        
        var paramter = [String:AnyObject]()
        paramter["idUser"] = AppPrefsManager.shared.getUserProfileData().id as AnyObject
        paramter["idFriend"] = userId as AnyObject
        
        
        _ = APIClient.createFriend(parameters: paramter, success: { (resposObject) in
            let response = resposObject ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                if success != nil {
                    success!(true)
                }
                AppDelegate.sharedDelegate().window?.showToastAtBottom(message: responseData.message)
            }
        })
        
    }
    
    func CancleFriendRequest(userId: String, completion success: ((Bool) -> Void)? = nil) {
        
        var paramter = [String:AnyObject]()
        paramter["idUser"] = AppPrefsManager.shared.getUserProfileData().id as AnyObject
        paramter["idFriend"] = userId as AnyObject
        
        
        _ = APIClient.CancleFriendRequest(parameters: paramter, success: { (resposObject) in
            let response = resposObject ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                if success != nil {
                    success!(true)
                }
                AppDelegate.sharedDelegate().window?.showToastAtBottom(message: responseData.message)
            }
        })
        
    }
    
    func updateStatus(userId: String, isBlock: Bool, completion success: ((Bool) -> Void)? = nil) {
        
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserProfileData().id)
        param.addParameter(key: ParameterRequest.idFriend, value: userId)
        param.addParameter(key: ParameterRequest.IsBlock, value: isBlock)
        
        _ = APIClient.BlockUnblockFriendByUser(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                if success != nil {
                    success!(true)
                }
            }
        }
    }
    
    func unFriendUser(userId: String, completion success: ((Bool) -> Void)? = nil) {
        
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserProfileData().id)
        param.addParameter(key: ParameterRequest.idFriend, value: userId)
        
        _ = APIClient.UnFriendByUser(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                if success != nil {
                    success!(true)
                }
            }
        }
    }
    
    func reportUser(userId: String) {
        
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.ReportedByUserId, value: AppPrefsManager.shared.getUserProfileData().id)
        param.addParameter(key: ParameterRequest.ReportedToUserId, value: userId)
        
        _ = APIClient.ReportUser(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            Utility.showMessageAlert(title: "Alert", andMessage: responseData.message, withOkButtonTitle: "OK")
        }
    }
}
