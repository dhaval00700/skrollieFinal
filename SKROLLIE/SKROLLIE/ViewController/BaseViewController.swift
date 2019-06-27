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
    
    func goToLoginPage() {
        let navVc = AppDelegate.sharedDelegate().window?.rootViewController as! UINavigationController
        for temp in navVc.viewControllers{
            
            if let vc = temp as? LoginViewController{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}
