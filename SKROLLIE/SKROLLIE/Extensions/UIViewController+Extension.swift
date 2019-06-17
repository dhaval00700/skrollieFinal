//
//  UIViewController+Extension.swift
//  Trustfund
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    
    func showToastAtBottom(message: String) {
        self.view.showToastAtBottom(message: message)
    }
    
    func showToastAtTop(message: String) {
        self.view.showToastAtTop(message: message)
    }
}

enum AppStoryboard : String {
    
    case Home
    case Main
    case Onboarding
    case LoginRegister
    case EditProfile
    case MyScheduled
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
