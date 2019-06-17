//
//  LoginModel.swift
//  SKROLLIE
//
//  Created by PC on 17/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import Foundation
import UIKit

class LoginModel {
    
    init() {}
    
    var token = ""
    var UserId = ""
    var UserName = ""
    var UserRole = ""
    
    init(data: [String: Any]) {
        
        token = data["token"] as? String ?? ""
        UserId = data["UserId"] as? String ?? (data["UserId"] as? NSNumber)?.stringValue ?? ""
        UserName = data["UserName"] as? String ?? ""
        UserRole = data["UserRole"] as? String ?? ""
    }
    
    func toDictionary() -> [String : Any] {
        var itemDict = [String : Any]()
        
        itemDict["token"] = token
        itemDict["UserId"] = UserId
        itemDict["UserName"] = UserName
        itemDict["UserRole"] = UserRole
        
        return itemDict
    }
}
