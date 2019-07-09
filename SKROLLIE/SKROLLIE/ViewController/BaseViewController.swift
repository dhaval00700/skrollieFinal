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
    
    
    func getUserProfileData(userId: String, complation success: ((Bool, UserProfileModel) -> Void)? = nil) {
        
        _ = APIClient.GetUserById(userId: userId) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let totalTodayPost = response["TotalTodayPost"] as? String ?? (response["TotalTodayPost"] as? NSNumber)?.stringValue ?? ""
                let totalForeverPost = response["TotalForeverPost"] as? String ?? (response["TotalForeverPost"] as? NSNumber)?.stringValue ?? ""
               let userProfileData = UserProfileModel(data: responseData.data as? [String: Any] ?? [String : Any](), totalTodayPost: totalTodayPost, totalForeverPost: totalForeverPost)
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
}
