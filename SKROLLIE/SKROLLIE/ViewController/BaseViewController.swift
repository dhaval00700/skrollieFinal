//
//  BaseViewController.swift
//  SKROLLIE
//
//  Created by PC on 25/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func goToHomePage() {
        let navVc = AppDelegate.sharedDelegate().window?.rootViewController as! UINavigationController
        for temp in navVc.viewControllers{
            
            if let vc = temp as? HomeViewController{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    
    func getUserProfileData(userId: String, complation success: ((Bool) -> Void)? = nil) {
        
        _ = APIClient.GetUserById(userId: userId) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let totalTodayPost = response["TotalTodayPost"] as? String ?? (response["TotalTodayPost"] as? NSNumber)?.stringValue ?? ""
                let totalForeverPost = response["TotalForeverPost"] as? String ?? (response["TotalForeverPost"] as? NSNumber)?.stringValue ?? ""
               let userPrifileData = UserProfileModel(data: responseData.data as? [String: Any] ?? [String : Any](), totalTodayPost: totalTodayPost, totalForeverPost: totalForeverPost)
                AppPrefsManager.shared.saveUserProfileData(model: userPrifileData)
                if success != nil {
                    success!(true)
                }
            }
        }
    }
}
