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
    var map: Map!
    var token = ""
    var UserId = ""
    var UserName = ""
    var UserRole = ""
    
    init(data: [String: Any]) {
        map = Map(data: data)
        token = map.value("token") ?? ""
        UserId = map.value("UserId") ?? map.value("id") ?? ""
        UserName = map.value("UserName") ?? ""
        UserRole = map.value("UserRole") ?? ""
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
